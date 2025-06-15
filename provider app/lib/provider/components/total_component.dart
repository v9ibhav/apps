import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/dashboard_response.dart';
import 'package:handyman_provider_flutter/provider/components/total_widget.dart';
import 'package:handyman_provider_flutter/provider/services/service_list_screen.dart';
import 'package:handyman_provider_flutter/screens/total_earning_screen.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class TotalComponent extends StatelessWidget {
  final DashboardResponse snap;

  TotalComponent({required this.snap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        TotalWidget(
          title: languages.lblTotalBooking,
          total: snap.totalBooking.toString(),
          icon: total_booking,
        ).onTap(
          () {
            LiveStream().emit(LIVESTREAM_PROVIDER_ALL_BOOKING, 1);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        TotalWidget(
          title: languages.lblTotalService,
          total: snap.totalService.validate().toString(),
          icon: total_services,
        ).onTap(
          () {
            ServiceListScreen().launch(context);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        TotalWidget(
          title: languages.remainingPayout,
          total: snap.remainingPayout.validate().toPriceFormat().toString(),
          icon: ic_remainng_payout_new,
        ),
        TotalWidget(
          title: languages.totalRevenue,
          total: snap.totalRevenue.validate().toPriceFormat(),
          icon: total_revenue_final,
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
