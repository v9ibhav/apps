import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:nb_utils/nb_utils.dart';
import '../components/base_scaffold_widget.dart';
import '../main.dart';
import '../models/booking_status_response.dart';
import '../networks/rest_apis.dart';
import '../utils/app_configuration.dart';
import '../utils/configs.dart';
import '../utils/constant.dart';
import 'components/filter_booking_status_component.dart';
import 'components/filter_customer_list_component.dart';
import 'components/filter_date_range_component.dart';
import 'components/filter_handyman_list_component.dart';
import 'components/filter_payment_status_component.dart';
import 'components/filter_payment_type_component.dart';
import 'components/filter_provider_list_component.dart';
import 'components/filter_service_list_component.dart';
import 'models/payment_status_model.dart';

class BookingFilterScreen extends StatefulWidget {
  @override
  _BookingFilterScreenState createState() => _BookingFilterScreenState();
}

class _BookingFilterScreenState extends State<BookingFilterScreen> {
  List<String> filteredSectionList = [];

  List<String> sectionList = [
    SERVICE_FILTER,
    DATE_RANGE,
    CUSTOMER,
    if (appStore.userType != USER_TYPE_HANDYMAN) PROVIDER.toLowerCase(),
    if (appStore.userType != USER_TYPE_HANDYMAN || appStore.userType != USER_TYPE_PROVIDER) HANDYMAN.toLowerCase(),
    BOOKING_STATUS,
    PAYMENT_TYPE,
    PAYMENT_STATUS,
  ];

  int selectedIndex = 0;

  List<BookingStatusResponse> bookingStatusList = [];
  List<PaymentSetting> paymentTypeList = [];
  List<PaymentStatusModel> paymentStatusList = [
    PaymentStatusModel(status: PAID),
    PaymentStatusModel(status: PENDING),
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
      filteredSectionList = sectionList.where((section) {
        if (section.toLowerCase() == HANDYMAN.toLowerCase() && appStore.userType == 'handyman') {
          return false;
        } else if (section.toLowerCase() == PROVIDER.toLowerCase() && appStore.userType == 'handyman') {
          return false;
        } else if (section.toLowerCase() == PROVIDER.toLowerCase() && appStore.userType == 'provider') {
          return false;
        }
        return true;
      }).toList();
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
      appBarTitle: languages.filterBy,
      scaffoldBackgroundColor: context.scaffoldBackgroundColor,
      showLoader: false,
      actions: [
        Observer(
          builder: (_) {
            return TextButton(
              onPressed: () {
                clearFilter();
              },
              child: Text(languages.reset, style: boldTextStyle(color: Colors.white)),
            ).visible(filterStore.isAnyFilterApplied);
          },
        ),
      ],
      body: Stack(
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
                    if (e == SERVICE_FILTER) {
                      return FilterServiceListComponent();
                    } else if (e == DATE_RANGE) {
                      return FilterDateRangeComponent();
                    } else if (e == CUSTOMER) {
                      return FilterCustomerListComponent();
                    } else if (e == PROVIDER.toLowerCase()) {
                      return FilterProviderListComponent();
                    } else if (e == HANDYMAN.toLowerCase()) {
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
                  text: languages.apply,
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