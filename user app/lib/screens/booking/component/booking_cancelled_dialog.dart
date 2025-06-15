import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/booking_detail_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/images.dart';

class BookingCancelledDialog extends StatefulWidget {
  final BookingDetailResponse status;
  final String? currentStatus;

  BookingCancelledDialog({required this.status, this.currentStatus});

  @override
  State<BookingCancelledDialog> createState() => _BookingCancelledDialogState();
}

class _BookingCancelledDialogState extends State<BookingCancelledDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController _textFieldReason = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: context.width(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    16.height,
                    Image.asset(ic_cancel_booking, height: 62),
                    32.height,
                    Text(language.bookingCancelled, style: boldTextStyle(size: 16)),
                    8.height,
                    Text(language.yourBookingHasBeen, textAlign: TextAlign.center, style: primaryTextStyle(size: 12, color: appTextSecondaryColor)),
                    32.height,
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: boxDecorationDefault(color: appStore.isDarkMode? context.dividerColor :primaryLightColor, borderRadius: BorderRadius.circular(4)),
                      child: Text(language.noteCheckYourBooking, style: boldTextStyle(size: 12,color:appStore.isDarkMode?white: primaryColor,fontStyle: FontStyle.italic)),
                    ),
                    24.height,
                    AppButton(
                      color: primaryColor,
                      height: 40,
                      text: language.lblOk,
                      textStyle: boldTextStyle(color: Colors.white,weight: FontWeight.w600, size: 12),
                      width: context.width() - context.navigationBarHeight,
                      onTap: () {
                        finish(context,true);
                      },
                    ),
                    8.height,
                  ],
                ).paddingAll(16)
              ],
            ),
          ),
        ),
        Observer(
          builder: (context) => LoaderWidget().withSize(height: 80, width: 80).visible(appStore.isLoading),
        )
      ],
    );
  }

  void saveCancelClick() async {
    Map request = {
      CommonKeys.id: widget.status.bookingDetail!.id.validate(),
      BookingUpdateKeys.startAt: widget.status.bookingDetail!.date.validate(),
      BookingUpdateKeys.endAt: formatBookingDate(DateTime.now().toString(), format: BOOKING_SAVE_FORMAT, isLanguageNeeded: false),
      BookingUpdateKeys.durationDiff: widget.status.bookingDetail!.durationDiff.validate(),
      BookingUpdateKeys.reason: _textFieldReason.text,
      CommonKeys.status: BookingStatusKeys.cancelled,
      CommonKeys.advancePaidAmount: widget.status.bookingDetail!.paidAmount,
      BookingUpdateKeys.paymentStatus: widget.status.bookingDetail!.isAdvancePaymentDone ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : widget.status.bookingDetail!.paymentStatus.validate(),
    };

    appStore.setLoading(true);

    await updateBooking(request).then((res) async {
      toast(res.message!);
      finish(context, true);
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    appStore.setLoading(false);
  }
}
