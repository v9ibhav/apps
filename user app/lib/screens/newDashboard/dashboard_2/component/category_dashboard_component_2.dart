import 'package:booking_system_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../model/category_model.dart';

class CategoryDashboardComponent2 extends StatelessWidget {
  final CategoryData categoryData;
  final bool isSelected;

  CategoryDashboardComponent2({required this.categoryData, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width() / 4,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      alignment: Alignment.center,
      decoration: boxDecorationDefault(color: isSelected ? primaryColor : context.cardColor, borderRadius: BorderRadius.circular(defaultRadius + 16)),
      child: Marquee(child: Text(categoryData.name.validate(), style: isSelected ? primaryTextStyle(color: Colors.white, size: 12) : primaryTextStyle(size: 12))),
    );
  }
}
