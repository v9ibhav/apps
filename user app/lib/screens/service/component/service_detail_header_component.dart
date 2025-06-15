import 'dart:async';

import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/service_data_model.dart';
import 'package:booking_system_flutter/screens/auth/sign_in_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceDetailHeaderComponent extends StatefulWidget {
  final ServiceData serviceDetail;
  final List<ServiceData>? featuredList;

  const ServiceDetailHeaderComponent({
    required this.serviceDetail,
    this.featuredList,
    Key? key,
  }) : super(key: key);

  @override
  State<ServiceDetailHeaderComponent> createState() => _ServiceDetailHeaderComponentState();
}

class _ServiceDetailHeaderComponentState extends State<ServiceDetailHeaderComponent> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoSliderTimer;

  @override
  void initState() {
    super.initState();
    _startAutoSlider();
  }

  void _startAutoSlider() {
    _autoSliderTimer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (widget.serviceDetail.attachments.validate().isNotEmpty) {
        _currentPage = (_currentPage + 1) % widget.serviceDetail.attachments!.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> onTapFavourite() async {
    if (widget.serviceDetail.isFavourite == 1) {
      widget.serviceDetail.isFavourite = 0;
      setState(() {});

      await removeToWishList(serviceId: widget.serviceDetail.id.validate()).then((value) {
        if (!value) {
          widget.serviceDetail.isFavourite = 1;
          setState(() {});
        }
      });
    } else {
      widget.serviceDetail.isFavourite = 1;
      setState(() {});

      await addToWishList(serviceId: widget.serviceDetail.id.validate()).then((value) {
        if (!value) {
          widget.serviceDetail.isFavourite = 0;
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _autoSliderTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attachments = widget.serviceDetail.attachments.validate();
    final hasMultipleImages = attachments.isNotEmpty && attachments.length > 1;

    return SizedBox(
      height: 250,
      width: context.width(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (attachments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: SizedBox(
                height: 250,
                width: context.width(),
                child: hasMultipleImages
                    ? PageView.builder(
                        controller: _pageController,
                        itemCount: attachments.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return CachedImageWidget(
                            radius: defaultRadius,
                            url: attachments[index],
                            fit: BoxFit.cover,
                            height: 350,
                          );
                        },
                      )
                    : CachedImageWidget(
                        radius: defaultRadius,
                        url: attachments.first,
                        fit: BoxFit.cover,
                        height: 350,
                      ),
              ),
            ),
          if (hasMultipleImages)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  padding: const EdgeInsets.symmetric( horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DotIndicator(
                        pageController: _pageController,
                        pages: attachments,
                        indicatorColor: primaryColor,
                        unselectedIndicatorColor: lineTextColor,
                        currentDotSize: 12,
                        dotSize: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            top: 20,
            right: 28,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: boxDecorationWithShadow(
                boxShape: BoxShape.circle,
                backgroundColor: context.cardColor,
              ),
              child: widget.serviceDetail.isFavourite == 1 ? ic_fill_heart.iconImage(color: favouriteColor, size: 24) : ic_heart.iconImage(color: unFavouriteColor, size: 24),
            ).onTap(() async {
              if (appStore.isLoggedIn) {
                onTapFavourite();
              } else {
                push(SignInScreen(returnExpected: true)).then((value) {
                  setStatusBarColor(transparentColor, delayInMilliSeconds: 1000);
                  if (value) {
                    onTapFavourite();
                  }
                });
              }
            }, highlightColor: Colors.transparent, splashColor: Colors.transparent, hoverColor: Colors.transparent),
          ),
        ],
      ),
    );
  }
}
