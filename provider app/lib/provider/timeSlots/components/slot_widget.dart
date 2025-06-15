import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class SlotWidget extends StatelessWidget {
  final bool isAvailable;
  final bool isSelected;
  final Color? isWhiteBackground;
  final String value;
  final double? width;
  final Color activeColor;
  final Function() onTap;

  SlotWidget({
    required this.isAvailable,
    required this.isSelected,
    required this.value,
    this.isWhiteBackground,
    this.width,
    this.activeColor = Colors.green,
    required this.onTap,
  });

  Color _getBackgroundColor(BuildContext context) {
    if (isAvailable && isSelected) {
      return activeColor;
    } else if (isSelected) {
      return activeColor;
    } else {
      return isWhiteBackground ?? context.cardColor;
    }
  }

  Color _getTextColor() {
    if (isAvailable && isSelected) {
      return Colors.white;
    } else if (isSelected) {
      return Colors.white;
    } else {
      return textPrimaryColorGlobal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? context.width() / 3 - 22,
        decoration: boxDecorationDefault(
          boxShadow: defaultBoxShadow(blurRadius: 0, spreadRadius: 0),
          border: Border.all(color: isAvailable ? activeColor : transparentColor),
          color: _getBackgroundColor(context),
        ),
        padding: EdgeInsets.all(12),
        child: Observer(
          builder: (context) => Text(
            appStore.is24HourFormat ? value.splitBefore(':00') : getTime(getSlotWithDate(date: DateTime.now().toString(), slotTime: value)),
            style: primaryTextStyle(color: _getTextColor()),
          ),
        ),
      ),
    );
  }
}
