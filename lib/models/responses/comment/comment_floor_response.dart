import 'package:qianshi_music/models/responses/base_response.dart';

abstract class CommentFloorResponse<T> extends BaseResponse {
  final T? data;
  CommentFloorResponse({
    required super.code,
    super.msg,
    required this.data,
  });
}
