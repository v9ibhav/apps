import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/cached_image_widget.dart';
import '../../../../model/dashboard_model.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/constant.dart';
import '../../../service/service_detail_screen.dart';

class SliderDashboardComponent2 extends StatefulWidget {
  final List<SliderModel> sliderList;

  SliderDashboardComponent2({required this.sliderList});

  @override
  _SliderDashboardComponent2State createState() => _SliderDashboardComponent2State();
}

class _SliderDashboardComponent2State extends State<SliderDashboardComponent2> {
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.sliderList.isNotEmpty
            ? CarouselSlider(
                items: List.generate(widget.sliderList.length, (index) {
                  SliderModel data = widget.sliderList[index];
                  return CachedImageWidget(
                    url: data.sliderImage.validate(),
                    height: 200,
                    width: context.width(),
                    radius: 8,
                    fit: BoxFit.cover,
                  ).onTap(() {
                    if (data.type == SERVICE) {
                      ServiceDetailScreen(serviceId: data.typeId.validate().toInt()).launch(
                        context,
                        pageRouteAnimation: PageRouteAnimation.Fade,
                      );
                    }
                  });
                }),
                options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
              )
            : CachedImageWidget(url: '', height: 200, width: context.width()),
        if (widget.sliderList.length.validate() > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.sliderList.length,
              (index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 0),
                height: 4,
                width: 30,
                decoration: BoxDecoration(
                  color: _currentPage == index ? primaryColor : context.cardColor,
                  borderRadius: index == 0
                      ? BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          topRight: Radius.circular(_currentPage == index ? 5 : 0),
                          bottomRight: Radius.circular(_currentPage == index ? 5 : 0),
                        )
                      : widget.sliderList.length - 1 == index
                          ? BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                              bottomLeft: Radius.circular(_currentPage == index ? 5 : 0),
                              topLeft: Radius.circular(_currentPage == index ? 5 : 0),
                            )
                          : BorderRadius.circular(_currentPage == index ? 5 : 0),
                ),
              ),
            ),
          ).paddingTop(16),
      ],
    );
  }
}
