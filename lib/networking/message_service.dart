
import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:use/models/message_response.dart';

class MessageService {

  // Properties

  static final baseURL = "https://api.revoo.studio/api/use";

  // Methods

  static Future<String> sendMessage(
    String input,
    String model,
    int maxTokens,
    double temperature,
    double topP,
    double presencePenalty,
    double frequencyPenalty,
    int bestOf,
  ) async {
    final url = Uri.parse('$baseURL/send-message');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'input': input,
          'model': model,
          'max_tokens': maxTokens,
          'temperature': temperature,
          'top_p': topP,
          'presence_penalty': presencePenalty,
          'frequency_penalty': frequencyPenalty,
          'best_of': bestOf
        })
      );

      if (response.statusCode == 200) {
        final messageResponse = MessageResponse.fromJson(jsonDecode(response.body));
        return messageResponse.text;
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}