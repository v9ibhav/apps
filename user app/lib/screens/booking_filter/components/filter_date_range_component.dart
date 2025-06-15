import 'package:booking_system_flutter/screens/booking_filter/components/date_component/custom_date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constant.dart';

class FilterDateRangeComponent extends StatefulWidget {
  @override
  _FilterDateRangeComponentState createState() => _FilterDateRangeComponentState();
}

class _FilterDateRangeComponentState extends State<FilterDateRangeComponent> {
  TextEditingController dateRangeCont = TextEditingController();

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
      dateRangeCont.text = '${formatBookingDate(startDate.toString(), format: DATE_FORMAT_7)} ${language.to} ${formatBookingDate(endDate.toString(), format: DATE_FORMAT_7)}';
    } else {
      dateRangeCont.text = language.chooseYourDateRange;
    }
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
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          16.height,
          AppTextField(
            title: language.dateRange,
            textStyle: primaryTextStyle(size: 12),
            controller: dateRangeCont,
            textFieldType: TextFieldType.NAME,
            readOnly: true,
            isValidationRequired: false,
            decoration: inputDecoration(
              context,
              hintText: language.selectStartDateEndDate,
              fillColor: context.cardColor,
            ),
            suffix: IconButton(
              onPressed: () {
                startDate = null;
                endDate = null;

                dateRangeCont.text = '';

                filterStore.setStartDate('');
                filterStore.setEndDate('');

                setState(() {});
              },
              icon: Icon(Icons.close),
            ).visible(startDate != null),
            onTap: () {
              showCustomDateRangePicker(
                context,
                disabledDateColor: Colors.grey.withValues(alpha: 0.5),
                dismissible: true,
                minimumDate: DateTime.now().subtract(const Duration(days: 30)),
                maximumDate: DateTime.now().add(const Duration(days: 30)),
                endDate: endDate,
                startDate: startDate,
                backgroundColor: context.cardColor,
                primaryColor: primaryColor,
                onApplyClick: (start, end) {
                  startDate = start;
                  endDate = end;

                  filterStore.setStartDate(formatBookingDate(startDate.toString(), format: DATE_FORMAT_7));
                  filterStore.setEndDate(formatBookingDate(endDate.toString(), format: DATE_FORMAT_7));

                  dateRangeCont.text = '${formatBookingDate(startDate.toString(), format: DATE_FORMAT_7)} to ${formatBookingDate(endDate.toString(), format: DATE_FORMAT_7)}';
                },
                onCancelClick: () {
                  //
                },
              );
            },
          ),
        ],
      ),
    );
  }
}