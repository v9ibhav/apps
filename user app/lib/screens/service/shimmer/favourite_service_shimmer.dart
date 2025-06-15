import 'package:booking_system_flutter/component/shimmer_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/constant.dart';

class FavouriteServiceShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget buildFavouriteServiceShimmer() {
      return Observer(builder: (context) {
        if (appConfigurationStore.userDashboardType != DEFAULT_USER_DASHBOARD) {
          return AnimatedWrap(
            spacing: 16,
            runSpacing: 16,
            listAnimationType: ListAnimationType.None,
            scaleConfiguration: ScaleConfiguration(duration: 300.milliseconds, delay: 50.milliseconds),
            itemCount: 20,
            itemBuilder: (_, index) {
              return ShimmerWidget(
                child: Container(
                  width: context.width(),
                  height: 200,
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radius(),
                    backgroundColor: context.cardColor,
                    border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                  ),
                ),
              ).paddingSymmetric(vertical: 16);
            },
          );
        } else {
          return AnimatedWrap(
            spacing: 16,
            runSpacing: 16,
            listAnimationType: ListAnimationType.None,
            scaleConfiguration: ScaleConfiguration(duration: 300.milliseconds, delay: 50.milliseconds),
            itemCount: 20,
            itemBuilder: (_, index) {
              return Container(
                width: context.width() / 2 - 24,
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: radius(),
                  backgroundColor: context.cardColor,
                  border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(
                      height: 205,
                      width: context.width() / 2 - 24,
                    ),
                    16.height,
                    ShimmerWidget(
                      height: 10,
                      width: 100,
                    ).paddingSymmetric(horizontal: 16),
                    16.height,
                    Row(
                      children: [
                        ShimmerWidget(
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: boxDecorationDefault(shape: BoxShape.circle, color: context.cardColor),
                          ),
                        ),
                        8.width,
                        ShimmerWidget(height: 10, width: context.width()).expand(),
                      ],
                    ).paddingSymmetric(horizontal: 16),
                    16.height,
                  ],
                ),
              );
            },
          );
        }
      });
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 60),
      child: buildFavouriteServiceShimmer(),
    );
  }
}
