import 'package:booking_system_flutter/screens/dashboard/component/promotional_banner_slider_component.dart';
import 'package:booking_system_flutter/screens/newDashboard/dashboard_2/shimmer/dashboard_shimmer_2.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';
import '../../../component/loader_widget.dart';
import '../../../main.dart';
import '../../../model/dashboard_model.dart';
import '../../../network/rest_apis.dart';
import '../../../utils/constant.dart';
import 'component/category_list_dashboard_component_2.dart';
import 'component/confirm_dashboard_booking_component_2.dart';
import 'component/custom_appbar_dashboard_component_2.dart';
import 'component/job_request_dashboard_component_2.dart';
import 'component/service_list_dashboard_component_2.dart';
import 'component/slider_dashboard_component_2.dart';

class DashboardFragment2 extends StatefulWidget {
  @override
  _DashboardFragment2State createState() => _DashboardFragment2State();
}

class _DashboardFragment2State extends State<DashboardFragment2> {
  Future<DashboardResponse>? future;

  @override
  void initState() {
    super.initState();
    init();

    afterBuildCreated(() {
      setStatusBarColorChange();
    });

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
      backgroundColor: appStore.isDarkMode ? context.primaryColor.withValues(alpha:0.01) : primaryLightColor,
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
            loadingWidget: DashboardShimmer2(),
            onSuccess: (snap) {
              return Observer(
                builder: (context) {
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
                      CustomAppbarDashboardComponent2(
                        featuredList: snap.featuredServices.validate(),
                        callback: () async {
                          appStore.setLoading(true);

                          init();
                          setState(() {});
                        },
                      ),
                      16.height,
                      SliderDashboardComponent2(sliderList: snap.slider.validate()),
                      ConfirmDashboardBookingComponent2(upcomingConfirmedBooking: snap.upcomingData),
                      16.height,
                      CategoryListDashboardComponent2(categoryList: snap.category.validate()),
                      if (snap.promotionalBanner.validate().isNotEmpty  && appConfigurationStore.isPromotionalBanner)
                        PromotionalBannerSliderComponent(
                          promotionalBannerList: snap.promotionalBanner.validate(),
                        ).paddingTop(16),
                      20.height,
                      ServiceListDashboardComponent2(serviceList: snap.service.validate(), serviceListTitle: language.service),
                      16.height,
                      ServiceListDashboardComponent2(serviceList: snap.featuredServices.validate(), serviceListTitle: language.featuredServices, isFeatured: true),
                      16.height,
                      if (appConfigurationStore.jobRequestStatus) JobRequestDashboardComponent2(),
                    ],
                  );
                }
              );
            },
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}