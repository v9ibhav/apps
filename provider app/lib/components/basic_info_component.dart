import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/handyman_name_widget.dart';
import 'package:handyman_provider_flutter/components/image_border_component.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:handyman_provider_flutter/screens/chat/user_chat_screen.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/booking_detail_response.dart';
import '../utils/model_keys.dart';

class BasicInfoComponent extends StatefulWidget {
  final UserData? handymanData;
  final UserData? customerData;
  final UserData? providerData;
  final ServiceData? service;
  final BookingDetailResponse? bookingInfo;

  /// flag == 0 = customer
  /// flag == 1 = handyman
  /// else provider
  final int flag;
  final BookingData? bookingDetail;

  BasicInfoComponent(this.flag, {this.customerData, this.handymanData, this.providerData, this.service, this.bookingDetail, this.bookingInfo});

  @override
  BasicInfoComponentState createState() => BasicInfoComponentState();
}

class BasicInfoComponentState extends State<BasicInfoComponent> {
  UserData customer = UserData();
  UserData provider = UserData();
  UserData userData = UserData();
  ServiceData service = ServiceData();

  String? googleUrl;
  String? address;
  String? name;
  String? contactNumber;
  String? profileUrl;
  int? profileId;
  int? handymanRating;

  int? flag;

  bool isChattingAllow = false;

  bool showVerifiedBadge = false;

  bool showContactWidgets = false;

