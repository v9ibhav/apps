import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/configs.dart';

class CommonPdfPlaceHolder extends StatelessWidget {
  final String text;
  final String fileExt;
  final double width;
  final double height;

  const CommonPdfPlaceHolder({super.key, this.height = 90, this.width = 80, this.text = "file", this.fileExt = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            fileExt.isPdf
                ? Icons.picture_as_pdf_outlined
                : fileExt.isVideo
                    ? Icons.video_file_outlined
                    : fileExt.isAudio
                        ? Icons.audio_file_outlined
                        : Icons.file_copy_rounded,
            color: primaryColor,
            size: 32,
          ),
          15.height,
          Marquee(child: Text(text == "file" ? "File" : text, overflow: TextOverflow.ellipsis, style: primaryTextStyle(), maxLines: 1, textAlign: TextAlign.center)),
        ],
      ).center(),
    );
  }
}
