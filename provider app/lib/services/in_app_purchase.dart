import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/provider_subscription_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../models/plan_request_model.dart';
import '../networks/rest_apis.dart';
import '../utils/constant.dart';
import '../utils/model_keys.dart';

class InAppPurchaseService {
  Future<void> init() async {
    try {
      // await Purchases.setLogLevel(LogLevel.debug);
      String apiKey = isIOS ? appConfigurationStore.inAppPurchaseAppleAPIKey : appConfigurationStore.inAppPurchaseGoogleAPIKey;

      if (apiKey.isNotEmpty) {
        PurchasesConfiguration configuration = PurchasesConfiguration(apiKey)
          ..appUserID = appStore.userEmail
          ..purchasesAreCompletedBy = PurchasesAreCompletedByRevenueCat();
        await Purchases.configure(configuration).then(
          (value) async {
            log('In App Purchase Configuration Successful');
            setValue(HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE, true);
            if(appStore.isLoggedIn){
            await loginToRevenueCate();
          }
          },
        ).catchError((e) {
          setValue(HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE, false);
          if (e is PlatformException) {
            toast(e.message, print: true);
          } else if (e is PurchasesError) {
            toast(e.message, print: true);
          } else {
            toast(e.toString());
          }
        });
      } else {
        log('In App Purchase Configuration is still remaining');
      }
    } catch (e) {
      log('In App Purchase Configuration Failed: ${e.toString()}');
    }
//
  }

  Future<void> loginToRevenueCate() async {
    try {
      await Purchases.logIn(appStore.userEmail.trim());
      log('In App Purchase User Login Successful');
      setValue(HAS_IN_REVENUE_CAT_LOGIN_DONE_LEASE_ONCE, true);
    } catch (e) {
      log('In App Purchase User Login Failed: ${e.toString()}');
    }
  }


  Future<void> logoutToRevenueCate() async {
    try {
      await Purchases.logOut();
      log('In App Purchase User Logout Successful');
      setValue(HAS_IN_REVENUE_CAT_LOGIN_DONE_LEASE_ONCE, false);
    } catch (e) {
      log('In App Purchase User Logout Failed: ${e.toString()}');
    }
  }

  Future<CustomerInfo> getCustomerInfo() async {
    Purchases.invalidateCustomerInfoCache();
    return await Purchases.getCustomerInfo().then(
      (customerData) {
        log('----------------------Customer information---------------------------');
        log(customerData.entitlements);
        log('----------------------Customer Subscription---------------------------');
        log(customerData.activeSubscriptions);
        return customerData;
      },
    ).catchError((e) {
      log('Error while fetching customer information');
    });
  }

  Future<Offerings?> getStoreSubscriptionPlanList() async {
    if (!getBoolAsync(HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE)) {
      await init();
    } else {
      try {
        return await Purchases.getOfferings();
      } catch (e) {
        if (e is PlatformException) {
          toast(e.message, print: true);
        } else if (e is PurchasesError) {
          toast(e.message, print: true);
        } else {
          toast(e.toString());
        }
      }
    }
    return null;
  }

  Future<void> startPurchase({
    required Package selectedRevenueCatPackage,
    required Function(String transactionId) onComplete,
  }) async {
    if (!getBoolAsync(HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE)) {
      await init();
    } else {
      await loginToRevenueCate().then(
        (value) async {
          log('-----------------------------appStore.activeRevenueCatIdentifier---------------------------------');
          log(appStore.activeRevenueCatIdentifier);
          await Purchases.purchasePackage(selectedRevenueCatPackage,
                  googleProductChangeInfo: appStore.activeRevenueCatIdentifier.isNotEmpty ? GoogleProductChangeInfo(appStore.activeRevenueCatIdentifier) : null)
              .then(
            (value) {
              log(value.entitlements);

              toast(languages.waitForAWhile);
              onComplete.call('');
              Purchases.logOut();
              setValue(HAS_IN_REVENUE_CAT_LOGIN_DONE_LEASE_ONCE, false);
            },
          ).catchError((e) {
            if (e is PlatformException) {
              toast(e.message);
            } else {
              if (e is PurchasesError) {
                toast(e.message);
              } else {
                toast(e.toString());
              }
            }
          });
        },
      ).catchError((e) {});
    }
  }

  Future<void> checkSubscriptionSync({VoidCallback? refreshCallBack}) async {
    //Case check current subscription on AppStore/ PlayStore

    if (!getBoolAsync(HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE)) {
      await init().then(
        (value) async {
          await loginToRevenueCate().then(
            (value) async {
              checkSubscriptionSync(refreshCallBack: refreshCallBack);
            },
          );
        },
      );
    } else {
      await loginToRevenueCate().then((val) async {
      await getCustomerInfo().then(
        (customerData) async {
          log(customerData.entitlements);
          log(customerData.entitlements.all);
          if (appStore.providerCurrentSubscription != null && appStore.providerCurrentSubscription!.activePlanRevenueCatIdentifier.isNotEmpty) {
            log("Active Subscriptions ---------------------------${customerData.activeSubscriptions.isEmpty} && ${customerData.activeSubscriptions}");
            if (customerData.activeSubscriptions.isEmpty) {
              cancelCurrentSubscription(refreshCallBack: refreshCallBack);
            } else {
              if (!customerData.activeSubscriptions.contains(appStore.activeRevenueCatIdentifier)) {
                retryPendingSubscriptionData();
              }
            }
          }
        },
      );
      },
    );
    }
  }

  Future<void> saveSubscriptionPurchase(PlanRequestModel planRequestModel) async {
    await saveSubscription(planRequestModel.toJson()).then((value) {
      appStore.setLoading(false);
      clearPendingSubscriptionData();
    }).catchError((e) {
      setValue(IS_RESTORE_PURCHASE_REQUIRED, true);
      toast(e.toString());
      appStore.setLoading(false);
      log(e.toString());
    });
  }

  Future<void> cancelCurrentSubscription({VoidCallback? refreshCallBack}) async {
    Map req = {
      CommonKeys.id: appStore.providerCurrentSubscription?.id,
    };
    appStore.setLoading(true);
    await cancelSubscription(req).then((value) {
      appStore.setLoading(false);
      appStore.setPlanSubscribeStatus(false);
      appStore.setProviderCurrentSubscriptionPlan(ProviderSubscriptionModel());
      appStore.setActiveRevenueCatIdentifier('');
      refreshCallBack?.call();
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  Future<void> retryPendingSubscriptionData() async {
    PlanRequestModel? planReq = await getPendingSubscriptionData();
    if (planReq != null) {
      await saveSubscriptionPurchase(planReq).then(
        (value) {
          clearPendingSubscriptionData();
        },
      ).catchError((e) {
        setValue(IS_RESTORE_PURCHASE_REQUIRED, true);
        setValue(PURCHASE_REQUEST, planReq.toJson());
        appStore.setLoading(false);
        log(e.toString());
      });
    } else {}
  }

  Future<PlanRequestModel?> getPendingSubscriptionData() async {
    if (getStringAsync(PURCHASE_REQUEST).isNotEmpty) {
      return PlanRequestModel.fromJson(jsonDecode(getStringAsync(PURCHASE_REQUEST)));
    }
    return null;
  }

  Future<void> clearPendingSubscriptionData() async {
    removeKey(HAS_PURCHASE_STORED);
    removeKey(PURCHASE_REQUEST);
    removeKey(IS_RESTORE_PURCHASE_REQUIRED);
  }
}
