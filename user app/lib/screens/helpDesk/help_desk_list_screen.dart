import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/screens/helpDesk/model/help_desk_status_model.dart';
import 'package:booking_system_flutter/screens/helpDesk/shimmer/help_desk_list_shimmer.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/empty_error_state_widget.dart';
import '../../component/loader_widget.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/constant.dart';
import '../../utils/images.dart';
import 'add_help_desk_screen.dart';
import 'components/help_desk_item_component.dart';
import 'help_desk_repository.dart';
import 'model/help_desk_response.dart';

class HelpDeskListScreen extends StatefulWidget {
  @override
  _HelpDeskListScreenState createState() => _HelpDeskListScreenState();
}

class _HelpDeskListScreenState extends State<HelpDeskListScreen> {
  Future<List<HelpDeskListData>>? future;

  List<HelpDeskListData> helpDeskListData = [];

  // Status Tab
  List<HelpDeskStatusModel> helpDeskStatus = [];
  HelpDeskStatusModel selectedTab = HelpDeskStatusModel();

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();

    LiveStream().on(LIVESTREAM_UPDATE_HELP_DESK_LIST, (value) {
      page = 1;
      appStore.setLoading(true);
      getHelpDeskListAPI(status: value.toString());

      setState(() {});
    });
  }

  void init() async {
    helpDeskStatus = [
      HelpDeskStatusModel(status: HelpDeskStatus.all, name: language.lblAll.capitalizeFirstLetter()),
      HelpDeskStatusModel(status: HelpDeskStatus.open, name: language.open.capitalizeFirstLetter()),
      HelpDeskStatusModel(status: HelpDeskStatus.closed, name: language.closed.capitalizeFirstLetter()),
    ];

    if (helpDeskStatus.isNotEmpty) {
      selectedTab = helpDeskStatus.first;
      getHelpDeskListAPI(status: selectedTab.name);
    }
  }

  void getHelpDeskListAPI({String status = ""}) {
    future = getHelpDeskList(
      helpDeskListData: helpDeskListData,
      status: status.toLowerCase(),
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
      appBarTitle: language.helpDesk,
      actions: [
        IconButton(
          onPressed: () async {
            AddHelpDeskScreen(callback: (p0) {
              selectedTab = helpDeskStatus.first;
              page = 1;
              appStore.setLoading(true);
              getHelpDeskListAPI(status: selectedTab.name);
              setState(() {});
            }).launch(context);
          },
          icon: Icon(Icons.add, size: 28, color: white),
        ).visible(rolesAndPermissionStore.helpDeskAdd),
      ],
      showLoader: false,
      child: Stack(
        children: [
          Column(
            children: [
              16.height,
              Row(
                children: [
                  HorizontalList(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    spacing: 16,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: helpDeskStatus.length,
                    itemBuilder: (ctx, index) {
                      HelpDeskStatusModel filterStatus = helpDeskStatus[index];
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FilterChip(
                            shape: RoundedRectangleBorder(
                              borderRadius: radius(18),
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
                            selected: false,
                            backgroundColor: selectedTab.status == filterStatus.status ? lightPrimaryColor : context.cardColor,
                            onSelected: (bool selected) {
                              selectedTab = helpDeskStatus[index];
                              page = 1;
                              appStore.setLoading(true);
                              getHelpDeskListAPI(status: selectedTab.name);
                              setState(() {});
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ).paddingOnly(right: 16),
              SnapHelperWidget<List<HelpDeskListData>>(
                initialData: cachedHelpDeskListData,
                future: future,
                loadingWidget: HelpDeskListShimmer(),
                onSuccess: (helpDeskList) {
                  return AnimatedListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    listAnimationType: ListAnimationType.FadeIn,
                    fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                    itemCount: helpDeskList.length,
                    emptyWidget: appStore.isLoading
                        ? Offstage()
                        : NoDataWidget(
                            title: '${language.lblNo} ${selectedTab.name} ${language.queryYet}',
                            titleTextStyle: boldTextStyle(),
                            subTitle: selectedTab.status == HelpDeskStatus.open
                                ? language.toSubmitYourProblems
                                : '${language.noRecordsFoundFor} ${selectedTab.name.toLowerCase()} ${language.queries}',
                            imageWidget: selectedTab.status == HelpDeskStatus.open ? ic_help_desk_outline.iconImage(size: 60) : EmptyStateWidget(),
                            retryText: selectedTab.status == HelpDeskStatus.open ? language.add : null,
                            onRetry: selectedTab.status == HelpDeskStatus.open
                                ? () {
                                    if (selectedTab.status == HelpDeskStatus.open) {
                                      AddHelpDeskScreen(callback: (p0) {
                                        selectedTab = helpDeskStatus.first;
                                        page = 1;
                                        appStore.setLoading(true);
                                        getHelpDeskListAPI(status: selectedTab.name);

                                        setState(() {});
                                      }).launch(context);
                                    }
                                  }
                                : null,
                          ).paddingSymmetric(horizontal: 16),
                    shrinkWrap: true,
                    onNextPage: () {
                      if (!isLastPage) {
                        page++;
                        appStore.setLoading(true);

                        getHelpDeskListAPI(status: selectedTab.name);
                        setState(() {});
                      }
                    },
                    onSwipeRefresh: () async {
                      page = 1;

                      getHelpDeskListAPI(status: selectedTab.name);
                      setState(() {});

                      return await 2.seconds.delay;
                    },
                    disposeScrollController: true,
                    itemBuilder: (BuildContext context, index) {
                      return HelpDeskItemComponent(helpDeskData: helpDeskList[index]);
                    },
                  );
                },
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    imageWidget: ErrorStateWidget(),
                    retryText: language.reload,
                    onRetry: () {
                      page = 1;
                      appStore.setLoading(true);

                      getHelpDeskListAPI(status: selectedTab.name);
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
