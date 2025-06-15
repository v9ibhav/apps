import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/booking_detail_model.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/app_common_dialog.dart';
import '../../../../model/booking_data_model.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/model_keys.dart';
import '../../../booking/booking_detail_screen.dart';
import '../../../booking/component/reason_dialog.dart';

class UpcomingBookingDashboardComponent3 extends StatefulWidget {
  final BookingData? upcomingBookingData;

  UpcomingBookingDashboardComponent3({this.upcomingBookingData});

  @override
  _UpcomingBookingDashboardComponent3State createState() => _UpcomingBookingDashboardComponent3State();
}

class _UpcomingBookingDashboardComponent3State extends State<UpcomingBookingDashboardComponent3> {
  //region Cancel
  void _handleCancelClick({required BookingData bookingData}) {
    if (bookingData.status == BookingStatusKeys.pending || bookingData.status == BookingStatusKeys.accept || bookingData.status == BookingStatusKeys.hold) {
      showInDialog(
        context,
        contentPadding: EdgeInsets.zero,
        builder: (context) {
          return AppCommonDialog(
            title: language.lblCancelReason,
            child: ReasonDialog(status: BookingDetailResponse(bookingDetail: bookingData)),
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
    if (widget.upcomingBookingData == null) return Offstage();

    if (getBoolAsync('$BOOKING_ID_CLOSED_${widget.upcomingBookingData!.id}')) {
      return Offstage();
    }

    if (widget.upcomingBookingData!.status != BOOKING_STATUS_PENDING && widget.upcomingBookingData!.status != BOOKING_STATUS_ACCEPT) {
      return Offstage();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        26.height,
        Text(language.upcomingBooking, style: boldTextStyle()).paddingSymmetric(horizontal: 16),
        16.height,
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: boxDecorationRoundedWithShadow(
                defaultRadius.toInt(),
                backgroundColor: appStore.isDarkMode ? context.primaryColor.withValues(alpha:0.1) : primaryLightColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.upcomingBookingData!.serviceName.validate(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: boldTextStyle(),
                                ),
                                8.height,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(language.lblDate.suffixText(value: ': '), style: secondaryTextStyle()),
                                        Text(formatDate(widget.upcomingBookingData!.date), style: primaryTextStyle(size: 12)),
                                      ],
                                    ),
                                    8.width,
                                    Row(
                                      children: [
                                        Text(language.lblTime.suffixText(value: ': '), style: secondaryTextStyle()),
                                        Text(formatDate(widget.upcomingBookingData!.date, isTime: true), style: primaryTextStyle(size: 12)),
                                      ],
                                    ),
                                  ],
                                ).fit(),
                              ],
                            ).expand(),
                            16.width,
                            if (widget.upcomingBookingData!.isPackageBooking)
                              CachedImageWidget(
                                url: widget.upcomingBookingData!.bookingPackage!.imageAttachments.validate().isNotEmpty ? widget.upcomingBookingData!.bookingPackage!.imageAttachments.validate().first.validate() : "",
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                                circle: true,
                                placeHolderImage: '',
                              )
                            else
                              CachedImageWidget(
                                url: widget.upcomingBookingData!.serviceAttachments.validate().isNotEmpty ? widget.upcomingBookingData!.serviceAttachments!.first.validate() : '',
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                                circle: true,
                                placeHolderImage: '',
                              ),
                            4.width,
                          ],
                        ),
                      ),
                      Container(
                        decoration: boxDecorationDefault(
                          color: context.cardColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(defaultRadius),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ic_calendar.iconImage(color: context.iconColor, size: 16),
                                    8.width,
                                    Text(
                                      '${language.bookingStatus}: ',
                                      style: primaryTextStyle(size: 12),
                                    ),
                                  ],
                                ),
                                16.height,
                                Row(
                                  children: [
                                    ic_un_fill_wallet.iconImage(color: context.iconColor, size: 16),
                                    8.width,
                                    Text(
                                      '${language.paymentStatus}: ',
                                      style: primaryTextStyle(size: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            16.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.upcomingBookingData!.status.validate().toBookingStatus(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: boldTextStyle(
                                    color: widget.upcomingBookingData!.status.validate().getPaymentStatusBackgroundColor,
                                    size: 12,
                                  ),
                                ),
                                16.height,
                                Text(
                                  buildPaymentStatusWithMethod(
                                    widget.upcomingBookingData!.paymentStatus.validate(),
                                    widget.upcomingBookingData!.paymentMethod.validate(),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: boldTextStyle(
                                    color: widget.upcomingBookingData!.paymentStatus == SERVICE_PAYMENT_STATUS_ADVANCE_PAID ||
                                            (widget.upcomingBookingData!.paymentStatus == SERVICE_PAYMENT_STATUS_PAID || widget.upcomingBookingData!.paymentStatus == PENDING_BY_ADMIN)
                                        ? Colors.green
                                        : Colors.red,
                                    size: 12,
                                  ),
                                )
                              ],
                            ).expand(),
                          ],
                        ),
                      ).paddingSymmetric(horizontal: 16),
                      16.height,
                    ],
                  ).onTap(() {
                    BookingDetailScreen(bookingId: widget.upcomingBookingData!.id!).launch(context).then((value) {
                      setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.dark);
                    });
                  }),
                  if (widget.upcomingBookingData!.status == BookingStatusKeys.pending || widget.upcomingBookingData!.status == BookingStatusKeys.accept)
                    checkTimeDifference(inputDateTime: DateTime.parse(widget.upcomingBookingData!.date.validate()))
                        ? AppButton(
                            width: context.width(),
                            onTap: () {
                              _handleCancelClick(bookingData: widget.upcomingBookingData!);
                            },
                            color: primaryColor,
                            textColor: Colors.white,
                            text: language.lblCancel,
                          ).paddingAll(16)
                        : Offstage()
                ],
              ),
            ).paddingSymmetric(horizontal: 16),
            Positioned(
              top: -8,
              right: 8,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(6),
                  color: primaryColor,
                ),
                child: Icon(Icons.close, color: white, size: 12),
              ).onTap(() async {
                await setValue('$BOOKING_ID_CLOSED_${widget.upcomingBookingData!.id}', true);
                setState(() {});
              }),
            ),
          ],
        ).center()
      ],
    );
  }
}
