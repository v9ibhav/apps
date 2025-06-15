import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/base_scaffold_widget.dart';
import '../../model/booking_status_model.dart';
import '../../model/payment_gateway_response.dart';
import '../../network/rest_apis.dart';
import '../../utils/colors.dart';
import '../../utils/constant.dart';
import 'components/filter_booking_status_component.dart';
import 'components/filter_date_range_component.dart';
import 'components/filter_handyman_list_component.dart';
import 'components/filter_payment_status_component.dart';
import 'components/filter_payment_type_component.dart';
import 'components/filter_provider_list_component.dart';
import 'components/filter_service_list_component.dart';
import 'models/payment_status_model.dart';

class BookingFilterScreen extends StatefulWidget {
  final bool showProviderFilter;
  final bool showHandymanFilter;

  BookingFilterScreen({this.showProviderFilter = false, this.showHandymanFilter = false});

  @override
  _BookingFilterScreenState createState() => _BookingFilterScreenState();
}

class _BookingFilterScreenState extends State<BookingFilterScreen> {
  List<String> filteredSectionList = [];

  List<String> sectionList = [
    SERVICE,
    DATE_RANGE,
    PROVIDER,
    HANDYMAN,
    BOOKING_STATUS,
    PAYMENT_TYPE,
    PAYMENT_STATUS,
  ];

  int selectedIndex = 0;

  List<BookingStatusResponse> bookingStatusList = [];
  List<PaymentSetting> paymentTypeList = [];
  List<PaymentStatusModel> paymentStatusList = [
    PaymentStatusModel(status: SERVICE_PAYMENT_STATUS_PAID),
    PaymentStatusModel(status: SERVICE_PAYMENT_STATUS_PENDING),
    PaymentStatusModel(status: SERVICE_PAYMENT_STATUS_ADVANCE_PAID),
    PaymentStatusModel(status: SERVICE_PAYMENT_STATUS_ADVANCE_REFUND),
  ];

  @override
  void initState() {
    super.initState();
    appStore.setLoading(true);
    afterBuildCreated(() => init());
    computeFilteredSectionList();
  }

  void init() async {
    // Booking Status List
    await bookingStatus(list: bookingStatusList).then((value) {
      appStore.setLoading(false);

      bookingStatusList = value.validate();
      bookingStatusList.forEach((element) {
        if (filterStore.bookingStatus.contains(element.value)) {
          element.isSelected = true;
        }
      });
      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    // Payment Type List
    await getPaymentGateways(isAddWallet: true).then((value) {
      appStore.setLoading(false);

      paymentTypeList = value.validate();
      paymentTypeList.forEach((element) {
        if (filterStore.paymentType.contains(element.type)) {
          element.isSelected = true;
        }
      });
      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    // Payment Status List
    getPaymentStatus();
  }

  void getPaymentStatus() {
    paymentStatusList.forEach((element) {
      if (filterStore.paymentStatus.contains(element.status)) {
        element.isSelected = true;
      }
    });
  }

  void computeFilteredSectionList() {
    setState(() {
      filteredSectionList = sectionList.toList();
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void clearFilter() {
    filterStore.clearFilters();
    finish(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.lblFilterBy,
      scaffoldBackgroundColor: context.scaffoldBackgroundColor,
      showLoader: false,
      actions: [
        Observer(
          builder: (_) {
            return TextButton(
                  onPressed: () {
                    clearFilter();
                  },
                  child: Text(language.reset, style: boldTextStyle(color: Colors.white)),
            ).visible(filterStore.isAnyFilterApplied);
          },
        ),
      ],
      child: Stack(
        children: [
          DefaultTabController(
            length: filteredSectionList.length,
            initialIndex: selectedIndex < filteredSectionList.length ? selectedIndex : 0,
            child: Column(
              children: [
                16.height,
                Container(
                  child: TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.transparent,
                    dividerColor: Colors.transparent,
                    tabAlignment: TabAlignment.start,
                    padding: EdgeInsets.only(left: 16),
                    labelPadding: EdgeInsets.only(right: 16),
                    overlayColor: WidgetStatePropertyAll(WidgetStateColor.transparent),
                    onTap: (i) {
                      selectedIndex = i;
                      setState(() {});
                    },
                    tabs: filteredSectionList.map((e) {
                      int index = filteredSectionList.indexOf(e);

                      return Tab(
                        height: 30,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radius(18),
                            border: Border.all(color: index == selectedIndex ? primaryColor : Colors.transparent),
                            backgroundColor: index == selectedIndex ? lightPrimaryColor : context.cardColor,
                          ),
                          child: Text(
                            e.toBookingFilterSectionType(),
                            style: boldTextStyle(
                              color: index == selectedIndex
                                  ? primaryColor
                                  : appStore.isDarkMode
                                      ? Colors.white
                                      : appTextPrimaryColor,
                            ),
                          ).center(),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  key: ValueKey(selectedIndex),
                  children: filteredSectionList.map((e) {
                    if (e == SERVICE) {
                      return FilterServiceListComponent();
                    } else if (e == DATE_RANGE) {
                      return FilterDateRangeComponent();
                    } else if (e == PROVIDER) {
                      return FilterProviderListComponent();
                    } else if (e == HANDYMAN) {
                      return FilterHandymanListComponent();
                    } else if (e == BOOKING_STATUS) {
                      return FilterBookingStatusComponent(bookingStatusList: bookingStatusList);
                    } else if (e == PAYMENT_TYPE) {
                      return PaymentTypeFilter(paymentTypeList: paymentTypeList);
                    } else if (e == PAYMENT_STATUS) {
                      return PaymentStatusFilter(paymentStatusList: paymentStatusList);
                    } else {
                      return Offstage();
                    }
                  }).toList(),
                ).expand(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Observer(
              builder: (_) => Container(
                decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor),
                width: context.width(),
                padding: EdgeInsets.all(16),
                child: AppButton(
                  text: language.lblApply,
                  textColor: Colors.white,
                  color: context.primaryColor,
                  onTap: () {
                    filterStore.bookingStatus = [];

                    bookingStatusList.forEach((element) {
                      if (element.isSelected.validate()) {
                        filterStore.addToBookingStatusList(bookingStatusList: element.value.validate());
                      }
                    });

                    filterStore.paymentType = [];

                    paymentTypeList.forEach((element) {
                      if (element.isSelected.validate()) {
                        filterStore.addToPaymentTypeList(paymentTypeList: element.type.validate());
                      }
                    });

                    filterStore.paymentStatus = [];

                    paymentStatusList.forEach((element) {
                      if (element.isSelected.validate()) {
                        filterStore.addToPaymentStatusList(paymentStatusList: element.status.validate());
                      }
                    });

                    finish(context, true);
                  },
                ).visible(filterStore.isAnyFilterApplied),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
