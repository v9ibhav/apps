import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/price_widget.dart';
import '../../../utils/constant.dart';
import '../model/earning_list_model.dart';

class EarningDetailBottomSheet extends StatelessWidget {
  final EarningListModel earningModel;

  const EarningDetailBottomSheet(this.earningModel);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
          backgroundColor: context.cardColor,
        ),
        padding: EdgeInsets.all(16),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          width: context.width(),
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: radius(),
            backgroundColor: context.scaffoldBackgroundColor,
            border: Border.all(color: context.dividerColor, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(languages.earningDetails, style: boldTextStyle()).paddingAll(16),
              if (earningModel.adminEarning != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(languages.adminEarning, style: secondaryTextStyle()).expand(),
                    8.width,
                    PriceWidget(
                      price: earningModel.adminEarning.validate(),
                      color: context.primaryColor,
                      isBoldText: true,
                      size: 14,
                    ),
                  ],
                ).paddingSymmetric(vertical: 8, horizontal: 16),
              if (earningModel.handymanName != null)
                Row(
                  children: [
                    Text(languages.handymanName, style: secondaryTextStyle(), textAlign: TextAlign.left).expand(),
                    8.width,
                    Text(
                      earningModel.handymanName.validate(),
                      style: boldTextStyle(size: 12),
                      textAlign: TextAlign.right,
                    ).expand(),
                  ],
                ).paddingSymmetric(vertical: 8, horizontal: 16),
              if (earningModel.commission != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(languages.commission, style: secondaryTextStyle()).expand(),
                    8.width,
                    if (earningModel.commissionType.validate().toLowerCase() == COMMISSION_TYPE_PERCENTAGE.toLowerCase() || earningModel.commissionType.validate().toLowerCase() == TAX_TYPE_PERCENT.toLowerCase())
                      Text(
                        '${earningModel.commission}%',
                        style: boldTextStyle(size: 12),
                        textAlign: TextAlign.right,
                      ).expand(),
                    if (earningModel.commissionType.validate().toLowerCase() == COMMISSION_TYPE_FIXED.toLowerCase())
                      Text(
                        earningModel.commission.validate().toPriceFormat(),
                        style: boldTextStyle(size: 12),
                        textAlign: TextAlign.right,
                      ).expand(),
                  ],
                ).paddingSymmetric(vertical: 8, horizontal: 16),
              if (earningModel.totalBookings != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(languages.lblTotalBooking, style: secondaryTextStyle()).expand(),
                    8.width,
                    Text(earningModel.totalBookings.validate().toString(), style: boldTextStyle(size: 12), textAlign: TextAlign.right).expand(),
                  ],
                ).paddingSymmetric(vertical: 8, horizontal: 16),
              if (earningModel.totalEarning != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(languages.totalEarning, style: secondaryTextStyle()).expand(),
                    8.width,
                    PriceWidget(
                      price: earningModel.totalEarning.validate(),
                      color: context.primaryColor,
                      isBoldText: true,
                      size: 14,
                    ),
                  ],
                ).paddingSymmetric(vertical: 8, horizontal: 16),
              if (earningModel.taxes != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(languages.lblTaxes, style: secondaryTextStyle()).expand(),
                    8.width,
                    PriceWidget(
                      price: earningModel.taxes.validate(),
                      color: context.primaryColor,
                      isBoldText: true,
                      size: 14,
                    ),
                  ],
                ).paddingSymmetric(vertical: 8, horizontal: 16),
              8.height,
            ],
          ),
        ),
      ),
    );
  }
}
