import 'package:booking_system_flutter/component/image_border_component.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/screens/auth/sign_in_screen.dart';
import 'package:booking_system_flutter/screens/category/category_screen.dart';
import 'package:booking_system_flutter/screens/chat/chat_list_screen.dart';
import 'package:booking_system_flutter/screens/dashboard/fragment/booking_fragment.dart';
import 'package:booking_system_flutter/screens/dashboard/fragment/dashboard_fragment.dart';
import 'package:booking_system_flutter/screens/dashboard/fragment/profile_fragment.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/voice_search_component.dart';
import '../../utils/app_configuration.dart';
import '../../utils/firebase_messaging_utils.dart';
import '../newDashboard/dashboard_1/dashboard_fragment_1.dart';
import '../newDashboard/dashboard_2/dashboard_fragment_2.dart';
import '../newDashboard/dashboard_3/dashboard_fragment_3.dart';
import '../newDashboard/dashboard_4/dashboard_fragment_4.dart';

class DashboardScreen extends StatefulWidget {
  final bool? redirectToBooking;

  DashboardScreen({this.redirectToBooking});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;
  bool isInterNetConnect = true;

  @override
  void initState() {
    super.initState();
    if (widget.redirectToBooking.validate(value: false)) {
      currentIndex = 1;
    }

    afterBuildCreated(() async {
      /// Changes System theme when changed
      if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
        appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
      }

      View.of(context).platformDispatcher.onPlatformBrightnessChanged = () async {
        if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
          appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.light);
        }
      };
    });

    /// Handle Firebase Notification click and redirect to that Service & BookDetail screen
    LiveStream().on(LIVESTREAM_FIREBASE, (value) {
      if (value == 3) {
        currentIndex = 3;
        setState(() {});
      }
    });

    Firebase.initializeApp().then((value) {
      //When the app is in the background and opened directly from the push notification.
      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        //Handle onClick Notification
        log("data 1 ==> ${message.data}");
        handleNotificationClick(message);
      });

      FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
        //Handle onClick Notification
        if (message != null) {
          log("data 2 ==> ${message.data}");
          handleNotificationClick(message);
        }
      });
    }).catchError(onError);

    init();
  }

  void init() async {
    if (isMobile && appStore.isLoggedIn) {
      /// Handle Notification click and redirect to that Service & BookDetail screen
      ///
      /// TODO check if handled with firebase
      /*OneSignal.Notifications.addClickListener((notification) async {
        if (notification.notification.additionalData == null) return;

        if (notification.notification.additionalData!.containsKey('id')) {
          String? notId = notification.notification.additionalData!["id"].toString();
          if (notId.validate().isNotEmpty) {
            BookingDetailScreen(bookingId: notId.toString().toInt()).launch(context);
          }
        } else if (notification.notification.additionalData!.containsKey('service_id')) {
          String? notId = notification.notification.additionalData!["service_id"];
          if (notId.validate().isNotEmpty) {
            ServiceDetailScreen(serviceId: notId.toInt()).launch(context);
          }
        } else if (notification.notification.additionalData!.containsKey('sender_uid')) {
          String? notId = notification.notification.additionalData!["sender_uid"];
          if (notId.validate().isNotEmpty) {
            currentIndex = 3;
            setState(() {});
          }
        }
      });*/
    }

    await 3.seconds.delay;
    if (getIntAsync(FORCE_UPDATE_USER_APP).getBoolInt()) {
      showForceUpdateDialog(context);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(LIVESTREAM_FIREBASE);
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      message: language.lblBackPressMsg,
      child: Scaffold(
        body: AnimatedOpacity(
          opacity: 1,
          duration: Duration(milliseconds: 500),
          child: [
            Observer(
              builder: (context) {
                if (appConfigurationStore.userDashboardType == DASHBOARD_1) {
                  return DashboardFragment1();
                } else if (appConfigurationStore.userDashboardType == DASHBOARD_2) {
                  return DashboardFragment2();
                } else if (appConfigurationStore.userDashboardType == DASHBOARD_3) {
                  return DashboardFragment3();
                } else if (appConfigurationStore.userDashboardType == DASHBOARD_4) {
                  return DashboardFragment4();
                } else {
                  return DashboardFragment();
                }
              }
            ),
            Observer(builder: (context) => appStore.isLoggedIn ? BookingFragment() : SignInScreen(isFromDashboard: true)),
            CategoryScreen(),
            Observer(builder: (context) => appStore.isLoggedIn ? ChatListScreen() : SignInScreen(isFromDashboard: true)),
            ProfileFragment(),
          ][currentIndex],
        ),
        bottomNavigationBar: Blur(
          blur: 30,
          borderRadius: radius(0),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: context.primaryColor.withValues(alpha:0.02),
              indicatorColor: context.primaryColor.withValues(alpha:0.1),
              labelTextStyle: WidgetStateProperty.all(primaryTextStyle(size: 12)),
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: NavigationBar(
              selectedIndex: currentIndex,
              destinations: [
                NavigationDestination(
                  icon: ic_home.iconImage(color: appTextSecondaryColor),
                  selectedIcon: ic_home.iconImage(color: context.primaryColor),
                  label: language.home,
                ),
                NavigationDestination(
                  icon: ic_ticket.iconImage(color: appTextSecondaryColor),
                  selectedIcon: ic_ticket.iconImage(color: context.primaryColor),
                  label: language.booking,
                ),
                NavigationDestination(
                  icon: ic_category.iconImage(color: appTextSecondaryColor),
                  selectedIcon: ic_category.iconImage(color: context.primaryColor),
                  label: language.category,
                ),
                NavigationDestination(
                  icon: ic_chat.iconImage(color: appTextSecondaryColor),
                  selectedIcon: ic_chat.iconImage(color: context.primaryColor),
                  label: language.lblChat,
                ),
                Observer(builder: (context) {
                  return NavigationDestination(
                    icon: (appStore.isLoggedIn && appStore.userProfileImage.isNotEmpty)
                        ? IgnorePointer(ignoring: true, child: ImageBorder(src: appStore.userProfileImage, height: 26))
                        : ic_profile2.iconImage(color: appTextSecondaryColor),
                    selectedIcon: (appStore.isLoggedIn && appStore.userProfileImage.isNotEmpty)
                        ? IgnorePointer(ignoring: true, child: ImageBorder(src: appStore.userProfileImage, height: 26))
                        : ic_profile2.iconImage(color: context.primaryColor),
                    label: language.profile,
                  );
                }),
              ],
              onDestinationSelected: (index) {
                currentIndex = index;
                setState(() {});
              },
            ),
          ),
        ),
        bottomSheet: Observer(builder: (context) {
          return VoiceSearchComponent().visible(appStore.isSpeechActivated);
        }),
      ),
    );
  }
}
