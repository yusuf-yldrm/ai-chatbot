import 'package:use/models/product.dart';

class Platforms {
  List<Product>? iOS;
  List<Product>? macOS;
  List<Product>? android;

  Platforms({
    this.iOS,
    this.macOS,
    this.android,
  });

  factory Platforms.fromJson(Map<String, dynamic?> json) {
    var iOS = json['iOS'] as List?;
    List<Product>? iOSProducts = iOS?.map((i) => Product.fromJson(i)).toList();

    var macOS = json['macOS'] as List?;
    List<Product>? macOSProducts = macOS?.map((i) => Product.fromJson(i)).toList();

    var android = json['android'] as List?;
    List<Product>? androidProducts = android?.map((i) => Product.fromJson(i)).toList();

    return Platforms(
      iOS: iOSProducts,
      macOS: macOSProducts,
      android: androidProducts
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic?>();
    data['iOS'] = iOS;
    data['macOS'] = macOS;
    data['android'] = android;
    return data;
  }
}