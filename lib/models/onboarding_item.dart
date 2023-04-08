import 'dart:ffi';

class OnboardingItem {

  String id;
  Int index;
  String image;
  String title;
  String description;

  OnboardingItem({
    required this.id,
    required this.index,
    required this.image,
    required this.title,
    required this.description,
  });

  factory OnboardingItem.fromJson(Map<String, dynamic> json) {
    return new OnboardingItem(
      id: json['id'],
      index: json['index'],
      image: json['image'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['index'] = index;
    data['image'] = image;
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}