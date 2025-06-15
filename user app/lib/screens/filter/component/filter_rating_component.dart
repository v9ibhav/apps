import 'package:booking_system_flutter/component/disabled_rating_bar_widget.dart';
import 'package:booking_system_flutter/component/selected_item_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FilterRatingComponent extends StatefulWidget {
  @override
  State<FilterRatingComponent> createState() => _FilterRatingComponentState();
}

class _FilterRatingComponentState extends State<FilterRatingComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: context.width(),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            reverse: true,
            itemBuilder: (context, index) {
              bool isSelected = filterStore.ratingId.contains(index + 1);

              return Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Row(
                  children: [
                    SelectedItemWidget(isSelected: isSelected),
                    8.width,
                    DisabledRatingBarWidget(rating: (index + 1).toDouble()).expand(),
                    Text('${(index + 1)}', style: primaryTextStyle(size: 14)),
                  ],
                ),
              ).onTap(() {
                int selectedIndex = index + 1;

                if (!filterStore.ratingId.contains(selectedIndex)) {
                  filterStore.ratingId.add(selectedIndex);
                } else {
                  filterStore.ratingId.removeWhere((element) => element == selectedIndex);
                }
                setState(() {});
              });
            },
          )
        ],
      ),
    );
  }
}
