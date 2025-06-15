import 'package:booking_system_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';
import '../../../../utils/images.dart';
import '../../../auth/sign_in_screen.dart';
import '../../../jobRequest/my_post_request_list_screen.dart';

class NewJobRequestDashboardComponent1 extends StatelessWidget {
  const NewJobRequestDashboardComponent1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationWithRoundedCorners(
        decorationImage: DecorationImage(image: AssetImage(imgNewPostJob1), fit: BoxFit.cover),
        borderRadius: BorderRadius.all(Radius.zero),
      ),
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          Text(
            language.postYourRequestAnd,
            style: boldTextStyle(color: white, size: 16),
          ),
          20.height,
          AppButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white),
                4.width,
                Text(language.newRequest, style: boldTextStyle(color: Colors.white, size: 14)),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: primaryColor,
            onTap: () async {
              if (appStore.isLoggedIn) {
                MyPostRequestListScreen().launch(context);
              } else {
                setStatusBarColor(Colors.white, statusBarIconBrightness: Brightness.dark);
                bool? res = await SignInScreen(isFromDashboard: true).launch(context);

                if (res ?? false) {
                  MyPostRequestListScreen().launch(context);
                }
              }
            },
          ),
          16.height,
        ],
      ),
    );
  }
}
