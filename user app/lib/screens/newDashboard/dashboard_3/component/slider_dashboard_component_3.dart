import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/cached_image_widget.dart';
import '../../../../model/dashboard_model.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/configs.dart';
import '../../../../utils/constant.dart';
import '../../../service/service_detail_screen.dart';

class SliderDashboardComponent3 extends StatefulWidget {
  final List<SliderModel> sliderList;

  SliderDashboardComponent3({required this.sliderList});

  @override
  _SliderDashboardComponent3State createState() => _SliderDashboardComponent3State();
}

class _SliderDashboardComponent3State extends State<SliderDashboardComponent3> {
  PageController sliderPageController = PageController(initialPage: 0);
  int _currentPage = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
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
    _timer?.cancel();
    sliderPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      width: context.width(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.sliderList.isNotEmpty
              ? PageView(
                  controller: sliderPageController,
                  physics: ClampingScrollPhysics(),
                  children: List.generate(
                    widget.sliderList.length,
                    (index) {
                      SliderModel data = widget.sliderList[index];
                      return CachedImageWidget(
                        url: data.sliderImage.validate(),
                        height: 190,
                        width: context.width() - 32,
                        fit: BoxFit.cover,
                      ).cornerRadiusWithClipRRect(8).onTap(() {
                        if (data.type == SERVICE) {
                          ServiceDetailScreen(serviceId: data.typeId.validate().toInt()).launch(
                            context,
                            pageRouteAnimation: PageRouteAnimation.Fade,
                          ).then((value) {
                            setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.dark, delayInMilliSeconds: 1000);
                          });
                        }
                      }).paddingSymmetric(horizontal: 16);
                    },
                  ),
                )
              : CachedImageWidget(url: '', height: 175, width: context.width()),
          if (widget.sliderList.length.validate() > 1)
            Positioned(
              bottom: -25,
              left: 0,
              right: 0,
              child: DotIndicator(
                pageController: sliderPageController,
                pages: widget.sliderList,
                indicatorColor: primaryColor,
                unselectedIndicatorColor: primaryLightColor,
                currentBoxShape: BoxShape.rectangle,
                boxShape: BoxShape.rectangle,
                borderRadius: radius(2),
                currentBorderRadius: radius(3),
                currentDotSize: 18,
                currentDotWidth: 6,
                dotSize: 6,
              ),
            ),
        ],
      ),
    );
  }
}
