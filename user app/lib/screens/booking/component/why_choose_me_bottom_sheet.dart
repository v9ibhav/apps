import 'package:booking_system_flutter/model/user_data_model.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class WhyChooseMeBottomSheet extends StatelessWidget {
  final WhyChooseMe whyChooseMe;
  final ScrollController scrollController;
  final String aboutMe;

  const WhyChooseMeBottomSheet({super.key, required this.scrollController, required this.aboutMe, required this.whyChooseMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: context.height() * 0.04),
            decoration: boxDecorationWithRoundedCorners(
              borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
              backgroundColor: context.cardColor,
            ),
            padding: EdgeInsets.all(22),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          30.height,
                          Text(
                            whyChooseMe.title.isNotEmpty ? whyChooseMe.title : language.whyChooseMeAs,
                            style: boldTextStyle(size: 18),
                          ),
                          8.height,
                           Text(whyChooseMe.aboutDescription.validate().isEmpty ? aboutMe:whyChooseMe.aboutDescription.validate(), style: primaryTextStyle()),
                           16.height,
                          if (whyChooseMe.reason.isNotEmpty) Text(language.reason, style: boldTextStyle(size: 16)),
                          if (whyChooseMe.reason.isNotEmpty) 6.height,
                          AnimatedListView(
                            itemCount: whyChooseMe.reason.length,
                            shrinkWrap: true,
                            listAnimationType: ListAnimationType.FadeIn,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: TextIcon(
                                  prefix: Icon(Icons.check_circle_outline, size: 16, color: primaryColor),
                                  text: whyChooseMe.reason[index].validate(),
                                  textStyle: primaryTextStyle(),
                                  useMarquee: true,
                                  expandedText: true,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -17,
                      right: -15,
                      child: CloseButton(onPressed: () => finish(context)),
                    ),
                    Positioned(
                      top: 0,
                      right: 120,
                      left: 120,
                      child: Container(
                        height: 6,
                        decoration: boxDecorationDefault(borderRadius: radius(defaultRadius), color: lightGrey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).expand(),
        ],
      ),
    );
  }
}
