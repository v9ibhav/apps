import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/service_detail_response.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/booking/component/coupon_card_widget.dart';
import 'package:booking_system_flutter/screens/booking/shimmer/coupon_list_shimmer.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';
import '../../../model/coupon_list_model.dart';

class CouponsScreen extends StatefulWidget {
  final int serviceId;
  final CouponData? appliedCouponData;
  final num? servicePrice;

  CouponsScreen({required this.serviceId, this.servicePrice, this.appliedCouponData});

  @override
  _CouponsScreenState createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  Future<CouponListResponse>? future;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init({Map? req}) async {
    future = getCouponList(serviceId: widget.serviceId);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.coupons,
      child: SnapHelperWidget<CouponListResponse>(
        future: future,
        loadingWidget: CouponListShimmer(),
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
          ).center();
        },
        onSuccess: (couponsRes) {
          if (couponsRes.validCupon.isEmpty)
            return NoDataWidget(
              title: language.lblNoCouponsAvailable,
              subTitle: language.noCouponsAvailableMsg,
              imageWidget: EmptyStateWidget(),
            ).center();
          else
            return AnimatedListView(
              shrinkWrap: true,
              itemCount: couponsRes.validCupon.length,
              slideConfiguration: sliderConfigurationGlobal,
              listAnimationType: ListAnimationType.FadeIn,
              fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
              emptyWidget: NoDataWidget(
                title: language.lblNoCouponsAvailable,
                subTitle: language.noCouponsAvailableMsg,
                imageWidget: EmptyStateWidget(),
              ),
              onSwipeRefresh: () {
                appStore.setLoading(true);

                init();
                setState(() {});
                return 2.seconds.delay;
              },
              itemBuilder: (context, index) {
                CouponData data = couponsRes.validCupon[index];
                if (widget.appliedCouponData != null && widget.appliedCouponData!.code == data.code) {
                  data.isApplied = widget.appliedCouponData!.isApplied;
                }
                return CouponCardWidget(data: data, servicePrice: widget.servicePrice).paddingOnly(top: 16);
              },
            );
        },
      ).paddingSymmetric(horizontal: 8),
    );
  }
}
