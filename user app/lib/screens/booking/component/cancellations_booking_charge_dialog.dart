import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/component/price_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/booking_detail_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/booking/component/booking_cancelled_dialog.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../component/chat_gpt_loder.dart';
import '../../../utils/images.dart';

class CancellationsBookingChargeDialog extends StatefulWidget {
  final BookingDetailResponse status;
  final bool isDurationMode;

  CancellationsBookingChargeDialog({required this.status, required this.isDurationMode});

  @override
  State<CancellationsBookingChargeDialog> createState() => _CancellationsBookingChargeDialogState();
}

class _CancellationsBookingChargeDialogState extends State<CancellationsBookingChargeDialog> {
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
                    Text(language.lblCancelBooking, style: boldTextStyle(size: 16)),
                    8.height,
                    Text(language.areYouSureYou, textAlign: TextAlign.center, style: primaryTextStyle(size: 12, color: appTextSecondaryColor)),
                    32.height,
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: boxDecorationDefault(color:appStore.isDarkMode? context.dividerColor: dashboard3CardColor, borderRadius: BorderRadius.circular(8)),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor, borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("${language.totalCancellationFee}:", style: boldTextStyle(size: 12)).expand(),
                            10.width,
                            PriceWidget(price: widget.status.bookingDetail!.cancellationChargeAmount!),
                          ],
                        ),
                      ),
                    ),
                    32.height,
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: boxDecorationDefault(color: appStore.isDarkMode? context.dividerColor: dashboard3CardColor, borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${language.reason}',
                                  style: boldTextStyle(size: 12, weight: FontWeight.w600),
                                ),
                                TextSpan(
                                  text: "*",
                                  style: boldTextStyle(color: redColor, size: 12, weight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          8.height,
                          Form(
                            key: formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: AppTextField(
                              controller: _textFieldReason,
                              textFieldType: TextFieldType.MULTILINE,
                              decoration: inputDecoration(context, labelText: language.enterReason, fillColor: context.scaffoldBackgroundColor),
                              enableChatGPT: appConfigurationStore.chatGPTStatus,
                              promptFieldInputDecorationChatGPT: inputDecoration(context).copyWith(
                                hintText: language.writeHere,
                                fillColor: context.primaryColor,
                                filled: true,
                              ),
                              testWithoutKeyChatGPT: appConfigurationStore.testWithoutKey,
                              loaderWidgetForChatGPT: const ChatGPTLoadingWidget(),
                              minLines: 1,
                              maxLines: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    24.height,
                    Row(
                      children: [
                        AppButton(
                          color: context.dividerColor,
                          height: 40,
                          text: language.goBack,
                          textStyle: boldTextStyle(weight: FontWeight.w600, size: 12),
                          width: context.width() - context.navigationBarHeight,
                          onTap: () {
                            finish(context);
                          },
                        ).expand(),
                        12.width,
                        AppButton(
                          color: primaryColor,
                          height: 40,
                          text: language.lblCancelBooking,
                          textStyle: boldTextStyle(color: Colors.white,weight: FontWeight.w600, size: 12),
                          width: context.width() - context.navigationBarHeight,
                          onTap: () {
                            _handleClick();
                          },
                        ).expand(),
                      ],
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
      CommonKeys.cancellationCharge: widget.status.bookingDetail!.cancellationCharges,
      CommonKeys.cancellationChargeAmount: widget.status.bookingDetail!.cancellationChargeAmount,
      BookingUpdateKeys.paymentStatus: widget.status.bookingDetail!.isAdvancePaymentDone ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : widget.status.bookingDetail!.paymentStatus.validate(),
    };

    appStore.setLoading(true);

    await updateBooking(request).then((res) async {
      finish(context,true);
      _handleBookingCancelledDialog();
    }).catchError((e) {
      toast(e.toString(), print: true);
    });
    appStore.setLoading(false);
  }

  void _handleBookingCancelledDialog() {
      showInDialog(
        context,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(horizontal: 10),
        builder: (context) {
          return BookingCancelledDialog(status: widget.status);
        },
      );
  }


  void _handleClick() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (widget.status.bookingDetail!.status == BookingStatusKeys.pending || widget.status.bookingDetail!.status == BookingStatusKeys.hold || widget.status.bookingDetail!.status == BookingStatusKeys.accept) {
        saveCancelClick();
      } 
    }
  }
}