  bool showChat = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (widget.flag == 0) {
      profileId = widget.customerData!.id.validate();
      name = widget.customerData!.displayName.validate();
      profileUrl = widget.customerData!.profileImage.validate();
      contactNumber = widget.customerData!.contactNumber.validate();
      address = widget.customerData!.address.validate();

      userData = widget.customerData!;
      await userService.getUser(email: widget.customerData!.email.validate()).then((value) {
        widget.customerData!.uid = value.uid;
      }).catchError((e) {
        log(e.toString());
      });
      showContactWidgets = widget.bookingDetail!.status != BookingStatusKeys.complete && widget.bookingDetail!.status != BookingStatusKeys.cancelled;
      showChat = true;
      showVerifiedBadge = widget.customerData!.isVerifiedAccount.validate().getBoolInt();
    } else if (widget.flag == 1) {
      profileId = widget.handymanData!.id.validate();
      name = widget.handymanData!.displayName.validate();
      profileUrl = widget.handymanData!.profileImage.validate();
      contactNumber = widget.handymanData!.contactNumber.validate();
      address = widget.handymanData!.address.validate();

      userData = widget.handymanData!;
      await userService.getUser(email: widget.handymanData!.email.validate()).then((value) {
        widget.handymanData!.uid = value.uid;
      }).catchError((e) {
        log(e.toString());
      });
      showContactWidgets = widget.bookingInfo != null && widget.bookingInfo!.providerData!.id.validate() != widget.handymanData!.id.validate();
      showVerifiedBadge = widget.handymanData!.isVerifiedAccount.validate().getBoolInt();
      showChat = widget.bookingDetail!.status != BookingStatusKeys.complete && widget.bookingDetail!.status != BookingStatusKeys.cancelled;
    } else {
      profileId = widget.providerData!.id.validate();
      name = widget.providerData!.displayName.validate();
      profileUrl = widget.providerData!.profileImage.validate();
      contactNumber = widget.providerData!.contactNumber.validate();
      address = widget.providerData!.address.validate();
      provider = widget.providerData!;
      showVerifiedBadge = widget.providerData!.isVerifiedAccount.validate().getBoolInt();
    }
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (profileUrl.validate().isNotEmpty) ImageBorder(src: profileUrl.validate(), height: 45),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    HandymanNameWidget(
                      name: name.validate(),
                      size: 14,
                      showVerifiedBadge: showVerifiedBadge,
                    ).flexible(),
                  ],
                ),
                if (widget.flag == 1 && userData.handymanRating.validate().toDouble() > 0)
                  Row(
                    children: [
                      Icon(Icons.star, color: rattingColor, size: 16),
                      2.width,
                      Text('${userData.handymanRating.validate().toDouble()}', style: secondaryTextStyle(weight: FontWeight.bold)),
                    ],
                  ),
              ],
            ).expand(),
            if (showContactWidgets) ...[
              GestureDetector(
                onTap: () {
                  String phoneNumber = "";
                  if (widget.handymanData != null && widget.handymanData!.contactNumber.validate().contains('+')) {
                    phoneNumber = "${contactNumber.validate().replaceAll('-', '')}";
                  } else {
                    phoneNumber = "+${contactNumber.validate().replaceAll('-', '')}";
                  }
                  launchUrl(Uri.parse('${getSocialMediaLink(LinkProvider.WHATSAPP)}$phoneNumber'), mode: LaunchMode.externalApplication);
                },
                child: Image.asset(ic_whatsapp, height: 22),
              ).paddingRight(8).visible(contactNumber.validate().isNotEmpty),
            ]
          ],
        ),
        if (widget.bookingDetail!.canCustomerContact && widget.flag == 0)
          Column(
            children: [
              16.height,
              if (userData.email.validate().isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languages.email,
                      style: boldTextStyle(size: 12, color: appStore.isDarkMode ? textSecondaryColor : textPrimaryColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ).expand(),
                    8.width,
                    Text(
                      userData.email.validate(),
                      style: boldTextStyle(size: 12, color: appStore.isDarkMode ? white : textSecondaryColor, weight: FontWeight.w400),
                      textAlign: TextAlign.left,
                    ).expand(flex: 4),
                  ],
                ).onTap(() {
                  launchMail(userData.email.validate());
                }),
              if (widget.bookingDetail != null) ...[
                8.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${languages.lblAddress}:',
                      style: boldTextStyle(size: 12, color: appStore.isDarkMode ? textSecondaryColor : textPrimaryColor),
                    ).expand(),
                    8.width,
                    Text(
                      widget.bookingDetail!.address.validate(),
                      style: boldTextStyle(size: 12, color: appStore.isDarkMode ? white : textSecondaryColor, weight: FontWeight.w400),
                      textAlign: TextAlign.left,
                    ).expand(flex: 4),
                  ],
                ).visible(widget.bookingDetail!.address.validate().isNotEmpty).onTap(() {
                  commonLaunchUrl('$GOOGLE_MAP_PREFIX${Uri.encodeFull(widget.bookingDetail!.address.validate())}', launchMode: LaunchMode.externalApplication);
                }),
                8.height,
              ],
            ],
          ).paddingSymmetric(horizontal: 4),
        if (contactNumber.validate().isNotEmpty) ...[
          16.height,
          Row(
            children: [
              if (showContactWidgets) ...[
                AppButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(calling, height: 18, width: 18),
                      16.width,
                      Text(languages.lblCall, style: boldTextStyle()),
                    ],
                  ),
                  width: context.width(),
                  color: context.scaffoldBackgroundColor,
                  elevation: 0,
                  onTap: () {
                    launchCall(contactNumber.validate());
                  },
                ).expand(),
                24.width
              ],
              AppButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(chat, color: Colors.white, height: 18, width: 18),
                    16.width,
                    Text(languages.lblChat, style: boldTextStyle(color: Colors.white)),
                  ],
                ),
                width: showContactWidgets ? context.width() : context.width() / 2,
                elevation: 0,
                color: primaryColor,
                onTap: () async {
                  //ChatScreen(chatUser: ChatUserModel(id: userData.uid!, email: userData.email!, name: userData.firstName!)).launch(context);
                  toast(languages.pleaseWaitWhileWeLoadChatDetails);
                  UserData? user = await userService.getUserNull(email: userData.email.validate());
                  if (user != null) {
                    Fluttertoast.cancel();
                    if (widget.bookingDetail != null) {
                      isChattingAllow = widget.bookingDetail!.status == BookingStatusKeys.complete || widget.bookingDetail!.status == BookingStatusKeys.cancelled;
                    }
                    UserChatScreen(receiverUser: user, isChattingAllow: isChattingAllow).launch(context);
                  } else {
                    Fluttertoast.cancel();
                    toast("${userData.firstName} ${languages.isNotAvailableForChat}");
                  }
                },
              ).expand(),
            ],
          ),
        ],
      ],
    );
  }
}
