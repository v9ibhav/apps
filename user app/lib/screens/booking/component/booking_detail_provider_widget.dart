import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/image_border_component.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/user_data_model.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/booking_data_model.dart';
import '../../../utils/model_keys.dart';
import '../../chat/user_chat_screen.dart';

class BookingDetailProviderWidget extends StatefulWidget {
  final UserData providerData;
  final bool canCustomerContact;
  final bool providerIsHandyman;
  final BookingData? bookingDetail;

  BookingDetailProviderWidget({required this.providerData, this.canCustomerContact = false, this.providerIsHandyman = false, this.bookingDetail});

  @override
  BookingDetailProviderWidgetState createState() => BookingDetailProviderWidgetState();
}

class BookingDetailProviderWidgetState extends State<BookingDetailProviderWidget> {
  UserData userData = UserData();

  bool isChattingAllow = false;

  int? flag;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    userData = widget.providerData;

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationDefault(color: context.cardColor,border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ImageBorder(src: widget.providerData.profileImage.validate(), height: 60),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Marquee(child: Text(widget.providerData.displayName.validate(), style: boldTextStyle())).flexible(),
                          16.width,
                          Image.asset(ic_verified, height: 16, color: Colors.green).visible(widget.providerData.isVerifyProvider == 1),
                        ],
                      ).expand(),
                      if (widget.providerIsHandyman && widget.providerData.isProvider)
                        GestureDetector(
                          onTap: () async {
                            String phoneNumber = "";
                            if (widget.providerData.contactNumber.validate().contains('+')) {
                              phoneNumber = "${widget.providerData.contactNumber.validate().replaceAll('-', '')}";
                            } else {
                              phoneNumber = "+${widget.providerData.contactNumber.validate().replaceAll('-', '')}";
                            }
                            launchUrl(Uri.parse('${getSocialMediaLink(LinkProvider.WHATSAPP)}$phoneNumber'), mode: LaunchMode.externalApplication);
                          },
                          child: CachedImageWidget(url: ic_whatsapp, height: 22, width: 22),
                        ),
                    ],
                  ),
                  4.height,
                  Row(
                    children: [
                      Image.asset(ic_star_fill, height: 14, fit: BoxFit.fitWidth, color: getRatingBarColor(widget.providerData.providersServiceRating.validate().toInt())),
                      4.width,
                      Text(widget.providerData.providersServiceRating.validate().toStringAsFixed(1).toString(), style: boldTextStyle(color: textSecondaryColor, size: 14)),
                    ],
                  ),
                ],
              ).expand(),
            ],
          ),
          if (widget.canCustomerContact)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${language.email}:',
                        style: boldTextStyle(size: 12, color: appStore.isDarkMode ? textSecondaryColor : textPrimaryColor),
                      ).expand(),
                      8.width,
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: () {
                            launchMail(widget.providerData.email.validate());
                          },
                          child: Text(
                            widget.providerData.email.validate(),
                            style: boldTextStyle(size: 12, color: appStore.isDarkMode ? white : textSecondaryColor, weight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  8.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.mobile,
                        style: boldTextStyle(size: 12, color: appStore.isDarkMode ? textSecondaryColor : textPrimaryColor),
                      ).expand(),
                      8.width,
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: () {
                            if (!widget.providerIsHandyman) {
                              launchCall(widget.providerData.contactNumber.validate());
                            }
                          },
                          child: Text(
                            widget.providerData.contactNumber.validate(),
                            style: boldTextStyle(size: 12, color: appStore.isDarkMode ? white : textSecondaryColor, weight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  8.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${language.hintAddress}:',
                        style: boldTextStyle(size: 12, color: appStore.isDarkMode ? textSecondaryColor : textPrimaryColor),
                      ).expand(),
                      8.width,
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: () {
                            launchMap(widget.providerData.address.validate());
                          },
                          child: Text(
                            widget.providerData.address.validate(),
                            style: boldTextStyle(size: 12, color: appStore.isDarkMode ? white : textSecondaryColor, weight: FontWeight.w400),
                            softWrap: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if (widget.providerIsHandyman)
            Row(
              children: [
                if (widget.providerData.contactNumber.validate().isNotEmpty)
                  AppButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ic_calling.iconImage(size: 18, color: Colors.white),
                        8.width,
                        Text(language.lblCall, style: boldTextStyle(color: white)),
                      ],
                    ).fit(),
                    width: context.width(),
                    color: primaryColor,
                    elevation: 0,
                    onTap: () {
                      launchCall(widget.providerData.contactNumber.validate());
                    },
                  ).expand(),
                16.width,
                AppButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ic_chat.iconImage(size: 18),
                      8.width,
                      Text(language.lblChat, style: boldTextStyle()),
                    ],
                  ).fit(),
                  width: context.width(),
                  elevation: 0,
                  color: context.scaffoldBackgroundColor,
                  onTap: () async {
                    toast(language.pleaseWaitWhileWeLoadChatDetails);
                    UserData? user = await userService.getUserNull(email: widget.providerData.email.validate());
                    if (user != null) {
                      Fluttertoast.cancel();
                      if (widget.bookingDetail != null) {
                        isChattingAllow = widget.bookingDetail!.status == BookingStatusKeys.complete || widget.bookingDetail!.status == BookingStatusKeys.cancelled;
                      }
                      UserChatScreen(receiverUser: user, isChattingAllow: isChattingAllow).launch(context);
                    } else {
                      Fluttertoast.cancel();
                      toast("${widget.providerData.firstName} ${language.isNotAvailableForChat}");
                    }
                  },
                ).expand(),
              ],
            ).paddingTop(8),
        ],
      ),
    );
  }
}
