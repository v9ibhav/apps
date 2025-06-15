import 'package:booking_system_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/price_widget.dart';

class FilterPriceComponent extends StatefulWidget {
  final num min;
  final num max;

  const FilterPriceComponent({
    Key? key,
    required this.min,
    required this.max,
  }) : super(key: key);

  @override
  State<FilterPriceComponent> createState() => _FilterPriceComponentState();
}

class _FilterPriceComponentState extends State<FilterPriceComponent> {
  late RangeValues rangeValues;

  @override
  void initState() {
    super.initState();

    // Use filterStore values if already set, else use widget.min/max
    if (filterStore.isPriceMax.isNotEmpty && filterStore.isPriceMin.isNotEmpty) {
      rangeValues = RangeValues(
        filterStore.isPriceMin.toDouble(),
        filterStore.isPriceMax.toDouble(),
      );
    } else {
      rangeValues = RangeValues(widget.min.toDouble(), widget.max.toDouble());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(language.lblPrice, style: boldTextStyle()).paddingAll(16),
          RangeSlider(
            min: widget.min.toDouble(),
            max: widget.max.toDouble(),
            divisions: (widget.max - widget.min).toInt() > 0
                ? (widget.max - widget.min).toInt()
                : null, // or just set to a default like 10
            labels: RangeLabels(
              rangeValues.start.toInt().toString(),
              rangeValues.end.toInt().toString(),
            ),
            values: rangeValues,
            onChanged: (values) {
              setState(() {
                rangeValues = values;
                filterStore.setMinPrice(values.start.toInt().toString());
                filterStore.setMaxPrice(values.end.toInt().toString());
              });
            },
          ),

          16.height,
          Marquee(
            child: Row(
              children: [
                Text("[ ", style: primaryTextStyle()),
                PriceWidget(
                  price: rangeValues.start.toInt(),
                  isBoldText: false,
                  color: textPrimaryColorGlobal,
                  decimalPoint: 0,
                ),
                Text(" - ", style: primaryTextStyle()),
                PriceWidget(
                  price: rangeValues.end.toInt(),
                  isBoldText: false,
                  color: textPrimaryColorGlobal,
                  decimalPoint: 0,
                ),
                Text(" ]", style: primaryTextStyle()),
              ],
            ),
          ).center(),
        ],
      ),
    );
  }
}