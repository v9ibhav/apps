import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../main.dart';
import '../../../../model/service_data_model.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/images.dart';
import '../../../notification/notification_screen.dart';
import '../../../service/search_service_screen.dart';

class CustomAppbarDashboardComponent2 extends StatefulWidget {
  final List<ServiceData>? featuredList;
  final VoidCallback? callback;

  CustomAppbarDashboardComponent2({this.callback, this.featuredList});

  @override
  State<CustomAppbarDashboardComponent2> createState() => _CustomAppbarDashboardComponent2State();
}

class _CustomAppbarDashboardComponent2State extends State<CustomAppbarDashboardComponent2> {
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
    return Container(
      width: context.width(),
      decoration: boxDecorationDefault(color: primaryColor),
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (context.statusBarHeight.toInt() + 8).height,
          Observer(
            builder: (context) {
              return Row(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          ic_location.iconImage(color: Colors.white, size: 22),
                          8.width,
                          Text(
                            appStore.isCurrentLocation ? getStringAsync(CITY_NAME) : language.helloGuest,
                            style: boldTextStyle(color: white),
                          ),
                          if (!appStore.isCurrentLocation) Image.asset(ic_hi, height: 20, fit: BoxFit.cover),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Marquee(
                            child: Text(
                              appStore.isCurrentLocation ? getStringAsync(CURRENT_ADDRESS) : language.lblLocationOff,
                              style: secondaryTextStyle(color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ).expand(),
                          IconButton(
                            icon: Icon(Icons.keyboard_arrow_down_outlined, size: 20),
                            color: Colors.white,
                            onPressed: () {
                              locationWiseService(context, () {
                                widget.callback?.call();
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  ).expand(),
                  if (appStore.isLoggedIn)
                    Container(
                      height: 36,
                      width: 36,
                      margin: EdgeInsets.only(left: 12),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ic_notification.iconImage(size: 24, color: Colors.white),
                          Observer(
                            builder: (context) {
                              return Positioned(
                                top: -20,
                                right: -10,
                                child: appStore.unreadCount.validate() > 0
                                    ? Container(
                                        padding: EdgeInsets.all(6),
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
                    })
                ],
              );
            },
          ),
          8.height,
          Observer(builder: (context) {
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
          30.height,
        ],
      ),
    ).cornerRadiusWithClipRRectOnly(bottomLeft: 30, bottomRight: 30);
  }
}
