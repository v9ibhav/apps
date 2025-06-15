import 'package:booking_system_flutter/app_theme.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/booking_data_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/model_keys.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class EditBookingServiceDialog extends StatefulWidget {
  final BookingData data;

  EditBookingServiceDialog({required this.data});

  @override
  State<EditBookingServiceDialog> createState() => _EditBookingServiceDialogState();
}

class _EditBookingServiceDialogState extends State<EditBookingServiceDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController dateTimeCont = TextEditingController();
  TextEditingController prevDateTimeCont = TextEditingController();

  DateTime? selectedDate;
  DateTime? finalDate;
  DateTime? packageExpiryDate;
  TimeOfDay? pickedTime;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.data.date != null) {
      dateTimeCont.text = formatBookingDate(widget.data.date.validate(), format: DATE_FORMAT_1);
      prevDateTimeCont.text = formatBookingDate(widget.data.date.validate(), format: DATE_FORMAT_1);
      selectedDate = DateTime.parse(widget.data.date.validate());
      pickedTime = TimeOfDay.fromDateTime(selectedDate!);

      if (widget.data.bookingPackage != null && widget.data.bookingPackage!.endDate.validate().isNotEmpty) {
        packageExpiryDate = DateTime.parse(widget.data.bookingPackage!.endDate.validate());
      }
    }
  }

  void selectDateAndTime(BuildContext context) async {
    if (packageExpiryDate != null && DateTime.now().isAfter(packageExpiryDate!)) {
      return toast(language.packageIsExpired);
    }

    await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: packageExpiryDate ?? DateTime(3000),
      locale: Locale(appStore.selectedLanguageCode),
      builder: (_, child) {
        return Theme(
          data: appStore.isDarkMode ? ThemeData.dark() : AppTheme.lightTheme(),
          child: child!,
        );
      },
    ).then((date) async {
      if (date != null) {
        await showTimePicker(
          context: context,
          initialTime: pickedTime ?? TimeOfDay.now(),
          builder: (_, child) {
            return Theme(
              data: appStore.isDarkMode ? ThemeData.dark() : AppTheme.lightTheme(),
              child: child!,
            );
          },
        ).then((time) {
          if (time != null) {
            selectedDate = date;
            pickedTime = time;

            dateTimeCont.text = "${formatDate(selectedDate.toString())} ${pickedTime!.format(context).toString()}";
          }
        }).catchError((e) {
          toast(e.toString());
        });
      }
    });
  }

  void _handleSubmitClick() async {
    if (prevDateTimeCont.text == dateTimeCont.text) {
      finish(context);
    } else if (dateTimeCont.text.isEmpty) {
      toast(language.lblSelectDate);
    } else {
      appStore.setLoading(true);
      finalDate = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, pickedTime!.hour, pickedTime!.minute);
      Map request = {
        CommonKeys.id: widget.data.id.validate(),
        CommonKeys.date: finalDate.toString(),
        CommonKeys.status: widget.data.status.validate(),
        BookingUpdateKeys.paymentStatus: widget.data.isAdvancePaymentDone ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : widget.data.paymentStatus.validate(),
      };

      log(request);

      await updateBooking(request).then((value) {
        widget.data.date = finalDate.toString();
        toast(language.lblDateTimeUpdated);
        finish(context);
      }).catchError((e) {
        log(e.toString());
      });

      appStore.setLoading(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('#${widget.data.id.validate()}', style: boldTextStyle(color: primaryColor)),
                  16.width,
                  Text('${widget.data.serviceName.validate()}', style: boldTextStyle()).flexible(),
                ],
              ),
              16.height,
              Container(
                decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${language.lblDateAndTime} ', style: secondaryTextStyle()),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.OTHER,
                      controller: dateTimeCont,
                      isValidationRequired: true,
                      validator: (value) {
                        if (value!.isEmpty) return language.requiredText;
                        return null;
                      },
                      readOnly: true,
                      onTap: () {
                        selectDateAndTime(context);
                      },
                      decoration: inputDecoration(context, prefixIcon: ic_calendar.iconImage(size: 10).paddingAll(14)).copyWith(
                        fillColor: context.cardColor,
                        filled: true,
                        hintText: language.chooseDateAndTime,
                        hintStyle: secondaryTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              16.height,
              Row(
                children: [
                  AppButton(
                    onTap: () {
                      finish(context);
                    },
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                    color: context.scaffoldBackgroundColor,
                    text: language.lblCancel,
                    textColor: context.iconColor,
                  ).expand(),
                  16.width,
                  AppButton(
                    onTap: _handleSubmitClick,
                    color: primaryColor,
                    text: language.confirm,
                  ).expand(),
                ],
              )
            ],
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
