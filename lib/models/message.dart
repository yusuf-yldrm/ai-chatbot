import 'dart:ffi';
import 'package:uuid/uuid.dart';

class MessageFields {
  static final List<String> values = [
    id, model, message, isGPT, showPremiumTag, createdAt
  ];

  static final String id = "_id";
  static final String model = "model";
  static final String message = "message";
  static final String isGPT = "is_gpt";
  static final String showPremiumTag = "show_premium_tag";
  static final String createdAt = "created_at";
}

class Message {

  int? id;
  String model;
  String message;
  bool isGPT;
  bool showPremiumTag;
  DateTime createdAt;

  Message({
    this.id,
    required this.model,
    required this.message,
    required this.isGPT,
    required this.showPremiumTag,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return new Message(
      id: json[MessageFields.id] as int?,
      model: json[MessageFields.model] as String,
      message: json[MessageFields.message] as String,
      isGPT: json[MessageFields.isGPT] == 1,
      showPremiumTag: json[MessageFields.showPremiumTag] == 1,
      createdAt: DateTime.parse(json[MessageFields.createdAt] as String),
    );
  }

  Map<String, Object?> toJson() => {
    MessageFields.id: id,
    MessageFields.model: model,
    MessageFields.message: message,
    MessageFields.isGPT: isGPT ? 1 : 0,
    MessageFields.showPremiumTag: showPremiumTag ? 1 : 0,
    MessageFields.createdAt: createdAt.toIso8601String(),
  };

  Message copy({
    int? id,
    String? model,
    String? message,
    bool? isGPT,
    bool? showPremiumTag,
    DateTime? createdAt
  }) =>
    Message(
      id: id ?? this.id,
      model: model ?? this.model,
      message: message ?? this.message,
      isGPT: isGPT ?? this.isGPT,
      showPremiumTag: showPremiumTag ?? this.showPremiumTag,
      createdAt: createdAt ?? this.createdAt,
    );
}