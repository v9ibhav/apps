import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/shimmer_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class HandymanEarningListShimmer extends StatelessWidget {
  HandymanEarningListShimmer({super.key});

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
              scaleConfiguration: ScaleConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
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
                    color: context.cardColor,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              ShimmerWidget(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: boxDecorationDefault(
                                      shape: BoxShape.circle,
                                      color: context.cardColor),
                                ),
                              ),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerWidget(height: 10, width: context.width() * 0.15).paddingOnly(top: 8),
                                  4.height,
                                  ShimmerWidget(height: 10, width: context.width() * 0.3).paddingOnly(top: 8),
                                ],
                              ).expand(),
                            ],
                          ).expand(),
                          Spacer(),
                          ShimmerWidget(
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: boxDecorationDefault(shape: BoxShape.circle, color: context.cardColor),
                            ),
                          ),
                        ],
                      ),
                      Divider(color: context.dividerColor, thickness: 1.0, height: 20),
                      Row(
                        children: [
                          Row(
                            children: [
                              ShimmerWidget(height: 10, width: context.width() * 0.03),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerWidget(height: 10, width: context.width() * 0.3),
                                  4.height,
                                  ShimmerWidget(height: 10, width: context.width() * 0.1).paddingOnly(top: 8),
                                ],
                              ).expand(),
                            ],
                          ).expand(),
                          16.width,
                          Row(
                            children: [
                              ShimmerWidget(height: 10, width: context.width() * 0.03),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerWidget(height: 10, width: context.width() * 0.3),
                                  4.height,
                                  ShimmerWidget(height: 10, width: context.width() * 0.1).paddingOnly(top: 8),
                                ],
                              ).expand(),
                            ],
                          ).expand(),
                        ],
                      ),
                      Divider(
                          color: context.dividerColor,
                          thickness: 1.0,
                          height: 20),
                      Row(
                        children: [
                          Row(
                            children: [
                              ShimmerWidget(height: 10, width: context.width() * 0.03),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerWidget(height: 10, width: context.width() * 0.3),
                                  4.height,
                                  ShimmerWidget(height: 10, width: context.width() * 0.1).paddingOnly(top: 8),
                                ],
                              ).expand(),
                            ],
                          ).expand(),
                          16.width,
                          Row(
                            children: [
                              ShimmerWidget(height: 10, width: context.width() * 0.03),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerWidget(height: 10, width: context.width() * 0.3),
                                  4.height,
                                  ShimmerWidget(height: 10, width: context.width() * 0.1).paddingOnly(top: 8),
                                ],
                              ).expand(),
                            ],
                          ).expand(),
                        ],
                      ),
                      Divider(color: context.dividerColor, thickness: 1.0, height: 20),
                      Row(
                        children: [
                          ShimmerWidget(height: 10, width: context.width() * 0.03),
                          16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerWidget(height: 10, width: context.width() * 0.3),
                              4.height,
                              ShimmerWidget(height: 10, width: context.width() * 0.1).paddingOnly(top: 8),
                            ],
                          ).expand(),
                        ],
                      ),
                      ShimmerWidget(height: 30, width: context.width()).paddingOnly(top: 24),
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
