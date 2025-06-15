import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/shimmer_widget.dart';
import '../../../../main.dart';

class DashboardShimmer2 extends StatelessWidget {
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

          /// Slider UI
          CarouselSlider(
            items: List.generate(3, (index) {
              return ShimmerWidget(
                child: Container(
                  width: context.width(),
                  height: 200,
                  decoration: boxDecorationDefault(borderRadius: radius(8), color: context.cardColor),
                ),
              );
            }),
            options: CarouselOptions(
              height: 200,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              onPageChanged: (index, reason) {
                //
              },
            ),
          ),
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
              ).paddingSymmetric(horizontal: 16, vertical: 8),
              HorizontalList(
                itemCount: 10,
                spacing: 16,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemBuilder: (context, index) {
                  return ShimmerWidget(
                    child: Container(
                      width: context.width() / 4,
                      padding: EdgeInsets.all(18),
                      decoration: boxDecorationDefault(
                        borderRadius: BorderRadius.circular(defaultRadius + 16),
                        color: context.cardColor,
                        border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          20.height,

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
                      height: 200,
                      width: 280,
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
                      height: 200,
                      width: 280,
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
