import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/screens/zoom_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ImageBorder extends StatelessWidget {
  final String src;
  final double height;
  final double? width;
  final Color? borderColor;
  final double borderWidth;

  ImageBorder({required this.src, required this.height, this.width, this.borderColor, this.borderWidth = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? context.dividerColor, width: borderWidth),
        shape: BoxShape.circle,
      ),
      child: CachedImageWidget(
        url: src,
        circle: true,
        height: height,
        width: width,
        fit: BoxFit.cover,
      ).onTap(() {
        if (src.isNotEmpty) ZoomImageScreen(galleryImages: [src], index: 0).launch(context);
      }),
    );
  }
}
