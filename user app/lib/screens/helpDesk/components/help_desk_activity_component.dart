import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/cached_image_widget.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constant.dart';
import '../../gallery/gallery_component.dart';
import '../model/help_desk_detail_response.dart';

class HelpDeskActivityComponent extends StatefulWidget {
  final int helpDeskIndex;
  final HelpDeskActivityData helpDeskActivityData;
  final int helpDeskActivityCount;
  final String showBtnOption;

  HelpDeskActivityComponent({
    required this.helpDeskIndex,
    required this.helpDeskActivityData,
    required this.helpDeskActivityCount,
    required this.showBtnOption,
  });

  @override
  State<HelpDeskActivityComponent> createState() => _HelpDeskActivityComponentState();
}

class _HelpDeskActivityComponentState extends State<HelpDeskActivityComponent> {
  bool isExpansionTile = false;

  double changeDashedRectDynamicHeight = 65;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedImageWidget(
            url: widget.helpDeskActivityData.senderImage.validate(),
            height: 40,
            circle: true,
            fit: BoxFit.cover,
          ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichTextWidget(
                list: [
                  TextSpan(
                    text: widget.helpDeskActivityData.activityType.validate().toHelpDeskActivityType(),
                    style: secondaryTextStyle(),
                  ),
                  TextSpan(text: ' ${widget.helpDeskActivityData.senderName} ', style: boldTextStyle(size: 12)),
                  TextSpan(
                    text: '${language.on} ${formatBookingDate(widget.helpDeskActivityData.updatedAt.validate(), format: DATE_FORMAT_10, isTime: true)}',
                    style: secondaryTextStyle(),
                  ),
                ],
              ),
              SizeListener(
                onSizeChange: (size) {
                  changeDashedRectDynamicHeight = size.height;
                  appStore.setExpansionDynamicHeight(size.height);
                  setState(() {});
                },
                child: ExpansionTile(
                  title: Offstage(),
                  childrenPadding: EdgeInsets.only(bottom: 16),
                  dense: true,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  shape: Border.all(color: Colors.transparent),
                  expandedAlignment: Alignment.topLeft,
                  iconColor: primaryColor,
                  collapsedIconColor: primaryColor,
                  tilePadding: EdgeInsets.zero,
                  showTrailingIcon: false,
                  onExpansionChanged: (value) {
                    isExpansionTile = value;
                    setState(() {});
                  },
                  leading: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(language.showMessage, style: boldTextStyle(size: 12, color: primaryColor)),
                      8.width,
                      Icon(isExpansionTile ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                    ],
                  ),
                  children: [
                    Container(
                      width: context.width(),
                      padding: EdgeInsets.all(16),
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: radius(8),
                        backgroundColor: appStore.isDarkMode ? appButtonColorDark : Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.helpDeskActivityData.activityType.validate() == ADD_HELP_DESK
                              && widget.helpDeskActivityData.helDeskAttachments.validate().isNotEmpty
                              && widget.helpDeskActivityData.attachments.validate().isEmpty)
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: List.generate(
                                widget.helpDeskActivityData.helDeskAttachments.validate().take(1).length,
                                (i) {
                                  return GalleryComponent(
                                    images: widget.helpDeskActivityData.helDeskAttachments.validate().map((e) => e.validate()).toList(),
                                    index: i,
                                    height: 60,
                                    width: 60,
                                  );
                                },
                              ),
                            ).paddingBottom(8)
                          else if (widget.helpDeskActivityData.attachments.validate().isNotEmpty)
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: List.generate(
                                widget.helpDeskActivityData.attachments.validate().take(1).length,
                                (i) => GalleryComponent(
                                  images: widget.helpDeskActivityData.attachments.validate().map((e) => e.validate()).toList(),
                                  index: i,
                                  height: 60,
                                  width: 60,
                                ),
                              ),
                            ).paddingBottom(8),
                          if (widget.helpDeskActivityData.activityType.validate() == CLOSED_HELP_DESK)
                            RichTextWidget(
                              list: [
                                TextSpan(
                                  text: widget.helpDeskActivityData.activityType.validate().toHelpDeskActivityType(),
                                  style: secondaryTextStyle(),
                                ),
                                TextSpan(text: ' ${widget.helpDeskActivityData.senderName} ', style: secondaryTextStyle(size: 12)),
                                TextSpan(
                                  text: '${language.on} ${formatBookingDate(widget.helpDeskActivityData.updatedAt.validate(), format: DATE_FORMAT_10, isTime: true)}',
                                  style: secondaryTextStyle(),
                                ),
                              ],
                            )
                          else
                            Text(
                              widget.helpDeskActivityData.messages.validate(),
                              style: secondaryTextStyle(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).expand(),
        ],
      ).paddingBottom(16);
    });
  }
}
