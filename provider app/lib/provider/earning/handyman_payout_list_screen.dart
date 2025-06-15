import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_widgets.dart';
import '../../components/base_scaffold_widget.dart';
import '../../components/empty_error_state_widget.dart';
import '../../components/price_widget.dart';
import '../../main.dart';
import '../../models/user_data.dart';
import '../../utils/common.dart';
import '../../utils/configs.dart';
import '../../utils/constant.dart';
import 'handyman_earning_repository.dart';
import 'model/payout_history_response.dart';

class HandymanPayoutListScreen extends StatefulWidget {
  final UserData user;

  HandymanPayoutListScreen({required this.user});

  @override
  _HandymanPayoutListScreenState createState() => _HandymanPayoutListScreenState();
}

class _HandymanPayoutListScreenState extends State<HandymanPayoutListScreen> {
  Future<List<PayoutData>>? future;
  List<PayoutData> payoutList = [];

  int currentPage = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getHandymanPayoutHistoryList(
      currentPage,
      id: widget.user.id!,
      payoutList: payoutList,
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
      appBarTitle: languages.handymanPayoutList,
      body: SnapHelperWidget<List<PayoutData>>(
        future: future,
        loadingWidget: LoaderWidget(),
        onSuccess: (payoutList) {
          return AnimatedListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16, 8, 16, 60),
            itemCount: payoutList.length,
            slideConfiguration: SlideConfiguration(delay: 50.milliseconds, verticalOffset: 400),
            itemBuilder: (_, index) {
              PayoutData data = payoutList[index];

              return Container(
                margin: EdgeInsets.only(top: 8, bottom: 8),
                width: context.width(),
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: radius(),
                  backgroundColor: context.scaffoldBackgroundColor,
                  border: Border.all(color: context.dividerColor, width: 1.0),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(languages.paymentMethod, style: secondaryTextStyle(size: 16)),
                        Text(
                          data.paymentMethod.validate().capitalizeFirstLetter(),
                          style: boldTextStyle(color: primaryColor),
                        ),
                      ],
                    ),
                    if (data.description.validate().isNotEmpty)
                      Column(
                        children: [
                          16.height,
                          Text(data.description.validate(), style: secondaryTextStyle()),
                        ],
                      ),
                    16.height,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.cardColor,
                        borderRadius: radius(),
                      ),
                      width: context.width(),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(languages.lblAmount, style: secondaryTextStyle(size: 14)),
                              16.width,
                              PriceWidget(
                                price: data.amount.validate(),
                                color: primaryColor,
                                isBoldText: true,
                              ).flexible(),
                            ],
                          ),
                          16.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(languages.lblDate, style: secondaryTextStyle(size: 14)),
                              Text(
                                formatDate(data.createdAt.validate().toString(), format: DATE_FORMAT_2),
                                style: boldTextStyle(size: 14),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            onNextPage: () {
              if (!isLastPage) {
                currentPage++;

                appStore.setLoading(true);

                init();
                setState(() {});
              }
            },
            onSwipeRefresh: () async {
              currentPage = 1;

              init();
              setState(() {});
              return await 2.seconds.delay;
            },
            emptyWidget: NoDataWidget(
              title: languages.noPayoutFound,
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
              currentPage = 1;
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
