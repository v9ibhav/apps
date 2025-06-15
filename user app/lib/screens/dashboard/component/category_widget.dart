import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/category_model.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../newDashboard/dashboard_3/component/category_dashboard_component_3.dart';
import '../../newDashboard/dashboard_4/component/category_dashboard_component_4.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryData categoryData;
  final double? width;
  final bool? isFromCategory;

  CategoryWidget({required this.categoryData, this.width, this.isFromCategory});

  Widget buildDefaultComponent(BuildContext context) {
    return SizedBox(
      width: width ?? context.width() / 4 - 20,
      child: Column(
        children: [
          categoryData.categoryImage.validate().endsWith('.svg')
              ? Container(
                  width: CATEGORY_ICON_SIZE,
                  height: CATEGORY_ICON_SIZE,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color: context.cardColor, shape: BoxShape.circle),
                  child: SvgPicture.network(
                    categoryData.categoryImage.validate(),
                    height: CATEGORY_ICON_SIZE,
                    width: CATEGORY_ICON_SIZE,
                    color: appStore.isDarkMode ? Colors.white : categoryData.color.validate(value: '000').toColor(),
                    placeholderBuilder: (context) => PlaceHolderWidget(
                      height: CATEGORY_ICON_SIZE,
                      width: CATEGORY_ICON_SIZE,
                      color: transparentColor,
                    ),
                  ).paddingAll(10),
                )
              : Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(color: appStore.isDarkMode ? Colors.white24 : context.cardColor, shape: BoxShape.circle),
                  child: CachedImageWidget(
                    url: categoryData.categoryImage.validate(),
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                    circle: true,
                    placeHolderImage: '',
                  ),
                ),
          4.height,
          Marquee(
            directionMarguee: DirectionMarguee.oneDirection,
            child: Text(
              '${categoryData.name.validate()}',
              style: primaryTextStyle(size: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget categoryComponent() {
      return Observer(builder: (context) {
        if (appConfigurationStore.userDashboardType == DASHBOARD_1) {
          return buildDefaultComponent(context);
        } else if (appConfigurationStore.userDashboardType == DASHBOARD_2) {
          return buildDefaultComponent(context);
        } else if (appConfigurationStore.userDashboardType == DASHBOARD_3) {
          return CategoryDashboardComponent3(categoryData: categoryData, width: context.width() / 4 - 20);
        } else if (appConfigurationStore.userDashboardType == DASHBOARD_4) {
          return CategoryDashboardComponent4(categoryData: categoryData);
        } else {
          return buildDefaultComponent(context);
        }
      });
    }

    return categoryComponent();
  }
}
