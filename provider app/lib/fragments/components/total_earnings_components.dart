import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/base_scaffold_widget.dart';
import '../../components/price_widget.dart';
import '../../main.dart';
import '../../models/booking_list_response.dart';

class TotalAmountsComponent extends StatelessWidget {
  final String totalEarning;
  final PaymentBreakdown paymentBreakdown;

  TotalAmountsComponent({required this.paymentBreakdown, required this.totalEarning});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.lblTotalAmount,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(languages.totalAmount, style: boldTextStyle()),
                    16.width,
                    PriceWidget(price: totalEarning.toDouble(), color: primaryColor),
                  ],
                ),
              ],
            ).paddingSymmetric(vertical: 6),
          ).paddingTop(16),
          30.height,
          Text(languages.paymentBreakdown, style: boldTextStyle()).paddingSymmetric(horizontal: 16),
          16.height,
          if (isUserTypeProvider)
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(languages.provider, style: boldTextStyle(size: 12)).expand(),
                  4.width,
                  PriceWidget(price: paymentBreakdown.providerEarned.toDouble(), color: darkOrange, size: 14),
                ],
              ),
            ).paddingOnly(bottom: 16),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(languages.handyman, style: boldTextStyle(size: 12)).expand(),
                4.width,
                PriceWidget(price: paymentBreakdown.handymanEarned.toDouble(), color: royalBlue, size: 14),
              ],
            ),
          ),
          16.height,
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(languages.taxAmount, style: boldTextStyle(size: 12)).expand(),
                16.width,
                PriceWidget(price: paymentBreakdown.tax.toDouble(), color: redColor, size: 14),
              ],
            ),
          ),
          16.height,
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(languages.hintDiscount, style: boldTextStyle(size: 12)).expand(),
                16.width,
                PriceWidget(price: paymentBreakdown.discount.toDouble(), color: greenColor, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
