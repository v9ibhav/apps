import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/price_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/package_data_model.dart';
import 'package:booking_system_flutter/model/service_data_model.dart';
import 'package:booking_system_flutter/screens/service/service_detail_screen.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/base_scaffold_widget.dart';
import '../../../utils/colors.dart';

class PackageDetailScreen extends StatefulWidget {
  final BookingPackage packageData;
  final bool? isFromServiceDetail;
  final Function(BookingPackage?)? callBack;

  PackageDetailScreen({required this.packageData, this.isFromServiceDetail = false, this.callBack});

  @override
  _PackageDetailScreenState createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> {
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: widget.packageData.name.validate(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: boxDecorationWithRoundedCorners(borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius), backgroundColor: context.cardColor),
              child: AnimatedScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      CachedImageWidget(
                        url: widget.packageData.attchments!.isNotEmpty ? widget.packageData.attchments!.first.url.validate() : '',
                        height: 200,
                        width: context.width(),
                        fit: BoxFit.cover,
                        radius: 8,
                      ),
                      Positioned(
                        top: 10,
                        right: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.cardColor,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Row(
                            children: [
                              PriceWidget(price: widget.packageData.price.validate()),
                              10.width,
                              if (widget.packageData.isPackageDiscountApplied)
                                PriceWidget(
                                  color: lineTextColor,
                                  price: widget.packageData.originalPrice,
                                  hourlyTextColor: Colors.white,
                                  size: 12,
                                  isLineThroughEnabled: true,
                                ),
                            ],
                          ).paddingSymmetric(horizontal: 10, vertical: 5),
                        ),
                      )
                    ],
                  ),
                  16.height,
                  Text(
                    widget.packageData.description.validate(),
                    style: secondaryTextStyle(),
                  ),
                  32.height,
                  Text("Service included in this package", style: boldTextStyle(size: LABEL_TEXT_SIZE)), //Todo translate
                  4.height,
                  if (widget.packageData.serviceList != null)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.packageData.serviceList!.length,
                      itemBuilder: (_, i) {
                        ServiceData data = widget.packageData.serviceList![i];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            width: context.width(),
                            padding: EdgeInsets.all(16),
                            decoration: boxDecorationWithRoundedCorners(
                              borderRadius: radius(),
                              backgroundColor: context.cardColor,
                              border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedImageWidget(
                                  url: data.attachments!.isNotEmpty ? data.attachments!.first : "",
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                  radius: 8,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (data.subCategoryName.validate().isNotEmpty)
                                            Expanded(
                                              child: Marquee(
                                                child: Row(
                                                  children: [
                                                    Text('${data.categoryName}', style: boldTextStyle(size: 12, color: textSecondaryColorGlobal)),
                                                    Text('  >  ', style: boldTextStyle(size: 14, color: textSecondaryColorGlobal)),
                                                    Text('${data.subCategoryName}', style: boldTextStyle(size: 12, color: context.primaryColor)),
                                                  ],
                                                ),
                                              ),
                                            )
                                          else
                                            Expanded(
                                              child: Text('${data.categoryName}', style: boldTextStyle(size: 12, color: context.primaryColor)),
                                            ),
                                          SizedBox(width: 8),
                                          PriceWidget(
                                            price: data.price.validate(),
                                            hourlyTextColor: Colors.white,
                                            size: 14,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(data.name.validate(), maxLines: 1, overflow: TextOverflow.ellipsis, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).onTap(() {
                            ServiceDetailScreen(serviceId: data.id.validate()).launch(context);
                          }),
                        );
                      },
                    )
                ],
              ),
            ),
          ),
          AppButton(
            onTap: () {
              widget.callBack?.call(widget.packageData);
            },
            color: context.primaryColor,
            child: Text(language.lblBookNow, style: boldTextStyle(color: white)),
            width: context.width(),
            textColor: Colors.white,
          ).paddingSymmetric(horizontal: 16.0, vertical: 10.0)
        ],
      ),
    );
  }
}
