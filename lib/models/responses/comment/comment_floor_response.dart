import 'package:qianshi_music/models/responses/base_response.dart';

abstract class CommentFloorResponse<T> extends BaseResponse {
  final T? data;
  CommentFloorResponse({
    required super.code,
    super.msg,
    required this.data,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()..addAll(dataToMap());
  }

  Map<String, dynamic> dataToMap();
}
