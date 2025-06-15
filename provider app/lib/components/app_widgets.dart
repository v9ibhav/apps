import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/spin_kit_chasing_dots.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/common.dart';
import '../utils/model_keys.dart';

Widget placeHolderWidget({String? placeHolderImage, double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment}) {
  return PlaceHolderWidget(
    height: height,
    width: width,
    alignment: alignment ?? Alignment.center,
  );
}

String commonPrice(num price) {
  var formatter = NumberFormat('#,##,000.00');
  return formatter.format(price);
}

class LoaderWidget extends StatelessWidget {
  final double? size;

  LoaderWidget({this.size});

  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(color: primaryColor, size: size ?? 50);
  }
}

Widget aboutCustomerWidget({BuildContext? context, BookingData? bookingDetail}) {
  return Row(
    children: [
      Text(languages.lblAboutCustomer, style: boldTextStyle(size: LABEL_TEXT_SIZE)).expand(),
      if (bookingDetail!.canCustomerContact && bookingDetail.status != BookingStatusKeys.complete && bookingDetail.status != BookingStatusKeys.cancelled)
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            child: Text(languages.lblGetDirection, style: boldTextStyle(color: primaryColor, size: 12)),
            onPressed: () async {
              if (isAndroid) {
                launchMap(bookingDetail.address.validate());
              } else {
                commonLaunchUrl('$GOOGLE_MAP_PREFIX${Uri.encodeFull(bookingDetail.address.validate())}', launchMode: LaunchMode.externalApplication);
              }
            },
          ),
        ),
    ],
  );
}
