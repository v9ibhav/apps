import 'package:booking_system_flutter/model/category_model.dart';
import 'package:booking_system_flutter/screens/newDashboard/dashboard_4/component/category_dashboard_component_4.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/view_all_label_component.dart';
import '../../../../utils/colors.dart';
import '../../../category/category_screen.dart';

class CategoryListDashboardComponent4 extends StatelessWidget {
  final List<CategoryData> categoryList;
  final String listTiTle;

  CategoryListDashboardComponent4({required this.categoryList, required this.listTiTle});

  @override
  Widget build(BuildContext context) {
    if (categoryList.isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: listTiTle,
          list: categoryList,
          trailingTextStyle: boldTextStyle(color: primaryColor, size: 12),
          onTap: () {
            CategoryScreen().launch(context).then((value) {
              setStatusBarColor(Colors.transparent);
            });
          },
        ).paddingSymmetric(horizontal: 16),
        if (categoryList.isNotEmpty)
          Wrap(
            spacing: 16,
            runSpacing: 16,
            direction: Axis.horizontal,
            children: categoryList.map((e) => CategoryDashboardComponent4(categoryData: e)).take(8).toList(),
          ).paddingSymmetric(horizontal: 16)
      ],
    );
  }
}
