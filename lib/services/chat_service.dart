
  import 'dart:convert';

  import 'package:http/http.dart' as http;

  import '../config/api_config.dart';
  import '../utils/token_storage.dart';

  class ChatService {
  // =========================================================
  // COMMON HEADERS
  // =========================================================

  static Future<Map<String, String>> _getHeaders() async {
  final token = await TokenStorage.getAccessToken();

  if (token == null || token.isEmpty) {
  throw Exception("Authentication token not found");
  }

  return {
  "Content-Type": "application/json",
  "Accept": "application/json",
  "Authorization": "Bearer $token",
  };
  }

  // =========================================================
  // FETCH ALL CONVERSATIONS
  // Buyer aur Farmer dono is method ko use karenge
  // =========================================================

  static Future<List<dynamic>> fetchConversations() async {
  final url = Uri.parse(
  "${ApiConfig.baseUrl}/chat/",
  );

  try {
  final response = await http.get(
  url,
  headers: await _getHeaders(),
  );

  if (response.statusCode == 200) {
  final decoded = jsonDecode(response.body);

  if (decoded is List) {
  return decoded;
  }

  if (decoded is Map<String, dynamic>) {
  if (decoded["results"] is List) {
  return decoded["results"];
  }

  if (decoded["data"] is List) {
  return decoded["data"];
  }

  if (decoded["conversations"] is List) {
  return decoded["conversations"];
  }
  }

  return [];
  }

  throw Exception(
  _extractErrorMessage(
  response.body,
  fallback: "Failed to fetch conversations",
  ),
  );
  } catch (error) {
  if (error is Exception) {
  rethrow;
  }

  throw Exception("Unable to connect with chat server");
  }
  }

  // =========================================================
  // CREATE CONVERSATION
  // Sirf tab use karo jab backend automatically conversation
  // create nahi karta
  // =========================================================

  static Future<Map<String, dynamic>> createConversation({
  required String inquiryId,
  }) async {
  if (inquiryId.trim().isEmpty) {
  throw Exception("Inquiry ID is required");
  }

  final url = Uri.parse(
  "${ApiConfig.baseUrl}/chat/",
  );

  try {
  final response = await http.post(
  url,
  headers: await _getHeaders(),
  body: jsonEncode({
  "inquiry": inquiryId,
  }),
  );

  if (response.statusCode == 200 ||
  response.statusCode == 201) {
  final decoded = jsonDecode(response.body);

  if (decoded is Map<String, dynamic>) {
  final data = decoded["data"];

  if (data is Map<String, dynamic>) {
  return data;
  }

  return decoded;
  }

  throw Exception("Invalid conversation response");
  }

  throw Exception(
  _extractErrorMessage(
  response.body,
  fallback: "Failed to create conversation",
  ),
  );
  } catch (error) {
  if (error is Exception) {
  rethrow;
  }

  throw Exception("Unable to create conversation");
  }
  }

  // =========================================================
  // FETCH MESSAGES
  // Buyer aur Farmer dono use karenge
  // =========================================================

  static Future<List<dynamic>> fetchMessages({
  required String conversationId,
  }) async {
  if (conversationId.trim().isEmpty) {
  throw Exception("Conversation ID is required");
  }

  final url = Uri.parse(
  "${ApiConfig.baseUrl}/chat/$conversationId/messages/",
  );

  try {
  final response = await http.get(
  url,
  headers: await _getHeaders(),
  );

  if (response.statusCode == 200) {
  final decoded = jsonDecode(response.body);

  if (decoded is List) {
  return decoded;
  }

  if (decoded is Map<String, dynamic>) {
  if (decoded["results"] is List) {
  return decoded["results"];
  }

  if (decoded["data"] is List) {
  return decoded["data"];
  }

  if (decoded["messages"] is List) {
  return decoded["messages"];
  }
  }

  return [];
  }

  throw Exception(
  _extractErrorMessage(
  response.body,
  fallback: "Failed to fetch messages",
  ),
  );
  } catch (error) {
  if (error is Exception) {
  rethrow;
  }

  throw Exception("Unable to fetch chat messages");
  }
  }

  // =========================================================
  // SEND MESSAGE
  // Sender ID backend JWT token se identify karega
  // =========================================================

  static Future<Map<String, dynamic>> sendMessage({
  required String conversationId,
  required String message,
  }) async {
  final cleanMessage = message.trim();

  if (conversationId.trim().isEmpty) {
  throw Exception("Conversation ID is required");
  }

  if (cleanMessage.isEmpty) {
  throw Exception("Message cannot be empty");
  }

  final url = Uri.parse(
  "${ApiConfig.baseUrl}/chat/$conversationId/messages/",
  );

  try {
  final response = await http.post(
  url,
  headers: await _getHeaders(),
  body: jsonEncode({
  "text": cleanMessage,
  }),
  );

  if (response.statusCode == 200 ||
  response.statusCode == 201) {
  final decoded = jsonDecode(response.body);

  if (decoded is Map<String, dynamic>) {
  final data = decoded["data"];

  if (data is Map<String, dynamic>) {
  return data;
  }

  return decoded;
  }

  throw Exception("Invalid message response");
  }

  throw Exception(
  _extractErrorMessage(
  response.body,
  fallback: "Failed to send message",
  ),
  );
  } catch (error) {
  if (error is Exception) {
  rethrow;
  }

  throw Exception("Unable to send message");
  }
  }

  // =========================================================
  // MARK CONVERSATION MESSAGES AS READ
  // Backend endpoint available ho to use hoga
  // =========================================================

  static Future<void> markMessagesAsRead({
  required String conversationId,
  }) async {
  if (conversationId.trim().isEmpty) {
  throw Exception("Conversation ID is required");
  }

  final url = Uri.parse(
  "${ApiConfig.baseUrl}/chat/$conversationId/read/",
  );

  try {
  final response = await http.patch(
  url,
  headers: await _getHeaders(),
  );

  if (response.statusCode == 200 ||
  response.statusCode == 204) {
  return;
  }

  throw Exception(
  _extractErrorMessage(
  response.body,
  fallback: "Failed to mark messages as read",
  ),
  );
  } catch (error) {
  if (error is Exception) {
  rethrow;
  }

  throw Exception("Unable to update message status");
  }
  }

  // =========================================================
  // ERROR MESSAGE PARSER
  // =========================================================

  static String _extractErrorMessage(
  String responseBody, {
  required String fallback,
  }) {
  try {
  final decoded = jsonDecode(responseBody);

  if (decoded is Map<String, dynamic>) {
  if (decoded["detail"] != null) {
  return decoded["detail"].toString();
  }

  if (decoded["message"] != null) {
  return decoded["message"].toString();
  }

  if (decoded["error"] != null) {
  return decoded["error"].toString();
  }

  if (decoded["non_field_errors"] is List &&
  decoded["non_field_errors"].isNotEmpty) {
  return decoded["non_field_errors"].first.toString();
  }

  for (final value in decoded.values) {
  if (value is List && value.isNotEmpty) {
  return value.first.toString();
  }

  if (value is String && value.isNotEmpty) {
  return value;
  }
  }
  }
  } catch (_) {
  // Response JSON format me nahi hai.
  }

  return fallback;
  }
  }
