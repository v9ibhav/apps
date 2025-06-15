import 'package:booking_system_flutter/component/view_all_label_component.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/category_model.dart';
import 'package:booking_system_flutter/screens/category/category_screen.dart';
import 'package:booking_system_flutter/screens/dashboard/component/category_widget.dart';
import 'package:booking_system_flutter/screens/service/view_all_service_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryComponent extends StatefulWidget {
  final List<CategoryData>? categoryList;
  final bool isNewDashboard;

  CategoryComponent({this.categoryList, this.isNewDashboard = false});

  @override
  CategoryComponentState createState() => CategoryComponentState();
}

class CategoryComponentState extends State<CategoryComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoryList.validate().isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: widget.isNewDashboard ? language.lblCategory : language.category,
          list: widget.categoryList!,
          trailingTextStyle: widget.isNewDashboard ? boldTextStyle(color: primaryColor, size: 12) : null,
          onTap: () {
            CategoryScreen().launch(context).then((value) {
              setStatusBarColor(Colors.transparent);
            });
          },
        ).paddingSymmetric(horizontal: 16),
        AnimatedWrap(
          spacing: 16,
          runSpacing: 16,
          itemCount: widget.categoryList.validate().length,
          itemBuilder: (ctx, i) {
            CategoryData data = widget.categoryList![i];
            return GestureDetector(
              onTap: () {
                ViewAllServiceScreen(categoryId: data.id.validate(), categoryName: data.name, isFromCategory: true).launch(context);
              },
              child: CategoryWidget(categoryData: data),
            );
          },
        ).paddingSymmetric(horizontal: 16),
      ],
    );
  }
}
