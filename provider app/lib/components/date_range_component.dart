// import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../utils/common.dart';
import '../../utils/configs.dart';
import '../../utils/constant.dart';
import 'date_component/custom_date_range_picker.dart';

class DateRangeComponent extends StatefulWidget {
  final String? title;
  final TextStyle? titleTextStyle;
  final TextStyle? hintTextStyle;
  final EdgeInsetsGeometry? padding;
  final bool isValidationRequired;
  final Color? fillColor;
  final bool isSuffixCloseButton;
  final bool isPreviousDateAllowed;
  final Function(String? startDate, String? endDate, String? totalDays) onApplyCallback;
  final VoidCallback? onCancelClick;

  DateRangeComponent({
    this.padding,
    this.title,
    this.hintTextStyle,
    this.titleTextStyle,
    this.isValidationRequired = true,
    this.fillColor,
    this.isSuffixCloseButton = false,
    this.isPreviousDateAllowed = false,
    required this.onApplyCallback,
    this.onCancelClick,
  });

  @override
  DateRangeComponentState createState() => DateRangeComponentState();
}

class DateRangeComponentState extends State<DateRangeComponent> {
  TextEditingController dateRangeCont = TextEditingController();

  String totalDaysCount = '';

  DateTime? startDate = DateTime.now();
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    // Initialize the date range with stored values if available
    startDate = filterStore.startDate.isNotEmpty ? parseDate(filterStore.startDate, format: DATE_FORMAT_7) : null;
    endDate = filterStore.endDate.isNotEmpty ? parseDate(filterStore.endDate, format: DATE_FORMAT_7) : null;

    // Set the text in the controller if dates are already set
    if (startDate != null && endDate != null) {
      dateRangeCont.text = '${formatBookingDate(startDate.toString(), format: DATE_FORMAT_7)} ${languages.to} ${formatBookingDate(endDate.toString(), format: DATE_FORMAT_7)}';
    } else {
      dateRangeCont.text = languages.chooseYourDateRange;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  /// Parses a date string into a DateTime object using the specified format.
  DateTime? parseDate(String dateString, {required String format}) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: AppTextField(

        title: widget.title ?? languages.dateRange,
        titleTextStyle: widget.titleTextStyle ?? boldTextStyle(size: LABEL_TEXT_SIZE),
        textStyle: widget.hintTextStyle ?? primaryTextStyle(size: 12),
        controller: dateRangeCont,
        textFieldType: TextFieldType.NAME,
        readOnly: true,
        isValidationRequired: widget.isValidationRequired,
        validator: (value) {
          if (value == null || value == languages.chooseYourDateRange) return errorThisFieldRequired;

          return null;
        },
        decoration: inputDecoration(
          context,
          hintText: languages.selectStartDateEndDate,
          fillColor: widget.fillColor ?? context.cardColor,
        ),
        suffix: widget.isSuffixCloseButton
            ? IconButton(
                onPressed: () {
                  startDate = null;
                  endDate = null;

                  dateRangeCont.text = '';

                  setState(() {});
                },
                icon: Icon(Icons.close),
              ).visible(startDate != null)
            : Offstage(),
        onTap: () {
          showCustomDateRangePicker(
            disabledDateColor: Colors.grey.withOpacity(0.5),
            context,
            dismissible: true,
            minimumDate: widget.isPreviousDateAllowed
                ? DateTime.now().subtract(const Duration(days: 30))
                : DateTime.now(), // Disable previous dates
            maximumDate:  DateTime(2100),
            startDate: startDate,
            endDate: endDate,
            backgroundColor: context.cardColor,
            primaryColor: primaryColor,
            onApplyClick: (start, end) {

              setState(() {
                startDate = start;
                endDate = end;

                if (startDate != null && endDate != null) {
                  totalDaysCount = (endDate!.difference(startDate!).inDays + 1).toString();
                }

                // Update the text controller
                dateRangeCont.text = '${formatBookingDate(start.toString(), format: DATE_FORMAT_7)} to ${formatBookingDate(end.toString(), format: DATE_FORMAT_7)}';

                widget.onApplyCallback.call(
                  formatBookingDate(start.toString(), format: DATE_FORMAT_7),
                  formatBookingDate(end.toString(), format: DATE_FORMAT_7),
                  totalDaysCount,
                );
              });
            },
            onCancelClick: () {
              widget.onCancelClick?.call();
            },
          );
        },
      ),
    );
  }
}