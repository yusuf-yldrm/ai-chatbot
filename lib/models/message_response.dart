import 'dart:ffi';

class MessageResponse {

  String text;

  MessageResponse({
    required this.text
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return new MessageResponse(
      text: json['text']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = text;
    return data;
  }
}