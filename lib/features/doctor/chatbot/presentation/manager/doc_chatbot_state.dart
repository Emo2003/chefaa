sealed class DocChatbotState {
  final List<Map<String, dynamic>> messages;

  const DocChatbotState(this.messages);
}

final class DocChatbotInitialState extends DocChatbotState {
  const DocChatbotInitialState(super.messages);
}

final class DocChatbotLoadingState extends DocChatbotState {
  const DocChatbotLoadingState(super.messages);
}

final class DocChatbotSuccessState extends DocChatbotState {
  const DocChatbotSuccessState(super.messages);
}

final class DocChatbotErrorState extends DocChatbotState {
  final String error;

  const DocChatbotErrorState(super.messages, this.error);
}