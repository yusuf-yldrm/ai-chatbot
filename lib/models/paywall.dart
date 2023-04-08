import 'dart:ffi';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:use/models/platforms.dart';

class Paywall {

  // Properties

  String id;
  String? title;
  String? description;
  String actionText;
  bool isDefault;
  Platforms platforms;

  // Initialization

  Paywall({
    required this.id,
    this.title,
    this.description,
    required this.actionText,
    required this.isDefault,
    required this.platforms,
  });

  // Methods

  factory Paywall.fromJson(Map<String, dynamic?> json) {
    return Paywall(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      actionText: json['action_text'],
      isDefault: json['is_default'],
      platforms: json['platforms'] == null ? Platforms() : Platforms.fromJson(json['platforms']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic?>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['action_text'] = actionText;
    data['is_default'] = isDefault;
    data['platforms'] = platforms.toJson();
    return data;
  }
}