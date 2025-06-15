import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/shimmer_widget.dart';
import '../../../../main.dart';

class DashboardShimmer3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (context.statusBarHeight).toInt().height,

          /// Custom App Bar UI
          Row(
            children: [
              ShimmerWidget(
                child: Container(
                  width: 44,
                  height: 44,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color: context.cardColor, shape: BoxShape.circle),
                ),
              ),
              16.width,
              Row(
                children: [
                  ShimmerWidget(height: 16, width: context.width()).expand(),
                ],
              ).expand(),
              16.width,
              ShimmerWidget(
                child: Container(
                  width: context.width() / 4,
                  padding: EdgeInsets.all(16),
                  decoration: boxDecorationDefault(
                    borderRadius: BorderRadius.circular(defaultRadius + 16),
                    color: context.cardColor,
                    border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 16),

          /// Location TextField UI
          ShimmerWidget(
            child: Container(
              height: 60,
              decoration: boxDecorationDefault(color: context.cardColor),
            ),
          ).cornerRadiusWithClipRRect(28).paddingAll(16),
          16.height,

          /// Slider UI
          ShimmerWidget(
            child: Container(
              height: 190,
              width: context.width(),
              decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius(8)),
            ),
          ).paddingSymmetric(horizontal: 16),
          26.height,

          /// Upcoming Booking UI
          ShimmerWidget(height: 16, width: context.width() * 0.5).paddingLeft(16),
          ShimmerWidget(height: 200, width: context.width()).paddingSymmetric(vertical: 16, horizontal: 16),
          16.height,

          /// Category UI
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget(height: 20, width: context.width() * 0.25),
                  ShimmerWidget(height: 20, width: context.width() * 0.15),
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 16),
              HorizontalList(
                itemCount: 10,
                padding: EdgeInsets.only(left: 16, right: 16),
                runSpacing: 8,
                spacing: 12,
                itemBuilder: (_, i) {
                  return ShimmerWidget(
                    child: SizedBox(
                      width: context.width() / 4 - 24,
                      child: Container(
                        width: 85,
                        height: 85,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: context.cardColor, shape: BoxShape.rectangle, borderRadius: radius(8)),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          16.height,

          /// Service List UI
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget(height: 20, width: context.width() * 0.25),
                  ShimmerWidget(height: 20, width: context.width() * 0.15),
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 8),
              HorizontalList(
                itemCount: 10,
                spacing: 16,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(),
                      backgroundColor: context.cardColor,
                      border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                    ),
                    child: ShimmerWidget(width: 280, height: 200),
                  );
                },
              )
            ],
          ).paddingSymmetric(vertical: 16),

          /// Post Job UI
          16.height,
          ShimmerWidget(
            child: Container(
              height: 180,
              width: context.width(),
              color: context.cardColor,
            ),
          ),
          16.height,

          /// Featured Service List UI
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget(height: 20, width: context.width() * 0.25),
                  ShimmerWidget(height: 20, width: context.width() * 0.15),
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 8),
              HorizontalList(
                itemCount: 10,
                spacing: 16,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(),
                      backgroundColor: context.cardColor,
                      border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                    ),
                    child: ShimmerWidget(width: 280, height: 200),
                  );
                },
              )
            ],
          ).paddingSymmetric(vertical: 16),
        ],
      ),
    );
  }
}
