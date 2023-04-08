
import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:use/models/image_response.dart';
import 'package:use/models/message_response.dart';

class OpenAIService {

  // Properties

  static final baseURL = "https://api.openai.com/v1";
  static final apiKey = "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";

  // Methods

  static Future<ImageResponse> createImages(String prompt, int numberOfImages) async {
    final url = Uri.parse('$baseURL/images/generations');
    final body = jsonEncode({
      "prompt": prompt,
      "n": numberOfImages,
      "size": "512x512",
      "response_format": "url"
    });

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: body,
      );

      print("response.statusCode: ${response.statusCode}");
      print("response.body: ${response.body}");

      if (response.statusCode == 200) {
        final imageResponse = ImageResponse.fromJson(jsonDecode(response.body));
        return imageResponse;
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}