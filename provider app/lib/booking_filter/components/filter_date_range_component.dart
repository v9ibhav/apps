import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/date_component/custom_date_range_picker.dart';
import '../../main.dart';
import '../../utils/common.dart';
import '../../utils/configs.dart';
import '../../utils/constant.dart';

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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          16.height,
          AppTextField(
            title: languages.dateRange,
            textStyle: primaryTextStyle(size: 12),
            controller: dateRangeCont,
            textFieldType: TextFieldType.NAME,
            readOnly: true,
            isValidationRequired: false,
            decoration: inputDecoration(
              context,
              hintText:languages.selectStartDateEndDate,
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
                disabledDateColor: Colors.grey.withOpacity(0.5),
                context,
                dismissible: true,
                minimumDate: DateTime.now().subtract(const Duration(days: 30)),
                maximumDate: DateTime.now().add(const Duration(days: 30)),
                startDate: startDate,
                endDate: endDate,
                backgroundColor: context.cardColor,
                primaryColor: primaryColor,
                onApplyClick: (start, end) {
                  setState(() {
                    startDate = start;
                    endDate = end;

                    // Update filterStore values
                    filterStore.setStartDate(formatBookingDate(start.toString(), format: DATE_FORMAT_7));
                    filterStore.setEndDate(formatBookingDate(end.toString(), format: DATE_FORMAT_7));

                    // Update the text controller
                    dateRangeCont.text = '${formatBookingDate(start.toString(), format: DATE_FORMAT_7)} to ${formatBookingDate(end.toString(), format: DATE_FORMAT_7)}';
                  });
                },
                onCancelClick: () {
                  // Handle cancel if needed
                },
              );
            },
          ),
        ],
      ),
    );
  }
}