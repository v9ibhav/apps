import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/shimmer_widget.dart';
import '../../../main.dart';


class HelpDeskListShimmer extends StatelessWidget {

  HelpDeskListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          24.height,
          Container(
            width: context.width(),
            child: AnimatedWrap(
              scaleConfiguration: ScaleConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
              listAnimationType: ListAnimationType.Scale,
              alignment: WrapAlignment.start,
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.zero,
                  width: context.width(),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radius(),
                    backgroundColor: context.cardColor,
                    border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShimmerWidget(height: 10,width: context.width() * 0.2),
                        ],
                      ),
                      4.height,
                      ShimmerWidget(height: 10,width: context.width() * 0.6).paddingOnly(top: 8),
                      8.height,
                      ShimmerWidget(height: 10,width: context.width() * 0.1).paddingOnly(top: 16),
                      4.height,
                      ShimmerWidget(height: 10,width: context.width() * 0.05).paddingOnly(top: 8),
                      8.height,
                      ShimmerWidget(height: 10,width: context.width() * 0.9).paddingOnly(top: 16),
                    ],
                  ).paddingAll(16),
                );
              },
            ).paddingSymmetric(horizontal: 16, vertical: 24),
          ),
        ],
      ),
    );
  }
}
