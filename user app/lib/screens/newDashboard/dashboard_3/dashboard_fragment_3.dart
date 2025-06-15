import 'dart:async';

import 'package:booking_system_flutter/screens/dashboard/component/promotional_banner_slider_component.dart';
import 'package:booking_system_flutter/screens/newDashboard/dashboard_3/component/appbar_dashboard_component_3.dart';
import 'package:booking_system_flutter/screens/newDashboard/dashboard_3/component/category_list_dashboard_component_3.dart';
import 'package:booking_system_flutter/screens/newDashboard/dashboard_3/component/job_request_dahboard_component_3.dart';
import 'package:booking_system_flutter/screens/newDashboard/dashboard_3/component/service_list_dashboard_component_3.dart';
import 'package:booking_system_flutter/screens/newDashboard/dashboard_3/component/slider_dashboard_component_3.dart';
import 'package:booking_system_flutter/screens/newDashboard/dashboard_3/shimmer/dashboard_shimmer_3.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';
import '../../../component/loader_widget.dart';
import '../../../main.dart';
import '../../../model/dashboard_model.dart';
import '../../../network/rest_apis.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constant.dart';
import '../../../utils/images.dart';
import 'component/upcoming_booking_dashboard_component_3.dart';

class DashboardFragment3 extends StatefulWidget {
  @override
  _DashboardFragment3State createState() => _DashboardFragment3State();
}

class _DashboardFragment3State extends State<DashboardFragment3> {
  Future<DashboardResponse>? future;

  @override
  void initState() {
    super.initState();
    init();

    afterBuildCreated(() {
      setStatusBarColor(
        transparentColor,
        delayInMilliSeconds: 800,
        statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
      );
    });

    LiveStream().on(LIVESTREAM_UPDATE_DASHBOARD, (p0) {
      init();
      appStore.setLoading(true);

      setState(() {});
    });
  }

  void init() async {
    future = userDashboard(isCurrentLocation: appStore.isCurrentLocation, lat: getDoubleAsync(LATITUDE), long: getDoubleAsync(LONGITUDE));
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
            loadingWidget: DashboardShimmer3(),
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
                    (context.statusBarHeight).toInt().height,
                    AppbarDashboardComponent3(
                      featuredList: snap.featuredServices.validate(),
                      callback: () async {
                        appStore.setLoading(true);

                        init();
                        setState(() {});
                      },
                    ),
                    Observer(
                      builder: (context) {
                        return AppButton(
                          padding: EdgeInsets.all(0),
                          width: context.width(),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: boxDecorationDefault(color: context.cardColor),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ic_location.iconImage(color: appStore.isDarkMode ? Colors.white : Colors.black, size: 24),
                                8.width,
                                Text(
                                  appStore.isCurrentLocation ? getStringAsync(CURRENT_ADDRESS) : language.lblLocationOff,
                                  style: secondaryTextStyle(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ).expand(),
                                8.width,
                                Icon(Icons.keyboard_arrow_down, size: 24, color: appStore.isCurrentLocation ? primaryColor : context.iconColor),
                              ],
                            ),
                          ),
                          onTap: () async {
                            locationWiseService(context, () {
                              appStore.setLoading(true);

                              init();
                              setState(() {});
                            });
                          },
                        ).cornerRadiusWithClipRRect(28);
                      },
                    ).paddingSymmetric(horizontal: 16),
                    24.height,
                    SliderDashboardComponent3(sliderList: snap.slider.validate()),
                    UpcomingBookingDashboardComponent3(upcomingBookingData: snap.upcomingData).paddingTop(16),
                    CategoryListDashboardComponent3(categoryList: snap.category.validate(), listTiTle: language.category),
                    if (snap.promotionalBanner.validate().isNotEmpty  && appConfigurationStore.isPromotionalBanner)
                      PromotionalBannerSliderComponent(
                        promotionalBannerList: snap.promotionalBanner.validate(),
                      ).paddingTop(16),
                    16.height,
                    ServiceListDashboardComponent3(serviceList: snap.service.validate(), serviceListTitle: language.popularServices),
                    14.height,
                    ServiceListDashboardComponent3(
                      serviceList: snap.featuredServices.validate(),
                      serviceListTitle: language.featuredServices,
                      isFeatured: true,
                    ),
                    16.height,
                    if (appConfigurationStore.jobRequestStatus) JobRequestDashboardComponent3(),
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