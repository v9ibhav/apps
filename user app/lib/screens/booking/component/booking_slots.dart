import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/booking_data_model.dart';
import 'package:booking_system_flutter/model/service_detail_response.dart';
import 'package:booking_system_flutter/model/slot_data.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/booking/component/available_slots_component.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/extensions/int_extension.dart';
import 'package:booking_system_flutter/utils/model_keys.dart';
import 'package:booking_system_flutter/utils/widgets/horizontal_calender/date_item.dart';
import 'package:booking_system_flutter/utils/widgets/horizontal_calender/date_picker_controller.dart';
import 'package:booking_system_flutter/utils/widgets/horizontal_calender/horizontal_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingSlotsComponent extends StatefulWidget {
  final ServiceDetailResponse? data;
  final BookingData? bookingData;
  final bool showAppbar;
  final ScrollController scrollController;
  final VoidCallback? onApplyClick;

  BookingSlotsComponent({this.data, this.showAppbar = false, this.bookingData, required this.scrollController, this.onApplyClick});

  @override
  _BookingSlotsComponentState createState() => _BookingSlotsComponentState();
}

class _BookingSlotsComponentState extends State<BookingSlotsComponent> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<SlotData> slotsList = [];

  DatePickerController _datePickerController = DatePickerController();

  DateTime selectedHorizontalDate = DateTime.now();

  bool isSlotSelected = false;
  bool isTodaySlotSelected = false;
  bool isUpdate = false;

  UniqueKey keyForTimeSlotWidget = UniqueKey();

  String? selectedDate;

  String? selectedSlot;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    slotsList = widget.data!.serviceDetail!.bookingSlots.validate();
    isUpdate = widget.bookingData != null;

    if (widget.data!.serviceDetail!.bookingDate != null) {
      selectedHorizontalDate = DateTime.parse(widget.data!.serviceDetail!.bookingDate.validate().toString());
    }

    selectedSlot = widget.data!.serviceDetail!.bookingSlot.validate().isNotEmpty
        ? widget.data!.serviceDetail!.bookingSlot.validate()
        : isUpdate
            ? widget.data!.serviceDetail!.bookingSlot.validate()
            : null;

    if (isUpdate) {
      selectedHorizontalDate = DateTime.parse(widget.bookingData!.date.validate().toString());

      SlotData tempSlot = slotsList.firstWhere((element) => element.day.validate().toLowerCase() == selectedHorizontalDate.weekday.weekDayName.validate().toLowerCase());

      if (!tempSlot.slot.validate().contains(widget.bookingData!.bookingSlot.validate())) {
        slotsList
            .firstWhere((element) => element.day.validate().toLowerCase() == selectedHorizontalDate.weekday.weekDayName.validate().toLowerCase())
            .slot!
            .add(widget.bookingData!.bookingSlot.validate());
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _handleNextButtonClick() {
    if (isSlotSelected) {
      widget.data!.serviceDetail!.bookingSlot = selectedSlot;
    } else {
      widget.data!.serviceDetail!.bookingSlot = "";
    }

    if (isUpdate) {
      if (widget.data!.serviceDetail!.bookingSlot.validate() == widget.bookingData!.bookingSlot.validate()) return toast(language.pleaseSelectDifferentSlotThenPrevious);

      showConfirmDialogCustom(
        context,
        dialogType: DialogType.UPDATE,
        positiveText: language.lblUpdate,
        negativeText: language.lblCancel,
        onAccept: (p0) {
          updateDetails();
        },
      );
    } else {
      if (widget.data!.serviceDetail!.bookingSlot.validate().isNotEmpty) {
        Fluttertoast.cancel();
        widget.data!.serviceDetail!.bookingDate = formatBookingDate(selectedHorizontalDate.toString(), format: DATE_FORMAT_7);
        widget.data!.serviceDetail!.bookingDay = selectedHorizontalDate.weekday.weekDayName.toLowerCase();
        widget.data!.serviceDetail!.dateTimeVal = formatBookingDate(selectedHorizontalDate.toString(), format: DATE_FORMAT_3);
        log(selectedHorizontalDate.toString());
        finish(context, true);
        widget.onApplyClick?.call();
      } else {
        toast(language.pleaseSelectTheSlotsFirst, length: Toast.LENGTH_LONG);
      }
    }
  }

  void updateDetails() async {
    Map request = {
      CommonKeys.id: widget.bookingData!.id.validate(),
      "date": formatDate(selectedHorizontalDate.toString()),
      "booking_date": formatDate(selectedHorizontalDate.toString()),
      "booking_slot": widget.data!.serviceDetail!.bookingSlot,
      "booking_day": selectedHorizontalDate.weekday.weekDayName.toLowerCase(),
      CommonKeys.status: widget.bookingData!.status.validate(),
    };

    log(request);
    appStore.setLoading(true);
    await updateBooking(request).then((value) {
      widget.bookingData!.date = formatDate(selectedHorizontalDate.toString());
      widget.bookingData!.bookingSlot = widget.data!.serviceDetail!.bookingSlot;

      toast(language.lblDateTimeUpdated);
      LiveStream().emit(LIVESTREAM_UPDATE_BOOKING_LIST);
      finish(context);
    }).catchError((e) {
      log(e.toString());
    });

    appStore.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    List<String> temp = slotsList.validate().isNotEmpty
        ? slotsList
            .validate()
            .firstWhere((element) => element.day!.toLowerCase() == DateFormat('E', 'en_US').format(selectedHorizontalDate).toLowerCase(), orElse: () => SlotData(slot: [], day: ''))
            .slot
            .validate()
        : [];
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: context.height() * 0.04),
            decoration: boxDecorationWithRoundedCorners(borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius), backgroundColor: context.cardColor),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SingleChildScrollView(
                  controller: widget.scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.height,
                      Text(language.lblSelectDate, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                      16.height,
                      HorizontalDatePickerWidget(
                        height: 90,
                        startDate: DateTime.now(),
                        endDate: DateTime.now().add(Duration(days: 365)),
                        selectedDate: selectedHorizontalDate,
                        widgetWidth: context.width(),
                        locale: appStore.selectedLanguageCode,
                        selectedColor: primaryColor,
                        dateItemComponentList: [DateItem.Month, DateItem.Day, DateItem.WeekDay],
                        dayFontSize: 20,
                        weekDayFontSize: 16,
                        datePickerController: _datePickerController,
                        onValueSelected: (date) {
                            setState(() {
                              selectedHorizontalDate = date;
                              widget.data!.serviceDetail!.bookingSlot = widget.data!.serviceDetail!.bookingSlot.validate().isNotEmpty
                                  ? widget.data!.serviceDetail!.bookingSlot.validate()
                                  : isUpdate
                                      ? widget.data!.serviceDetail!.bookingSlot.validate()
                                      : null;
                              selectedSlot = null;
                              isSlotSelected = false;
                              keyForTimeSlotWidget = UniqueKey();
                            });
                        },
                      ),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(language.use24HourFormat, style: secondaryTextStyle(size: 14)),
                          16.width,
                          Observer(builder: (context) {
                            return Transform.scale(
                              scale: 0.8,
                              child: Switch.adaptive(
                                value: appStore.is24HourFormat,
                                onChanged: (value) {
                                  appStore.set24HourFormat(value);
                                },
                              ),
                            );
                          })
                        ],
                      ),
                      16.height,
                      Text(language.availableSlots, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                      16.height,
                      temp.isNotEmpty
                          ? AvailableSlotsComponent(
                              key: keyForTimeSlotWidget,
                              selectedSlots: selectedSlot != null && selectedSlot!.isNotEmpty ? [selectedSlot.validate()] : [],
                              isProvider: false,
                              availableSlots: temp,
                              selectedDate: selectedHorizontalDate,
                              onChanged: (List<String> selectedSlots) {
                                isSlotSelected = selectedSlots.isNotEmpty;
                                if (isSlotSelected) {
                                  selectedSlot = selectedSlots.first.validate();

                                  setState(() {});
                                }
                              },
                            )
                          : appStore.isLoading
                              ? LoaderWidget()
                              : NoDataWidget(title: language.noTimeSlots),
                    ],
                  ),
                ).expand(),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButton(
                      text: language.lblCancel,
                      color: appStore.isDarkMode ? context.scaffoldBackgroundColor : white,
                      textColor: appStore.isDarkMode ? white : context.primaryColor,
                      onTap: () {
                        finish(context);
                      },
                    ).expand(),
                    16.width,
                    AppButton(
                      text: language.lblApply,
                      color: context.primaryColor,
                      textColor: white,
                      onTap: _handleNextButtonClick,
                    ).expand(),
                  ],
                ).paddingOnly(bottom: 8),
              ],
            ),
          ).expand(),
        ],
      ),
    );
  }
}