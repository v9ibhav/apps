import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/utils/extensions/color_extension.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constant.dart';
import '../model/promotional_banner_response.dart';
import '../promotional_banner_detail_screen.dart';
import '../promotional_banner_repository.dart';

class PromotionalBannerItemComponent extends StatelessWidget {
  final PromotionalBannerListData promotionalBannerData;
  final String selectedStatus;
  final VoidCallback? onCallBack;

  PromotionalBannerItemComponent({required this.promotionalBannerData, required this.selectedStatus, this.onCallBack});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PromotionalBannerDetailScreen(promotionalBannerData: promotionalBannerData,).launch(context);
      },
      child: Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.only(bottom: 16),
        width: context.width(),
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(),
          backgroundColor: context.cardColor,
          border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
        ),
        child: Column(
          children: [
            Stack(
              children: [
                CachedImageWidget(
                  url: promotionalBannerData.image.validate(),
                  fit: BoxFit.fill,
                  height: context.height() * 0.25,
                  width: context.width(),
                ).cornerRadiusWithClipRRectOnly(
                  topLeft: 8,
                  topRight: 8,
                ),
                if (selectedStatus == PROMOTIONAL_BANNER_ALL)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: radius(8),
                        backgroundColor: promotionalBannerData.status.validate().getPromBannerStatusBackgroundColor,
                      ),
                      child: Text(
                        promotionalBannerData.status.validate().toPromotionalBannerStatus(),
                        style: boldTextStyle(color: Colors.white, size: 12),
                      ),
                    ),
                  ),
              ],
            ),
            if (promotionalBannerData.description.validate().isNotEmpty)
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  promotionalBannerData.description.validate(),
                  style: boldTextStyle(),
                ),
              ).paddingOnly(left: 16, top: 8, right: 16, bottom: promotionalBannerData.status.validate() == PROMOTIONAL_BANNER_ACCEPTED ? 8 : 0),
            Align(
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                  style: secondaryTextStyle(),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${languages.paymentStatus}: ',
                      style: secondaryTextStyle(size: 12,),
                    ),
                    TextSpan(text: promotionalBannerData.paymentStatus.validate().toPaymentStatus(), style: boldTextStyle(size: 12, color: promotionalBannerData.paymentStatus == 'paid' ? greenColor : redColor)),
                  ],
                ),
              ).paddingOnly(left: 16, right: 16, top: 8, bottom: 16),
            ),
            if (promotionalBannerData.status.validate() == PROMOTIONAL_BANNER_PENDING)
              Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    style: secondaryTextStyle(),
                    children: <TextSpan>[
                      TextSpan(
                        text: languages.note,
                        style: boldTextStyle(size: 12, color: redColor),
                      ),
                      TextSpan(text: languages.thisBannerIsCurrently, style: secondaryTextStyle()),
                    ],
                  ),
                ).paddingOnly(left: 16, right: 16, top: 8, bottom: 16),
              ),
            if (promotionalBannerData.status.validate() == PROMOTIONAL_BANNER_REJECT) ...[
              if (promotionalBannerData.reason.validate().isNotEmpty)
                Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: secondaryTextStyle(),
                      children: <TextSpan>[
                        TextSpan(
                          text: '${languages.reason} ',
                          style: boldTextStyle(size: 12, color: redColor),
                        ),
                        TextSpan(text: promotionalBannerData.reason.validate(), style: secondaryTextStyle()),
                      ],
                    ),
                  ),
                ).paddingOnly(left: 16, right: 16, top: 16),
              AppButton(
                text: languages.lblDelete,
                color: cancelled.withValues(alpha: 0.1),
                textStyle: boldTextStyle(color: cancelled),
                width: context.width(),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                onTap: () {
                  showConfirmDialogCustom(
                    context,
                    dialogType: DialogType.DELETE,
                    title: languages.doYouWantToDeleteBanner,
                    positiveText: languages.lblDelete,
                    negativeText: languages.lblCancel,
                    onAccept: (v) async {
                      /// Promotional Banner Delete API
                      ifNotTester(context, () {
                        appStore.setLoading(true);
                        deleteBanner(bannerId: promotionalBannerData.id.validate()).then((value) {
                          toast(value.message.toString());
                          onCallBack?.call();
                        }).catchError((e) {
                          appStore.setLoading(false);
                          toast(e.toString(), print: true);
                        });
                      });
                    },
                  );
                },
              ).paddingAll(16),
            ],
          ],
        ),
      ),
    );
  }
}