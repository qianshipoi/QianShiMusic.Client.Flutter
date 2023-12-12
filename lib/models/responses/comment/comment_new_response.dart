import 'package:qianshi_music/models/responses/base_response.dart';

abstract class CommentNewResponse<T> extends BaseResponse {
  final T? data;
  CommentNewResponse({
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
