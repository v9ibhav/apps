import 'package:booking_system_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';
import '../../../../utils/images.dart';
import '../../../auth/sign_in_screen.dart';
import '../../../jobRequest/my_post_request_list_screen.dart';

class JobRequestDashboardComponent2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(image: AssetImage(grid), fit: BoxFit.cover, opacity: 0.3),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.33, 0.65, 0.99],
          colors: [
            Color(0xFF4647a0),
            Color(0xFF36377c),
            Color(0xFF272759),
          ],
        ),
      ),
      child: Column(
        children: [
          16.height,
          Text(
            language.ifYouDidnTFind,
            style: primaryTextStyle(size: 16, color: white),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          20.height,
          AppButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white),
                4.width,
                Text(language.newRequest, style: boldTextStyle(color: Colors.white)),
              ],
            ),
            color: primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
