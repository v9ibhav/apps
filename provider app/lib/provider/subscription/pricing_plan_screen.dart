import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/plan_request_model.dart';
import 'package:handyman_provider_flutter/models/provider_subscription_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/payment/payment_screen.dart';
import 'package:handyman_provider_flutter/provider/provider_dashboard_screen.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/object_wrappers.dart';

import '../../components/base_scaffold_widget.dart';
import '../../components/empty_error_state_widget.dart';

class PricingPlanScreen extends StatefulWidget {
  const PricingPlanScreen({Key? key}) : super(key: key);

  @override
  _PricingPlanScreenState createState() => _PricingPlanScreenState();
}

class _PricingPlanScreenState extends State<PricingPlanScreen> {
  Future<List<ProviderSubscriptionModel>>? future;

  List<ProviderSubscriptionModel> subscriptionPlanList = [];

  ProviderSubscriptionModel? selectedPricingPlan;

  int currentSelectedPlan = -1;
  int page = 1;

  Offerings? revenueCatSubscriptionOfferings;

  List<StoreProduct> storeProductList = [];

  @override
  void initState() {
    super.initState();
    if(appConfigurationStore.isInAppPurchaseEnable){
    inAppPurchaseService.init();
    }
    init();
  }

  Future<void> init() async {
    future = getPricingPlanList().then(
      (value) {
        subscriptionPlanList = value;
        if (appConfigurationStore.isInAppPurchaseEnable) {
          getRevenueCatOfferings();
        }
        setState(() {});

        return value;
      },
    );
  }

  Future<void> getRevenueCatOfferings() async {
    await inAppPurchaseService.getStoreSubscriptionPlanList().then((value) {
      revenueCatSubscriptionOfferings = value;

      if (revenueCatSubscriptionOfferings != null && revenueCatSubscriptionOfferings!.current != null && revenueCatSubscriptionOfferings!.current!.availablePackages.isNotEmpty) {
        storeProductList = revenueCatSubscriptionOfferings!.current!.availablePackages.map((e) => e.storeProduct).toList();
        Set<String> revenueCatIdentifiers = revenueCatSubscriptionOfferings!.current!.availablePackages.map((package) => package.storeProduct.identifier).toSet();

        // Filter backend plans to match RevenueCat identifiers

        subscriptionPlanList = subscriptionPlanList.where((plan) {
          return (revenueCatIdentifiers.contains(isIOS ? plan.appStoreIdentifier : plan.playStoreIdentifier));
        }).toList();

        setState(() {});
      }
    }).catchError((e) {
      log("Can't find revenueCat offerings");
    });
  }

  Package? getSelectedPlanFromRevenueCat(ProviderSubscriptionModel selectedPlan) {
    if (revenueCatSubscriptionOfferings != null && revenueCatSubscriptionOfferings!.current != null && revenueCatSubscriptionOfferings!.current!.availablePackages.isNotEmpty) {
      int index = revenueCatSubscriptionOfferings!.current!.availablePackages
          .indexWhere((element) => element.storeProduct.identifier == (isIOS ? selectedPlan.appStoreIdentifier : selectedPlan.playStoreIdentifier));
      if (index > -1) {
        return revenueCatSubscriptionOfferings!.current!.availablePackages[index];
      }
    } else {
      return null;
    }
    return null;
  }

