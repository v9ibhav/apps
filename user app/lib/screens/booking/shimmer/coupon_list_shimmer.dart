import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/dotted_line.dart';
import '../../../component/shimmer_widget.dart';

class CouponListShimmer extends StatelessWidget {

  CouponListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          24.height,
          Container(
            width: context.width(),
            child: AnimatedWrap(
              scaleConfiguration: ScaleConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
              listAnimationType: ListAnimationType.Scale,
              alignment: WrapAlignment.start,
              itemCount: 6,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: context.width(),
                      height: context.height() * 0.22,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration: boxDecorationDefault(
                        color: context.cardColor,
                        borderRadius: radius(0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShimmerWidget(height: 20,width: context.width() * 0.3).paddingOnly(top: 8),
                                ShimmerWidget(height: 10,width: context.width() * 0.2).paddingOnly(top: 8),
                              ],
                            )
                          ).paddingRight(4).expand(flex: 1),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerWidget(height: 10,width: context.width() * 0.3).paddingOnly(top: 8),
                              8.height,
                              ShimmerWidget(height: 10,width: context.width() * 0.6).paddingOnly(top: 8),
                              ShimmerWidget(height: 10,width: context.width() * 0.6).paddingOnly(top: 8),
                              16.height,
                              ShimmerWidget(
                                child: Container(
                                  height: 30,
                                  width: 80,
                                  decoration: boxDecorationDefault(shape: BoxShape.rectangle, color: context.cardColor),
                                ),
                              ),
                              ShimmerWidget(height: 10,width: context.width() * 0.6).paddingOnly(top: 8),
                            ],
                          ).paddingLeft(32).expand(flex: 2),
                        ],
                      ),
                    ).paddingBottom(16),
                    Positioned(
                      left: -9,
                      child: Column(
                        children: List.generate(
                          countOfSideCuts(context),
                              (index) => CircleAvatar(
                            radius: 9,
                            backgroundColor: context.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -9,
                      child: Column(
                        children: List.generate(
                          countOfSideCuts(context),
                              (index) => CircleAvatar(
                            radius: 9,
                            backgroundColor: context.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -9 * 1.8,
                      child: SizedBox(
                        width: context.width(),
                        height: context.height() * 0.22 + (9 * 2 * 1.8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.center,
                            ).expand(flex: 1),
                            Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      radius: 9 * 1.5,
                                      backgroundColor: context.scaffoldBackgroundColor,
                                    ),
                                    DottedLine(
                                      direction: Axis.vertical,
                                      dashColor: white.withValues(alpha:0.12),
                                      dashGapLength: 8,
                                      dashLength: 10,
                                    ).expand(),
                                    CircleAvatar(
                                      radius: 9 * 1.5,
                                      backgroundColor: context.scaffoldBackgroundColor,
                                    ),
                                  ],
                                ).paddingSymmetric(horizontal: 8)
                              ],
                            ),
                            Container(
                              alignment: Alignment.center,
                            ).expand(flex: 2),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  int countOfSideCuts(BuildContext context) {
    num dotCount = 0;
    dotCount = (context.height() * 0.22) / 9;
    return dotCount.round();
  }
}
