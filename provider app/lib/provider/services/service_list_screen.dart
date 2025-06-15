import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/components/service_widget.dart';
import 'package:handyman_provider_flutter/provider/services/add_services.dart';
import 'package:handyman_provider_flutter/provider/services/service_detail_screen.dart';
import 'package:handyman_provider_flutter/provider/services/shimmer/service_list_shimmer.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';
import '../../utils/configs.dart';
import '../../utils/constant.dart';
import 'model/service_list_approval_status_model.dart';

class ServiceListScreen extends StatefulWidget {
  @override
  _ServiceListScreenState createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  TextEditingController searchList = TextEditingController();

  List<ServiceData> services = [];
  Future<List<ServiceData>>? future;

  // Status Tab
  List<ServiceListApprovalStatusModel> serviceApprovalStatus = [];
  ServiceListApprovalStatusModel selectedTab = ServiceListApprovalStatusModel();

  int page = 1;

  bool changeListType = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    serviceApprovalStatus = [
      ServiceListApprovalStatusModel(status: ServiceListApprovalStatus.all, name: SERVICE_ALL),
      ServiceListApprovalStatusModel(status: ServiceListApprovalStatus.pending, name: SERVICE_PENDING),
      ServiceListApprovalStatusModel(status: ServiceListApprovalStatus.approved, name: SERVICE_APPROVE),
      ServiceListApprovalStatusModel(status: ServiceListApprovalStatus.reject, name: SERVICE_REJECT),
    ];

