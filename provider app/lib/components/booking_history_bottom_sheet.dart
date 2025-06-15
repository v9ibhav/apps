import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/booking_history_list_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/constant.dart';

class BookingHistoryBottomSheet extends StatelessWidget {
  final List<BookingActivity> data;
  final ScrollController? scrollController;

  BookingHistoryBottomSheet({required this.data, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationDefault(
        color: context.scaffoldBackgroundColor,
        borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
      ),
      padding: EdgeInsets.all(16),
      child: AnimatedScrollView(
        controller: scrollController,
        listAnimationType: ListAnimationType.FadeIn,
        fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Text(languages.bookingStatus, style: boldTextStyle(size: LABEL_TEXT_SIZE)).expand(),
              GestureDetector(
                onTap: () {
                  finish(context);
                },
                child: Container(
                  decoration: boxDecorationDefault(
                    color: context.cardColor,
                    borderRadius: radius(4),
                    border: Border.all(color: context.iconColor),
                  ),
                  child: Icon(Icons.close_rounded, size: 16),
                ),
              )
            ],
          ),
          Divider(height: 32, thickness: 1, color: context.dividerColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${languages.lblBookingID}:', style: secondaryTextStyle(size: 14)),
              Text(
                ' #' + data[0].bookingId.toString().validate(),
                style: boldTextStyle(color: primaryColor),
              ),
            ],
          ),
          16.height,
          if (data.isNotEmpty)
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              decoration: boxDecorationDefault(color: context.cardColor),
              child: AnimatedWrap(
                listAnimationType: ListAnimationType.FadeIn,
                itemCount: data.length,
                itemBuilder: (p0, i) {
                  return BookingHistoryListWidget(
                    data: data[i],
                    index: i,
                    length: data.length.validate(),
                  );
                },
              ),
            ),
          if (data.isEmpty) Text(languages.noDataFound),
        ],
      ),
    );
  }
}
