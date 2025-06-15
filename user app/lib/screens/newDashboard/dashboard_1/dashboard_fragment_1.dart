import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/screens/dashboard/component/promotional_banner_slider_component.dart';
import 'package:booking_system_flutter/screens/newDashboard/dashboard_1/shimmer/dashboard_shimmer_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';
import '../../../component/loader_widget.dart';
import '../../../model/dashboard_model.dart';
import '../../../network/rest_apis.dart';
import '../../../utils/constant.dart';
import '../../dashboard/component/category_component.dart';
import 'component/booking_confirmed_component_1.dart';
import 'component/feature_services_dashboard_component_1.dart';
import 'component/job_request_dashboard_component_1.dart';
import 'component/service_list_dashboard_component_1.dart';
import 'component/slider_dashboard_component_1.dart';

class DashboardFragment1 extends StatefulWidget {
  @override
  _DashboardFragment1State createState() => _DashboardFragment1State();
}

class _DashboardFragment1State extends State<DashboardFragment1> {
  Future<DashboardResponse>? future;

  @override
  void initState() {
    super.initState();
    init();

    setStatusBarColorChange();

    LiveStream().on(LIVESTREAM_UPDATE_DASHBOARD, (p0) {
      init();
      appStore.setLoading(true);

      setState(() {});
    });
  }

  void init() async {
    future = userDashboard(isCurrentLocation: appStore.isCurrentLocation, lat: getDoubleAsync(LATITUDE), long: getDoubleAsync(LONGITUDE));
    setStatusBarColorChange();
    setState(() {});
  }

  Future<void> setStatusBarColorChange() async {
    setStatusBarColor(
      statusBarIconBrightness: appStore.isDarkMode
          ? Brightness.light
          : await isNetworkAvailable()
              ? Brightness.light
              : Brightness.dark,
      transparentColor,
      delayInMilliSeconds: 800,
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(LIVESTREAM_UPDATE_DASHBOARD);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SnapHelperWidget<DashboardResponse>(
            initialData: cachedDashboardResponse,
            future: future,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                imageWidget: ErrorStateWidget(),
                retryText: language.reload,
                onRetry: () {
                  appStore.setLoading(true);
                  init();

                  setState(() {});
                },
              );
            },
            loadingWidget: DashboardShimmer1(),
            onSuccess: (snap) {
              return Observer(builder: (context) {
                return AnimatedScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  listAnimationType: ListAnimationType.FadeIn,
                  fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                  onSwipeRefresh: () async {
                    appStore.setLoading(true);

                    setValue(LAST_APP_CONFIGURATION_SYNCED_TIME, 0);
                    init();
                    setState(() {});

                    return await 2.seconds.delay;
                  },
                  children: [
                    SliderDashboardComponent1(
                      sliderList: snap.slider.validate(),
                      featuredList: snap.featuredServices.validate(),
                      callback: () async {
                        appStore.setLoading(true);

                        init();
                        setState(() {});
                      },
                    ),
                    BookingConfirmedComponent1(upcomingConfirmedBooking: snap.upcomingData),
                    16.height,
                    CategoryComponent(categoryList: snap.category.validate(), isNewDashboard: true),
                    if (snap.promotionalBanner.validate().isNotEmpty  && appConfigurationStore.isPromotionalBanner)
                      PromotionalBannerSliderComponent(
                        promotionalBannerList: snap.promotionalBanner.validate(),
                      ).paddingTop(16),
                    16.height,
                    ServiceListDashboardComponent1(serviceList: snap.service.validate()),
                    16.height,
                    FeatureServicesDashboardComponent1(serviceList: snap.featuredServices.validate()),
                    16.height,
                    if (appConfigurationStore.jobRequestStatus) NewJobRequestDashboardComponent1()
                  ],
                );
              });
            },
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}