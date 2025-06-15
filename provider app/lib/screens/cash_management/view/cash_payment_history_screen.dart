import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/empty_error_state_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/screens/cash_management/cash_repository.dart';
import 'package:handyman_provider_flutter/screens/cash_management/component/payment_history_list_widget.dart';
import 'package:handyman_provider_flutter/screens/cash_management/model/payment_history_model.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class CashPaymentHistoryScreen extends StatefulWidget {
  final String bookingId;

  const CashPaymentHistoryScreen({Key? key, required this.bookingId}) : super(key: key);

  @override
  State<CashPaymentHistoryScreen> createState() => _CashPaymentHistoryScreenState();
}

class _CashPaymentHistoryScreenState extends State<CashPaymentHistoryScreen> {
  Future<List<PaymentHistoryData>>? future;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init({bool flag = false}) async {
    future = getPaymentHistory(bookingId: widget.bookingId);
    if (flag) setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PaymentHistoryData>>(
      future: future,
      builder: (context, snap) {
        if (snap.hasData) {
          if (snap.data.validate().isEmpty) return Offstage();
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(languages.paymentHistory, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                8.height,
                Container(
                  decoration: boxDecorationWithRoundedCorners(borderRadius: radius(defaultRadius), backgroundColor: context.cardColor),
                  padding: EdgeInsets.all(16),
                  child: AnimatedScrollView(
                    listAnimationType: ListAnimationType.FadeIn,
                    fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      8.height,
                      if (snap.data.validate().isNotEmpty)
                        AnimatedListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snap.data.validate().length,
                          listAnimationType: ListAnimationType.FadeIn,
                          fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                          itemBuilder: (_, i) {
                            return PaymentHistoryListWidget(
                              data: snap.data.validate()[i],
                              index: i,
                              length: snap.data.validate().length.validate(),
                            );
                          },
                        ),
                      if (snap.data.validate().isEmpty) Text(languages.noDataFound),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return snapWidgetHelper(
          snap,
          errorBuilder: (p0) {
            return NoDataWidget(
              title: languages.retryPaymentDetails,
              imageWidget: ErrorStateWidget(),
              onRetry: () {
                init(flag: true);
              },
            );
          },
        );
      },
    );
  }
}
