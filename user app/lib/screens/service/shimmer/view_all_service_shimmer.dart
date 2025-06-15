import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/shimmer_widget.dart';
import '../../../main.dart';
import '../../../utils/common.dart';
import '../../../utils/constant.dart';

class ViewAllServiceShimmer extends StatefulWidget {
  const ViewAllServiceShimmer({super.key});

  @override
  State<ViewAllServiceShimmer> createState() => _ViewAllServiceShimmerState();
}

class _ViewAllServiceShimmerState extends State<ViewAllServiceShimmer> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      if (appConfigurationStore.userDashboardType == DASHBOARD_1) {
        return Container(
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: radius(),
            backgroundColor: context.cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 150,
                width: context.width(),
                child: Stack(
                  children: [
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                        child: ShimmerWidget(height: 10,width: context.width() * 0.3).paddingOnly(top: 8),
                      ),
                    ).visible(appConfigurationStore.userDashboardType == DASHBOARD_1 && appConfigurationStore.userDashboardType == DASHBOARD_4),
                    Positioned(
                      bottom: 100,
                      left: isRTL ? 0 : 16,
                      right: isRTL ? 16 : 0,
                      child: ShimmerWidget(height: 10,width: context.width() * 0.3).paddingOnly(top: 8),
                    ).visible(appConfigurationStore.userDashboardType == DASHBOARD_4),
                    Positioned(
                      bottom: 60,
                      left:0,
                      right: 16,
                      child: ShimmerWidget(height: 10,width: context.width() * 0.6).paddingOnly(top: 8),
                    ).visible(appConfigurationStore.userDashboardType == DASHBOARD_4),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child:Container(
                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                        child: ShimmerWidget(height: 10,width: context.width() * 0.6).paddingOnly(top: 8),
                      ),
                    ).visible(appConfigurationStore.userDashboardType == DASHBOARD_4),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 0, right: 16, top: 0, bottom: 0),
                        child:ShimmerWidget(height: 30,width: 70).paddingOnly(top: 8),
                      ),
                    ],
                  ).paddingOnly(left: 16),
                  16.height,
                  ShimmerWidget(height: 10,width: context.width() * 0.6).paddingOnly(top: 8, left: 16),
                  16.height,
                  ShimmerWidget(height: 10,width: context.width() * 0.6).paddingOnly(top: 8, left: 16),
                  Divider(color: context.dividerColor, height: 20).visible(appConfigurationStore.userDashboardType == DASHBOARD_1 && appConfigurationStore.userDashboardType == DASHBOARD_3 ),
                  Row(
                    children: [
                      ShimmerWidget(
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: boxDecorationDefault(shape: BoxShape.circle, color: context.cardColor),
                        ),
                      ).paddingOnly(top: 8),
                      8.width,
                      ShimmerWidget(height: 10,width: context.width() * 0.6).paddingOnly(top: 8),
                    ],
                  ).paddingSymmetric(horizontal: 16),
                  16.height,
                  ShimmerWidget(
                    child: Container(
                      height: 30,
                      width: context.width(),
                      decoration: boxDecorationDefault(shape: BoxShape.rectangle, color: context.cardColor),
                    ),
                  ).paddingOnly(bottom: 16,left: 16,right: 16).visible(appConfigurationStore.userDashboardType == DASHBOARD_2),
                ],
              ).visible(appConfigurationStore.userDashboardType != DASHBOARD_4),
            ],
          ),
        ).paddingOnly(bottom: 16);
      } else {
        return Container(
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: radius(),
            backgroundColor: context.cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 150,
                width: context.width(),
                child: Stack(
                  children: [
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                        child: ShimmerWidget(height: 10,width: context.width() * 0.3).paddingOnly(top: 8),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 0, right: 16, top: 0, bottom: 0),
                        child:ShimmerWidget(height: 30,width: 70).paddingOnly(top: 8),
                      ),
                    ],
                  ).paddingOnly(left: 16),
                  16.height,
                  ShimmerWidget(height: 10,width: context.width() * 0.3).paddingOnly(top: 8, left: 16),
                  16.height,
                  ShimmerWidget(height: 10,width: context.width() * 0.3).paddingOnly(top: 8, left: 16),
                  Row(
                    children: [
                      ShimmerWidget(
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: boxDecorationDefault(shape: BoxShape.circle, color: context.cardColor),
                        ),
                      ).paddingOnly(top: 8),
                      8.width,
                      ShimmerWidget(height: 10,width: context.width() * 0.6).paddingOnly(top: 8),
                    ],
                  ).paddingSymmetric(horizontal: 16),
                  16.height,
                ],
              ),
            ],
          ),
        ).paddingOnly(bottom: 16);
      }
    });
  }
}
