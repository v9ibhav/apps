import 'dart:async';

import 'package:booking_system_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../component/cached_image_widget.dart';
import '../../../../model/dashboard_model.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/configs.dart';
import '../../../../utils/constant.dart';
import '../../../utils/common.dart';
import '../../service/service_detail_screen.dart';

class PromotionalBannerSliderComponent extends StatefulWidget {
  final List<PromotionalBannerModel> promotionalBannerList;

  PromotionalBannerSliderComponent({required this.promotionalBannerList});

  @override
  _PromotionalBannerSliderComponentState createState() => _PromotionalBannerSliderComponentState();
}

class _PromotionalBannerSliderComponentState extends State<PromotionalBannerSliderComponent> {
  PageController sliderPageController = PageController(initialPage: 0);
  int _currentPage = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (getBoolAsync(AUTO_SLIDER_STATUS, defaultValue: true) && widget.promotionalBannerList.length >= 2) {
      _timer = Timer.periodic(Duration(seconds: DASHBOARD_AUTO_SLIDER_SECOND), (Timer timer) {
        if (_currentPage < widget.promotionalBannerList.length - 1) {
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
      height: 180,
      width: context.width(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.promotionalBannerList.isNotEmpty
              ? PageView(
                  controller: sliderPageController,
                  physics: ClampingScrollPhysics(),
                  children: List.generate(
                    widget.promotionalBannerList.length,
                    (index) {
                      PromotionalBannerModel data = widget.promotionalBannerList[index];
                      return CachedImageWidget(
                        url: data.image.validate(),
                        height: 190,
                        width: context.width() - 32,
                        fit: BoxFit.cover,
                      ).onTap(() {
                        if (data.bannerType == SERVICE) {
                          ServiceDetailScreen(serviceId: data.serviceId.validate().toInt()).launch(
                            context,
                            pageRouteAnimation: PageRouteAnimation.Fade,
                          );
                        } else if (data.bannerType == PROMOTIONAL_TYPE_LINK) {
                          commonLaunchUrl(
                            data.bannerRedirectUrl.validate(),
                            launchMode: LaunchMode.externalApplication,
                          );
                        }
                      });
                    },
                  ),
                )
              : CachedImageWidget(url: '', height: 190, width: context.width()),
          if (widget.promotionalBannerList.length.validate() > 1)
            Positioned(
              bottom: 6,
              left: 0,
              right: 0,
              child: DotIndicator(
                pageController: sliderPageController,
                pages: widget.promotionalBannerList,
                indicatorColor: primaryColor,
                unselectedIndicatorColor: appStore.isDarkMode ? context.cardColor : Colors.white,
                currentBoxShape: BoxShape.rectangle,
                boxShape: BoxShape.rectangle,
                borderRadius: radius(3),
                currentBorderRadius: radius(3),
                currentDotSize: 30,
                currentDotWidth: 6,
                dotSize: 6,
              ),
            ),
        ],
      ),
    );
  }
}
