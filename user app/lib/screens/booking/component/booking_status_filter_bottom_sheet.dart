import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../model/booking_status_model.dart';
import '../../../network/rest_apis.dart';
import '../../../utils/colors.dart';
import '../../../utils/constant.dart';

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
                Text(language.lblFilterBy, style: boldTextStyle()),
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
            Text(language.bookingStatus, style: primaryTextStyle()),
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
                  text: language.clearFilter,
                  color: appStore.isDarkMode ? context.scaffoldBackgroundColor : white,
                  textColor: appStore.isDarkMode ? white : context.primaryColor,
                  width: context.width() - context.navigationBarHeight,
                  onTap: () {
                    finish(context);
                    init();
                    LiveStream().emit(LIVESTREAM_UPDATE_BOOKING_LIST);
                  },
                ).expand(),
                16.width,
                AppButton(
                  text: language.lblApply,
                  color: context.primaryColor,
                  textColor: white,
                  width: context.width() - context.navigationBarHeight,
                  onTap: () {
                    int selectedCount = cachedBookingStatusDropdown.validate().where((element) => element.isSelected).length;
                    if (selectedCount >= 1) {
                      finish(context, cachedBookingStatusDropdown!.where((element) => element.isSelected).map((e) => e.value).join(','));
                    } else {
                      toast(language.serviceStatusPicMessage);
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
