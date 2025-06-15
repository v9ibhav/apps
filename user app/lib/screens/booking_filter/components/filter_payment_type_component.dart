import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';
import '../../../main.dart';
import '../../../model/payment_gateway_response.dart';
import '../../../utils/colors.dart';
import '../../../utils/constant.dart';

class PaymentTypeFilter extends StatefulWidget {
  final List<PaymentSetting> paymentTypeList;

  PaymentTypeFilter({required this.paymentTypeList});

  @override
  _PaymentTypeFilterState createState() => _PaymentTypeFilterState();
}

class _PaymentTypeFilterState extends State<PaymentTypeFilter> {
  @override
  Widget build(BuildContext context) {
    if (widget.paymentTypeList.isEmpty)
      return NoDataWidget(
        title: language.noPaymentMethodFound,
        imageWidget: EmptyStateWidget(),
      );

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 80),
      child: Container(
        alignment: Alignment.topLeft,
        child: AnimatedWrap(
          spacing: 12,
          runSpacing: 12,
          slideConfiguration: sliderConfigurationGlobal,
          itemCount: widget.paymentTypeList.length,
          listAnimationType: ListAnimationType.FadeIn,
          fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
          itemBuilder: (context, index) {
            PaymentSetting res = widget.paymentTypeList[index];

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
                    res.title.validate(),
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
