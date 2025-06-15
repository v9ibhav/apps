import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/components/empty_error_state_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/bank_details/add_bank_screen.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../models/bank_list_response.dart';
import '../../utils/common.dart';
import '../../utils/images.dart';
import 'shimmer/bank_detail_shimmer.dart';

class BankDetails extends StatefulWidget {
  final BankHistory? bankHistory;

  const BankDetails({super.key, this.bankHistory});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  Future<List<BankHistory>>? future;
  List<BankHistory> bankHistoryList = [];
  int page = 1;
  bool isLastPage = false;
  BankHistory _selectedAccount = BankHistory();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> update() async {
    appStore.setLoading(true);
    chooseDefaulBank(bankId: _selectedAccount.id).then((value) async {
     await init();
      setState(() {});
    }).catchError((value) async {
      toast(value);
    }).whenComplete(() {
      appStore.setLoading(false);
    });
  }

  Future<void> delete(bankId) async {
    appStore.setLoading(true);
    deleteBank(bankId: bankId).then((value) {
      init();
      setState(() {});
    }).catchError((value) async {
      toast(value);
    }).whenComplete(() {
      appStore.setLoading(false);
    });
  }

  void setDefault() {
    bankHistoryList.forEach((value) {
      if (value.isDefault == 1) {
        _selectedAccount = value;
        setState(() {});
      }
    });
  }

  init() async {
    future = getBankListDetail(
      page: page,
      list: bankHistoryList,
      lastPageCallback: (b) {
        isLastPage = b;
      },
      userId: appStore.userId,
    );
  }

  List<OptionModel> optionList({required BankHistory bankHistory}) {
    return [
      if (rolesAndPermissionStore.bankEdit)
      OptionModel(
        title: languages.lblEdit,
        onTap: () {
          AddBankScreen(data: bankHistory).launch(context, pageRouteAnimation: PageRouteAnimation.Fade).then((value) {
            if (value[0]) {
              init();
              setState(() {});
            }
          });
        },
      ),
      if (bankHistory.isDefault == 0 &&  rolesAndPermissionStore.bankDelete)
      OptionModel(
        title: languages.lblDelete,
        onTap: () {
          showConfirmDialogCustom(
            context,
            dialogType: DialogType.DELETE,
            title: languages.deleteBankTitle,
            positiveText: languages.lblDelete,
            negativeText: languages.lblCancel,
            onAccept: (v) {
              delete(bankHistory.id);
            },
          );
        },
      ),
      if (bankHistory.isDefault == 0)
        OptionModel(
          title: languages.setAsDefault,
          onTap: () {
            setState(() {
              _selectedAccount = bankHistory;
              update();
            });
          },
        ),
    ];
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.bankList,
      actions: [
        IconButton(
          onPressed: () {
            AddBankScreen().launch(context).then((value) {
              if (value[0]) {
                init();
                setState(() {});
              }
            });
          },
          icon: CachedImageWidget(
            url: ic_add,
            height: 14,
            width: 14,
            color: white,
          ),
        ).visible(rolesAndPermissionStore.bankAdd),
      ],
      body: SnapHelperWidget<List<BankHistory>>(
        future: future,
        initialData: cachedBankList,
        onSuccess: (snap) {
          return AnimatedListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            listAnimationType: ListAnimationType.FadeIn,
            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
            slideConfiguration: SlideConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
            padding: EdgeInsets.all(8),
            itemCount: snap.length,
            itemBuilder: (BuildContext context, index) {
              BankHistory data = snap[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                margin: EdgeInsets.all(8),
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: BorderRadius.circular(8),
                  backgroundColor: context.cardColor,
                ),
                width: context.width(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Marquee(child: Text(data.bankName.validate(), style: primaryTextStyle(size: 14, weight: FontWeight.bold))).expand(),
                        16.width,
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(50)),
                          child: Text(languages.lbldefault, style: primaryTextStyle(size: 10, color: white)),
                        ).visible(data.isDefault == 1),
                      ],
                    ),
                    8.height,
                    Text(bankAccountWidget(data.accountNo.validate()), style: secondaryTextStyle()),
                    8.height,
                    OptionListWidget(optionList: optionList(bankHistory: data)),
                  ],
                ),
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
              title: languages.noBankDataTitle,
              subTitle: languages.noBankDataSubTitle,
              imageWidget: EmptyStateWidget(),
            ),
          );
        },
        loadingWidget: BankDetailShimmer(),
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