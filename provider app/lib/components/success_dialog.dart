import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/configs.dart';

class SuccessDialog extends StatelessWidget {
  final String title, description, buttonText;

  SuccessDialog({
    required this.title,
    required this.description,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return AnimatedScrollView(
      children: [
        Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: Consts.avatarRadius + Consts.padding,
                bottom: Consts.padding,
                left: Consts.padding,
                right: Consts.padding,
              ),
              margin: EdgeInsets.only(top: Consts.avatarRadius),
              decoration: new BoxDecoration(
                color: context.scaffoldBackgroundColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(Consts.padding),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  24.height,
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: primaryTextStyle(size: 18, weight: FontWeight.bold),
                  ),
                  8.height,
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: secondaryTextStyle(size: 14, color: Colors.grey),
                  ),
                  32.height,
                  AppButton(
                    text: languages.done,
                    height: 40,
                    color: primaryColor,
                    textStyle: boldTextStyle(color: white),
                    width: context.width() * 0.4,
                    onTap: () {
                      finish(context, true);
                      finish(context, true);
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: DottedBorder(
                color: primaryColor,
                strokeWidth: 2,
                dashPattern: [8, 9],
                borderType: BorderType.Circle,
                padding: EdgeInsets.all(6),
                child: Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    padding: EdgeInsets.all(19),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    child: CachedImageWidget(
                      url: ic_right,
                      height: 14,
                      width: 14,
                      color: white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Consts {
  Consts._();
  static const double padding = 8.0;
  static const double avatarRadius = 50.0;
}
