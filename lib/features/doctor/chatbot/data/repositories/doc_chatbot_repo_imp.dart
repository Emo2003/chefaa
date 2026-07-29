import 'package:chefaa/core/error_handling/failure.dart';
import 'package:chefaa/features/doctor/chatbot/data/data_sources/doc_chatbot_data_source.dart';
import 'package:chefaa/features/doctor/chatbot/data/models/chat_history.dart';
import 'package:chefaa/features/doctor/chatbot/data/models/chatbot_doc.dart';
import 'package:chefaa/features/doctor/chatbot/domain/repositories/doc_chatbot_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DocChatbotRepo)
class DocChatbotRepoImp implements DocChatbotRepo {
  DocChatbotDataSource docChatbotDataSource;

  DocChatbotRepoImp({required this.docChatbotDataSource});

  @override
  Future<ChatbotDoc> getResponse({
    required String message,
    required List<ChatHistory> history,
  }) async {
    try {
      debugPrint(
        'DocChatbotRepoImp.getResponse message="$message" history=${history.map((e) => "${e.role}:${e.content}").toList()}',
      );
      final response = await docChatbotDataSource.getResponse(
        message: message,
        history: history,
      );
      debugPrint(
        'DocChatbotRepoImp response status=${response.statusCode} data=${response.data}',
      );
      if (response.statusCode == 200) {
        return ChatbotDoc.fromJson(response.data);
      } else {
        throw Exception('Failed to get response from server');
      }
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e).message;
    } catch (e) {
      throw ServerFailure.unexpectedError;
    }
  }
}
