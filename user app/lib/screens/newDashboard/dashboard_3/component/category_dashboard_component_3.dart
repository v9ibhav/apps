import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';
import '../../../../model/category_model.dart';
import '../../../../utils/constant.dart';
import '../../../service/view_all_service_screen.dart';

class CategoryDashboardComponent3 extends StatelessWidget {
  final CategoryData categoryData;
  final double? width;

  CategoryDashboardComponent3({required this.categoryData, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ViewAllServiceScreen(
          categoryId: categoryData.id.validate(),
          categoryName: categoryData.name.validate(),
          isFromCategory: true,
        ).launch(context).then((value) {
          setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.dark);
        });
      },
      child: SizedBox(
        width: width ?? context.width() / 4 - 8,
        child: Column(
          children: [
            categoryData.categoryImage.validate().endsWith('.svg')
                ? Container(
                    width: CATEGORY_ICON_SIZE,
                    height: CATEGORY_ICON_SIZE,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      shape: BoxShape.rectangle,
                      borderRadius: radius(8),
                    ),
                    child: Column(
                      children: [
                        SvgPicture.network(
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
                        6.height,
                        Marquee(
                          directionMarguee: DirectionMarguee.oneDirection,
                          child: Text(
                            '${categoryData.name.validate()}',
                            style: primaryTextStyle(size: 12),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(14),
                    width: width ?? context.width() / 4 - 8,
                    decoration: BoxDecoration(
                      color: appStore.isDarkMode ? Colors.white24 : context.cardColor,
                      shape: BoxShape.rectangle,
                      borderRadius: radius(8),
                    ),
                    child: Column(
                      children: [
                        CachedImageWidget(
                          url: categoryData.categoryImage.validate(),
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                          circle: true,
                          placeHolderImage: '',
                        ),
                        16.height,
                        Marquee(
                          directionMarguee: DirectionMarguee.oneDirection,
                          child: Text(
                            '${categoryData.name.validate()}',
                            style: primaryTextStyle(size: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
