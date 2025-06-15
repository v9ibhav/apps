import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/booking_item_component.dart';
import 'package:handyman_provider_flutter/fragments/shimmer/booking_shimmer.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/empty_error_state_widget.dart';
import '../components/price_widget.dart';
import '../store/filter_store.dart';
import '../utils/colors.dart';
import '../utils/configs.dart';
import 'components/total_earnings_components.dart';

String selectedBookingStatus = BOOKING_PAYMENT_STATUS_ALL;

class BookingFragment extends StatefulWidget {
  @override
  BookingFragmentState createState() => BookingFragmentState();
}

class BookingFragmentState extends State<BookingFragment> with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  int page = 1;
  List<BookingData> bookings = [];

  bool isLastPage = false;
  bool hasError = false;
  bool isApiCalled = false;

  Future<List<BookingData>>? future;
  UniqueKey keyForList = UniqueKey();

  FocusNode myFocusNode = FocusNode();

  TextEditingController searchCont = TextEditingController();

  String totalEarnings = '';
  PaymentBreakdown paymentBreakdownData = PaymentBreakdown();

  @override
  void initState() {
    super.initState();
    selectedBookingStatus = BOOKING_PAYMENT_STATUS_ALL;
    init();
    filterStore = FilterStore();

    LiveStream().on(LIVESTREAM_UPDATE_BOOKING_STATUS_WISE, (data) {
      if (data is String && data.isNotEmpty) {
        cachedBookingList = null;
        selectedBookingStatus = data;
        bookings = [];

        page = 1;
        init(status: selectedBookingStatus);

        setState(() {});
      }
    });

    /*LiveStream().on(LIVESTREAM_HANDYMAN_ALL_BOOKING, (index) {
      if (index == 1) {
        selectedBookingStatus = BOOKING_PAYMENT_STATUS_ALL;
        page = 1;
        init(status: selectedBookingStatus);
        setState(() {});
      }
    });*/

    LiveStream().on(LIVESTREAM_UPDATE_BOOKINGS, (p0) {
      appStore.setLoading(true);
      page = 1;
      init();
      setState(() {});
    });

    cachedBookingStatusDropdown.validate().forEach((element) {
      element.isSelected = false;
    });
  }

  void init({String status = ''}) async {
    future = getBookingList(
      page,
      serviceId: filterStore.serviceId.join(","),
      dateFrom: filterStore.startDate,
      dateTo: filterStore.endDate,
      customerId: filterStore.customerId.join(","),
      providerId: filterStore.providerId.join(","),
      handymanId: filterStore.handymanId.join(","),
      bookingStatus: filterStore.bookingStatus.join(","),
      paymentStatus: filterStore.paymentStatus.join(","),
      paymentType: filterStore.paymentType.join(","),
      searchText: searchCont.text,
      bookings: bookings,
      lastPageCallback: (b) {
        isLastPage = b;
      },
      paymentBreakdownCallBack: (totalEarning, paymentBreakdown) {
        totalEarnings = totalEarning;
        paymentBreakdownData = paymentBreakdown;
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    filterStore.clearFilters();
    LiveStream().dispose(LIVESTREAM_UPDATE_BOOKINGS);
    // LiveStream().dispose(LIVESTREAM_HANDY_BOARD);
    // LiveStream().dispose(LIVESTREAM_HANDYMAN_ALL_BOOKING);
    // LiveStream().dispose(LIVESTREAM_HANDY_BOARD);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SnapHelperWidget<List<BookingData>>(
            initialData: cachedBookingList,
            future: future,
            loadingWidget: BookingShimmer(),
            onSuccess: (list) {
              return AnimatedScrollView(
                controller: scrollController,
                listAnimationType: ListAnimationType.FadeIn,
                physics: AlwaysScrollableScrollPhysics(),
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                onSwipeRefresh: () async {
                  page = 1;
                  appStore.setLoading(true);

                  init(status: selectedBookingStatus);
                  setState(() {});

                  return await 1.seconds.delay;
                },
                onNextPage: () {
                  if (!isLastPage) {
                    page++;
                    appStore.setLoading(true);

                    init();
                    setState(() {});
                  }
                },
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 8),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radius(),
                            backgroundColor: appStore.isDarkMode ? context.cardColor : cardLightColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(languages.totalAmount, style: boldTextStyle()).expand(),
                                  TextButton(
                                    style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 2, horizontal: 0))),
                                    onPressed: () {
                                      TotalAmountsComponent(
                                        totalEarning: totalEarnings,
                                        paymentBreakdown: paymentBreakdownData,
                                      ).launch(context);
                                    },
                                    child: Text(languages.viewBreakdown, style: boldTextStyle(color: defaultStatus, size: 13)),
                                  ).withHeight(25),
                                ],
                              ),
                              PriceWidget(price: totalEarnings.toDouble(), color: primaryColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedListView(
                    key: keyForList,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    listAnimationType: ListAnimationType.FadeIn,
                    fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                    itemCount: list.length,
                    shrinkWrap: true,
                    disposeScrollController: true,
                    physics: NeverScrollableScrollPhysics(),
                    emptyWidget: SizedBox(
                      width: context.width(),
                      height: context.height() * 0.55,
                      child: NoDataWidget(
                        title: languages.noBookingTitle,
                        subTitle: languages.noBookingSubTitle,
                        imageWidget: EmptyStateWidget(),
                      ),
                    ),
                    itemBuilder: (_, index) => BookingItemComponent(bookingData: list[index], index: index),
                  ),
                ],
              );
            },
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: languages.reload,
                imageWidget: ErrorStateWidget(),
                onRetry: () {
                  page = 1;
                  appStore.setLoading(true);

                  init();
                  setState(() {});
                },
              );
            },
          ),
          Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
