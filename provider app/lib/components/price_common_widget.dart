import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/price_widget.dart';
import 'package:handyman_provider_flutter/components/view_all_label_component.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/package_response.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/tax_list_response.dart';
import '../provider/payment/components/payment_info_component.dart';
import '../utils/colors.dart';
import 'applied_tax_list_bottom_sheet.dart';

class PriceCommonWidget extends StatelessWidget {
  final BookingData bookingDetail;
  final ServiceData serviceDetail;
  final CouponData? couponData;
  final List<TaxData> taxes;
  final PackageData? bookingPackage;

  const PriceCommonWidget({
    Key? key,
    required this.bookingDetail,
    required this.serviceDetail,
    required this.taxes,
    required this.couponData,
    required this.bookingPackage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //price details
        ViewAllLabel(
          label: languages.lblPriceDetail,
          list: [],
        ),

        if (bookingPackage != null)
          Container(
            padding: EdgeInsets.all(16),
            width: context.width(),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(languages.hintPrice, style: secondaryTextStyle(size: 14)).expand(),
                    PriceWidget(price: bookingPackage!.price.validate(), color: textPrimaryColorGlobal, isBoldText: true, size: 16).flexible(),
                  ],
                ),
                if (bookingDetail.totalExtraChargeAmount != 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.height,
                      Row(
                        children: [
                          Text(languages.lblTotalCharges, style: secondaryTextStyle(size: 14)).expand(),
                          PriceWidget(price: bookingDetail.totalExtraChargeAmount, color: textPrimaryColorGlobal),
                        ],
                      ),
                    ],
                  ),
                if (bookingDetail.finalTotalTax.validate() != 0)
                  Column(
                    children: [
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(languages.lblTax, style: secondaryTextStyle(size: 14)),
                          16.width,
                          PriceWidget(price: bookingDetail.finalTotalTax.validate(), color: Colors.red, isBoldText: true),
                        ],
                      ),
                    ],
                  ),
                Column(
                  children: [
                    16.height,
                    Divider(height: 8, color: context.dividerColor),
                    8.height,
                    Row(
                      children: [
                        Text(languages.lblTotalAmount, style: secondaryTextStyle(size: 14)).expand(),
                        PriceWidget(
                          price: bookingDetail.totalAmount.validate(),
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        else
          Container(
            padding: EdgeInsets.all(16),
            width: context.width(),
            decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
            child: Column(
              children: [
                if (bookingDetail.bookingType.validate() == BOOKING_TYPE_SERVICE || bookingDetail.bookingType.validate() == BOOKING_TYPE_USER_POST_JOB)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(languages.hintPrice, style: secondaryTextStyle(size: 14)).expand(),
                          16.width,
                          if (bookingDetail.isFixedService)
                            Marquee(
                              child: Row(
                                children: [
                                  PriceWidget(
                                    price: bookingDetail.amount.validate(),
                                    size: 12,
                                    isBoldText: false,
                                    color: appTextSecondaryColor,
                                  ),
                                  Text(' * ${bookingDetail.quantity != 0 ? bookingDetail.quantity : 1}  = ', style: secondaryTextStyle()),
                                  PriceWidget(
                                    price: (bookingDetail.bookingType.validate() == BOOKING_TYPE_USER_POST_JOB)
                                        ? bookingDetail.amount.validate()
                                        : bookingDetail.finalTotalServicePrice.validate(),
                                    isBoldText: true,
                                    color: textPrimaryColorGlobal,
                                  ),
                                ],
                              ),
                            )
                          else
                            PriceWidget(price: bookingDetail.finalTotalServicePrice.validate(), color: textPrimaryColorGlobal, isBoldText: true),
                        ],
                      ),
                      16.height,
                    ],
                  ),
                if (bookingDetail.finalDiscountAmount != 0 && bookingDetail.bookingType.validate() == BOOKING_TYPE_SERVICE)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: languages.hintDiscount, style: secondaryTextStyle(size: 14)),
                                TextSpan(
                                  text: " (${bookingDetail.discount.validate()}% ${languages.lblOff.toLowerCase()}) ",
                                  style: boldTextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ).expand(),
                          16.width,
                          PriceWidget(
                            price: bookingDetail.finalDiscountAmount.validate(),
                            color: Colors.green,
                            isBoldText: true,
                            isDiscountedPrice: true,
                          ),
                        ],
                      ),
                      16.height,
                    ],
                  ),
                if (couponData != null)
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(languages.lblCoupon, style: secondaryTextStyle(size: 14)),
                          Text(" (${couponData!.code})", style: boldTextStyle(size: 14, color: primaryColor)).expand(),
                          PriceWidget(price: bookingDetail.finalCouponDiscountAmount.validate(), color: Colors.green, isBoldText: true, isDiscountedPrice: true),
                        ],
                      ),
                      16.height,
                    ],
                  ),

                /// Show Service Add-On Price
                if (bookingDetail.serviceaddon.validate().isNotEmpty)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(languages.serviceAddOns, style: secondaryTextStyle(size: 14)).flexible(fit: FlexFit.loose),
                          16.width,
                          PriceWidget(price: bookingDetail.serviceaddon.validate().sumByDouble((p0) => p0.price), color: textPrimaryColorGlobal)
                        ],
                      ),
                      16.height,
                    ],
                  ),

                if ((bookingDetail.isHourlyService || bookingDetail.isFixedService))
                  if (bookingDetail.totalExtraChargeAmount != 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(languages.lblTotalCharges, style: secondaryTextStyle(size: 14)).expand(),
                            PriceWidget(price: bookingDetail.totalExtraChargeAmount, color: textPrimaryColorGlobal),
                          ],
                        ),
                        16.height,
                      ],
                    ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(languages.lblSubTotal, style: secondaryTextStyle(size: 14)).flexible(fit: FlexFit.loose),
                        PriceWidget(
                          price: (bookingDetail.finalSubTotal == null && bookingDetail.bookingType.validate() == BOOKING_TYPE_USER_POST_JOB)
                              ? bookingDetail.amount.validate()
                              : bookingDetail.finalSubTotal.validate(),
                          color: textPrimaryColorGlobal,
                          isBoldText: true,
                        ),
                      ],
                    ),
                  ],
                ),

                if (bookingDetail.finalTotalTax.validate() != 0 && bookingDetail.bookingType.validate() == BOOKING_TYPE_SERVICE)
                  Column(
                    children: [
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(languages.lblTax, style: secondaryTextStyle(size: 14)).expand(),
                              Icon(Icons.info_outline_rounded, size: 20, color: context.primaryColor).onTap(
                                () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (_) {
                                      return AppliedTaxListBottomSheet(taxes: bookingDetail.taxes.validate(), subTotal: bookingDetail.finalSubTotal.validate());
                                    },
                                  );
                                },
                              ),
                            ],
                          ).expand(),
                          16.width,
                          PriceWidget(price: bookingDetail.finalTotalTax.validate(), color: Colors.red, isBoldText: true),
                        ],
                      ),
                    ],
                  ),

                /// Advance Payment
                if (serviceDetail.isAdvancePayment && serviceDetail.isFixedService && !serviceDetail.isFreeService)
                  Column(
                    children: [
                      16.height,
                      Row(
                        children: [
                          Text.rich(
                            TextSpan(children: [
                              TextSpan(text: bookingDetail.paidAmount.validate() != 0 ? languages.advancePaid : languages.advancePayment, style: secondaryTextStyle(size: 14)),
                              TextSpan(
                                text: " (${serviceDetail.advancePaymentPercentage.validate().toString()}%)  ",
                                style: boldTextStyle(color: Colors.green),
                              ),
                            ]),
                          ).expand(),
                          PriceWidget(price: getAdvancePaymentAmount, color: primaryColor),
                        ],
                      ),
                    ],
                  ),
                if (serviceDetail.isAdvancePayment && bookingDetail.paidAmount.validate() != 0 && serviceDetail.isFixedService && !serviceDetail.isFreeService && bookingDetail.status.validate().toLowerCase() != BOOKING_STATUS_CANCELLED)
                  Column(
                    children: [
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextIcon(
                            text: '${languages.remainingAmount}',
                            textStyle: secondaryTextStyle(size: 14),
                            edgeInsets: EdgeInsets.zero,
                            suffix: bookingDetail.status == BookingStatusKeys.complete && bookingDetail.paymentStatus == SERVICE_PAYMENT_STATUS_PAID ? Offstage() : Icon(Icons.info_outline_rounded, size: 20, color: context.primaryColor),
                            expandedText: true,
                            maxLine: 3,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (_) {
                                  return PaymentInfoComponent(bookingDetail.id!);
                                },
                              );
                            },
                          ).expand(),
                          8.width,
                          bookingDetail.status == BookingStatusKeys.complete && bookingDetail.paymentStatus == SERVICE_PAYMENT_STATUS_PAID
                              ? bookingDetail.status == BookingStatusKeys.complete && bookingDetail.paymentStatus == SERVICE_PAYMENT_STATUS_PAID
                                  ? Center(
                                      child: Text(
                                        languages.paid,
                                        style: boldTextStyle(color: greenColor),
                                      ),
                                    )
                                  : Offstage()
                              : PriceWidget(price: getRemainingAmount, color: primaryColor),
                        ],
                      ),
                    ],
                  ),

                /// Final Amount
                16.height,
                Divider(height: 8, color: context.dividerColor),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextIcon(
                      text: '${languages.lblTotalAmount}',
                      textStyle: boldTextStyle(),
                      edgeInsets: EdgeInsets.zero,
                      expandedText: true,
                      maxLine: 2,
                    ).expand(flex: 2),
                    Marquee(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          16.width,
                          if (bookingDetail.isHourlyService)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('(', style: secondaryTextStyle()),
                                PriceWidget(price: bookingDetail.amount.validate(), color: appTextSecondaryColor, size: 14, isBoldText: false),
                                Text('/${languages.lblHr})', style: secondaryTextStyle()),
                              ],
                            ),
                          8.width,
                          PriceWidget(price: bookingDetail.totalAmount.validate(), color: primaryColor)
                        ],
                      ),
                    ).flexible(flex: 3),
                  ],
                ),

                /// Hourly completed service
                if (bookingDetail.isHourlyService && bookingDetail.status == BookingStatusKeys.complete)
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        16.height,
                        Text(
                          "${languages.lblOnBasisOf} ${calculateTimer(bookingDetail.durationDiff.validate().toInt())} ${getMinHour(durationDiff: bookingDetail.durationDiff.validate())}",
                          style: secondaryTextStyle(),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )
      ],
    );
  }

  num get getAdvancePaymentAmount {
    if (bookingDetail.paidAmount.validate() != 0) {
      return bookingDetail.paidAmount!;
    } else {
      return bookingDetail.totalAmount.validate() * serviceDetail.advancePaymentPercentage.validate() / 100;
    }
  }

  num get getRemainingAmount {
    return bookingDetail.totalAmount.validate() - getAdvancePaymentAmount;
  }

  String getMinHour({required String durationDiff}) {
    String totalTime = calculateTimer(durationDiff.toInt());
    List<String> totalHours = totalTime.split(":");
    if (totalHours.first == "00") {
      return languages.min;
    } else {
      return languages.hour;
    }
  }
}
