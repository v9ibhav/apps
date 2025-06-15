import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/shimmer_widget.dart';
import '../../../main.dart';

class PromotionalBannerListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: AnimatedListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              listAnimationType: ListAnimationType.FadeIn,
              fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.only(bottom: 16),
                  width: context.width(),
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radius(),
                    backgroundColor: context.cardColor,
                    border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget(height: 200, width: context.width()).cornerRadiusWithClipRRectOnly(
                        topLeft: 8,
                        topRight: 8,
                        bottomLeft: 0,
                        bottomRight: 0,
                      ),
                      16.height,
                      ShimmerWidget(
                        height: 12,
                        width: 100,
                      ).paddingSymmetric(horizontal: 16),
                      16.height,
                      ShimmerWidget(height: 10, width: context.width()).paddingSymmetric(horizontal: 16),
                      16.height,
                    ],
                  ),
                );
              },
            ).paddingSymmetric(horizontal: 16, vertical: 24),
          ),
        ],
      ),
    );
  }
}
