import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

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
          Text(languages.lblUnderMaintenance, style: boldTextStyle(size: 18), textAlign: TextAlign.center).center(),
          8.height,
          Text(languages.lblCatchUpAfterAWhile, style: secondaryTextStyle(), textAlign: TextAlign.center).center(),
          16.height,
          TextButton(
            onPressed: () async {
              await setValue(LAST_APP_CONFIGURATION_SYNCED_TIME, 0);
              await getAppConfigurations();
              RestartAppWidget.init(context);
            },
            child: Text(languages.lblRecheck),
          ),
        ],
      ),
    );
  }
}
