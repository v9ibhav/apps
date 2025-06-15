import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/shimmer_widget.dart';
import '../../../../main.dart';
import '../../../../utils/constant.dart';

class DashboardShimmer1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Slider UI
          ShimmerWidget(
            child: Container(
              height: 325,
              width: context.width(),
              color: context.cardColor,
            ),
          ),
          16.height,
          Row(
            children: [
              ShimmerWidget(
                child: Container(
                  height: 60,
                  decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
                ),
              ).expand(),
              16.width,
              ShimmerWidget(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
                ),
              ),
            ],
          ).paddingAll(16),
          16.height,

          /// Upcoming Booking UI
          ShimmerWidget(height: 16, width: context.width() * 0.5).paddingLeft(16),
          ShimmerWidget(height: 200, width: context.width()).paddingSymmetric(vertical: 16, horizontal: 16),
          6.height,

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
                      child: Column(
                        children: [
                          Container(
                            width: CATEGORY_ICON_SIZE,
                            height: CATEGORY_ICON_SIZE,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(color: context.cardColor, shape: BoxShape.circle),
                          ),
                          4.height,
                          Container(
                            width: 60,
                            height: 10,
                            decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
                          ),
                        ],
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

          /// Post Job UI
          16.height,
          ShimmerWidget(
            child: Container(
              height: 160,
              width: context.width(),
              color: context.cardColor,
            ),
          ),
        ],
      ),
    );
  }
}
