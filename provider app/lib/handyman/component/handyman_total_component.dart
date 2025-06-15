import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/handyman/component/handyman_total_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/handyman_dashboard_response.dart';
import 'package:handyman_provider_flutter/screens/total_earning_screen.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class HandymanTotalComponent extends StatelessWidget {
  final HandymanDashBoardResponse snap;

  HandymanTotalComponent({required this.snap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        HandymanTotalWidget(
          title: languages.lblTotalBooking,
          total: snap.totalBooking.validate().toString(),
          icon: total_services,
        ).onTap(
          () {
            LiveStream().emit(LIVESTREAM_CHANGE_HANDYMAN_TAB, {"index": 1});
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        HandymanTotalWidget(
          title: languages.completedBookings,
          total: snap.completedBooking.validate().toString(),
          icon: total_services,
        ).onTap(
          () {
            LiveStream().emit(LIVESTREAM_CHANGE_HANDYMAN_TAB, {"index": 1, "booking_type": BookingStatusKeys.complete});
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        HandymanTotalWidget(
          title: languages.remainingPayout,
          total: snap.remainingPayout.validate().toPriceFormat().toString(),
          icon: percent_line,
        ),
        HandymanTotalWidget(
          title: languages.totalRevenue,
          total: snap.totalRevenue.validate().toPriceFormat(),
          icon: percent_line,
        ).onTap(
          () {
            TotalEarningScreen().launch(context);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
      ],
    ).paddingAll(16);
  }
}
