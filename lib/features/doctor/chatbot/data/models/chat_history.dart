class ChatHistory {
  final String role;
  final String content;

  ChatHistory({
    required this.role,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
  };
}