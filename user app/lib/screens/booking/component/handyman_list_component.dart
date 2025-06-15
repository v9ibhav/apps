import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/cached_image_widget.dart';
import '../../../component/empty_error_state_widget.dart';
import '../../../main.dart';
import '../../../model/user_data_model.dart';
import '../../../utils/colors.dart';

class HandymanListComponent extends StatelessWidget {
  final List<UserData> handymanList;

  HandymanListComponent({required this.handymanList});

  @override
  Widget build(BuildContext context) {
    if (handymanList.isEmpty) return Offstage();

    return Scaffold(
      appBar: appBarWidget(language.handymanList, color: context.primaryColor, textColor: white),
      backgroundColor: appStore.isDarkMode ? blackColor : cardColor,
      body: Stack(
        children: [
          AnimatedScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 60),
            listAnimationType: ListAnimationType.FadeIn,
            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
            scaleConfiguration: ScaleConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
            children: [
              AnimatedWrap(
                spacing: 16,
                runSpacing: 16,
                listAnimationType: ListAnimationType.None,
                itemCount: handymanList.length,
                itemBuilder: (ctx, index) {
                  UserData handymanData = handymanList[index];
                  return Container(
                    width: context.width() * 0.48 - 20,
                    decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: appStore.isDarkMode ? context.scaffoldBackgroundColor : white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radius(),
                            backgroundColor: primaryColor.withValues(alpha:0.2),
                          ),
                          child: CachedImageWidget(
                            url: handymanData.profileImage.validate().isNotEmpty ? handymanData.profileImage.validate() : '',
                            width: context.width(),
                            height: 110,
                            fit: BoxFit.cover,
                          ).cornerRadiusWithClipRRectOnly(topRight: defaultRadius.toInt(), topLeft: defaultRadius.toInt()),
                        ),
                        Marquee(child: Text(handymanData.displayName.validate(), style: boldTextStyle(size: 14), maxLines: 1)).paddingAll(16),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          Observer(
            builder: (context) => NoDataWidget(
              title: language.noHandymanFound,
              imageWidget: EmptyStateWidget(),
              retryText: language.back,
              onRetry: () => finish(context),
            ).visible(!appStore.isLoading && handymanList.validate().isEmpty),
          ),
        ],
      ),
    );
  }
}