    selectedTab = serviceApprovalStatus.first;
    getServiceListAPI(status: selectedTab.name);
  }

  void getServiceListAPI({String status = ""}) {
    future = getSearchList(
      page,
      status: status.toLowerCase() != SERVICE_ALL ? status.toLowerCase() : '',
      search: searchList.text,
      perPage: 10,
      providerId: appStore.userId,
      services: services,
      lastPageCallback: (b) {
        isLastPage = b;
      },
    );
  }
  List<ServiceListApprovalStatusModel> servicesRequestStatus = [];

  Future<void> getFilterList() async {
    servicesRequestStatus = [
      ServiceListApprovalStatusModel(status: ServiceListApprovalStatus.all, name: ServiceRequestKey.all),
      ServiceListApprovalStatusModel(status: ServiceListApprovalStatus.pending, name: ServiceRequestKey.pending),
      ServiceListApprovalStatusModel(status: ServiceListApprovalStatus.approved, name: ServiceRequestKey.approve),
      ServiceListApprovalStatusModel(status: ServiceListApprovalStatus.reject, name: ServiceRequestKey.reject),
    ];

    selectedTab = servicesRequestStatus.first;
    await init();
  }

  void setPageToOne({String status = ""}) {
    page = 1;
    appStore.setLoading(true);

    getServiceListAPI(status: status);
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        languages.lblAllService,
        textColor: white,
        color: context.primaryColor,
        backWidget: BackWidget(),
        textSize: APP_BAR_TEXT_SIZE,
        actions: [
          IconButton(
            onPressed: () {
              changeListType = !changeListType;
              setState(() {});
            },
            icon: Image.asset(changeListType ? list : grid, height: 20, width: 20),
          ),
          IconButton(
            onPressed: () async {
              bool? res;

              res = await AddServices().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);

              if (res ?? false) {
                selectedTab = serviceApprovalStatus.first;
                setPageToOne(status: selectedTab.name);
              }
            },
            icon: Icon(Icons.add, size: 28, color: white),
            tooltip: languages.hintAddService,
          ).visible(rolesAndPermissionStore.serviceAdd),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              AppTextField(
                textFieldType: TextFieldType.OTHER,
                controller: searchList,
                onFieldSubmitted: (s) {
                  selectedTab = serviceApprovalStatus.first;
                  setPageToOne(status: selectedTab.name);
                },
                decoration: InputDecoration(
                  hintText: languages.lblSearchHere,
                  prefixIcon: Icon(Icons.search, color: context.iconColor, size: 20),
                  hintStyle: secondaryTextStyle(),
                  border: OutlineInputBorder(borderRadius: radius(8), borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                  filled: true,
                  contentPadding: EdgeInsets.all(16),
                  fillColor: appStore.isDarkMode ? cardDarkColor : cardColor,
                ),
              ).paddingOnly(left: 16, right: 16, top: 16, bottom: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: HorizontalList(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  spacing: 16,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: serviceApprovalStatus.length,
                  itemBuilder: (ctx, index) {
                    ServiceListApprovalStatusModel serviceStatus = serviceApprovalStatus[index];
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FilterChip(
                          shape: RoundedRectangleBorder(
                            borderRadius: radius(8),
                            side: BorderSide(color: selectedTab.status == serviceStatus.status ? primaryColor : Colors.transparent),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          label: Text(
                            serviceStatus.name.toServiceApprovalStatusText(),
                            style: boldTextStyle(
                              size: 12,
                              color: selectedTab.status == serviceStatus.status
                                  ? primaryColor
                                  : appStore.isDarkMode
                                      ? Colors.white
                                      : appTextPrimaryColor,
                            ),
                          ),
                          selected: false,
                          backgroundColor: selectedTab.status == serviceStatus.status ? lightPrimaryColor : context.cardColor,
                          onSelected: (bool selected) {
                            selectedTab = serviceApprovalStatus[index];
                            setPageToOne(status: selectedTab.name);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ).paddingOnly(bottom: 4),
              SnapHelperWidget<List<ServiceData>>(
                future: future,
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    imageWidget: ErrorStateWidget(),
                    retryText: languages.reload,
                    onRetry: () {
                      setPageToOne(status: selectedTab.name);
                    },
                  );
                },
                loadingWidget: ServiceListShimmer(width: changeListType ? context.width() : context.width() * 0.5 - 24),
                onSuccess: (list) {
                  if (list.isEmpty) {
                    return NoDataWidget(
                      title: languages.noServiceFound,
                      subTitle: languages.noServiceSubTitle,
                      imageWidget: EmptyStateWidget(),
                    );
                  }

                  return AnimatedScrollView(
                    listAnimationType: ListAnimationType.FadeIn,
                    fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                    physics: AlwaysScrollableScrollPhysics(),
                    onSwipeRefresh: () async {
                      page = 1;

                      getServiceListAPI(status: selectedTab.name);
                      setState(() {});

                      return await 2.seconds.delay;
                    },
                    onNextPage: () {
                      if (!isLastPage) {
                        page++;
                        appStore.setLoading(true);
                        getServiceListAPI(status: selectedTab.name);
                        setState(() {});
                      }
                    },
                    children: [
                      if (services.isNotEmpty)
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 24),
                          child: AnimatedWrap(
                            spacing: 16.0,
                            runSpacing: 16.0,
                            scaleConfiguration: ScaleConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
                            listAnimationType: ListAnimationType.FadeIn,
                            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                            alignment: WrapAlignment.start,
                            itemCount: services.length,
                            itemBuilder: (context, index) {
                              return ServiceComponent(
                                data: services[index],
                                width: changeListType ? context.width() : context.width() * 0.5 - 24,
                                changeList: changeListType,
                                  showApprovalStatus: selectedTab.status == ServiceListApprovalStatus.all && services[index].serviceRequestStatus != ServiceRequestKey.approve,
                                onCallBack: () {
                                  page = 1;
                                  appStore.setLoading(true);
                                  getServiceListAPI(status: selectedTab.name);
                                  setState(() {});
                                },
                              ).onTap(() async {
                                await ServiceDetailScreen(serviceId: services[index].id.validate()).launch(context).then((value) {
                                  if (value != null) {
                                    setPageToOne();
                                  }
                                });
                              }, borderRadius: radius());
                            },
                          ),
                        ),
                    ],
                  );
                },
              ).expand(),
            ],
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
        ],
      ),
    );
  }
}