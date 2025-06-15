import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/shimmer_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class VerifyProviderShimmer extends StatelessWidget {
  final double? width;

  VerifyProviderShimmer({this.width});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          24.height,
          ShimmerWidget(height: 50, width: context.width()).paddingOnly(left: 16, right: 16, top: 24),
          Container(
            alignment: Alignment.topLeft,
            child: AnimatedWrap(
              spacing: 16.0,
              runSpacing: 16.0,
              scaleConfiguration: ScaleConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
              listAnimationType: ListAnimationType.Scale,
              alignment: WrapAlignment.start,
              itemCount: 6,
              itemBuilder: (context, index) {
                return ShimmerWidget(height: 200, width: context.width()).paddingOnly(top: 24);
              },
            ).paddingSymmetric(horizontal: 16, vertical: 24),
          ),
        ],
      ),
    );
  }
}
