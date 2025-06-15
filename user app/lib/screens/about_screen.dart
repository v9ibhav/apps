import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/configs.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_configuration.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarBrightness: Brightness.light));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.about,
      child: AnimatedScrollView(
        crossAxisAlignment: CrossAxisAlignment.center,
        listAnimationType: ListAnimationType.FadeIn,
        padding: EdgeInsets.symmetric(horizontal: 16),
        fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
        children: [
          Image.asset(about_us_page),
          16.height,
          Text(APP_NAME, style: boldTextStyle(size: 16)),
          8.height,
          Text(APP_NAME_TAG_LINE, style: secondaryTextStyle(), maxLines: 2),
          30.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (appConfigurationStore.helplineNumber.isNotEmpty)
                Container(
                  height: 80,
                  width: 80,
                  padding: EdgeInsets.all(16),
                  decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: context.scaffoldBackgroundColor),
                  child: Column(
                    children: [
                      Image.asset(ic_calling, height: 22, color: primaryColor),
                      4.height,
                      Text(language.lblCall, style: secondaryTextStyle(), textAlign: TextAlign.center),
                    ],
                  ),
                ).onTap(
                  () {
                    toast(appConfigurationStore.helplineNumber);
                    launchCall(appConfigurationStore.helplineNumber);
                  },
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
              if (appConfigurationStore.inquiryEmail.isNotEmpty)
                Container(
                  height: 80,
                  width: 80,
                  padding: EdgeInsets.all(16),
                  decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: context.scaffoldBackgroundColor),
                  child: Column(
                    children: [
                      Image.asset(ic_message, height: 22, color: primaryColor),
                      4.height,
                      Text(language.email, style: secondaryTextStyle(), textAlign: TextAlign.center),
                    ],
                  ),
                ).onTap(
                  () {
                    launchMail(appConfigurationStore.inquiryEmail);
                  },
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
            ],
          ),
          25.height,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(parseHtmlString(getStringAsync(SITE_DESCRIPTION)), style: primaryTextStyle(), textAlign: TextAlign.justify),
          ),
          30.height,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (getStringAsync(FACEBOOK_URL).isNotEmpty)
                  IconButton(
                    icon: Image.asset(ic_facebook, height: 35),
                    onPressed: () {
                      commonLaunchUrl(getStringAsync(FACEBOOK_URL), launchMode: LaunchMode.externalApplication);
                    },
                  ).expand(),
                if (getStringAsync(INSTAGRAM_URL).isNotEmpty)
                  IconButton(
                    icon: Image.asset(ic_instagram, height: 35),
                    onPressed: () {
                      commonLaunchUrl(getStringAsync(INSTAGRAM_URL), launchMode: LaunchMode.externalApplication);
                    },
                  ).expand(),
                if (getStringAsync(TWITTER_URL).isNotEmpty)
                  IconButton(
                    icon: Image.asset(ic_twitter, height: 35),
                    onPressed: () {
                      commonLaunchUrl(getStringAsync(TWITTER_URL), launchMode: LaunchMode.externalApplication);
                    },
                  ).expand(),
                if (getStringAsync(LINKEDIN_URL).isNotEmpty)
                  IconButton(
                    icon: Image.asset(ic_linkedIN, height: 35),
                    onPressed: () {
                      commonLaunchUrl(getStringAsync(LINKEDIN_URL), launchMode: LaunchMode.externalApplication);
                    },
                  ).expand(),
                if (getStringAsync(YOUTUBE_URL).isNotEmpty)
                  IconButton(
                    icon: Image.asset(ic_youtube, height: 35),
                    onPressed: () {
                      commonLaunchUrl(getStringAsync(YOUTUBE_URL), launchMode: LaunchMode.externalApplication);
                    },
                  ).expand(),
              ],
            ),
          ),
          25.height,
        ],
      ),
    );
  }
}
