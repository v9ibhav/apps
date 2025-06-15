import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/provider/earning/shimmer/handyman_earning_list_shimmer.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/base_scaffold_widget.dart';
import '../../components/empty_error_state_widget.dart';
import '../../main.dart';
import 'component/earning_item_widget.dart';
import 'handyman_earning_repository.dart';
import 'model/earning_list_model.dart';

class HandymanEarningListScreen extends StatefulWidget {
  const HandymanEarningListScreen({Key? key}) : super(key: key);

  @override
  State<HandymanEarningListScreen> createState() => _HandymanEarningListScreenState();
}

class _HandymanEarningListScreenState extends State<HandymanEarningListScreen> {
  Future<List<EarningListModel>>? future;
  List<EarningListModel> earningList = [];

  bool isLastPage = false;

  int page = 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = getHandymanEarningList(
      page: page,
      earnings: earningList,
      callback: (res) {
        appStore.setLoading(false);
        isLastPage = res;
        setState(() {});
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
      appBarTitle: languages.handymanEarnings,
      body: SnapHelperWidget<List<EarningListModel>>(
        future: future,
        loadingWidget: HandymanEarningListShimmer(),
        onSuccess: (earnings) {
          return AnimatedListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16, 8, 16, 60),
            itemCount: earningList.length,
            slideConfiguration: SlideConfiguration(delay: 50.milliseconds, verticalOffset: 400),
            listAnimationType: ListAnimationType.FadeIn,
            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
            itemBuilder: (_, index) {
              return EarningItemWidget(
                earningList[index],
                onUpdate: () {
                  page = 1;
                  appStore.setLoading(true);

                  init();
                  setState(() {});
                },
              );
            },
            onSwipeRefresh: () async {
              page = 1;

              init();
              setState(() {});

              return await 2.seconds.delay;
            },
            onNextPage: () {
              if (!isLastPage) {
                page++;
                appStore.setLoading(true);

                init();
                setState(() {});
              }
            },
            emptyWidget: NoDataWidget(
              title: languages.lblNoEarningFound,
              imageWidget: EmptyStateWidget(),
            ),
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

              init();
              setState(() {});
            },
          );
        },
      ),
    );
  }
}
