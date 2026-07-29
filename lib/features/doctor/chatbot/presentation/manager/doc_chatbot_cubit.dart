import 'package:chefaa/features/doctor/chatbot/data/models/chat_history.dart';
import 'package:chefaa/features/doctor/chatbot/domain/repositories/doc_chatbot_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'doc_chatbot_state.dart';

@injectable
class DocChatbotCubit extends Cubit<DocChatbotState> {
  final DocChatbotRepo docChatbotRepo;

  final List<Map<String, dynamic>> _messages = [
    {"message": "Hello 👋\nHow can I help you today?", "isBot": true},
  ];

  List<Map<String, dynamic>> get messages => List.unmodifiable(_messages);

  DocChatbotCubit({required this.docChatbotRepo})
    : super(
        const DocChatbotInitialState([
          {"message": "Hello 👋\nHow can I help you today?", "isBot": true},
        ]),
      );

  static DocChatbotCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    debugPrint('DocChatbotCubit.sendMessage text="$text"');

    final userMessage = text.trim();
    final nextMessages = List<Map<String, dynamic>>.from(_messages)
      ..add({"message": userMessage, "isBot": false})
      ..add({"isBot": true, "isLoading": true});

    _messages
      ..clear()
      ..addAll(nextMessages);

    if (!isClosed) emit(DocChatbotLoadingState(List.unmodifiable(_messages)));

    final history = _messages
        .where((m) => m["isLoading"] != true)
        .take(_messages.length - 2)
        .map(
          (m) => ChatHistory(
            role: m["isBot"] == true ? "assistant" : "user",
            content: m["message"] ?? '',
          ),
        )
        .toList();

    try {
      debugPrint(
        'DocChatbotCubit calling repo with history=${history.map((e) => "${e.role}:${e.content}").toList()}',
      );
      final response = await docChatbotRepo.getResponse(
        message: userMessage,
        history: history,
      );

      _messages.removeWhere((e) => e["isLoading"] == true);
      _messages.add({"message": response.reply ?? '', "isBot": true});
      debugPrint('DocChatbotCubit success reply="${response.reply}"');
      if (!isClosed) emit(DocChatbotSuccessState(List.unmodifiable(_messages)));
    } catch (e) {
      _messages.removeWhere((e) => e["isLoading"] == true);
      _messages.add({"message": e.toString(), "isBot": true});
      debugPrint('DocChatbotCubit error="$e"');
      if (!isClosed) {
        emit(DocChatbotErrorState(List.unmodifiable(_messages), e.toString()));
      }
    }
  }
}
