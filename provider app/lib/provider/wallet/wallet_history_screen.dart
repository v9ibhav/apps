import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/wallet_history_list_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/wallet/components/wallet_card.dart';
import 'package:handyman_provider_flutter/provider/wallet/shimmer/wallet_history_shimmer.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';
import '../../utils/common.dart';
import '../../utils/constant.dart';
import '../../utils/images.dart';

class WalletHistoryScreen extends StatefulWidget {
  @override
  WalletHistoryScreenState createState() => WalletHistoryScreenState();
}

class WalletHistoryScreenState extends State<WalletHistoryScreen> {
  Future<List<WalletHistory>>? future;
  List<WalletHistory> walletHistoryList = [];
  num availableBalance = 0;

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    future = getWalletHistory(
      page: page,
      availableBalance: (p0) {
        availableBalance = p0;
      },
      list: walletHistoryList,
      lastPageCallback: (b) {
        isLastPage = b;
      },
    );

    appStore.setUserWalletAmount();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.lblWalletHistory,
      showLoader: false,
      body: SnapHelperWidget<List<WalletHistory>>(
        future: future,
        initialData: cachedWalletList,
        onSuccess: (snap) {
          return AnimatedScrollView(
            crossAxisAlignment: CrossAxisAlignment.start,
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              16.height,
              WalletCard(
                availableBalance: availableBalance,
                callback: (value) {
                  if (value ?? false) {
                    init();
                    setState(() {});
                  }
                },
              ),
              20.height,
              Text(languages.lblWalletHistory, style: primaryTextStyle(size: 14, weight: FontWeight.bold)).paddingSymmetric(horizontal: 16),
              16.height,
              AnimatedListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                slideConfiguration: SlideConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
                padding: EdgeInsets.symmetric(horizontal: 8),
                itemCount: snap.length,
                itemBuilder: (BuildContext context, index) {
                  WalletHistory data = snap[index];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    margin: EdgeInsets.all(8),
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: BorderRadius.circular(8),
                      backgroundColor: context.cardColor,
                    ),
                    width: context.width(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: snap[index].activityData!.transactionType.isEmptyOrNull
                                ? Colors.red.shade50
                                : snap[index].activityData!.transactionType!.toLowerCase().contains(PAYMENT_STATUS_DEBIT)
                                    ? Colors.red.shade50
                                    : Colors.green.shade50,
                          ),
                          child: Image.asset(
                            snap[index].activityData!.transactionType.isEmptyOrNull
                                ? ic_diagonal_right_up_arrow
                                : snap[index].activityData!.transactionType!.toLowerCase().contains(PAYMENT_STATUS_DEBIT)
                                    ? ic_diagonal_right_up_arrow
                                    : ic_diagonal_left_down_arrow,
                            height: 18,
                            width: 18,
                            color: snap[index].activityData!.transactionType.isEmptyOrNull
                                ? Colors.red
                                : snap[index].activityData!.transactionType!.toLowerCase().contains(PAYMENT_STATUS_DEBIT)
                                    ? Colors.red
                                    : Colors.green,
                          ),
                        ),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (data.activityMessage.validate().isNotEmpty)
                              Text(
                                data.activityMessage.validate(),
                                style: boldTextStyle(size: 12),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            4.height,
                            Text(
                              formatDate(snap[index].datetime, showDateWithTime: true),
                              style: secondaryTextStyle(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ).expand(),
                        16.width,
                        Text(
                          snap[index].activityData!.creditDebitAmount.validate().toPriceFormat(),
                          style: boldTextStyle(
                              color: snap[index].activityData!.transactionType.isEmptyOrNull
                                  ? Colors.red
                                  : snap[index].activityData!.transactionType!.toLowerCase().contains(PAYMENT_STATUS_DEBIT)
                                      ? Colors.redAccent
                                      : Colors.green),
                        ),
                      ],
                    ),
                  );
                },
                emptyWidget: NoDataWidget(
                  title: languages.noWalletHistoryTitle,
                  subTitle: languages.noWalletHistorySubTitle,
                  imageWidget: EmptyStateWidget(),
                ),
              ),
            ],
            onNextPage: () {
              if (!isLastPage) {
                page++;
                appStore.setLoading(true);
                init();
                setState(() {});
              }
            },
            onSwipeRefresh: () async {
              page = 1;
              init();
              setState(() {});
              return await 2.seconds.delay;
            },
          );
        },
        loadingWidget: WalletHistoryShimmer(),
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