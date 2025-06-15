import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/screens/booking/booking_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../model/booking_data_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constant.dart';

class PendingBookingComponent extends StatefulWidget {
  final BookingData? upcomingConfirmedBooking;

  PendingBookingComponent({this.upcomingConfirmedBooking});

  @override
  State<PendingBookingComponent> createState() => _PendingBookingComponentState();
}

class _PendingBookingComponentState extends State<PendingBookingComponent> {
  @override
  Widget build(BuildContext context) {
    if (widget.upcomingConfirmedBooking == null) return Offstage();

    if (getBoolAsync('$BOOKING_ID_CLOSED_${widget.upcomingConfirmedBooking!.id}')) {
      return Offstage();
    }

    if (widget.upcomingConfirmedBooking!.status != BOOKING_STATUS_PENDING && widget.upcomingConfirmedBooking!.status != BOOKING_STATUS_ACCEPT) {
      return Offstage();
    }

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 26),
      decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: primaryColor),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 20,
                    width: 3,
                    decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: Colors.white.withValues(alpha:0.6)),
                  ),
                  8.width,
                  Marquee(child: Text(language.bookingConfirmedMsg, style: primaryTextStyle(color: Colors.white, size: LABEL_TEXT_SIZE, fontStyle: FontStyle.italic))).expand(),
                ],
              ).expand(),
              SizedBox(
                width: 30,
                height: 22,
                child: IconButton(
                  icon: Icon(Icons.cancel, color: Colors.white.withValues(alpha:0.6)),
                  visualDensity: VisualDensity.compact,
                  onPressed: () async {
                    await setValue('$BOOKING_ID_CLOSED_${widget.upcomingConfirmedBooking!.id}', true);
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          16.height,
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: boxDecorationRoundedWithShadow(21, backgroundColor: Colors.white.withValues(alpha:0.2)),
                child: Icon(Icons.library_add_check_outlined, size: 18, color: Colors.white),
              ),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.upcomingConfirmedBooking!.serviceName.validate(), style: boldTextStyle(color: Colors.white)),
                  2.height,
                  Text(formatDate(widget.upcomingConfirmedBooking!.date.validate(), showDateWithTime: true), style: primaryTextStyle(color: Colors.white, size: 14)),
                ],
              ).flexible(),
            ],
          )
        ],
      ).onTap(() {
        BookingDetailScreen(bookingId: widget.upcomingConfirmedBooking!.id!).launch(context);
      }),
    );
  }
}
