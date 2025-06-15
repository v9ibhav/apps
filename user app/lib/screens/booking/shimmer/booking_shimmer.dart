import 'package:booking_system_flutter/component/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/dotted_line.dart';
import '../../../main.dart';

class BookingShimmer extends StatelessWidget {
  const BookingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AnimatedListView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 16, top: 16, right: 16, left: 16),
            itemCount: 20,
            shrinkWrap: true,
            listAnimationType: ListAnimationType.None,
            itemBuilder: (_, index) {
              return Container(
                width: context.width(),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: context.scaffoldBackgroundColor, border: Border.all(color: context.dividerColor), borderRadius: radius()),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget(height: 80, width: 80),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ShimmerWidget(height: 20, width: 50),
                                8.width,
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(borderRadius: radius(8), color: Colors.transparent),
                                  child: ShimmerWidget(height: 20, width: context.width() * 0.24),
                                ).flexible(),
                              ],
                            ),
                            4.height,
                            ShimmerWidget(height: 20, width: context.width()),
                            4.height,
                            ShimmerWidget(height: 20, width: context.width()),
                          ],
                        ).expand(),
                      ],
                    ).paddingAll(8),
                    Container(
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.cardColor,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      width: context.width(),
                      margin: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          8.height,
                          Row(
                            children: [
                              ShimmerWidget(height: 10).expand(flex: 2),
                              16.width,
                              ShimmerWidget(height: 10).expand(flex: 5),
                            ],
                          ),
                          8.height,
                          Row(
                            children: [
                              ShimmerWidget(height: 10).expand(flex: 2),
                              16.width,
                              ShimmerWidget(height: 10).expand(flex: 5),
                            ],
                          ),
                          8.height,
                          Row(
                            children: [
                              ShimmerWidget(height: 10).expand(flex: 2),
                              16.width,
                              ShimmerWidget(height: 10).expand(flex: 5),
                            ],
                          ),
                          8.height,
                          DottedLine(
                            dashColor: appStore.isDarkMode ? lightGray.withValues(alpha:0.4) : lightGray,
                            dashGapLength: 5,
                            dashLength: 8,
                          ).paddingAll(8),
                          8.height,
                          Row(
                            children: [
                              ShimmerWidget(height: 40, width: 40).cornerRadiusWithClipRRect(22),
                              16.width,
                              Column(
                                children: [
                                  ShimmerWidget(height: 10, width: context.width()),
                                  8.height,
                                  ShimmerWidget(height: 10, width: context.width()),
                                ],
                              ).expand(),
                            ],
                          ),
                          8.height,
                        ],
                      ).paddingAll(16),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
