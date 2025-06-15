import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/view_all_label_component.dart';
import '../../../../model/category_model.dart';
import '../../../../utils/colors.dart';
import '../../../category/category_screen.dart';
import 'category_dashboard_component_3.dart';

class CategoryListDashboardComponent3 extends StatelessWidget {
  final List<CategoryData> categoryList;
  final String listTiTle;

  CategoryListDashboardComponent3({required this.categoryList, this.listTiTle = ''});

  @override
  Widget build(BuildContext context) {
    if (categoryList.isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        ViewAllLabel(
          label: listTiTle,
          list: categoryList,
          trailingTextStyle: boldTextStyle(color: primaryColor, size: 12),
          onTap: () {
            CategoryScreen().launch(context).then((value) {
              setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.dark);
            });
          },
        ).paddingSymmetric(horizontal: 16),
        if (categoryList.isNotEmpty)
          HorizontalList(
            itemCount: categoryList.length,
            spacing: 16,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              return CategoryDashboardComponent3(
                categoryData: categoryList[index],
              );
            },
          ),
      ],
    );
  }
}
