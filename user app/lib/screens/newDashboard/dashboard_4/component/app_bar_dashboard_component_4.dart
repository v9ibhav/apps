import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../component/cached_image_widget.dart';
import '../../../../main.dart';
import '../../../../model/service_data_model.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/images.dart';
import '../../../notification/notification_screen.dart';
import '../../../service/search_service_screen.dart';

class AppBarDashboardComponent4 extends StatefulWidget {
  final List<ServiceData>? featuredList;
  final VoidCallback? callback;

  AppBarDashboardComponent4({this.callback, this.featuredList});

  @override
  _AppBarDashboardComponent4State createState() => _AppBarDashboardComponent4State();
}

class _AppBarDashboardComponent4State extends State<AppBarDashboardComponent4> {
  SpeechToText speech = SpeechToText();
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';

  void startListening() async {
    bool available = await speech.initialize(onStatus: statusListener, onError: errorListener);

    if (available) {
      speech.listen(onResult: resultListener);

      appStore.setSpeechStatus(true);
      lastWords = '';
      lastError = '';
      speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 10),
        listenOptions: SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
          listenMode: ListenMode.deviceDefault,
        ),
      );
      setState(() {});
    } else {
      appStore.setSpeechStatus(false);
      toast(language.theUserHasDenied);
    }
  }

  void stopListening() {
    appStore.setSpeechStatus(false);
    speech.stop();
  }

  void cancelListening() {
    appStore.setSpeechStatus(false);
    speech.cancel();
  }

  void resultListener(SpeechRecognitionResult result) {
    appStore.setSpeechStatus(false);
    if (result.finalResult) {
      lastWords = result.recognizedWords;
      SearchServiceScreen(search: lastWords, featuredList: widget.featuredList).launch(context);
    }
    log("LastWords: $lastWords");
  }

  void errorListener(SpeechRecognitionError error) {
    appStore.setSpeechStatus(false);
    lastError = '${error.errorMsg} - ${error.permanent}';
    log("lastError: $lastError");
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = '$status';
      log("lastStatus: $lastStatus");
    });

    if (status == 'done') {
      appStore.setSpeechStatus(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    appStore.setSpeechStatus(false);
    speech.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: context.width(),
          height: context.height() * 0.18,
          decoration: boxDecorationDefault(color: primaryColor),
          padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CachedImageWidget(url: imgAppLogo, height: 35, width: 35),
              Observer(
                builder: (context) {
                  return AppButton(
                    onTap: () async {
                      locationWiseService(context, () {
                        widget.callback?.call();
                      });
                    },
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.only(left: 20, right: appStore.isLoggedIn ? 20 : 0, top: 16, bottom: 16),
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(36)),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius(36)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ic_location.iconImage(color: appStore.isDarkMode ? Colors.white : Colors.black),
                          8.width,
                          Marquee(
                            child: Text(
                              appStore.isCurrentLocation ? getStringAsync(CURRENT_ADDRESS) : language.lblLocationOff,
                              style: secondaryTextStyle(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ).expand(),
                          8.width,
                          Icon(Icons.keyboard_arrow_down, size: 24, color: context.iconColor),
                        ],
                      ),
                    ),
                  );
                },
              ).expand(flex: 4),
              if (appStore.isLoggedIn)
                SizedBox(
                  height: 25,
                  width: 25,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ic_notification.iconImage(color: Colors.white, size: 22),
                      Observer(
                        builder: (context) {
                          return Positioned(
                            top: appStore.unreadCount.validate() > 0 ? -16 : -10,
                            right: appStore.unreadCount.validate() > 0 ? -1 : 1,
                            child: appStore.unreadCount.validate() > 0
                                ? Container(
                                    padding: EdgeInsets.all(appStore.unreadCount.validate() > 0 ? 3 : 4),
                                    child: FittedBox(
                                      child: Text(appStore.unreadCount.toString(), style: primaryTextStyle(size: 12, color: Colors.white)),
                                    ),
                                    decoration: boxDecorationDefault(color: Colors.red, shape: BoxShape.circle),
                                  )
                                : Offstage(),
                          );
                        },
                      )
                    ],
                  ),
                ).onTap(() {
                  NotificationScreen().launch(context);
                }),
            ],
          ),
        ).cornerRadiusWithClipRRectOnly(bottomLeft: 16, bottomRight: 16, topLeft: 0, topRight: 0),
        Positioned(
          bottom: -26,
          left: 16,
          right: 16,
          child: Observer(builder: (context) {
            return Container(
              height: 50,
              width: context.width(),
              decoration: boxDecorationDefault(color: context.cardColor),
              child: AppTextField(
                textFieldType: TextFieldType.NAME,
                readOnly: true,
                onTap: () {
                  SearchServiceScreen(featuredList: widget.featuredList).launch(context);
                },
                decoration: inputDecoration(
                  context,
                  hintText: language.eGCleaningPlumberPest,
                  prefixIcon: ic_search.iconImage(size: 10, color: context.iconColor).paddingAll(14),
                ),
                suffix: IconButton(
                  icon: appStore.isSpeechActivated
                      ? Icon(Icons.stop, color: context.iconColor)
                      : Icon(
                    Icons.mic_none_outlined,
                    color: context.iconColor,
                  ),
                  color: context.iconColor,
                  onPressed: () async {
                    if (appStore.isSpeechActivated) {
                      stopListening();
                    } else {
                      startListening();
                    }
                  },
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
