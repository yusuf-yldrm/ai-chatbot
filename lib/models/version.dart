import 'dart:ffi';

class Version {

  String number;
  String platform;
  bool underReview;

  Version({
    required this.number,
    required this.platform,
    required this.underReview,
  });

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      number: json['number'],
      platform: json['platform'],
      underReview: json['under_review'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = number;
    data['platform'] = platform;
    data['under_review'] = underReview;
    return data;
  }
}