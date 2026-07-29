import 'package:chefaa/features/doctor/chatbot/data/models/chat_history.dart';
import 'package:dio/dio.dart';

abstract class DocChatbotDataSource {
  Future<Response> getResponse({
    required String message,
    required List<ChatHistory> history,
  });
}
