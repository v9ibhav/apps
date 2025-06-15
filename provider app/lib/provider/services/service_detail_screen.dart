import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handyman_provider_flutter/components/review_list_view_component.dart';
import 'package:handyman_provider_flutter/components/view_all_label_component.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/models/service_detail_response.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/packages/components/package_component.dart';
import 'package:handyman_provider_flutter/provider/services/components/service_detail_header_component.dart';
import 'package:handyman_provider_flutter/provider/services/components/service_faq_widget.dart';
import 'package:handyman_provider_flutter/screens/rating_view_all_screen.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/back_widget.dart';
import '../../components/empty_error_state_widget.dart';
import '../../utils/colors.dart';
import 'shimmer/service_detail_shimmer.dart';

class ServiceDetailScreen extends StatefulWidget {
  final int serviceId;

  ServiceDetailScreen({required this.serviceId});

  @override
  ServiceDetailScreenState createState() => ServiceDetailScreenState();
}

class ServiceDetailScreenState extends State<ServiceDetailScreen> {
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(transparentColor, delayInMilliSeconds: 1000);
  }

  Widget serviceFaqWidget({required List<ServiceFaq> data}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          12.height,
          ViewAllLabel(label: languages.lblFAQs, list: data).paddingSymmetric(horizontal: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: data.length,
            itemBuilder: (_, index) {
              return ServiceFaqWidget(serviceFaq: data[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget customerReviewWidget({required List<RatingData> data, int? serviceId, required ServiceDetailResponse serviceDetailResponse}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        ViewAllLabel(
          label: '${languages.review} (${serviceDetailResponse.serviceDetail!.totalReview})',
          list: data,
          onTap: () {
            RatingViewAllScreen(serviceId: serviceId).launch(context).then((value) => init());
          },
        ),
        8.height,
        data.isNotEmpty
            ? ReviewListViewComponent(
                ratings: data,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 6),
              )
            : Text(languages.lblNoReviewYet, style: secondaryTextStyle()),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  Widget availableWidget({required ServiceData data}) {
    if (data.serviceAddressMapping.validate().isEmpty) return Offstage();

    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(languages.availableAt, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
          16.height,
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(
              data.serviceAddressMapping!.length,
              (index) {
                ServiceAddressMapping value = data.serviceAddressMapping![index];
                if (value.providerAddressMapping == null) return Offstage();

                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: boxDecorationDefault(color: context.cardColor),
                  child: Text(
                    '${value.providerAddressMapping!.address.validate()}',
                    style: boldTextStyle(color: textPrimaryColorGlobal),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Widget buildBodyWidget(AsyncSnapshot<ServiceDetailResponse> snap) {
    if (snap.hasData) {
      return Scaffold(
        body: AnimatedScrollView(
          padding: EdgeInsets.only(bottom: 120),
          listAnimationType: ListAnimationType.FadeIn,
          fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ServiceDetailHeaderComponent(
              serviceDetail: snap.data!.serviceDetail!,
              voidCallback: () {
                setState(() {});
              },
            ),
            if (snap.data!.serviceDetail!.isOnlineService)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.height,
                  Text(languages.serviceVisitType, style: boldTextStyle()),
                  8.height,
                  Text(languages.thisServiceIsOnlineRemote, style: secondaryTextStyle()),
                ],
              ).paddingAll(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(languages.hintDescription, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                8.height,
                snap.data!.serviceDetail!.description.validate().isNotEmpty
                    ? ReadMoreText(
                        snap.data!.serviceDetail!.description.validate(),
                        style: secondaryTextStyle(),
                        textAlign: TextAlign.justify,
                        colorClickableText: context.primaryColor,
                      )
                    : Text(languages.lblNoDescriptionAvailable, style: secondaryTextStyle()),
              ],
            ).paddingAll(16),
            availableWidget(data: snap.data!.serviceDetail!),
            PackageComponent(servicePackage: snap.data!.serviceDetail!.servicePackage.validate()),
            if (snap.data!.serviceFaq.validate().isNotEmpty) serviceFaqWidget(data: snap.data!.serviceFaq.validate()),
            customerReviewWidget(data: snap.data!.ratingData!, serviceId: snap.data!.serviceDetail!.id, serviceDetailResponse: snap.data!),
            24.height,
            /// Service Approval and Rejection UI
            if (snap.data!.serviceDetail!.serviceRequestStatus == SERVICE_PENDING)
            RichText(
              text: TextSpan(
                style: secondaryTextStyle(),
                children: <TextSpan>[
                  TextSpan(
                    text: '${languages.note} ',
                    style: boldTextStyle(color: redColor),
                  ),
                  TextSpan(text: languages.thisServiceIsCurrently, style: secondaryTextStyle()),
                ],
              ),
            ).paddingOnly(left: 16, right: 16, bottom: 16),
            if (snap.data!.serviceDetail!.serviceRequestStatus == SERVICE_REJECT)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${languages.lblReason} :', style: boldTextStyle(color: redColor)),
                8.height,
                Text(snap.data!.serviceDetail!.rejectReason.validate(), style: secondaryTextStyle()),
                16.height,
                AppButton(
                  text: languages.lblDelete,
                  width: context.width(),
                  color: cancelled.withValues(alpha: 0.1),
                  textStyle: boldTextStyle(color: cancelled),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  onTap: () {
                    showConfirmDialogCustom(
                      context,
                      dialogType: DialogType.DELETE,
                      title: languages.doWantToDelete,
                      positiveText: languages.lblDelete,
                      negativeText: languages.lblCancel,
                      onAccept: (context) async {
                        if (snap.data != null) {
                          /// Service Delete API
                          //TODO: check this API after approval status and reason set from API
                          ifNotTester(context, () {
                            appStore.setLoading(true);
                            deleteService(widget.serviceId.validate()).then((value) {
                              getServiceDetail({'service_id': widget.serviceId.validate()});
                              finish(context, true);
                            }).catchError((e) {
                              appStore.setLoading(false);
                              toast(e.toString(), print: true);
                            });
                          });
                        }
                      },
                    );
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
          ],
        ),
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: snap.connectionState == ConnectionState.waiting
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: transparentColor,
              leading: Container(
                  margin: EdgeInsets.only(left: 6),
                  padding: EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: BackWidget(color: context.iconColor)),
              scrolledUnderElevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
                statusBarColor: context.scaffoldBackgroundColor,
              ),
            ),
      body: snapWidgetHelper(
        snap,
        loadingWidget: ServiceDetailShimmer(),
        errorWidget: NoDataWidget(
          title: snap.error.toString(),
          imageWidget: ErrorStateWidget(),
          retryText: languages.reload,
          onRetry: () {
            getServiceDetail({'service_id': widget.serviceId.validate()});
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ServiceDetailResponse>(
      initialData: listOfCachedData.firstWhere((element) => element?.$1 == widget.serviceId.validate(), orElse: () => null)?.$2,
      future: getServiceDetail({'service_id': widget.serviceId.validate()}),
      builder: (context, snap) {
        return buildBodyWidget(snap);
      },
    );
  }
}
