import 'dart:async';

import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/cached_image_widget.dart';
import '../../../../main.dart';
import '../../../../model/dashboard_model.dart';
import '../../../../model/service_data_model.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common.dart';
import '../../../../utils/configs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/images.dart';
import '../../../notification/notification_screen.dart';
import '../../../service/search_service_screen.dart';
import '../../../service/service_detail_screen.dart';

class SliderDashboardComponent1 extends StatefulWidget {
  final List<SliderModel> sliderList;
  final List<ServiceData>? featuredList;
  final VoidCallback? callback;

  SliderDashboardComponent1({required this.sliderList, this.callback, this.featuredList});

  @override
  _SliderDashboardComponent1State createState() => _SliderDashboardComponent1State();
}

class _SliderDashboardComponent1State extends State<SliderDashboardComponent1> {
  PageController sliderPageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (getBoolAsync(AUTO_SLIDER_STATUS, defaultValue: true) && widget.sliderList.length >= 2) {
      _timer = Timer.periodic(Duration(seconds: DASHBOARD_AUTO_SLIDER_SECOND), (Timer timer) {
        if (_currentPage < widget.sliderList.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        sliderPageController.animateToPage(_currentPage, duration: Duration(milliseconds: 950), curve: Curves.easeOutQuart);
      });

      sliderPageController.addListener(() {
        _currentPage = sliderPageController.page!.toInt();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    sliderPageController.dispose();
  }

  Widget getSliderWidget() {
    return SizedBox(
      height: 300,
      width: context.width(),
      child: Stack(
        children: [
          widget.sliderList.isNotEmpty
              ? PageView(
                  controller: sliderPageController,
                  children: List.generate(
                    widget.sliderList.length,
                    (index) {
                      SliderModel data = widget.sliderList[index];
                      return CachedImageWidget(url: data.sliderImage.validate(), height: 250, width: context.width(), fit: BoxFit.cover).onTap(() {
                        if (data.type == SERVICE) {
                          ServiceDetailScreen(serviceId: data.typeId.validate().toInt()).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                        }
                      });
                    },
                  ),
                )
              : CachedImageWidget(url: '', height: 250, width: context.width()),
          if (widget.sliderList.length.validate() > 1)
            Positioned(
              bottom: 25,
              left: 16,
              child: DotIndicator(
                pageController: sliderPageController,
                pages: widget.sliderList,
                indicatorColor: primaryColor,
                unselectedIndicatorColor: white,
                currentBoxShape: BoxShape.rectangle,
                boxShape: BoxShape.rectangle,
                borderRadius: radius(16),
                currentBorderRadius: radius(16),
                currentDotSize: 70,
                currentDotWidth: 20,
                dotSize: 40,
              ).scale(scale: 0.4),
            ),
          if (appStore.isLoggedIn)
            Positioned(
              top: context.statusBarHeight + 16,
              right: 16,
              child: Container(
                decoration: boxDecorationDefault(color: context.cardColor, shape: BoxShape.circle),
                height: 36,
                padding: EdgeInsets.all(8),
                width: 36,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ic_notification.iconImage(size: 24, color: primaryColor).center(),
                    Observer(builder: (context) {
                      return Positioned(
                        top: -20,
                        right: -10,
                        child: appStore.unreadCount.validate() > 0
                            ? Container(
                                padding: EdgeInsets.all(4),
                                child: FittedBox(
                                  child: Text(appStore.unreadCount.toString(), style: primaryTextStyle(size: 12, color: Colors.white)),
                                ),
                                decoration: boxDecorationDefault(color: Colors.red, shape: BoxShape.circle),
                              )
                            : Offstage(),
                      );
                    })
                  ],
                ),
              ).onTap(() {
                NotificationScreen().launch(context);
              }),
            )
        ],
      ),
    );
  }

  Decoration get commonDecoration {
    return boxDecorationDefault(
      color: context.cardColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getSliderWidget(),
        Row(
          children: [
            Observer(
              builder: (context) {
                return AppButton(
                  padding: EdgeInsets.all(0),
                  width: context.width(),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: commonDecoration,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ic_location.iconImage(color: appStore.isDarkMode ? Colors.white : Colors.black),
                        8.width,
                        Text(
                          appStore.isCurrentLocation ? getStringAsync(CURRENT_ADDRESS) : language.lblLocationOff,
                          style: secondaryTextStyle(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ).expand(),
                        8.width,
                        ic_active_location.iconImage(size: 24, color: appStore.isCurrentLocation ? primaryColor : grey),
                      ],
                    ),
                  ),
                  onTap: () async {
                    locationWiseService(context, () {
                      widget.callback?.call();
                    });
                  },
                );
              },
            ).expand(),
            16.width,
            GestureDetector(
              onTap: () {
                SearchServiceScreen(featuredList: widget.featuredList).launch(context);
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: commonDecoration,
                child: ic_search.iconImage(color: primaryColor),
              ),
            ),
          ],
        ).paddingAll(16),
      ],
    );
  }
}
