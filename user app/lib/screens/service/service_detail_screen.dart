import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/component/online_service_icon_widget.dart';
import 'package:booking_system_flutter/component/price_widget.dart';
import 'package:booking_system_flutter/component/view_all_label_component.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/package_data_model.dart';
import 'package:booking_system_flutter/model/service_data_model.dart';
import 'package:booking_system_flutter/model/service_detail_response.dart';
import 'package:booking_system_flutter/model/slot_data.dart';
import 'package:booking_system_flutter/model/user_data_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/booking/book_service_screen.dart';
import 'package:booking_system_flutter/screens/booking/component/booking_detail_provider_widget.dart';
import 'package:booking_system_flutter/screens/booking/provider_info_screen.dart';
import 'package:booking_system_flutter/screens/review/components/review_widget.dart';
import 'package:booking_system_flutter/screens/review/rating_view_all_screen.dart';
import 'package:booking_system_flutter/screens/service/component/related_service_component.dart';
import 'package:booking_system_flutter/screens/service/component/service_detail_header_component.dart';
import 'package:booking_system_flutter/screens/service/component/service_faq_widget.dart';
import 'package:booking_system_flutter/screens/service/package/package_component.dart';
import 'package:booking_system_flutter/screens/service/shimmer/service_detail_shimmer.dart';
import 'package:booking_system_flutter/store/service_addon_store.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/images.dart';
import 'addons/service_addons_component.dart';

ServiceAddonStore serviceAddonStore = ServiceAddonStore();

class ServiceDetailScreen extends StatefulWidget {
  final int serviceId;
  final ServiceData? service;
  final bool isFromProviderInfo;

  ServiceDetailScreen({
    required this.serviceId,
    this.service,
    this.isFromProviderInfo = false,
  });

  @override
  _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> with TickerProviderStateMixin {
  PageController pageController = PageController();

  Future<ServiceDetailResponse>? future;

  int selectedAddressId = 0;
  int selectedBookingAddressId = -1;
  BookingPackage? selectedPackage;

  @override
  void initState() {
    super.initState();
    serviceAddonStore.selectedServiceAddon.clear();
    setStatusBarColor(transparentColor);
    init();
  }

  void init() async {
    future = getServiceDetails(serviceId: widget.serviceId.validate(), customerId: appStore.userId);
  }

  //region Widgets
  Widget availableWidget({required ServiceData data}) {
    if (data.serviceAddressMapping.validate().isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        Text(language.lblAvailableAt, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
        8.height,
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            spacing: 8,
            direction:Axis.vertical,
            runSpacing: 8,
            children: List.generate(
              data.serviceAddressMapping!.length,
              (index) {
                ServiceAddressMapping value = data.serviceAddressMapping![index];
                if (value.providerAddressMapping == null) return Offstage();
                bool isSelected = selectedAddressId == index;
                if (selectedBookingAddressId == -1) {
                  selectedBookingAddressId = data.serviceAddressMapping!.first.providerAddressId.validate();
                }
                return GestureDetector(
                  onTap: () {
                    selectedAddressId = index;
                    selectedBookingAddressId = value.providerAddressId.validate();
                    setState(() {});
                  },
                  child: Container(
                    decoration: boxDecorationDefault(
                        color: appStore.isDarkMode
                            ? isSelected
                                ? primaryColor
                                : Colors.black
                            : isSelected
                                ? primaryColor
                                : Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                      child: Text(
                        '${value.providerAddressMapping!.address.validate()}',
                        style: boldTextStyle(color: isSelected ? Colors.white : textPrimaryColorGlobal),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        8.height,
      ],
    );
  }

  Widget providerWidget({required UserData data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.lblAboutProvider, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
        16.height,
        BookingDetailProviderWidget(providerData: data).onTap(() async {
          await ProviderInfoScreen(providerId: data.id).launch(context);
          setStatusBarColor(Colors.transparent);
        }),
      ],
    ).paddingAll(16);
  }

  Widget serviceFaqWidget({required List<ServiceFaq> data}) {
    if (data.isEmpty) return Offstage();

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.height,
          ViewAllLabel(label: language.lblFaq, list: data),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length,
            padding: EdgeInsets.all(0),
            itemBuilder: (_, index) => ServiceFaqWidget(serviceFaq: data[index]),
          ),
          8.height,
        ],
      ),
    );
  }

  Widget slotsAvailable({required List<SlotData> data, required bool isSlotAvailable}) {
    if (!isSlotAvailable || data.where((element) => element.slot.validate().isNotEmpty).isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        Text(language.lblAvailableOnTheseDays, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
        8.height,
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: List.generate(data.where((element) => element.slot.validate().isNotEmpty).length, (index) {
            SlotData value = data.where((element) => element.slot.validate().isNotEmpty).toList()[index];

            return Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              decoration: boxDecorationDefault(
                color: context.cardColor,
                border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
              ),
              child: Text('${value.day.capitalizeFirstLetter()}', style: secondaryTextStyle(size: LABEL_TEXT_SIZE, color: primaryColor)),
            );
          }),
        ),
        8.height,
      ],
    );
  }

