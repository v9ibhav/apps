import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/booking_detail_model.dart';
import 'package:booking_system_flutter/screens/booking/component/booking_history_list_widget.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/constant.dart';

class BookingHistoryComponent extends StatefulWidget {
  final List<BookingActivity> data;
  final ScrollController scrollController;

  BookingHistoryComponent({required this.data, required this.scrollController});

  @override
  BookingHistoryComponentState createState() => BookingHistoryComponentState();
}

class BookingHistoryComponentState extends State<BookingHistoryComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius), backgroundColor: context.cardColor),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                40.width,
                Container(width: 40, height: 2, color: gray.withValues(alpha:0.3)).center(),
                IconButton(
                  onPressed: () => finish(context),
                  icon: Icon(
                    Icons.close_sharp,
                    size: 20.0,
                  ),
                )
              ],
            ),
            4.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(language.bookingHistory, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                if (widget.data.validate().isNotEmpty)
                  Row(
                    children: [
                      Text('${language.lblID}:', style: boldTextStyle(color: primaryColor)),
                      4.width,
                      Text(' #' + widget.data[0].bookingId.validate().toString(), style: boldTextStyle(color: primaryColor)),
                    ],
                  )
              ],
            ),
            16.height,
            Divider(color: context.dividerColor),
            16.height,
            widget.data.isNotEmpty
                ? AnimatedListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.data.length,
                    listAnimationType: ListAnimationType.FadeIn,
                    fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                    itemBuilder: (_, i) {
                      BookingActivity data = widget.data[i];
                      return BookingHistoryListWidget(data: data, index: i, length: widget.data.length.validate());
                    },
                  )
                : Text(language.noDataAvailable).center().paddingAll(16),
          ],
        ),
      ),
    );
  }
}
