import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/generated/assets.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/package_data_model.dart';
import 'package:booking_system_flutter/model/service_detail_response.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/service/service_detail_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/extensions/num_extenstions.dart';
import 'package:booking_system_flutter/utils/model_keys.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../model/booking_amount_model.dart';
import '../../../utils/app_configuration.dart';
import '../../../utils/common.dart';
import '../../../utils/constant.dart';
import '../../payment/payment_screen.dart';
import 'booking_confirmation_dialog.dart';

class ConfirmBookingDialog extends StatefulWidget {
  final ServiceDetailResponse data;
  final num? bookingPrice;
  final int qty;
  final String? couponCode;
  final BookingPackage? selectedPackage;
  final BookingAmountModel? bookingAmountModel;

  ConfirmBookingDialog({required this.data, required this.bookingPrice, this.qty = 1, this.couponCode, this.selectedPackage, this.bookingAmountModel});

  @override
  State<ConfirmBookingDialog> createState() => _ConfirmBookingDialogState();
}

class _ConfirmBookingDialogState extends State<ConfirmBookingDialog> {
  Map? selectedPackage;
  List<int> selectedService = [];

  bool isSelected = false;

  Future<void> bookServices() async {
    if (widget.selectedPackage != null) {
      if (widget.selectedPackage!.serviceList != null) {
        widget.selectedPackage!.serviceList!.forEach((element) {
          selectedService.add(element.id.validate());
        });
      }

      selectedPackage = {
        PackageKey.packageId: widget.selectedPackage!.id.validate(),
        PackageKey.categoryId: widget.selectedPackage!.categoryId != -1 ? widget.selectedPackage!.categoryId.validate() : null,
        PackageKey.name: widget.selectedPackage!.name.validate(),
        PackageKey.price: widget.selectedPackage!.price.validate(),
        PackageKey.serviceId: selectedService.join(','),
        PackageKey.startDate: widget.selectedPackage!.startDate.validate(),
        PackageKey.endDate: widget.selectedPackage!.endDate.validate(),
        PackageKey.isFeatured: widget.selectedPackage!.isFeatured == 1 ? '1' : '0',
        PackageKey.packageType: widget.selectedPackage!.packageType.validate(),
      };
    }

    log("selectedPackage: ${[selectedPackage]}");

    Map request = {
      CommonKeys.id: "",
      CommonKeys.serviceId: widget.data.serviceDetail!.id.toString(),
      CommonKeys.providerId: widget.data.provider!.id.validate().toString(),
      CommonKeys.customerId: appStore.userId.toString().toString(),
      BookingServiceKeys.description: widget.data.serviceDetail!.bookingDescription.validate().toString(),
      CommonKeys.address: widget.data.serviceDetail!.address.validate().toString(),
      CommonKeys.date: widget.data.serviceDetail!.isSlotAvailable ? widget.data.serviceDetail!.bookingDate.validate().toString() : widget.data.serviceDetail!.dateTimeVal.validate().toString(),
      BookingServiceKeys.couponId: widget.couponCode.validate(),
      BookService.amount: widget.selectedPackage != null ? widget.selectedPackage!.price : widget.data.serviceDetail!.price,
      BookService.quantity: '${widget.qty}',
      BookingServiceKeys.totalAmount: !widget.data.serviceDetail!.isFreeService ? widget.bookingPrice.validate().toStringAsFixed(getIntAsync(PRICE_DECIMAL_POINTS)) : 0,
      CouponKeys.discount: widget.data.serviceDetail!.discount != null ? widget.data.serviceDetail!.discount.toString() : "",
      BookService.bookingAddressId: widget.data.serviceDetail!.bookingAddressId != -1 ? widget.data.serviceDetail!.bookingAddressId : null,
      BookingServiceKeys.type: BOOKING_TYPE_SERVICE,
      BookingServiceKeys.bookingPackage: widget.selectedPackage != null ? selectedPackage : null,
      BookingServiceKeys.serviceAddonId: serviceAddonStore.selectedServiceAddon.map((e) => e.id).toList(),
    };
    if (widget.bookingAmountModel != null) {
      request.addAll(widget.bookingAmountModel!.toJson());
    }

    if (widget.data.serviceDetail!.isSlotAvailable) {
      request.putIfAbsent('booking_date', () => widget.data.serviceDetail!.bookingDate.validate().toString());
      request.putIfAbsent('booking_slot', () => widget.data.serviceDetail!.bookingSlot.validate().toString());
      request.putIfAbsent('booking_day', () => widget.data.serviceDetail!.bookingDay.validate().toString());
    }

    if (!widget.data.serviceDetail!.isFreeService && widget.data.taxes.validate().isNotEmpty) {
      request.putIfAbsent('tax', () => widget.data.taxes);
    }
    if (widget.data.serviceDetail != null && widget.data.serviceDetail!.isAdvancePayment && !widget.data.serviceDetail!.isFreeService && widget.data.serviceDetail!.isFixedService) {
      request.putIfAbsent(CommonKeys.status, () => BookingStatusKeys.waitingAdvancedPayment);
    }

    appStore.setLoading(true);

    saveBooking(request).then((bookingDetailResponse) async {
      appStore.setLoading(false);

      if (widget.data.serviceDetail != null && widget.data.serviceDetail!.isAdvancePayment && !widget.data.serviceDetail!.isFreeService && widget.data.serviceDetail!.isFixedService) {
        finish(context);
        PaymentScreen(bookings: bookingDetailResponse, isForAdvancePayment: true).launch(context);
      } else {
        finish(context);
        showInDialog(
          context,
          barrierDismissible: false,
          builder: (BuildContext context) => BookingConfirmationDialog(
            data: widget.data,
            bookingId: bookingDetailResponse.bookingDetail!.id,
            bookingPrice: widget.bookingPrice,
            selectedPackage: widget.selectedPackage,
            bookingDetailResponse: bookingDetailResponse,
          ),
          backgroundColor: transparentColor,
          contentPadding: EdgeInsets.zero,
        );
      }
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(language.lblConfirmBooking, style: boldTextStyle(size: 16)),
                GestureDetector(
                  onTap: () {
                    finish(context);
                  },
                  child: Image.asset(
                    Assets.iconsIcClose,
                    height: 20.0,
                    color: context.iconColor,
                  ),
                ),
              ],
            ),
            Divider(),
            10.height,
            Text(language.wouldYouLikeTo, textAlign: TextAlign.left, style: secondaryTextStyle(size: 14, color: appTextSecondaryColor, weight: FontWeight.w600)),
            16.height,
            Container(
              padding: EdgeInsets.all(14),
              decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(8), backgroundColor: appStore.isDarkMode ? context.dividerColor : dashboard3CardColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  serviceDetailsWidget("${language.serviceName}:", widget.data.serviceDetail?.name.validate() ?? "", false).visible(widget.selectedPackage == null),
                  serviceDetailsWidget("${language.packageName}:", widget.selectedPackage?.name.validate() ?? "", false).visible(widget.selectedPackage != null),
                  serviceDetailsWidget("${language.lblDateAndTime}",widget.data.serviceDetail!.isSlotAvailable?getConfirmBookingDateFormat(date: "${widget.data.serviceDetail!.bookingDate} ${widget.data.serviceDetail!.bookingSlot}"): getConfirmBookingDateFormat(date: widget.data.serviceDetail!.dateTimeVal.validate()), false),
                  serviceDetailsWidget("${language.price}:",widget.data.serviceDetail!.isFreeService? "Free" :  widget.bookingPrice.validate().toStringAsFixed(getIntAsync(PRICE_DECIMAL_POINTS)), !widget.data.serviceDetail!.isFreeService)
                ],
              ),
            ),
            16.height,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14),
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: BorderRadius.circular(8),
                backgroundColor: cancellationsBgColor,
              ),
              child: Text(
                '* ${language.a} ${appConfigurationStore.cancellationChargeAmount}% ${language.feeAppliesForCancellations} ${appConfigurationStore.cancellationChargeHours} ${language.hoursOfTheScheduled}',
                style: secondaryTextStyle(size: 10, color: redColor, fontStyle: FontStyle.italic, weight: FontWeight.w600),
              ),
            ).visible(!widget.data.serviceDetail!.isFreeService && appConfigurationStore.cancellationCharge),
            16.height,
            ExcludeSemantics(
              child: CheckboxListTile(
                checkboxShape: RoundedRectangleBorder(borderRadius: radius(4)),
                autofocus: false,
                activeColor: context.primaryColor,
                checkColor: appStore.isDarkMode ? context.iconColor : context.cardColor,
                value: isSelected,
                onChanged: (val) async {
                  isSelected = !isSelected;
                  setState(() {});
                },
                title: RichTextWidget(
                  list: [
                    TextSpan(text: '${language.byConfirmingYouAgree} ', style: secondaryTextStyle(size: 14, fontFamily: fontFamilySecondaryGlobal)),
                    TextSpan(
                      text: language.lblTermsOfService,
                      style: boldTextStyle(color: primaryColor, size: 14),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          checkIfLink(context, appConfigurationStore.termConditions, title: language.termsCondition);
                        },
                    ),
                    TextSpan(text: ' ${language.and} ', style: secondaryTextStyle()),
                    TextSpan(
                      text: language.privacyPolicy,
                      style: boldTextStyle(color: primaryColor, size: 14),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          checkIfLink(context, appConfigurationStore.privacyPolicy, title: language.privacyPolicy);
                        },
                    ),
                  ],
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            32.height,
            AppButton(
              width: context.width(),
              text: language.confirm,
              textColor: isSelected ? Colors.white : darkGray,
              color: isSelected ? context.primaryColor : context.dividerColor,
              onTap: () {
                if (isSelected) {
                  bookServices();
                } else {
                  toast(language.termsConditionsAccept);
                }
              },
            ),
            TextButton(
                onPressed: () {
                  finish(context);
                },
                child: Text(language.lblCancel, style: boldTextStyle(size: 14, color: primaryColor, decoration: TextDecoration.underline, decorationColor: primaryColor)))
          ],
        ).visible(
          !appStore.isLoading,
          defaultWidget: LoaderWidget().withSize(width: 250, height: 280),
        );
      },
    );
  }
}

Widget serviceDetailsWidget(String title, String value, bool isPrice) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: secondaryTextStyle(size: 10, color: appStore.isDarkMode ? darkGray : appTextSecondaryColor)).expand(flex: 2),
      Text(isPrice ? num.parse(value.toString()).toPriceFormat() : value, style: boldTextStyle(size: 10)).expand(flex: 3),
    ],
  ).paddingBottom(6.0);
}
