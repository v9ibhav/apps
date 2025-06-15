import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/cached_image_widget.dart';
import '../../../components/price_widget.dart';
import '../../../main.dart';
import '../../../utils/configs.dart';
import '../../../utils/images.dart';
import '../add_handyman_payout_screen.dart';
import '../model/earning_list_model.dart';
import 'earning_detail_bottomsheet.dart';

class EarningItemWidget extends StatelessWidget {
  final EarningListModel earningModel;
  final VoidCallback? onUpdate;

  const EarningItemWidget(this.earningModel, {this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: context.width(),
      decoration: BoxDecoration(
        border: Border.all(color: context.dividerColor),
        borderRadius: radius(),
        color: context.cardColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CachedImageWidget(
                    url: earningModel.handymanImage.validate(),
                    height: 50,
                    circle: true,
                    fit: BoxFit.cover,
                  ),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        earningModel.handymanName.validate(),
                        style: boldTextStyle(size: 12),
                        textAlign: TextAlign.right,
                      ),
                      4.height,
                      Text(
                        earningModel.email.validate(),
                        style: secondaryTextStyle(),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ).expand(),
                ],
              ).expand(),
              IconButton(
                icon: Icon(Icons.info_outline_rounded, size: 22),
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) {
                      return EarningDetailBottomSheet(earningModel);
                    },
                  );
                },
              ),
            ],
          ),
          Divider(color: context.dividerColor, thickness: 1.0, height: 20),
          Row(
            children: [
              Row(
                children: [
                  Image.asset(total_booking, height: 16, color: context.primaryColor),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        languages.lblTotalBooking,
                        style: secondaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.height,
                      Text(
                        earningModel.totalBookings.validate().toString(),
                        style: boldTextStyle(color: context.primaryColor),
                      ),
                    ],
                  ).expand(),
                ],
              ).expand(),
              16.width,
              Row(
                children: [
                  Image.asset(ic_un_fill_wallet, height: 16, color: context.primaryColor),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        languages.totalEarning,
                        style: secondaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.height,
                      PriceWidget(
                        price: earningModel.totalEarning.validate(),
                        color: context.primaryColor,
                        isBoldText: true,
                        size: 14,
                      ),
                    ],
                  ).expand(),
                ],
              ).expand(),
            ],
          ),
          Divider(color: context.dividerColor, thickness: 1.0, height: 20),
          Row(
            children: [
              Row(
                children: [
                  Image.asset(ic_un_fill_wallet, height: 16, color: context.primaryColor),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        languages.myEarning,
                        style: secondaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.height,
                      PriceWidget(
                        price: earningModel.providerTotalAmount.validate(),
                        color: context.primaryColor,
                        isBoldText: true,
                        size: 14,
                      ),
                    ],
                  ).expand(),
                ],
              ).expand(),
              16.width,
              Row(
                children: [
                  Image.asset(ic_un_fill_wallet, height: 16, color: context.primaryColor),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        languages.adminEarning,
                        style: secondaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.height,
                      PriceWidget(
                        price: earningModel.adminEarning.validate(),
                        color: context.primaryColor,
                        isBoldText: true,
                        size: 14,
                      ),
                    ],
                  ).expand(),
                ],
              ).expand(),
            ],
          ),
          Divider(color: context.dividerColor, thickness: 1.0, height: 20),
          Row(
            children: [
              Image.asset(ic_un_fill_wallet, height: 16, color: context.primaryColor),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languages.handymanPayDue,
                    style: secondaryTextStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.height,
                  PriceWidget(
                    price: earningModel.handymanDueAmount.validate(),
                    color: context.primaryColor,
                    isBoldText: true,
                    size: 14,
                  ),
                ],
              ).expand(),
            ],
          ),
          Divider(color: context.dividerColor, thickness: 1.0, height: 20),
          Row(
            children: [
              Image.asset(ic_un_fill_wallet, height: 16, color: context.primaryColor),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languages.handymanPaidAmount,
                    style: secondaryTextStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.height,
                  PriceWidget(
                    price: earningModel.handymanPaidEarning.validate(),
                    color: context.primaryColor,
                    isBoldText: true,
                    size: 14,
                  ),
                ],
              ).expand(),
            ],
          ),
          if (earningModel.handymanDueAmount.validate() > 0)
            AppButton(
              text: languages.payout,
              color: primaryColor,
              width: context.width(),
              margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.zero,
              onTap: () async {
                bool? res = await AddHandymanPayoutScreen(earningModel: earningModel).launch(context);

                if (res ?? false) {
                  onUpdate?.call();
                }
              },
            ),
        ],
      ),
    ).onTap(
      () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (_) {
            return EarningDetailBottomSheet(earningModel);
          },
        );
      },
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }
}
