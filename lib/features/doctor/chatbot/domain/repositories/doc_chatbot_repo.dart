import 'package:chefaa/features/doctor/chatbot/data/models/chat_history.dart';
import 'package:chefaa/features/doctor/chatbot/data/models/chatbot_doc.dart';

abstract class DocChatbotRepo {
  Future<ChatbotDoc> getResponse({
    required String message,
    required List<ChatHistory> history,
  });
}
