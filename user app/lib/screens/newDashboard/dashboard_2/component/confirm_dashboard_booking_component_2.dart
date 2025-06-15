import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/app_common_dialog.dart';
import '../../../../component/cached_image_widget.dart';
import '../../../../main.dart';
import '../../../../model/booking_data_model.dart';
import '../../../../model/booking_detail_model.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/model_keys.dart';
import '../../../booking/booking_detail_screen.dart';
import '../../../booking/component/reason_dialog.dart';

class ConfirmDashboardBookingComponent2 extends StatefulWidget {
  final BookingData? upcomingConfirmedBooking;

  ConfirmDashboardBookingComponent2({this.upcomingConfirmedBooking});

  @override
  _ConfirmDashboardBookingComponent2State createState() => _ConfirmDashboardBookingComponent2State();
}

class _ConfirmDashboardBookingComponent2State extends State<ConfirmDashboardBookingComponent2> {
  @override
  Widget build(BuildContext context) {
    if (widget.upcomingConfirmedBooking == null) return Offstage();

    if (getBoolAsync('$BOOKING_ID_CLOSED_${widget.upcomingConfirmedBooking!.id}')) {
      return Offstage();
    }

    if (widget.upcomingConfirmedBooking!.status != BOOKING_STATUS_PENDING && widget.upcomingConfirmedBooking!.status != BOOKING_STATUS_ACCEPT) {
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
                backgroundColor: appStore.isDarkMode ? context.primaryColor.withValues(alpha:0.1) : white,
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
                                  widget.upcomingConfirmedBooking!.serviceName.validate(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: boldTextStyle(),
                                ),
                                8.height,
                                Text(
                                  formatDate(widget.upcomingConfirmedBooking!.date.validate(), showDateWithTime: true),
                                  style: secondaryTextStyle(color: appStore.isDarkMode ? textPrimaryColorGlobal : null),
                                ),
                              ],
                            ).expand(),
                            16.width,
                            if (widget.upcomingConfirmedBooking!.isPackageBooking)
                              CachedImageWidget(
                                url: widget.upcomingConfirmedBooking!.bookingPackage!.imageAttachments.validate().isNotEmpty ? widget.upcomingConfirmedBooking!.bookingPackage!.imageAttachments.validate().first.validate() : "",
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                                circle: true,
                                placeHolderImage: '',
                              )
                            else
                              CachedImageWidget(
                                url: widget.upcomingConfirmedBooking!.serviceAttachments.validate().isNotEmpty ? widget.upcomingConfirmedBooking!.serviceAttachments!.first.validate() : '',
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${language.bookingStatus}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: primaryTextStyle(size: 10),
                                ),
                                10.height,
                                Text(
                                  widget.upcomingConfirmedBooking!.status.validate().toBookingStatus(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: boldTextStyle(
                                    color: widget.upcomingConfirmedBooking!.status.validate().getPaymentStatusBackgroundColor,
                                    size: 12,
                                  ),
                                ),
                              ],
                            ).expand(),
                            16.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  language.paymentStatus,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: primaryTextStyle(size: 10),
                                ),
                                10.height,
                                Text(
                                  buildPaymentStatusWithMethod(
                                    widget.upcomingConfirmedBooking!.paymentStatus.validate(),
                                    widget.upcomingConfirmedBooking!.paymentMethod.validate(),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: boldTextStyle(
                                    size: 12,
                                    color: widget.upcomingConfirmedBooking!.paymentStatus == SERVICE_PAYMENT_STATUS_ADVANCE_PAID ||
                                            (widget.upcomingConfirmedBooking!.paymentStatus == SERVICE_PAYMENT_STATUS_PAID || widget.upcomingConfirmedBooking!.paymentStatus == PENDING_BY_ADMIN)
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ).expand(),
                          ],
                        ),
                      ).paddingSymmetric(horizontal: 16),
                      16.height,
                    ],
                  ).onTap(() {
                    BookingDetailScreen(bookingId: widget.upcomingConfirmedBooking!.id!).launch(context);
                  }),
                  if (widget.upcomingConfirmedBooking!.status == BookingStatusKeys.pending || widget.upcomingConfirmedBooking!.status == BookingStatusKeys.accept)
                    checkTimeDifference(inputDateTime: DateTime.parse(widget.upcomingConfirmedBooking!.date.validate()))
                        ? AppButton(
                            width: context.width(),
                            onTap: () {
                              _handleCancelClick(bookingData: widget.upcomingConfirmedBooking!);
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
                await setValue('$BOOKING_ID_CLOSED_${widget.upcomingConfirmedBooking!.id}', true);
                setState(() {});
              }),
            )
          ],
        )
      ],
    );
  }

  //region Cancel
  void _handleCancelClick({required BookingData bookingData}) {
    if (bookingData.status == BookingStatusKeys.pending || bookingData.status == BookingStatusKeys.accept || bookingData.status == BookingStatusKeys.hold) {
      showInDialog(
        context,
        contentPadding: EdgeInsets.zero,
        builder: (context) {
          return AppCommonDialog(
            title: language.lblCancelReason,
            child: ReasonDialog(
              status: BookingDetailResponse(bookingDetail: widget.upcomingConfirmedBooking!),
            ),
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
}
