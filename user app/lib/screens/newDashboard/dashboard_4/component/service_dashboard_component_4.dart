import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/online_service_icon_widget.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/image_border_component.dart';
import '../../../../component/price_widget.dart';
import '../../../../main.dart';
import '../../../../model/package_data_model.dart';
import '../../../../model/service_data_model.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/images.dart';
import '../../../booking/provider_info_screen.dart';
import '../../../service/service_detail_screen.dart';

class ServiceDashboardComponent4 extends StatefulWidget {
  final ServiceData serviceData;
  final BookingPackage? selectedPackage;
  final double? width;
  final bool? isBorderEnabled;
  final VoidCallback? onUpdate;
  final bool isFavouriteService;
  final bool isFromDashboard;

  ServiceDashboardComponent4({
    required this.serviceData,
    this.width,
    this.isBorderEnabled,
    this.isFavouriteService = false,
    this.onUpdate,
    this.selectedPackage,
    this.isFromDashboard = false,
  });

  @override
  State<ServiceDashboardComponent4> createState() => _ServiceDashboardComponent4State();
}

class _ServiceDashboardComponent4State extends State<ServiceDashboardComponent4> {
  num get finalDiscountAmount => widget.serviceData.discount != 0
      ? ((widget.serviceData.price.validate() / 100) * widget.serviceData.discount.validate()).toStringAsFixed(appConfigurationStore.priceDecimalPoint).toDouble()
      : 0;

  num get discountedAmount => widget.serviceData.price.validate() - finalDiscountAmount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        ServiceDetailScreen(
          serviceId: widget.isFavouriteService ? widget.serviceData.serviceId.validate().toInt() : widget.serviceData.id.validate(),
        ).launch(context).then((value) {
          setStatusBarColor(context.primaryColor);
        });
      },
      child: SizedBox(
        width: widget.width,
        height: 280,
        child: Stack(
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
              height: 280,
              width: widget.width ?? context.width(),
            ).cornerRadiusWithClipRRect(defaultRadius),
            Container(
              height: 280,
              width: widget.width ?? context.width(),
              decoration: boxDecorationDefault(
                boxShadow: [],
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.mirror,
                  stops: [0.33, 0.66, 0.99],
                  colors: [
                    Colors.transparent,
                    Colors.black38,
                    Colors.black87,
                  ],
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                constraints: BoxConstraints(maxWidth: context.width() * 0.3),
                decoration: boxDecorationWithShadow(
                  backgroundColor: context.cardColor.withValues(alpha:0.9),
                  borderRadius: radius(12),
                ),
                child: Marquee(
                  directionMarguee: DirectionMarguee.oneDirection,
                  child: Text(
                    "${widget.serviceData.subCategoryName.validate().isNotEmpty ? widget.serviceData.subCategoryName.validate() : widget.serviceData.categoryName.validate()}".toUpperCase(),
                    style: boldTextStyle(color: appStore.isDarkMode ? white : primaryColor, size: 12),
                  ).paddingSymmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ),
            if (widget.serviceData.isOnlineService)
              Positioned(
                top: 12,
                right: widget.isFavouriteService ? 50 : 12,
                child: OnlineServiceIconWidget(isShowText: false),
              ),
            Positioned(
              bottom: 100,
              left: isRTL ? 0 : 16,
              right: isRTL ? 16 : 0,
              child: Text(
                widget.serviceData.name.validate(),
                style: boldTextStyle(size: 14, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Positioned(
              bottom: 60,
              left: isRTL ? 0 : 16,
              right: isRTL ? 16 : 0,
              child: Row(
                children: [
                  ImageBorder(src: widget.serviceData.providerImage.validate(), height: 30),
                  8.width,
                  if (widget.serviceData.providerName.validate().isNotEmpty)
                    Text(
                      widget.serviceData.providerName.validate(),
                      style: secondaryTextStyle(size: 12, color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ).expand()
                ],
              ).onTap(() async {
                if (widget.serviceData.providerId != appStore.userId.validate()) {
                  await ProviderInfoScreen(providerId: widget.serviceData.providerId.validate()).launch(context);
                  setStatusBarColor(Colors.transparent);
                }
              }),
            ),
            if (widget.isFavouriteService)
              Positioned(
                top: 8,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(right: 8),
                  decoration: boxDecorationWithShadow(boxShape: BoxShape.circle, backgroundColor: context.cardColor),
                  child: widget.serviceData.isFavourite == 1 ? ic_fill_heart.iconImage(color: favouriteColor, size: 18) : ic_heart.iconImage(color: unFavouriteColor, size: 18),
                ).onTap(() async {
                  if (widget.serviceData.isFavourite != 0) {
                    widget.serviceData.isFavourite = 1;
                    setState(() {});

                    await removeToWishList(serviceId: widget.serviceData.serviceId.validate().toInt()).then((value) {
                      if (!value) {
                        widget.serviceData.isFavourite = 1;
                        setState(() {});
                      }
                    });
                  } else {
                    widget.serviceData.isFavourite = 0;
                    setState(() {});

                    await addToWishList(serviceId: widget.serviceData.serviceId.validate().toInt()).then((value) {
                      if (!value) {
                        widget.serviceData.isFavourite = 1;
                        setState(() {});
                      }
                    });
                  }
                  widget.onUpdate?.call();
                }),
              ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: boxDecorationDefault(
                  shape: BoxShape.rectangle,
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Marquee(
                  directionMarguee: DirectionMarguee.oneDirection,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.serviceData.discount.validate() != 0)
                        PriceWidget(
                          price: discountedAmount,
                          isHourlyService: widget.serviceData.isHourlyService,
                          color: Colors.white,
                          hourlyTextColor: Colors.white,
                          size: 16,
                          isFreeService: widget.serviceData.type.validate() == SERVICE_TYPE_FREE,
                        ).paddingRight(8),
                      PriceWidget(
                        price: widget.serviceData.price.validate(),
                        isLineThroughEnabled: widget.serviceData.discount != 0 ? true : false,
                        isHourlyService: widget.serviceData.isHourlyService,
                        color: Colors.white,
                        hourlyTextColor: Colors.white,
                        size: widget.serviceData.discount != 0 ? 12 : 16,
                        isFreeService: widget.serviceData.type.validate() == SERVICE_TYPE_FREE,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
