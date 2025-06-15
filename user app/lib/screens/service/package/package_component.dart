import 'package:booking_system_flutter/component/price_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/package_data_model.dart';
import 'package:booking_system_flutter/screens/service/package/package_detail_screen.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/cached_image_widget.dart';
import '../../../component/view_all_label_component.dart';
import '../../../utils/colors.dart';

class PackageComponent extends StatefulWidget {
  final List<BookingPackage> servicePackage;
  final Function(BookingPackage?) callBack;

  PackageComponent({required this.servicePackage, required this.callBack});

  @override
  _PackageComponentState createState() => _PackageComponentState();
}

class _PackageComponentState extends State<PackageComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  bool _isDateClose(String endDate) {
    final DateTime currentDate = DateTime.now();
    final DateTime endDateTime = DateFormat('yyyy-MM-dd').parse(endDate); // Ensure the date format matches
    final difference = endDateTime.difference(currentDate).inDays;

    return difference <= 2;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.servicePackage.isEmpty) return Offstage();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: language.package,
          list: [],
          onTap: () {
            //
          },
        ),
        AnimatedListView(
          listAnimationType: ListAnimationType.FadeIn,
          fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
          shrinkWrap: true,
          itemCount: widget.servicePackage.length,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (_, i) {
            BookingPackage data = widget.servicePackage[i];

            return Container(
              width: context.width(),
              padding: EdgeInsets.all(16),
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: radius(),
                backgroundColor: context.cardColor,
                border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CachedImageWidget(
                        url: data.imageAttachments.validate().isNotEmpty ? data.imageAttachments!.first.validate() : "",
                        height: 60,
                        fit: BoxFit.cover,
                        radius: defaultRadius,
                      ),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Marquee(
                                directionMarguee: DirectionMarguee.oneDirection,
                                child: Text(data.name.validate(), style: boldTextStyle()),
                              ),
                              10.height,
                              Row(
                                children: [
                                  PriceWidget(
                                    price: data.price.validate(),
                                    hourlyTextColor: Colors.white,
                                    size: 14,
                                  ),
                                  10.width,
                                  if (data.isPackageDiscountApplied)
                                    PriceWidget(
                                      price: data.originalPrice,
                                      color: lineTextColor,
                                      hourlyTextColor: Colors.white,
                                      size: 12,
                                      isBoldText: true,
                                      isLineThroughEnabled: true,
                                    ),
                                  10.width,
                                  Text(
                                    '${(((data.originalPrice - data.price.validate()) / data.originalPrice) * 100).toStringAsFixed(1)}% off', // Todo translate
                                    style: TextStyle(fontSize: 12, color: defaultActivityStatus, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ).expand(),
                    ],
                  ),
                  8.height,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${data.serviceList!.length.toString().padLeft(2, '0')} service included", //Todo Language
                      style: TextStyle(color: lineTextColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ).paddingOnly(left: 75),
                  ),
                  16.height,
                  AppButton(
                    width: context.width(),
                    child: Text(
                      "Purchase", //Todo language
                      style: boldTextStyle(color: Colors.white),
                    ),
                    color: context.primaryColor,
                    onTap: () async {
                      PackageDetailScreen(packageData: data, isFromServiceDetail: true, callBack: widget.callBack).launch(context);
                    },
                  ),
                  5.height,
                  if (data.endDate.validate().isNotEmpty)
                    Text(
                      '${language.endOn}: ${formatDate(data.endDate.validate())}',
                      style: boldTextStyle(
                        color: _isDateClose(data.endDate.validate()) ? cancelled : defaultActivityStatus, // Set color conditionally
                        size: 12,
                      ),
                    ).paddingTop(2),
                ],
              ),
            );
          },
        ),
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}
