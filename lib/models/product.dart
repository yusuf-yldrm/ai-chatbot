import 'dart:ffi';
import 'package:uuid/uuid.dart';

class Product {

  String productId;
  String? subscriptionPeriod;
  String? offerText;
  String? leftText;
  String? leftTextColor;
  String? rightText;
  String? rightTextColor;

  Product({
    required this.productId,
    this.subscriptionPeriod,
    this.offerText,
    this.leftText,
    this.leftTextColor,
    this.rightText,
    this.rightTextColor,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return new Product(
      productId: json['product_id'],
      subscriptionPeriod: json['subscription_period'],
      offerText: json['offer_text'],
      leftText: json['left_text'],
      leftTextColor: json['left_text_color'],
      rightText: json['right_text'],
      rightTextColor: json['right_text_color'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = productId;
    data['subscription_period'] = subscriptionPeriod;
    data['offer_text'] = offerText;
    data['left_text'] = leftText;
    data['left_text_color'] = leftTextColor;
    data['right_text'] = rightText;
    data['right_text_color'] = rightTextColor;
    return data;
  }
}