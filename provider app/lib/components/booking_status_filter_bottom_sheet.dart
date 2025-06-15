import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';
import '../fragments/booking_fragment.dart';
import '../models/booking_status_response.dart';
import '../networks/rest_apis.dart';
import '../utils/constant.dart';

class BookingStatusFilterBottomSheet extends StatefulWidget {
  const BookingStatusFilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<BookingStatusFilterBottomSheet> createState() => _BookingStatusFilterBottomSheetState();
}

class _BookingStatusFilterBottomSheetState extends State<BookingStatusFilterBottomSheet> {
  Future<List<BookingStatusResponse>>? future;

  List<BookingStatusResponse> list = [];
  BookingStatusResponse? selectedData;

  @override
  void initState() {
    if (cachedBookingStatusDropdown.validate().isEmpty) {
      init();
    }
    super.initState();
  }

  void init() async {
    future = bookingStatus(list: list);
  }

  Widget itemWidget(BookingStatusResponse res) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: boxDecorationDefault(
        color: appStore.isDarkMode
            ? res.isSelected
                ? lightPrimaryColor
                : context.scaffoldBackgroundColor
            : res.isSelected
                ? lightPrimaryColor
                : context.scaffoldBackgroundColor,
        borderRadius: radius(8),
        border: Border.all(color: appStore.isDarkMode ? Colors.white54 : lightPrimaryColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (res.isSelected)
            Container(
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.only(right: 1),
              child: Icon(Icons.done, size: 16, color: context.primaryColor),
            ),
          Text(
            res.value.validate().toBookingStatus(),
            style: primaryTextStyle(
                color: appStore.isDarkMode
                    ? res.isSelected
                        ? context.primaryColor
                        : Colors.white54
                    : res.isSelected
                        ? context.primaryColor
                        : Colors.black38,
                size: 12),
          ),
        ],
      ),
    ).onTap(() {
      res.isSelected = !res.isSelected;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius), backgroundColor: context.cardColor),
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(languages.filterBy, style: boldTextStyle()),
                IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.close, color: appStore.isDarkMode ? lightPrimaryColor : context.primaryColor, size: 20),
                  visualDensity: VisualDensity.compact,
                  onPressed: () async {
                    finish(context);
                  },
                ),
              ],
            ),
            8.height,
            Container(width: context.width() - 16, height: 1, color: gray.withValues(alpha:0.3)).center(),
            24.height,
            Text(languages.bookingStatus, style: primaryTextStyle()),
            24.height,
            FutureBuilder<List<BookingStatusResponse>>(
              initialData: cachedBookingStatusDropdown,
              future: future,
              builder: (context, snap) {
                if (snap.hasData) {
                  return Wrap(
                    runSpacing: 12,
                    spacing: 12,
                    children: List.generate(snap.data!.length, (index) => itemWidget(snap.data![index])),
                  );
                }

                return snapWidgetHelper(snap, defaultErrorMessage: "", loadingWidget: Offstage());
              },
            ),
            24.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton(
                  text: languages.clearFilter,
                  color: appStore.isDarkMode ? context.scaffoldBackgroundColor : white,
                  textColor: appStore.isDarkMode ? white : context.primaryColor,
                  width: context.width() - context.navigationBarHeight,
                  onTap: () {
                    int selectedCount = cachedBookingStatusDropdown!.where((element) => element.isSelected).length;

                    if (selectedCount >= 1) {
                      selectedBookingStatus = BOOKING_PAYMENT_STATUS_ALL;
                      LiveStream().emit(LIVESTREAM_UPDATE_BOOKINGS);
                      finish(context);
                      init();

                      appStore.setLoading(true);
                    } else {
                      finish(context);
                    }
                  },
                ).expand(),
                16.width,
                AppButton(
                  text: languages.apply,
                  color: context.primaryColor,
                  textColor: white,
                  width: context.width() - context.navigationBarHeight,
                  onTap: () {
                    int selectedCount = cachedBookingStatusDropdown!.where((element) => element.isSelected).length;
                    if (selectedCount >= 1) {
                      finish(context, cachedBookingStatusDropdown.validate().where((element) => element.isSelected).map((e) => e.value).join(','));
                    } else {
                      toast(languages.filterAtLeastOneBookingStatusToast);
                    }
                  },
                ).expand(),
              ],
            ).paddingOnly(left: 16, right: 16, bottom: 16),
          ],
        ),
      ),
    );
  }
}
