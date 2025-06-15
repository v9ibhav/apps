import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/shimmer_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class HandymanCommissionListShimmer extends StatelessWidget {
  HandymanCommissionListShimmer({super.key});

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
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  width: context.width(),
                  decoration: BoxDecoration(
                      border: Border.all(color: context.dividerColor),
                      borderRadius: radius(),
                      color: context.cardColor),
                  child: Column(children: [
                    Row(
                      children: [
                        ShimmerWidget(
                            height: 15, width: context.width() * 0.05),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerWidget(
                                height: 10, width: context.width() * 0.3),
                            4.height,
                            ShimmerWidget(
                                    height: 10, width: context.width() * 0.3)
                                .paddingOnly(top: 8),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                        color: context.dividerColor,
                        thickness: 1.0,
                        height: 16),
                    Row(
                      children: [
                        ShimmerWidget(height: 15, width: context.width() * 0.05)
                            .paddingOnly(top: 24),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerWidget(
                                height: 10, width: context.width() * 0.3),
                            4.height,
                            ShimmerWidget(
                                    height: 10, width: context.width() * 0.2)
                                .paddingOnly(top: 8),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                        color: context.dividerColor,
                        thickness: 1.0,
                        height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ShimmerWidget(
                                    height: 15, width: context.width() * 0.05)
                                .paddingOnly(top: 24),
                            16.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerWidget(
                                    height: 10, width: context.width() * 0.3),
                                4.height,
                                ShimmerWidget(
                                        height: 10,
                                        width: context.width() * 0.2)
                                    .paddingOnly(top: 8),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                        color: context.dividerColor,
                        thickness: 1.0,
                        height: 16),
                    ShimmerWidget(height: 10, width: context.width())
                        .paddingOnly(top: 24),
                  ]),
                );
              },
            ).paddingSymmetric(horizontal: 16, vertical: 24),
          ),
        ],
      ),
    );
  }
}
