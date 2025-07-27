import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

//NetworkImageCircleAvatar
class NetworkImageCircleAvatar extends StatelessWidget {
  final double radius;
  final String imageurl;
  final Color? backgroundColor;
  const NetworkImageCircleAvatar({
    super.key,
    required this.radius,
    required this.imageurl,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundImage: CachedNetworkImageProvider(imageurl, cacheKey: imageurl),
    );
  }
}

//AssetImageCircleAvatar
class AssetImageCircleAvatar extends StatelessWidget {
  final double radius;
  final String imageurl;
  final Color? backgroundColor;
  const AssetImageCircleAvatar({
    super.key,
    required this.radius,
    required this.imageurl,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundImage: AssetImage(imageurl),
    );
  }
}

//FileImageCircleAvatar
class FileImageCircleAvatar extends StatelessWidget {
  final double radius;
  final File fileImage;
  final Color? backgroundColor;
  const FileImageCircleAvatar({
    super.key,
    required this.radius,
    required this.fileImage,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundImage: FileImage(fileImage),
    );
  }
}
