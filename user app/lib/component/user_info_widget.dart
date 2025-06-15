import 'package:booking_system_flutter/model/user_data_model.dart';
import 'package:booking_system_flutter/screens/auth/sign_in_screen.dart';
import 'package:booking_system_flutter/screens/booking/provider_info_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../network/rest_apis.dart';
import '../utils/common.dart';
import 'cached_image_widget.dart';

class UserInfoWidget extends StatefulWidget {
  final UserData data;
  final bool? isOnTapEnabled;
  final bool forProvider;
  final VoidCallback? onUpdate;

  UserInfoWidget({
    required this.data,
    this.isOnTapEnabled,
    this.forProvider = true,
    this.onUpdate,
  });

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  @override
  void initState() {
    setStatusBarColor(primaryColor);
    super.initState();
  }

  //Favourite provider
  Future<bool> addProviderToWishList({required int providerId}) async {
    Map req = {"id": "", "provider_id": providerId, "user_id": appStore.userId};
    return await addProviderWishList(req).then((res) {
      toast(language.providerAddedToFavourite);
      return true;
    }).catchError((error) {
      toast(error.toString());
      return false;
    });
  }

  Future<bool> removeProviderToWishList({required int providerId}) async {
    Map req = {"user_id": appStore.userId, 'provider_id': providerId};

    return await removeProviderWishList(req).then((res) {
      toast(language.providerRemovedFromFavourite);
      return true;
    }).catchError((error) {
      toast(error.toString());
      return false;
    });
  }

  Future<void> onTapFavouriteProvider() async {
    if (widget.data.isFavourite == 1) {
      widget.data.isFavourite = 0;
      setState(() {});

      await removeProviderToWishList(providerId: widget.data.id.validate()).then((value) {
        if (!value) {
          widget.data.isFavourite = 1;
          setState(() {});
          widget.onUpdate!.call();
        }
      });
    } else {
      widget.data.isFavourite = 1;
      setState(() {});

      await addProviderToWishList(providerId: widget.data.id.validate()).then((value) {
        if (!value) {
          widget.data.isFavourite = 0;
          setState(() {});
          widget.onUpdate!.call();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isOnTapEnabled.validate(value: false)
          ? null
          : () {
              ProviderInfoScreen(providerId: widget.data.id).launch(context);
            },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 290,
            child: Stack(
              children: [
                CachedImageWidget(
                  radius: 8,
                  url: widget.data.profileImage.validate(),
                  fit: BoxFit.cover,
                  height: 290,
                  width: context.width(),
                ),
                if (widget.data.isProvider)
                  Positioned(
                    top: 15,
                    right: 12,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha:0.1),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: widget.data.isFavourite == 1 ? ic_fill_heart.iconImage(color: favouriteColor, size: 20) : ic_heart.iconImage(color: unFavouriteColor, size: 20),
                      ),
                    ).onTap(() async {
                      if (appStore.isLoggedIn) {
                        onTapFavouriteProvider();
                      } else {
                        bool? res = await push(SignInScreen(returnExpected: true));

                        if (res ?? false) {
                          onTapFavouriteProvider();
                        }
                      }
                    }),
                  ),
                Positioned(
                  left: 16,
                  top: 15,
                  child: Container(
                    decoration: BoxDecoration(color: context.cardColor, borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ic_star_fill.iconImage(color: ratingBarColor, size: 11),
                        4.width,
                        Text(
                          "${widget.forProvider ? widget.data.providersServiceRating.validate().toStringAsPrecision(2) : widget.data.handymanRating.validate().toStringAsFixed(1)}",
                          style: primaryTextStyle(size: 12, weight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  child: Container(
                    decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(20)),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          "Service Provided:",
                          style: secondaryTextStyle(),
                        ), //Todo Translate
                        4.width,
                        Text("${widget.data.totalBooking.validate()}", style: boldTextStyle()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          32.height,
          if (widget.data.totalBooking.validate() > 0) 16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.displayName.validate(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: primaryTextStyle(size: 16, weight: FontWeight.bold),
                  ).flexible(),
                  4.width,
                  Image.asset(ic_verified, height: 16, color: Colors.green).visible(widget.data.isVerifyProvider == 1),
                ],
              ).expand(),
              12.width,
              Text(
                widget.data.designation.validate(),
                textAlign: TextAlign.center,
                style: secondaryTextStyle(color: primaryColor, weight: FontWeight.bold),
              )
            ],
          ).paddingSymmetric(horizontal: 16),
          8.height,
          RichTextWidget(
            list: [
              TextSpan(text: language.lblMemberSince, style: primaryTextStyle(size: 12)),
              TextSpan(text: ' '),
              TextSpan(text: formatDate(widget.data.createdAt.validate()), style: primaryTextStyle(size: 12)),
            ],
          ).paddingSymmetric(horizontal: 16),
          if (widget.data.description.validate().isNotEmpty) ...[
            32.height,
            Text(
              language.whyChooseMe,
              style: primaryTextStyle(weight: FontWeight.bold),
            ).paddingSymmetric(horizontal: 16),
            4.height,
            Text(
              "${widget.data.description.validate()}",
              style: secondaryTextStyle(size: 12),
            ).paddingSymmetric(horizontal: 16),
          ],
          if (widget.data.whyChooseMeObj.reason.isNotEmpty) ...[
            32.height,
            Text(language.reason, style: boldTextStyle(size: 16)).paddingSymmetric(horizontal: 16),
            4.height,
            if (widget.data.whyChooseMeObj.reason.validate().isNotEmpty)
              AnimatedListView(
                itemCount: widget.data.whyChooseMeObj.reason.length,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 8),
                listAnimationType: ListAnimationType.FadeIn,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  String reason = widget.data.whyChooseMeObj.reason[index];

                  return TextIcon(
                    prefix: Icon(Icons.check_circle_outline, size: 16, color: primaryColor),
                    text: reason.validate(),
                    textStyle: secondaryTextStyle(),
                    useMarquee: true,
                    expandedText: true,
                  );
                },
              ),
          ]
        ],
      ),
    );
  }
}
