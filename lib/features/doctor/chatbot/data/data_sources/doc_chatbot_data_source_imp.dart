import 'package:chefaa/core/services/network_service.dart';
import 'package:chefaa/features/doctor/chatbot/data/models/chat_history.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'doc_chatbot_data_source.dart';

@Injectable(as: DocChatbotDataSource)
class DocChatbotDataSourceImp implements DocChatbotDataSource {
  NetworkService networkService;

  DocChatbotDataSourceImp({required this.networkService});

  @override
  Future<Response<dynamic>> getResponse({
    required String message,
    required List<ChatHistory> history,
  }) {
    debugPrint(
      'DocChatbotDataSourceImp POST /doctor/ai/chat message="$message" history=${history.map((e) => "${e.role}:${e.content}").toList()}',
    );
    return networkService.dio.post(
      '/doctor/ai/chat',
      data: {
        'message': message,
        'history': history.map((e) => e.toJson()).toList(),
      },
    );
  }
}
