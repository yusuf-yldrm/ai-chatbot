import 'dart:ffi';
import 'package:use/models/image_data.dart';

class ImageResponse {

  /// The creation date of the response.
  final int created;

  /// The data sent within the response containing either `URL` or `Base64` data.
  final List<ImageData> data;

  ImageResponse({
    required this.created,
    required this.data,
  });

  factory ImageResponse.fromJson(Map<String, dynamic> json) {
    final created = json['created'] as int;
    final dataList = json['data'] as List<dynamic>;
    final data = dataList.map((item) => ImageData.fromJson(item)).toList();
    return ImageResponse(created: created, data: data);
  }

  Map<String, dynamic> toJson() {
    final data = this.data.map((item) => item.toJson()).toList();
    return {
      'created': created,
      'data': data,
    };
  }
}