  Future<void> saveSubscriptionPurchase({required String paymentType, String transactionId = ''}) async {
    appStore.setLoading(true);

    PlanRequestModel planRequestModel = PlanRequestModel()
      ..amount = selectedPricingPlan!.amount
      ..description = selectedPricingPlan!.description
      ..duration = selectedPricingPlan!.duration
      ..identifier = selectedPricingPlan!.identifier
      ..otherTransactionDetail = ''
      ..paymentStatus = PAID
      ..paymentType = paymentType
      ..planId = selectedPricingPlan!.id
      ..planLimitation = selectedPricingPlan!.planLimitation
      ..planType = selectedPricingPlan!.planType
      ..title = selectedPricingPlan!.title
      ..txnId = transactionId
      ..type = selectedPricingPlan!.type
      ..userId = appStore.userId;

    if (appConfigurationStore.isInAppPurchaseEnable) {
      planRequestModel.activeRevenueCatIdentifier = isIOS ? selectedPricingPlan!.appStoreIdentifier : selectedPricingPlan!.playStoreIdentifier;
    }

    log('Request : ${planRequestModel.toJson()}');

    await saveSubscription(planRequestModel.toJson()).then((value) {
      appStore.setLoading(false);
      toast("${selectedPricingPlan!.title.validate()} ${languages.lblSuccessFullyActivated}");

      push(ProviderDashboardScreen(index: 0), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
      if (appConfigurationStore.isInAppPurchaseEnable) {
        setValue(IS_RESTORE_PURCHASE_REQUIRED, true);
        setValue(PURCHASE_REQUEST, planRequestModel.toJson());
      }
      log(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.lblPricingPlan,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SnapHelperWidget<List<ProviderSubscriptionModel>>(
            future: future,
            loadingWidget: LoaderWidget(),
            onSuccess: (res) {
              return AnimatedScrollView(
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  42.height,
                  Text(languages.lblSelectPlan, style: boldTextStyle(size: 16)).center(),
                  8.height,
                  Text(languages.selectPlanSubTitle, style: secondaryTextStyle()).center(),
                  24.height,
                  AnimatedListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 90, top: 8, right: 8, left: 8),
                    itemCount: subscriptionPlanList.length,
                    itemBuilder: (_, index) {
                      ProviderSubscriptionModel data = subscriptionPlanList[index];
                      StoreProduct? revenueCatProduct;
                      if (appConfigurationStore.isInAppPurchaseEnable) revenueCatProduct = getSelectedPlanFromRevenueCat(data)?.storeProduct;

                      return AnimatedContainer(
                        duration: 500.milliseconds,
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: radius(),
                          backgroundColor: context.scaffoldBackgroundColor,
                          border: Border.all(color: currentSelectedPlan == index ? primaryColor : context.dividerColor, width: 1.5),
                        ),
                        margin: EdgeInsets.all(8),
                        width: context.width(),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    currentSelectedPlan == index
                                        ? AnimatedContainer(
                                            duration: 500.milliseconds,
                                            decoration: BoxDecoration(
                                              color: context.primaryColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.grey.shade300),
                                            ),
                                            padding: EdgeInsets.all(2),
                                            child: Icon(Icons.check, color: Colors.white, size: 16),
                                          )
                                        : AnimatedContainer(
                                            duration: 500.milliseconds,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.grey.shade300),
                                            ),
                                            padding: EdgeInsets.all(2),
                                            child: Icon(Icons.check, color: Colors.transparent, size: 16),
                                          ),
                                    16.width,
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            revenueCatProduct != null
                                                ? Text(
                                                    '${revenueCatProduct.title}',
                                                    style: boldTextStyle(),
                                                  ).flexible()
                                                : Text('${data.identifier.capitalizeFirstLetter()}', style: boldTextStyle()).flexible(),
                                            if (revenueCatProduct == null) ...[
                                              if (data.trialPeriod.validate() != 0 && data.identifier == FREE)
                                                RichText(
                                                  text: TextSpan(
                                                    text: ' (${languages.lblTrialFor} ',
                                                    style: secondaryTextStyle(),
                                                    children: <TextSpan>[
                                                      TextSpan(text: ' ${data.trialPeriod.validate()} ', style: boldTextStyle()),
                                                      TextSpan(text: '${languages.lblDays})', style: secondaryTextStyle()),
                                                    ],
                                                  ),
                                                )
                                              else
                                                Text(' (${data.type.validate().capitalizeFirstLetter()})', style: secondaryTextStyle()),
                                            ]
                                          ],
                                        ),
                                        8.height,
                                        Text(data.title.validate().capitalizeFirstLetter(), style: secondaryTextStyle()),
                                      ],
                                    ).expand(),
                                  ],
                                ).expand(),
                                Container(
                                  decoration: BoxDecoration(color: context.primaryColor, borderRadius: radius()),
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  child: revenueCatProduct != null
                                      ? Text(
                                          '${revenueCatProduct.priceString}',
                                          style: boldTextStyle(color: white, size: 12),
                                        )
                                      : Text(
                                          data.identifier == FREE ? '${languages.lblFreeTrial}' : data.amount.validate().toPriceFormat(),
                                          style: boldTextStyle(color: white, size: 12),
                                        ),
                                ),
                              ],
                            ),
                            if (data.planLimitation != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  16.height,
                                  Container(
                                    decoration: boxDecorationWithRoundedCorners(
                                      backgroundColor: context.cardColor,
                                      borderRadius: radius(),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    width: context.width(),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(getPlanStatusImage(limitData: data.planLimitation!.service!), width: 14, height: 14),
                                            8.width,
                                            getPlanStatus(limitData: data.planLimitation!.service!, name: 'Services'),
                                          ],
                                        ),
                                        8.height,
                                        Row(
                                          children: [
                                            Image.asset(getPlanStatusImage(limitData: data.planLimitation!.handyman!), width: 14, height: 14),
                                            8.width,
                                            getPlanStatus(limitData: data.planLimitation!.handyman!, name: 'Handyman'),
                                          ],
                                        ),
                                        8.height,
                                        Row(
                                          children: [
                                            Image.asset(getPlanStatusImage(limitData: data.planLimitation!.featuredService!), width: 14, height: 14),
                                            8.width,
                                            getPlanStatus(limitData: data.planLimitation!.featuredService!, name: 'Featured Services'),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ).onTap(() {
                          selectedPricingPlan = data;
                          currentSelectedPlan = index;

                          setState(() {});
                        }),
                      );
                    },
                    emptyWidget: NoDataWidget(
                      title: languages.noSubscriptionPlan,
                      imageWidget: EmptyStateWidget(),
                    ),
                  ),
                ],
                onSwipeRefresh: () async {
                  page = 1;

                  init();
                  setState(() {});

                  return await 2.seconds.delay;
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

                  init();
                  setState(() {});
                },
              );
            },
          ),
          if (selectedPricingPlan != null)
            Positioned(
              bottom: 32,
              left: 16,
              right: 16,
              child: AppButton(
                child: Text(selectedPricingPlan!.identifier == FREE ? languages.lblProceed : languages.lblMakePayment, style: boldTextStyle(color: white)),
                color: primaryColor,
                onTap: () async {
                  if (selectedPricingPlan!.identifier == FREE) {
                    await saveSubscriptionPurchase(paymentType: PAYMENT_METHOD_COD, transactionId: '');
                  } else {
                    if (appConfigurationStore.isInAppPurchaseEnable) {
                      if (selectedPricingPlan != null) {
                        Package? selectedRevenueCatPackage = await getSelectedPlanFromRevenueCat(selectedPricingPlan!);
                        if (selectedRevenueCatPackage != null)
                          inAppPurchaseService.startPurchase(
                            selectedRevenueCatPackage: selectedRevenueCatPackage,
                            onComplete: (String transactionId) async {
                              await saveSubscriptionPurchase(paymentType: PAYMENT_METHOD_IN_APP_PURCHASE, transactionId: transactionId);
                            },
                          );
                        else {
                          toast(languages.canTFindRevenuecatProduct);
                        }
                      }
                    } else {
                      PaymentScreen(selectedPricingPlan!).launch(context);
                    }
                  }
                },
              ),
            ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }

  Widget getPlanStatus({required LimitData limitData, required String name}) {
    if (limitData.isChecked == null) {
      return RichTextWidget(
        list: [
          TextSpan(text: '${languages.unlimited} $name', style: primaryTextStyle()),
        ],
      );
    } else if (limitData.isChecked.validate() == 'on' && (limitData.limit == null || limitData.limit == "0")) {
      return RichTextWidget(
        list: [
          TextSpan(text: '${languages.hintAdd} $name ${languages.upTo} ', style: primaryTextStyle(decoration: TextDecoration.lineThrough)),
          TextSpan(text: '0', style: boldTextStyle(color: primaryColor, decoration: TextDecoration.lineThrough)),
        ],
      );
    } else {
      return RichTextWidget(
        list: [
          TextSpan(text: '${languages.hintAdd} $name ${languages.upTo} ', style: primaryTextStyle()),
          TextSpan(text: '${limitData.limit.validate()}', style: boldTextStyle(color: primaryColor)),
        ],
      );
    }
  }

  String getPlanStatusImage({required LimitData limitData}) {
    if (limitData.isChecked == null) {
      return pricing_plan_accept;
    } else if (limitData.isChecked.validate() == 'on' && (limitData.limit == null || limitData.limit == "0")) {
      return pricing_plan_reject;
    } else {
      return pricing_plan_accept;
    }
  }
}
