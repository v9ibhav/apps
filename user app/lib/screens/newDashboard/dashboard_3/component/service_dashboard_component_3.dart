import 'package:booking_system_flutter/model/service_data_model.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/cached_image_widget.dart';
import '../../../../component/image_border_component.dart';
import '../../../../component/online_service_icon_widget.dart';
import '../../../../component/price_widget.dart';
import '../../../../main.dart';
import '../../../../model/package_data_model.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/images.dart';
import '../../../booking/provider_info_screen.dart';
import '../../../service/service_detail_screen.dart';

class ServiceDashboardComponent3 extends StatefulWidget {
  final ServiceData serviceData;
  final BookingPackage? selectedPackage;
  final double? width;
  final bool? isBorderEnabled;
  final VoidCallback? onUpdate;
  final bool isFavouriteService;
  final bool isFromDashboard;

  ServiceDashboardComponent3({
    required this.serviceData,
    this.width,
    this.isBorderEnabled,
    this.isFavouriteService = false,
    this.onUpdate,
    this.selectedPackage,
    this.isFromDashboard = false,
  });

  @override
  State<ServiceDashboardComponent3> createState() => _ServiceDashboardComponent3State();
}

class _ServiceDashboardComponent3State extends State<ServiceDashboardComponent3> {
  num get finalDiscountAmount => widget.serviceData.discount != 0 ? ((widget.serviceData.price.validate() / 100) * widget.serviceData.discount.validate()).toStringAsFixed(appConfigurationStore.priceDecimalPoint).toDouble() : 0;

  num get discountedAmount => widget.serviceData.price.validate() - finalDiscountAmount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        ServiceDetailScreen(
          serviceId: widget.isFavouriteService ? widget.serviceData.serviceId.validate().toInt() : widget.serviceData.id.validate(),
        ).launch(context).then((value) {
          setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.dark, delayInMilliSeconds: 1000);
        });
      },
      child: Container(
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(),
          backgroundColor: context.cardColor,
          border: widget.isBorderEnabled.validate(value: false)
              ? appStore.isDarkMode
                  ? Border.all(color: context.dividerColor)
                  : null
              : null,
        ),
        width: widget.width ?? context.width(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 180,
              width: context.width(),
              child: Stack(
                clipBehavior: Clip.none,
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
                    height: 180,
                    width: widget.width ?? context.width(),
                    circle: false,
                  ).cornerRadiusWithClipRRectOnly(topRight: defaultRadius.toInt(), topLeft: defaultRadius.toInt()),
                  if (widget.serviceData.isOnlineService)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: OnlineServiceIconWidget(),
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
                        if (widget.serviceData.isFavourite == 0) {
                          widget.serviceData.isFavourite = 1;
                          setState(() {});

                          await removeToWishList(serviceId: widget.serviceData.serviceId.validate().toInt()).then((value) {
                            if (!value) {
                              widget.serviceData.isFavourite = 0;
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
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                Marquee(
                  directionMarguee: DirectionMarguee.oneDirection,
                  child: Text(
                    "${widget.serviceData.subCategoryName.validate().isNotEmpty ? widget.serviceData.subCategoryName.validate() : widget.serviceData.categoryName.validate()}".toUpperCase(),
                    style: boldTextStyle(color: appStore.isDarkMode ? textSecondaryColorGlobal : primaryColor, size: 12),
                  ),
                ).paddingSymmetric(horizontal: 16),
                16.height,
                Text(
                  widget.serviceData.name.validate(),
                  style: boldTextStyle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ).paddingSymmetric(horizontal: 16),
                16.height,
                Row(
                  children: [
                    Marquee(
                      directionMarguee: DirectionMarguee.oneDirection,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.serviceData.discount != 0)
                            PriceWidget(
                              price: discountedAmount,
                              isHourlyService: widget.serviceData.isHourlyService,
                              color: primaryColor,
                              hourlyTextColor: primaryColor,
                              size: 18,
                              isFreeService: widget.serviceData.type.validate() == SERVICE_TYPE_FREE,
                            ),
                          if (widget.serviceData.discount != 0) 16.width,
                          PriceWidget(
                            price: widget.serviceData.price.validate(),
                            isLineThroughEnabled: widget.serviceData.discount != 0 ? true : false,
                            isHourlyService: widget.serviceData.isHourlyService,
                            color: widget.serviceData.discount != 0 ? textSecondaryColorGlobal : primaryColor,
                            hourlyTextColor: widget.serviceData.discount != 0 ? textSecondaryColorGlobal : primaryColor,
                            size: widget.serviceData.discount != 0 ? 14 : 18,
                            isFreeService: widget.serviceData.type.validate() == SERVICE_TYPE_FREE,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    if (widget.serviceData.totalRating.validate() > 0)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: boxDecorationDefault(
                          color: appStore.isDarkMode ? context.cardColor.withValues(alpha:0.2) : Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Image.asset(ic_star_fill, height: 15, color: getRatingBarColor(widget.serviceData.totalRating.validate().toInt())),
                            4.width,
                            Text("${widget.serviceData.totalRating.validate().toStringAsFixed(1)}", style: boldTextStyle(size: 12)),
                          ],
                        ),
                      ),
                  ],
                ).paddingSymmetric(horizontal: 16),
                12.height,
                Row(
                  children: [
                    ImageBorder(src: widget.serviceData.providerImage.validate(), height: 30),
                    8.width,
                    if (widget.serviceData.providerName.validate().isNotEmpty)
                      Text(
                        widget.serviceData.providerName.validate(),
                        style: secondaryTextStyle(size: 12, color: appStore.isDarkMode ? Colors.white : appTextSecondaryColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ).expand()
                  ],
                ).onTap(() async {
                  if (widget.serviceData.providerId != appStore.userId.validate()) {
                    await ProviderInfoScreen(providerId: widget.serviceData.providerId.validate()).launch(context);
                    setStatusBarColor(Colors.transparent);
                  }
                }).paddingSymmetric(horizontal: 16),
                16.height,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
