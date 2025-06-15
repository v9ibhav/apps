import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/shimmer_widget.dart';
import '../../../../main.dart';

class DashboardShimmer4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Custom Appbar UI
          ShimmerWidget(
            child: Container(
              width: context.width(),
              height: context.height() * 0.22,
              color: context.cardColor,
            ).cornerRadiusWithClipRRectOnly(bottomLeft: 30, bottomRight: 30),
          ),
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
              Wrap(
                spacing: 16,
                runSpacing: 16,
                direction: Axis.horizontal,
                children: List.generate(4, (index) {
                  return ShimmerWidget(
                    child: SizedBox(
                      width: context.width() / 4 - 22,
                      child: Container(
                        width: 85,
                        height: 85,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: context.cardColor, shape: BoxShape.rectangle, borderRadius: radius(8)),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          24.height,

          /// Upcoming Booking UI
          ShimmerWidget(height: 16, width: context.width() * 0.5).paddingLeft(16),
          ShimmerWidget(height: 200, width: context.width()).paddingSymmetric(vertical: 16, horizontal: 16),
          16.height,

          /// Slider UI
          ShimmerWidget(
            child: Container(
              height: 190,
              width: context.width(),
              decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius(8)),
            ),
          ),
          26.height,

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
                  return ShimmerWidget(
                    child: Container(
                      width: 280,
                      height: 200,
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: radius(),
                        backgroundColor: context.cardColor,
                        border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                      ),
                    ),
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
                  return ShimmerWidget(
                    child: Container(
                      width: 280,
                      height: 200,
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: radius(),
                        backgroundColor: context.cardColor,
                        border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                      ),
                    ),
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
