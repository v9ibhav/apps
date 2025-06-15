import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/shimmer_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class WalletHistoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        16.height,
        ShimmerWidget(height: context.height() * 0.19, width: context.width()).paddingSymmetric(horizontal: 16),
        20.height,
        AnimatedListView(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          slideConfiguration: SlideConfiguration(
              duration: 400.milliseconds, delay: 50.milliseconds),
          padding: EdgeInsets.all(8),
          listAnimationType: ListAnimationType.None,
          itemBuilder: (_, i) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              margin: EdgeInsets.all(8),
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: context.dividerColor),
                backgroundColor: context.scaffoldBackgroundColor,
              ),
              width: context.width(),
              child:Row(
                children: [
                  ShimmerWidget(height: 40, width: 45),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget(height: 10, width: context.width() * 0.25),
                      8.height,
                      ShimmerWidget(height: 10, width: context.width() * 0.60),
                    ],
                  ),
                ],
              ),
            );
          },
        ).expand(),
      ],
    );
  }
}
