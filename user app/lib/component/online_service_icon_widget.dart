import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/images.dart';

class OnlineServiceIconWidget extends StatelessWidget {
  final bool isShowText;

  const OnlineServiceIconWidget({super.key, this.isShowText = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(24)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 26,
            margin: EdgeInsets.only(right: isShowText ? 8 : 0),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            child: ic_video.iconImage(size: 15, color: white),
          ),
          if (isShowText) Text(language.online, style: boldTextStyle(size: 12, color: Colors.green)).paddingRight(16),
        ],
      ),
    );
  }
}
