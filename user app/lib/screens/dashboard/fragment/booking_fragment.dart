import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/booking_data_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/booking/booking_detail_screen.dart';
import 'package:booking_system_flutter/screens/booking/component/booking_item_component.dart';
import 'package:booking_system_flutter/screens/booking/shimmer/booking_shimmer.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';
import '../../../store/filter_store.dart';
import '../../booking_filter/booking_filter_screen.dart';

class BookingFragment extends StatefulWidget {
  @override
  _BookingFragmentState createState() => _BookingFragmentState();
}

class _BookingFragmentState extends State<BookingFragment> {
  UniqueKey keyForList = UniqueKey();

  ScrollController scrollController = ScrollController();

  Future<List<BookingData>>? future;
  List<BookingData> bookings = [];

  int page = 1;
  bool isLastPage = false;

  String selectedValue = BOOKING_TYPE_ALL;

  @override
  void initState() {
    super.initState();
    init();
    filterStore = FilterStore();

    afterBuildCreated(() {
      if (appStore.isLoggedIn) {
        setStatusBarColor(context.primaryColor);
      }
    });

    LiveStream().on(LIVESTREAM_UPDATE_BOOKING_LIST, (p0) {
      page = 1;
      appStore.setLoading(true);
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
      providerId: filterStore.providerId.join(","),
      handymanId: filterStore.handymanId.join(","),
      bookingStatus: filterStore.bookingStatus.join(","),
      paymentStatus: filterStore.paymentStatus.join(","),
      paymentType: filterStore.paymentType.join(","),
      bookings: bookings,
      lastPageCallback: (b) {
        isLastPage = b;
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
    LiveStream().dispose(LIVESTREAM_UPDATE_BOOKING_LIST);
    //scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.booking,
        textColor: white,
        showBack: false,
        textSize: APP_BAR_TEXT_SIZE,
        elevation: 3.0,
        color: context.primaryColor,
        actions: [
          Observer(
            builder: (_) {
              int filterCount = filterStore.getActiveFilterCount();
              return Stack(
                children: [
                  IconButton(
                    icon: ic_filter.iconImage(color: white, size: 20),
                    onPressed: () async {
                      BookingFilterScreen(showHandymanFilter: true).launch(context).then((value) {
                        if (value != null) {
                          page = 1;
                          appStore.setLoading(true);
                          init();
                          if (bookings.isNotEmpty) {
                            scrollController.animateTo(0, duration: 1.seconds, curve: Curves.easeOutQuart);
                          } else {
                            scrollController = ScrollController();
                            keyForList = UniqueKey();
                          }
                          setState(() {});
                        }
                      });
                    },
                  ),
                  if (filterCount > 0)
                    Positioned(
                      right: 7,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: FittedBox(
                          child: Text('$filterCount', style: TextStyle(color: white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        decoration: boxDecorationDefault(color: Colors.red, shape: BoxShape.circle),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: SizedBox(
        width: context.width(),
        height: context.height(),
        child: Stack(
          children: [
            SnapHelperWidget<List<BookingData>>(
              initialData: cachedBookingList,
              future: future,
              errorBuilder: (error) {
                return NoDataWidget(
                  title: error,
                  imageWidget: ErrorStateWidget(),
                  retryText: language.reload,
                  onRetry: () {
                    page = 1;
                    appStore.setLoading(true);

                    init();
                    setState(() {});
                  },
                );
              },
              loadingWidget: BookingShimmer(),
              onSuccess: (list) {
                return AnimatedListView(
                  key: keyForList,
                  controller: scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 60, top: 16, right: 16, left: 16),
                  itemCount: list.length,
                  shrinkWrap: true,
                  disposeScrollController: true,
                  listAnimationType: ListAnimationType.FadeIn,
                  fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                  slideConfiguration: SlideConfiguration(verticalOffset: 400),
                  emptyWidget: NoDataWidget(
                    title: language.lblNoBookingsFound,
                    subTitle: language.noBookingSubTitle,
                    imageWidget: EmptyStateWidget(),
                  ),
                  itemBuilder: (_, index) {
                    BookingData? data = list[index];

                    return GestureDetector(
                      onTap: () {
                        BookingDetailScreen(bookingId: data.id.validate()).launch(context);
                      },
                      child: BookingItemComponent(bookingData: data),
                    );
                  },
                  onNextPage: () {
                    if (!isLastPage) {
                      page++;
                      appStore.setLoading(true);

                      init(status: selectedValue);
                      setState(() {});
                    }
                  },
                  onSwipeRefresh: () async {
                    page = 1;
                    appStore.setLoading(true);

                    init(status: selectedValue);
                    setState(() {});

                    return await 1.seconds.delay;
                  },
                );
              },
            ),
            Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
