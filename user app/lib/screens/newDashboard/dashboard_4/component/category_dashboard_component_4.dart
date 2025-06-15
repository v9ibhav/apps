import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';
import '../../../service/view_all_service_screen.dart';

class CategoryDashboardComponent4 extends StatelessWidget {
  final CategoryData categoryData;
  final double? width;

  CategoryDashboardComponent4({required this.categoryData, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ViewAllServiceScreen(categoryId: categoryData.id.validate(), categoryName: categoryData.name.validate(), isFromCategory: true).launch(context);
      },
      child: Stack(
        children: [
          categoryData.categoryImage.validate().endsWith('.svg')
              ? Container(
                  width: width ?? context.width() / 4 - 22,
                  height: 85,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    shape: BoxShape.rectangle,
                    borderRadius: radius(8),
                  ),
                  child: SvgPicture.network(
                    categoryData.categoryImage.validate(),
                    height: 85,
                    width: width ?? context.width() / 4 - 22,
                    color: appStore.isDarkMode ? Colors.white : categoryData.color.validate(value: '000').toColor(),
                    placeholderBuilder: (context) => PlaceHolderWidget(
                      height: 85,
                      width: width ?? context.width() / 4 - 22,
                      color: transparentColor,
                    ),
                  ).paddingAll(10),
                )
              : Container(
                  padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
                  height: 85,
                  width: width ?? context.width() / 4 - 22,
                  decoration: BoxDecoration(
                    color: appStore.isDarkMode ? Colors.white24 : context.cardColor,
                    shape: BoxShape.rectangle,
                    borderRadius: radius(8),
                    border: appStore.isDarkMode ? Border.all(color: grey) : null,
                  ),
                  child: CachedImageWidget(
                    url: categoryData.categoryImage.validate(),
                    height: 85,
                    width: width ?? context.width() / 4 - 22,
                  ),
                ),
          Container(
            height: 85,
            width: width ?? context.width() / 4 - 22,
            decoration: boxDecorationDefault(
              boxShadow: [],
              borderRadius: radius(8),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black12,
                  Colors.black12,
                  Colors.black12,
                  Colors.black26,
                  Colors.black38,
                  Colors.black45,
                  Colors.black87,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            left: 4,
            right: 4,
            child: Marquee(
              child: Text(
                categoryData.name.validate(),
                style: boldTextStyle(color: Colors.white, size: 10),
              ),
            ).center(),
          ),
        ],
      ),
    );
  }
}
