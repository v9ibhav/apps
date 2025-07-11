import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/images.dart';

class HandymanNameWidget extends StatelessWidget {
  final String name;
  final bool? isHandymanAvailable;
  final bool showVerifiedBadge;

  final int size;
  final MainAxisAlignment mainAxisAlignment;

  HandymanNameWidget({
    required this.name,
    this.isHandymanAvailable,
    this.size = 16,
    this.showVerifiedBadge = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isHandymanAvailable != null)
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: isHandymanAvailable! ? Colors.lightGreen : redColor,
                  shape: BoxShape.circle,
                ),
              ),
              8.width,
            ],
          ),
        Marquee(child: Text(name, style: boldTextStyle(size: size), maxLines: 1)).flexible(),
         if (showVerifiedBadge)
        ...[
          4.width,
          ImageIcon(
            AssetImage(ic_verified),
            size: 14,
            color: Colors.green,
          )
        ],
      ],
    );
  }
}
