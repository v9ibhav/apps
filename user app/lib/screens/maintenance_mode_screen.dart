import 'package:booking_system_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../network/rest_apis.dart';
import '../utils/constant.dart';

class MaintenanceModeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            appStore.isDarkMode ? 'assets/lottie/maintenance_mode_dark.json' : 'assets/lottie/maintenance_mode_light.json',
            height: 300,
          ),
          Text(language.lblUnderMaintenance, style: boldTextStyle(size: 18), textAlign: TextAlign.center).center(),
          8.height,
          Text(language.lblCatchUpAfterAWhile, style: secondaryTextStyle(), textAlign: TextAlign.center).center(),
          16.height,
          TextButton(
            onPressed: () async {
              await setValue(LAST_APP_CONFIGURATION_SYNCED_TIME, 0);
              await getAppConfigurations();
              RestartAppWidget.init(context);
            },
            child: Text(language.lblRecheck),
          ),
        ],
      ),
    );
  }
}
