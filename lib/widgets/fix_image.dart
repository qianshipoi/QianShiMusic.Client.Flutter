import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:qianshi_music/utils/ssj_request_manager.dart';

class FixImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final String? cacheKey;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;
  const FixImage({
    Key? key,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
    this.cacheKey,
    this.progressIndicatorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      httpHeaders: Map<String, String>.from({"User-Agent": bytesUserAgent}),
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      progressIndicatorBuilder: progressIndicatorBuilder,
      height: height,
      cacheKey: cacheKey,
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
