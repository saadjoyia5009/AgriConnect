class AIChatMessage {
  final String role;
  final String content;
  final DateTime createdAt;

  const AIChatMessage({
    required this.role,
    required this.content,
    required this.createdAt,
  });

  bool get isUser => role == 'user';

  bool get isAssistant => role == 'assistant';
}