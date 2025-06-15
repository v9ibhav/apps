import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/cached_image_widget.dart';
import '../../../component/price_widget.dart';
import '../../../main.dart';
import '../../../model/package_data_model.dart';
import '../../../model/service_data_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/images.dart';
import '../../service/service_detail_screen.dart';

class ProviderServiceComponent extends StatefulWidget {
  final ServiceData? serviceData;
  final BookingPackage? selectedPackage;
  final bool? isBorderEnabled;
  final VoidCallback? onUpdate;
  final bool isFavouriteService;
  final bool isFromProviderInfo;

  ProviderServiceComponent({
    this.serviceData,
    this.selectedPackage,
    this.isBorderEnabled,
    this.onUpdate,
    this.isFavouriteService = false,
    this.isFromProviderInfo = false,
  });

  @override
  _ProviderServiceComponentState createState() => _ProviderServiceComponentState();
}

class _ProviderServiceComponentState extends State<ProviderServiceComponent> {
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
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        ServiceDetailScreen(serviceId: widget.isFavouriteService ? widget.serviceData!.serviceId.validate().toInt() : widget.serviceData!.id.validate()).launch(context).then((value) {
          setStatusBarColor(context.primaryColor);
        });
      },
      child: Container(
        width: context.width(),
        padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(),
          backgroundColor: context.cardColor,
          border: widget.isBorderEnabled.validate(value: false)
              ? appStore.isDarkMode
                  ? Border.all(color: context.dividerColor)
                  : null
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImageWidget(
              url: widget.isFavouriteService
                  ? widget.serviceData!.serviceAttachments.validate().isNotEmpty
                      ? widget.serviceData!.serviceAttachments!.first.validate()
                      : ''
                  : widget.serviceData!.attachments.validate().isNotEmpty
                      ? widget.serviceData!.attachments!.first.validate()
                      : '',
              fit: BoxFit.cover,
              height: 85,
              circle: false,
              radius: defaultRadius,
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Text(
                          widget.serviceData!.categoryName.validate(),
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
                            Image.asset(ic_star_fill, height: 12, color: getRatingBarColor(widget.serviceData!.totalRating.validate().toInt())),
                            4.width,
                            Text("${widget.serviceData!.totalRating.validate().toStringAsFixed(1)}", style: boldTextStyle()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  10.height,
                  Text(
                    widget.serviceData!.name.validate(),
                    style: primaryTextStyle(weight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  10.height,
                  Row(
                    children: [
                      PriceWidget(
                        size: 14,
                        price: widget.serviceData!.price.validate(),
                      ),
                      8.width,
                      if (widget.serviceData!.discount.validate() > 0)
                        PriceWidget(
                          size: 12,
                          price: widget.serviceData!.getDiscountedPrice,
                          isDiscountedPrice: true,
                          color: textSecondaryColorGlobal,
                          isLineThroughEnabled: true,
                        ),
                      10.width,
                      if (widget.serviceData!.discount.validate() > 0)
                        Text(
                          "${widget.serviceData!.discount.validate()}% off", //Todo translate
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: defaultActivityStatus, fontWeight: FontWeight.bold, fontSize: 12),
                        ).expand(),
                    ],
                  )
                ],
              ),
            ),
            8.width,
            if (widget.isFavouriteService)
              Container(
                margin: EdgeInsets.only(right: 8),
                decoration: boxDecorationWithShadow(boxShape: BoxShape.circle, backgroundColor: context.cardColor),
                child: widget.serviceData!.isFavourite == 0 ? ic_fill_heart.iconImage(color: favouriteColor, size: 18) : ic_heart.iconImage(color: unFavouriteColor, size: 18),
              ).onTap(() async {
                if (widget.serviceData!.isFavourite == 0) {
                  widget.serviceData!.isFavourite = 1;
                  setState(() {});

                  await removeToWishList(serviceId: widget.serviceData!.serviceId.validate().toInt()).then((value) {
                    if (!value) {
                      widget.serviceData!.isFavourite = 0;
                      setState(() {});
                    }
                  });
                } else {
                  widget.serviceData!.isFavourite = 0;
                  setState(() {});

                  await addToWishList(serviceId: widget.serviceData!.serviceId.validate().toInt()).then((value) {
                    if (!value) {
                      widget.serviceData!.isFavourite = 1;
                      setState(() {});
                    }
                  });
                }
                widget.onUpdate?.call();
              }),
          ],
        ),
      ),
    );
  }
}
