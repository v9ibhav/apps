import 'dart:io';

import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/configs.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class NewUpdateDialog extends StatelessWidget {
  final bool canClose;

  const NewUpdateDialog({super.key, this.canClose = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: context.width() - 16,
          constraints: BoxConstraints(maxHeight: context.height() * 0.6),
          child: AnimatedScrollView(
            listAnimationType: ListAnimationType.FadeIn,
            children: [
              60.height,
              Text(language.lblNewUpdate, style: boldTextStyle(size: 18)),
              8.height,
              Text(
                '${language.lblAnUpdateTo} $APP_NAME ${language.isAvailableGoTo}',
                style: secondaryTextStyle(),
                textAlign: TextAlign.left,
              ),
              24.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppButton(
                    text: canClose ? language.later : language.closeApp,
                    textStyle: boldTextStyle(color: primaryColor, size: 14),
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: primaryColor)),
                    elevation: 0,
                    onTap: () async {
                      if (canClose) {
                        finish(context);
                      } else {
                        exit(0);
                      }
                    },
                  ).expand(),
                  32.width,
                  AppButton(
                    text: language.lblUpdate,
                    textStyle: boldTextStyle(color: Colors.white),
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                    color: primaryColor,
                    elevation: 0,
                    onTap: () async {
                      getPackageName().then((value) async {
                        if (isAndroid) {
                          String package = '';
                          package = value;

                          commonLaunchUrl(
                            '${getSocialMediaLink(LinkProvider.PLAY_STORE)}$package',
                            launchMode: LaunchMode.externalApplication,
                          );

                          if (canClose) {
                            finish(context);
                          } else {
                            exit(0);
                          }
                        } else if (isIOS) {
                          await launchUrl(Uri.parse(IOS_LINK_FOR_USER));
                          if (canClose) {
                            finish(context);
                          } else {
                            exit(0);
                          }
                        }
                      });
                    },
                  ).expand(),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 24),
        ),
        Positioned(
          top: -42,
          child: Image.asset(imgForceUpdate, height: 100, width: 100, fit: BoxFit.cover),
        ),
      ],
    );
  }
}
