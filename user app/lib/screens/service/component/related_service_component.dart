import 'package:booking_system_flutter/component/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/cached_image_widget.dart';
import '../../../main.dart';
import '../../../model/service_data_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/images.dart';
import '../service_detail_screen.dart';

class RelatedServiceComponent extends StatefulWidget {
  final ServiceData serviceData;
  final double? width;
  final bool? isBorderEnabled;
  final VoidCallback? onUpdate;
  final bool isFavouriteService;
  final bool isFromDashboard;
  final bool isFromViewAllService;
  final bool isFromServiceDetail;
  final bool isFromProviderInfo;

  RelatedServiceComponent({
    required this.serviceData,
    this.width,
    this.isBorderEnabled,
    this.isFavouriteService = false,
    this.onUpdate,
    this.isFromDashboard = false,
    this.isFromViewAllService = false,
    this.isFromServiceDetail = false,
    this.isFromProviderInfo = false,
  });

  @override
  _ServiceComponentState createState() => _ServiceComponentState();
}

class _ServiceComponentState extends State<RelatedServiceComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        ServiceDetailScreen(
          serviceId: widget.isFavouriteService ? widget.serviceData.serviceId.validate().toInt() : widget.serviceData.id.validate(),
        ).launch(context).then((value) {
          setStatusBarColor(context.primaryColor);
          widget.onUpdate?.call();
        });
      },
      child: Container(
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(),
          backgroundColor: context.cardColor,
          border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
        ),
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImageWidget(
              url: widget.isFavouriteService
                  ? widget.serviceData.serviceAttachments.validate().isNotEmpty
                      ? widget.serviceData.serviceAttachments!.first.validate()
                      : ''
                  : widget.serviceData.attachments.validate().isNotEmpty
                      ? widget.serviceData.attachments!.first.validate()
                      : '',
              fit: BoxFit.cover,
              height: 90,
              width: 90,
              circle: false,
              radius: 8,
            ),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: appStore.isDarkMode ? Colors.black : lightPrimaryColor,
                          borderRadius: radius(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Text(
                          widget.serviceData.categoryName.validate(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ).flexible(),
                      TextIcon(
                        suffix: Row(
                          children: [
                            Image.asset(ic_star_fill, height: 12, color: getRatingBarColor(widget.serviceData.totalRating.validate().toInt())),
                            4.width,
                            Text("${widget.serviceData.totalRating.validate().toStringAsFixed(1)}", style: boldTextStyle()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  10.height,
                  Text(
                    widget.serviceData.name.validate(),
                    style: primaryTextStyle(weight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  10.height,
                  Row(
                    children: [
                      PriceWidget(
                        size: 14,
                        price: widget.serviceData.price.validate(),
                      ),
                      8.width,
                      if (widget.serviceData.discount.validate() > 0)
                        PriceWidget(
                          size: 12,
                          price: widget.serviceData.getDiscountedPrice,
                          isDiscountedPrice: true,
                          color: textSecondaryColorGlobal,
                          isLineThroughEnabled: true,
                        ),
                      10.width,
                      if (widget.serviceData.discount.validate() > 0)
                        Text(
                          "${widget.serviceData.discount.validate()}% off", //Todo translate
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: defaultActivityStatus, fontWeight: FontWeight.bold, fontSize: 12),
                        ).expand(),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
