import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constant.dart';
import '../models/payment_status_model.dart';

class PaymentStatusFilter extends StatefulWidget {
  final List<PaymentStatusModel> paymentStatusList;

  PaymentStatusFilter({required this.paymentStatusList});

  @override
  _PaymentStatusFilterState createState() => _PaymentStatusFilterState();
}

class _PaymentStatusFilterState extends State<PaymentStatusFilter> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 80),
      child: Container(
        alignment: Alignment.topLeft,
        child: AnimatedWrap(
          spacing: 12,
          runSpacing: 12,
          slideConfiguration: sliderConfigurationGlobal,
          itemCount: widget.paymentStatusList.length,
          listAnimationType: ListAnimationType.FadeIn,
          fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
          itemBuilder: (context, index) {
            PaymentStatusModel res = widget.paymentStatusList[index];

            return Container(
              width: context.width(),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: boxDecorationDefault(
                color: appStore.isDarkMode
                    ? res.isSelected
                        ? lightPrimaryColor
                        : context.cardColor
                    : res.isSelected
                        ? lightPrimaryColor
                        : context.cardColor,
                borderRadius: radius(8),
                border: Border.all(color: appStore.isDarkMode ? Colors.white54 : lightPrimaryColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (res.isSelected)
                    Container(
                      padding: EdgeInsets.all(2),
                      margin: EdgeInsets.only(right: 1),
                      child: Icon(Icons.done, size: 16, color: context.primaryColor),
                    ),
                  Text(
                    getPaymentStatusFilterText(res.status.validate()),
                    style: primaryTextStyle(
                        color: appStore.isDarkMode
                            ? res.isSelected
                                ? context.primaryColor
                                : Colors.white54
                            : res.isSelected
                                ? context.primaryColor
                                : Colors.black,
                        size: 12),
                  ),
                ],
              ),
            ).onTap(() {
              if (res.isSelected.validate()) {
                res.isSelected = false;
              } else {
                res.isSelected = true;
              }
              setState(() {});
            });
          },
        ).paddingAll(16),
      ),
    );
  }
}