  Widget reviewWidget({required List<RatingData> data, required ServiceDetailResponse serviceDetailResponse}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          //label: language.review,
          label: '${language.review} (${serviceDetailResponse.serviceDetail!.totalReview})',
          list: data,
          onTap: () {
            RatingViewAllScreen(serviceId: widget.serviceId).launch(context);
          },
        ),
        data.isNotEmpty
            ? Wrap(
                children: List.generate(
                  data.length,
                  (index) => ReviewWidget(data: data[index]),
                ),
              ).paddingTop(8)
            : Text(language.lblNoReviews, style: secondaryTextStyle()),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  Widget relatedServiceWidget({required List<ServiceData> serviceList, required int serviceId}) {
    if (serviceList.isEmpty) return Offstage();

    serviceList.removeWhere((element) => element.id == serviceId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (serviceList.isNotEmpty)
          Text(
            language.lblRelatedServices,
            style: boldTextStyle(size: LABEL_TEXT_SIZE),
          ).paddingSymmetric(horizontal: 16),
        8.height,
        if (serviceList.isNotEmpty)
          ListView.builder(
            padding: EdgeInsets.all(8),
            shrinkWrap: true,
            itemCount: serviceList.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) => RelatedServiceComponent(
              serviceData: serviceList[index],
              width: appConfigurationStore.userDashboardType == DEFAULT_USER_DASHBOARD ? context.width() / 2 - 26 : 280,
            ).paddingOnly(bottom: 16, left: 8, right: 8),
          )
      ],
    );
  }

  //endregion

  void bookNow(ServiceDetailResponse serviceDetailResponse) {
    doIfLoggedIn(context, () {
      serviceDetailResponse.serviceDetail!.bookingAddressId = selectedBookingAddressId;
      BookServiceScreen(data: serviceDetailResponse, selectedPackage: selectedPackage).launch(context).then((value) {
        setStatusBarColor(transparentColor);
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(widget.isFromProviderInfo ? primaryColor : transparentColor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildBodyWidget(AsyncSnapshot<ServiceDetailResponse> snap) {
      if (snap.hasError) {
        return Text(snap.error.toString()).center();
      } else if (snap.hasData) {
        return AppScaffold(
          appBarTitle: snap.data!.serviceDetail?.categoryName.validate() ?? '',
          showLoader: false,
          child: Column(
            children: [
              Expanded(
                child: AnimatedScrollView(
                  padding: EdgeInsets.only(bottom: 120),
                  listAnimationType: ListAnimationType.FadeIn,
                  fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                  onSwipeRefresh: () async {
                    appStore.setLoading(true);
                    init();
                    setState(() {});
                    return await 2.seconds.delay;
                  },
                  children: [
                    8.height,
                    ServiceDetailHeaderComponent(serviceDetail: snap.data!.serviceDetail!),
                    4.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                if (snap.data!.serviceDetail!.isOnlineService) ...[OnlineServiceIconWidget(), 10.width],
                                Flexible(
                                    child: Container(
                                  decoration: BoxDecoration(
                                    color: appStore.isDarkMode ? Colors.black : lightPrimaryColor,
                                    borderRadius: radius(20),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  child: Text(
                                    (snap.data!.serviceDetail?.categoryName.validate() ?? ' '),
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                )),
                              ],
                            ).expand(),
                            TextIcon(
                              suffix: Row(
                                children: [
                                  Image.asset(
                                    ic_star_fill,
                                    height: 18,
                                    color: getRatingBarColor(snap.data!.serviceDetail!.totalRating.validate().toInt()),
                                  ),
                                  4.width,
                                  Text("${snap.data!.serviceDetail!.totalRating.validate().toStringAsFixed(1)}", style: boldTextStyle()),
                                ],
                              ),
                            ),
                          ],
                        ),
                        12.height,
                        Text(
                          snap.data!.serviceDetail!.name.validate(),
                          style: primaryTextStyle(weight: FontWeight.bold, size: 16),
                        ),
                        10.height,
                        if (convertToHourMinute(snap.data!.serviceDetail!.duration.validate()).isNotEmpty)
                          Row(
                            children: [
                              Text(language.duration, style: secondaryTextStyle()),
                              8.width,
                              Text(
                                "${convertToHourMinute(snap.data!.serviceDetail!.duration.validate())}",
                                style: secondaryTextStyle(weight: FontWeight.bold, color: textPrimaryColorGlobal),
                              )
                            ],
                          ),
                        10.height,
                        Row(
                          children: [
                            if (snap.data!.serviceDetail!.discount.validate() > 0)
                              PriceWidget(
                                size: 14,
                                price: snap.data!.serviceDetail!.getDiscountedPrice.validate(),
                              ).paddingRight(8),
                            PriceWidget(
                              size: snap.data!.serviceDetail!.discount != 0 ? 12 : 14,
                              price: snap.data!.serviceDetail!.price.validate(),
                              isLineThroughEnabled: snap.data!.serviceDetail!.discount != 0 ? true : false,
                              color: snap.data!.serviceDetail!.discount != 0 ? textSecondaryColorGlobal : primaryColor,
                            ),
                            10.width,
                            if (snap.data!.serviceDetail!.discount.validate() > 0)
                              Text(
                                "${snap.data!.serviceDetail!.discount.validate()}% ${language.lblOff}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(color: defaultActivityStatus, fontWeight: FontWeight.bold, fontSize: 12),
                              ).expand(),
                          ],
                        ),
                        10.height
                      ],
                    ).paddingSymmetric(horizontal: 16),
                    Container(
                      width: context.width(),
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: radius(),
                        border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          snap.data!.serviceDetail!.description.validate().isNotEmpty
                              ? ReadMoreText(
                                  snap.data!.serviceDetail!.description.validate(),
                                  style: secondaryTextStyle(),
                                  colorClickableText: context.primaryColor,
                                  textAlign: TextAlign.justify,
                                )
                              : Text(language.lblNotDescription, style: secondaryTextStyle()),
                          8.height,
                          slotsAvailable(
                            data: snap.data!.serviceDetail!.bookingSlots.validate(),
                            isSlotAvailable: snap.data!.serviceDetail!.isSlotAvailable,
                          ),
                          availableWidget(data: snap.data!.serviceDetail!),
                        ],
                      ),
                    ).paddingSymmetric(horizontal: 16, vertical: 8),
                    providerWidget(data: snap.data!.provider!),
                    if (snap.data!.serviceDetail!.servicePackage.validate().isNotEmpty)
                      PackageComponent(
                        servicePackage: snap.data!.serviceDetail!.servicePackage.validate(),
                        callBack: (v) {
                          if (v != null) {
                            selectedPackage = v;
                          } else {
                            selectedPackage = null;
                          }
                          bookNow(snap.data!);
                        },
                      ),
                    if (snap.data!.serviceaddon.validate().isNotEmpty)
                      AddonComponent(
                        serviceAddon: snap.data!.serviceaddon.validate(),
                        onSelectionChange: (v) {
                          serviceAddonStore.setSelectedServiceAddon(v);
                        },
                      ),
                    serviceFaqWidget(data: snap.data!.serviceFaq.validate()).paddingSymmetric(horizontal: 16),
                    reviewWidget(data: snap.data!.ratingData!, serviceDetailResponse: snap.data!),
                    24.height,
                    if (snap.data!.relatedService.validate().isNotEmpty)
                      relatedServiceWidget(
                        serviceList: snap.data!.relatedService.validate(),
                        serviceId: snap.data!.serviceDetail!.id.validate(),
                      ),
                  ],
                ),
              ),
              AppButton(
                onTap: () {
                  selectedPackage = null;
                  bookNow(snap.data!);
                },
                color: context.primaryColor,
                child: Text(language.lblBookNow, style: boldTextStyle(color: white)),
                width: context.width(),
                textColor: Colors.white,
              ).paddingSymmetric(horizontal: 16.0, vertical: 10.0)
            ],
          ),
        );
      }
      return ServiceDetailShimmer();
    }

    return FutureBuilder<ServiceDetailResponse>(
      initialData: listOfCachedData.firstWhere((element) => element?.$1 == widget.serviceId.validate(), orElse: () => null)?.$2,
      future: future,
      builder: (context, snap) {
        return Scaffold(
          body: Stack(
            children: [
              buildBodyWidget(snap),
              Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
            ],
          ),
        );
      },
    );
  }
}
