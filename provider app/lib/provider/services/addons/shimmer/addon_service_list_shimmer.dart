import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/shimmer_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class AddonServiceListShimmer extends StatelessWidget {
  AddonServiceListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          24.height,
          Container(
            alignment: Alignment.topLeft,
            child: AnimatedWrap(
              spacing: 16.0,
              runSpacing: 16.0,
              scaleConfiguration: ScaleConfiguration(
                  duration: 400.milliseconds, delay: 50.milliseconds),
              listAnimationType: ListAnimationType.Scale,
              alignment: WrapAlignment.start,
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  width: context.width(),
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.only(
                      top: 16, bottom: 16, left: 16, right: 8),
                  decoration: boxDecorationRoundedWithShadow(
                      defaultRadius.toInt(),
                      backgroundColor: context.cardColor),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget(
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: boxDecorationDefault(shape: BoxShape.rectangle, color: context.cardColor),
                        ),
                      ),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          4.height,
                          ShimmerWidget(height: 10, width: context.width()*0.3).paddingOnly(top: 8),
                          4.height,
                          ShimmerWidget(height: 10, width: context.width()*0.2).paddingOnly(top: 8),
                          ShimmerWidget(height: 10, width: context.width()*0.1).paddingOnly(top: 8),
                        ],
                      ).expand(),
                      ShimmerWidget(height: 10, width: context.width()*0.1).paddingOnly(top: 8),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
