import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_provider_flutter/provider/promotional_banner/shimmer/promotional_banner_list_shimmer.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_widgets.dart';
import '../../components/empty_error_state_widget.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/configs.dart';
import '../../utils/constant.dart';
import '../../utils/images.dart';
import 'add_promotional_banner_screen.dart';
import 'components/promotional_banner_item_component.dart';
import 'model/promotional_banner_response.dart';
import 'model/promotional_banner_status_model.dart';
import 'promotional_banner_repository.dart';

class PromotionalBannerListScreen extends StatefulWidget {
  @override
  _PromotionalBannerListScreenState createState() => _PromotionalBannerListScreenState();
}

class _PromotionalBannerListScreenState extends State<PromotionalBannerListScreen> {
  Future<List<PromotionalBannerListData>>? future;

  List<PromotionalBannerListData> promotionalBannerListData = [];

  // Status Tab
  List<PromotionalBannerStatusModel> promotionalBannerStatus = [];
  PromotionalBannerStatusModel selectedTab = PromotionalBannerStatusModel();

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    promotionalBannerStatus = [
      PromotionalBannerStatusModel(status: PROMOTIONAL_BANNER_ALL, name: languages.all),
      PromotionalBannerStatusModel(status: PROMOTIONAL_BANNER_PENDING, name: languages.pending),
      PromotionalBannerStatusModel(status: PROMOTIONAL_BANNER_REJECT, name: languages.rejected),
    ];

    selectedTab = promotionalBannerStatus.first;
    getPromotionalBannerListAPI(status: selectedTab.status);
  }

  void getPromotionalBannerListAPI({String status = ""}) {
    future = getPromotionalBannerList(
      promotionalBannerListData: promotionalBannerListData,
      status: status,
      page: page,
      lastPageCallback: (b) {
        isLastPage = b;
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.promotionalBanner,
      actions: [
        IconButton(
          onPressed: () async {
            AddPromotionalBannerScreen(
              callback: (p0) {
                selectedTab = promotionalBannerStatus.first;
                page = 1;
                appStore.setLoading(true);
                getPromotionalBannerListAPI(status: selectedTab.status);
                setState(() {});
              },
            ).launch(context);
          },
          icon: Icon(Icons.add, size: 28, color: white),
        ),
      ],
      showLoader: false,
      body: Stack(
        children: [
          Column(
            children: [
              16.height,
              Align(
                alignment: Alignment.centerLeft,
                child: HorizontalList(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  spacing: 16,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: promotionalBannerStatus.length,
                  itemBuilder: (ctx, index) {
                    PromotionalBannerStatusModel filterStatus = promotionalBannerStatus[index];
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FilterChip(
                          shape: RoundedRectangleBorder(
                            borderRadius: radius(defaultRadius),
                            side: BorderSide(color: selectedTab.status == filterStatus.status ? primaryColor : Colors.transparent),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          label: Text(
                            filterStatus.name,
                            style: boldTextStyle(
                              size: 12,
                              color: selectedTab.status == filterStatus.status
                                  ? primaryColor
                                  : appStore.isDarkMode
                                      ? Colors.white
                                      : appTextPrimaryColor,
                            ),
                          ),
                          backgroundColor: selectedTab.status == filterStatus.status ? lightPrimaryColor : context.cardColor,
                          onSelected: (bool selected) {
                            selectedTab = filterStatus;
                            page = 1;
                            appStore.setLoading(true);
                            getPromotionalBannerListAPI(status: selectedTab.status);
                            setState(() {});
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              SnapHelperWidget<List<PromotionalBannerListData>>(
                initialData: cachedPromotionalBannerListData,
                future: future,
                loadingWidget: PromotionalBannerListShimmer(),
                onSuccess: (promotionBannerList) {
                  return AnimatedListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    shrinkWrap: true,
                    listAnimationType: ListAnimationType.FadeIn,
                    fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                    itemCount: promotionBannerList.length,
                    emptyWidget: appStore.isLoading
                        ? Offstage()
                        : NoDataWidget(
                            title: selectedTab.status == PROMOTIONAL_BANNER_ALL ? languages.noPromotionalBannerYet : languages.promotionalBannerYet(selectedTab.name),
                            titleTextStyle: boldTextStyle(),
                            subTitle: (selectedTab.status == PROMOTIONAL_BANNER_ALL || selectedTab.status == PROMOTIONAL_BANNER_PENDING)
                                ? languages.toSubmitYourBanner : languages.noRecordsFoundForBanner(selectedTab.name.toLowerCase()),
                            imageWidget: (selectedTab.status == PROMOTIONAL_BANNER_ALL || selectedTab.status == PROMOTIONAL_BANNER_PENDING)
                                ? ic_outline_banner.iconImage(
                                    size: 60,
                                    color: appStore.isDarkMode ? white.withValues(alpha: 0.9) : appTextSecondaryColor.withValues(alpha: 0.8),
                                  )
                                : EmptyStateWidget(),
                            retryText: (selectedTab.status == PROMOTIONAL_BANNER_ALL || selectedTab.status == PROMOTIONAL_BANNER_PENDING) ? languages.hintAdd : null,
                            onRetry: (selectedTab.status == PROMOTIONAL_BANNER_ALL || selectedTab.status == PROMOTIONAL_BANNER_PENDING)
                                ? () {
                                    if (selectedTab.status == PROMOTIONAL_BANNER_ALL || selectedTab.status == PROMOTIONAL_BANNER_PENDING) {
                                      AddPromotionalBannerScreen(
                                        callback: (p0) {
                                          selectedTab = promotionalBannerStatus.first;
                                          page = 1;
                                          appStore.setLoading(true);
                                          getPromotionalBannerListAPI(status: selectedTab.status);
                                          setState(() {});
                                        },
                                      ).launch(context);
                                    }
                                  }
                                : null,
                          ).paddingSymmetric(horizontal: 16),
                    onNextPage: () {
                      if (!isLastPage) {
                        page++;
                        appStore.setLoading(true);

                        getPromotionalBannerListAPI(status: selectedTab.status);
                        setState(() {});
                      }
                    },
                    onSwipeRefresh: () async {
                      page = 1;

                      getPromotionalBannerListAPI(status: selectedTab.status);
                      setState(() {});

                      return await 2.seconds.delay;
                    },
                    disposeScrollController: true,
                    itemBuilder: (BuildContext context, index) {
                      return PromotionalBannerItemComponent(
                        promotionalBannerData: promotionBannerList[index],
                        selectedStatus: selectedTab.status,
                        onCallBack: () {
                          page = 1;
                          appStore.setLoading(true);

                          getPromotionalBannerListAPI(status: selectedTab.status);
                          setState(() {});
                        },
                      );
                    },
                  );
                },
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    imageWidget: ErrorStateWidget(),
                    retryText: languages.reload,
                    onRetry: () {
                      page = 1;
                      appStore.setLoading(true);

                      getPromotionalBannerListAPI(status: selectedTab.status);
                      setState(() {});
                    },
                  );
                },
              ).expand(),
            ],
          ),
          Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
