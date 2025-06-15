import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/notification_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/booking/booking_detail_screen.dart';
import 'package:booking_system_flutter/screens/jobRequest/my_post_detail_screen.dart';
import 'package:booking_system_flutter/screens/notification/components/notification_widget.dart';
import 'package:booking_system_flutter/screens/wallet/user_wallet_balance_screen.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/empty_error_state_widget.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<List<NotificationData>>? future;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init({Map? req}) async {
    future = getNotification(request: req);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.lblNotification,
      actions: [
        IconButton(
          icon: Icon(Icons.clear_all_rounded, color: Colors.white),
          onPressed: () async {
            appStore.setLoading(true);

            init(req: {NotificationKey.type: MARK_AS_READ});

            setState(() {});
          },
        ),
      ],
      child: SnapHelperWidget<List<NotificationData>>(
        future: future,
        initialData: cachedNotificationList,
        loadingWidget: LoaderWidget(),
        errorBuilder: (error) {
          return NoDataWidget(
            title: error,
            imageWidget: ErrorStateWidget(),
            retryText: language.reload,
            onRetry: () {
              init();
              setState(() {});
            },
          );
        },
        onSuccess: (list) {
          return AnimatedListView(
            shrinkWrap: true,
            itemCount: list.length,
            slideConfiguration: sliderConfigurationGlobal,
            listAnimationType: ListAnimationType.FadeIn,
            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
            emptyWidget: NoDataWidget(
              title: language.noNotifications,
              subTitle: language.noNotificationsSubTitle,
              imageWidget: EmptyStateWidget(),
            ),
            onSwipeRefresh: () {
              appStore.setLoading(true);

              init();
              setState(() {});
              return 2.seconds.delay;
            },
            itemBuilder: (context, index) {
              NotificationData data = list[index];

              return GestureDetector(
                onTap: () async {
                  if (data.data!.notificationType.validate().contains(WALLET)) {
                    if (appConfigurationStore.onlinePaymentStatus) {
                      UserWalletBalanceScreen().launch(context);
                    }
                  } else if (data.data!.notificationType.validate().contains(BOOKING) || data.data!.notificationType.validate().contains(PAYMENT_MESSAGE_STATUS)) {
                    await BookingDetailScreen(bookingId: data.data!.id.validate()).launch(context);
                    init();
                    setState(() {});
                  }
                  else if (data.data!.notificationType.validate().contains(PROVIDER_SEND_BID)) {
                    int jobId = data.data!.jobId ?? 0;

                      getPostJobDetail({PostJob.postRequestId: jobId}).then((response) {
                        if (response.postRequestDetail != null) {
                          MyPostDetailScreen(
                            postJobData: response.postRequestDetail!,
                            postRequestId: jobId,
                            callback: () {},
                          ).launch(context);
                        } else {
                          toast("Post job data not found.");
                        }
                      }).catchError((e) {
                        toast(e.toString());
                      });
                  }
                  else {
                    //
                  }
                },
                child: NotificationWidget(data: data),
              );
            },
          );
        },
      ),
    );
  }
}
