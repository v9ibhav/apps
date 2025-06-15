import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/booking_data_model.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/app_common_dialog.dart';
import '../../../../model/booking_detail_model.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/model_keys.dart';
import '../../../booking/booking_detail_screen.dart';
import '../../../booking/component/reason_dialog.dart';

class UpComingBookingDashboardComponent4 extends StatefulWidget {
  final BookingData? upComingBookingData;

  UpComingBookingDashboardComponent4({this.upComingBookingData});

  @override
  _UpComingBookingDashboardComponent4State createState() => _UpComingBookingDashboardComponent4State();
}

class _UpComingBookingDashboardComponent4State extends State<UpComingBookingDashboardComponent4> {
  //region Cancel
  void _handleCancelClick({required BookingData bookingData}) {
    if (bookingData.status == BookingStatusKeys.pending || bookingData.status == BookingStatusKeys.accept || bookingData.status == BookingStatusKeys.hold) {
      showInDialog(
        context,
        contentPadding: EdgeInsets.zero,
        builder: (context) {
          return AppCommonDialog(
            title: language.lblCancelReason,
            child: ReasonDialog(status: BookingDetailResponse(bookingDetail: widget.upComingBookingData!)),
          );
        },
      ).then((value) {
        if (value != null) {
          setState(() {});
          LiveStream().emit(LIVESTREAM_UPDATE_DASHBOARD);
        }
      });
    }
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    if (widget.upComingBookingData == null) return Offstage();

    if (getBoolAsync('$BOOKING_ID_CLOSED_${widget.upComingBookingData!.id}')) {
      return Offstage();
    }

    if (widget.upComingBookingData!.status != BOOKING_STATUS_PENDING && widget.upComingBookingData!.status != BOOKING_STATUS_ACCEPT) {
      return Offstage();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        24.height,
        Text(language.upcomingBooking, style: boldTextStyle()).paddingSymmetric(horizontal: 16),
        16.height,
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 16),
          decoration: boxDecorationRoundedWithShadow(
            defaultRadius.toInt(),
            backgroundColor: appStore.isDarkMode ? context.primaryColor.withValues(alpha:0.1) : white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      if (widget.upComingBookingData!.isPackageBooking)
                        CachedImageWidget(
                          url: widget.upComingBookingData!.bookingPackage!.imageAttachments.validate().isNotEmpty ? widget.upComingBookingData!.bookingPackage!.imageAttachments.validate().first.validate() : "",
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          circle: true,
                          placeHolderImage: '',
                        )
                      else
                        CachedImageWidget(
                          url: widget.upComingBookingData!.serviceAttachments.validate().isNotEmpty ? widget.upComingBookingData!.serviceAttachments!.first.validate() : '',
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          circle: true,
                          placeHolderImage: '',
                        ),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Marquee(
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        ic_calendar.iconImage(size: 14),
                                        4.width,
                                        Text(
                                          formatDate(widget.upComingBookingData!.date.validate()),
                                          style: secondaryTextStyle(color: appStore.isDarkMode ? textPrimaryColorGlobal : null),
                                        ),
                                      ],
                                    ),
                                    8.width,
                                    Row(
                                      children: [
                                        ic_clock.iconImage(size: 14),
                                        4.width,
                                        Text(
                                          formatDate(widget.upComingBookingData!.date.validate(), isTime: true),
                                          style: secondaryTextStyle(color: appStore.isDarkMode ? textPrimaryColorGlobal : null),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ).expand(),
                              6.width,
                              SizedBox(
                                height: 22,
                                width: 22,
                                child: IconButton(
                                  icon: ic_close.iconImage(),
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    await setValue('$BOOKING_ID_CLOSED_${widget.upComingBookingData!.id}', true);
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.upComingBookingData!.serviceName.validate(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: boldTextStyle(),
                          ),
                          4.height,
                        ],
                      ).expand(),
                    ],
                  ).paddingOnly(left: 16, right: 16, bottom: 16, top: 8),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            language.bookingStatus,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: primaryTextStyle(size: 12),
                          ).expand(),
                          16.width,
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              widget.upComingBookingData!.status.validate().toBookingStatus(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: boldTextStyle(
                                color: widget.upComingBookingData!.status.validate().getPaymentStatusBackgroundColor,
                                size: 12,
                              ),
                            ),
                          ).expand(),
                        ],
                      ),
                      Divider(color: context.dividerColor),
                      Row(
                        children: [
                          Text(
                            language.paymentStatus,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: primaryTextStyle(size: 12),
                          ).expand(),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              buildPaymentStatusWithMethod(
                                widget.upComingBookingData!.paymentStatus.validate(),
                                widget.upComingBookingData!.paymentMethod.validate(),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: boldTextStyle(
                                size: 12,
                                color: widget.upComingBookingData!.paymentStatus == SERVICE_PAYMENT_STATUS_ADVANCE_PAID ||
                                        (widget.upComingBookingData!.paymentStatus == SERVICE_PAYMENT_STATUS_PAID || widget.upComingBookingData!.paymentStatus == PENDING_BY_ADMIN)
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ).expand(),
                        ],
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 16),
                ],
              ).onTap(() {
                BookingDetailScreen(bookingId: widget.upComingBookingData!.id!).launch(context);
              }),
              if (widget.upComingBookingData!.status == BookingStatusKeys.pending || widget.upComingBookingData!.status == BookingStatusKeys.accept)
                checkTimeDifference(inputDateTime: DateTime.parse(widget.upComingBookingData!.date.validate()))
                    ? AppButton(
                        width: context.width(),
                        onTap: () {
                          _handleCancelClick(bookingData: widget.upComingBookingData!);
                        },
                        color: primaryColor,
                        textColor: Colors.white,
                        text: language.lblCancel,
                      ).paddingAll(16)
                    : Offstage(),
            ],
          ),
        ).paddingSymmetric(horizontal: 16),
      ],
    );
  }
}
