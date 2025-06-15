import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:nb_utils/nb_utils.dart';

class PriceWidget extends StatelessWidget {
  final num price;
  final double? size;
  final Color? color;
  final Color? hourlyTextColor;
  final bool isBoldText;
  final bool isLineThroughEnabled;
  final bool isDiscountedPrice;
  final bool isHourlyService;
  final bool isFreeService;
  final int? decimalPoint;

  PriceWidget({
    required this.price,
    this.size = 16.0,
    this.color,
    this.hourlyTextColor,
    this.isLineThroughEnabled = false,
    this.isBoldText = true,
    this.isDiscountedPrice = false,
    this.isHourlyService = false,
    this.isFreeService = false,
    this.decimalPoint,
  });

  @override
  Widget build(BuildContext context) {
    TextDecoration? textDecoration() => isLineThroughEnabled ? TextDecoration.lineThrough : null;

    TextStyle _textStyle({int? aSize}) {
      return isBoldText
          ? boldTextStyle(
              size: aSize ?? size!.toInt(),
              color: color != null ? color : primaryColor,
              decoration: textDecoration(),
            )
          : secondaryTextStyle(
              size: aSize ?? size!.toInt(),
              color: color != null ? color : primaryColor,
              decoration: textDecoration(),
            );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "${isDiscountedPrice ? ' -' : ''}",
          style: _textStyle(),
        ),
        Row(
          children: [
            if (isFreeService)
              Text(languages.lblFree, style: _textStyle())
            else
              Text(
                price.validate().toPriceFormat(),
                style: _textStyle(),
              ),
            if (isHourlyService) Text('/${languages.lblHr}', style: secondaryTextStyle(color: hourlyTextColor, size: 14)),
          ],
        ),
      ],
    );
  }
}
