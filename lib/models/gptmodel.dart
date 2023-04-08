import 'dart:ffi';

class GPTModel {

  String image;
  String name;
  String title;
  String description;
  int maxTokens;
  double temperature;
  double topP;
  int numberOfCompletions;
  double presencePenalty;
  double frequencyPenalty;
  int bestOf;
  bool isPremium;

  GPTModel({
    required this.image,
    required this.name,
    required this.title,
    required this.description,
    required this.maxTokens,
    required this.temperature,
    required this.topP,
    required this.numberOfCompletions,
    required this.presencePenalty,
    required this.frequencyPenalty,
    required this.bestOf,
    required this.isPremium,
  });

  factory GPTModel.fromJson(Map<String, dynamic> json) {
    return new GPTModel(
      image: json['image'],
      name: json['name'],
      title: json['title'],
      description: json['description'],
      maxTokens: json['max_tokens'],
      temperature: json['temperature'],
      topP: json['top_p'],
      numberOfCompletions: json['number_of_completions'],
      presencePenalty: json['presence_penalty'],
      frequencyPenalty: json['frequency_penalty'],
      bestOf: json['bestOf'],
      isPremium: json['is_premium'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = image;
    data['name'] = name;
    data['title'] = title; 
    data['description'] = description;
    data['max_tokens'] = maxTokens;
    data['temperature'] = temperature;
    data['top_p'] = topP;
    data['number_of_completions'] = numberOfCompletions;
    data['presence_penalty'] = presencePenalty;
    data['frequency_penalty'] = frequencyPenalty;
    data['bestOf'] = bestOf;
    data['is_premium'] = isPremium;
    return data;
  }
}