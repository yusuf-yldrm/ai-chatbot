import 'dart:ffi';

class ImageData {

  static const String urlKey = 'url';
  static const String b64JsonKey = 'b64_json';

  /// The image is stored as a URL string.
  final String? url;

  /// The image is stored as a Base64 binary.
  final String? b64Json;

  ImageData.url(this.url) : b64Json = null;

  ImageData.b64Json(this.b64Json) : url = null;

  /// The image itself.
  String? get image {
    return b64Json ?? url;
  }

  factory ImageData.fromJson(Map<String, dynamic> json) {
    final url = json[urlKey];
    final b64Json = json[b64JsonKey];

    if (url != null) {
      return ImageData.url(url);
    } else if (b64Json != null) {
      return ImageData.b64Json(b64Json);
    } else {
      throw FormatException('Invalid ImageData JSON: $json');
    }
  }

  Map<String, dynamic> toJson() {
    if (url != null) {
      return {
        urlKey: url,
      };
    } else if (b64Json != null) {
      return {
        b64JsonKey: b64Json,
      };
    } else {
      throw StateError('Invalid ImageData: neither url nor b64Json is set.');
    }
  }
}