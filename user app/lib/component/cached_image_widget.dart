import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CachedImageWidget extends StatelessWidget {
  final String url;
  final double height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  final String? placeHolderImage;
  final AlignmentGeometry? alignment;
  final bool usePlaceholderIfUrlEmpty;
  final bool circle;
  final double? radius;
  final Widget? child;

  CachedImageWidget({
    required this.url,
    required this.height,
    this.width,
    this.fit,
    this.color,
    this.placeHolderImage,
    this.alignment,
    this.radius,
    this.usePlaceholderIfUrlEmpty = true,
    this.circle = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (url.validate().isEmpty) {
      return Container(
        height: height,
        width: width ?? height,
        color: color ?? grey.withValues(alpha:0.1),
        alignment: alignment,
        //padding: EdgeInsets.all(10),
        //child: Image.asset(ic_no_photo, color: appStore.isDarkMode ? Colors.white : Colors.black),
        child: Stack(
          children: [
            PlaceHolderWidget(
              height: height,
              width: width,
              alignment: alignment ?? Alignment.center,
            ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0)),
            child ?? Offstage(),
          ],
        ),
      ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0));
    } else if (url.validate().startsWith('http')) {
      return CachedNetworkImage(
        placeholder: (_, __) {
          return Stack(
            children: [
              PlaceHolderWidget(
                height: height,
                width: width,
                alignment: alignment ?? Alignment.center,
              ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0)),
              child ?? Offstage(),
            ],
          );
        },
        imageUrl: url,
        height: height,
        width: width ?? height,
        fit: fit,
        color: color,
        alignment: alignment as Alignment? ?? Alignment.center,
        errorWidget: (_, s, d) {
          return Stack(
            children: [
              PlaceHolderWidget(
                height: height,
                width: width,
                alignment: alignment ?? Alignment.center,
              ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0)),
              child ?? Offstage(),
            ],
          );
        },
      ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0));
    } else {
      if (url.validate().startsWith(r"assets/")) {
        return Image.asset(
          url,
          height: height,
          width: width ?? height,
          fit: fit,
          color: color,
          alignment: alignment ?? Alignment.center,
          errorBuilder: (_, s, d) {
            return Stack(
              children: [
                PlaceHolderWidget(
                  height: height,
                  width: width,
                  alignment: alignment ?? Alignment.center,
                ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0)),
                child ?? Offstage(),
              ],
            );
          },
        ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0));
      } else {
        return Image.file(
          File(url),
          height: height,
          width: width,
          fit: fit,
          color: color,
          alignment: alignment ?? Alignment.center,
          errorBuilder: (_, s, d) {
            return Stack(
              children: [
                PlaceHolderWidget(
                  height: height,
                  width: width,
                  alignment: alignment ?? Alignment.center,
                ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0)),
                child ?? Offstage(),
              ],
            );
          },
        ).cornerRadiusWithClipRRect(radius ?? (circle ? (height.validate() / 2) : 0));
      }
    }
  }
}
