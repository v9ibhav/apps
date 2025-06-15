import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/images.dart';
import '../../../auth/sign_in_screen.dart';
import '../../../jobRequest/my_post_request_list_screen.dart';

class JobRequestDashboardComponent4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: jobRequestComponentColor,
        image: DecorationImage(image: AssetImage(grid), fit: BoxFit.cover),
        shape: BoxShape.rectangle,
      ),
      width: context.width(),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                language.canTFindYourServices,
                style: boldTextStyle(size: 14, color: white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                language.postYourRequestAnd,
                style: boldTextStyle(color: white, size: 12),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ).expand(),
          8.width,
          AppButton(
            textColor: white,
            elevation: 0,
            color: appTextPrimaryColor,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            text: language.newRequest,
            onTap: () async {
              if (appStore.isLoggedIn) {
                MyPostRequestListScreen().launch(context);
              } else {
                setStatusBarColor(transparentColor, delayInMilliSeconds: 100, statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark);
                bool? res = await SignInScreen(isFromDashboard: true).launch(context);

                if (res ?? false) {
                  MyPostRequestListScreen().launch(context);
                }
              }
            },
          ).paddingAll(16),
        ],
      ),
    );
  }
}
