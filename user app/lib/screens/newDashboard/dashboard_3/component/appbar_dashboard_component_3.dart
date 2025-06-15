import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../model/service_data_model.dart';
import '../../../notification/notification_screen.dart';
import '../../../service/search_service_screen.dart';

class AppbarDashboardComponent3 extends StatefulWidget {
  final List<ServiceData> featuredList;
  final VoidCallback? callback;

  AppbarDashboardComponent3({required this.featuredList, this.callback});

  @override
  State<AppbarDashboardComponent3> createState() => _AppbarDashboardComponent3State();
}

class _AppbarDashboardComponent3State extends State<AppbarDashboardComponent3> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (appStore.isLoggedIn)
          CachedImageWidget(
            url: appStore.userProfileImage.validate(),
            height: 44,
            width: 44,
            fit: BoxFit.cover,
          ).cornerRadiusWithClipRRect(100).paddingRight(16),
        Row(
          children: [
            Text(
              appStore.isLoggedIn ? appStore.userFullName : language.helloGuest,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: boldTextStyle(),
            ),
            appStore.isLoggedIn ? Offstage() : Image.asset(ic_hi, height: 20, fit: BoxFit.cover),
          ],
        ).expand(),
        16.width,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: appStore.unreadCount > 0 ? 10 : 8),
          decoration: boxDecorationDefault(
            color: context.cardColor,
            borderRadius: radius(28),
          ),
          child: Row(
            children: [
              ic_search.iconImage(size: 18).onTap(() {
                SearchServiceScreen(featuredList: widget.featuredList).launch(context).then((value) {
                  setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.dark);
                });
              }),
              if (appStore.isLoggedIn)
                Container(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ic_notification.iconImage(size: 18).center(),
                      if (appStore.unreadCount.validate() > 0)
                        Observer(builder: (context) {
                          return Positioned(
                            top: -2,
                            right: 2,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: boxDecorationDefault(color: Colors.red, shape: BoxShape.circle),
                            ),
                          );
                        })
                    ],
                  ),
                ).paddingLeft(12).onTap(() {
                  NotificationScreen().launch(context).then((value) {
                    setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.dark);
                  });
                })
            ],
          ),
        )
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
