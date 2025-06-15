// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

import '../../../../main.dart';
import '../../../../utils/app_configuration.dart';
import 'upi_app_model.dart';
import 'upi_pay.dart';

class PhonePeServices {
  late PaymentSetting paymentSetting;
  int bookingId = 0;
  num totalAmount = 0;
  late Function(Map<String, dynamic>) onComplete;
  bool isTest = false;
  String environmentValue = '';
  String appId = "";
  String merchantId = "";
  String saltKey = "";
  String saltIndex = '1';

  PhonePeServices({
    required PaymentSetting paymentSetting,
    required num totalAmount,
    int bookingId = 0,
    required Function(Map<String, dynamic>) onComplete,
  }) {
    isTest = paymentSetting.isTest == 1;
    environmentValue = isTest ? phonePeTestEnvironment : phonePeLiveEnvironment;
    appId = isTest ? "" : paymentSetting.liveValue!.phonePeAppID.validate().trim();
    merchantId = isTest ? paymentSetting.testValue!.phonePeMerchantID.validate().trim() : paymentSetting.liveValue!.phonePeMerchantID.validate().trim();
    saltKey = isTest ? paymentSetting.testValue!.phonePeSaltKey.validate().trim() : paymentSetting.liveValue!.phonePeSaltKey.validate().trim();
    saltIndex = isTest ? paymentSetting.testValue!.phonePeSaltIndex.validate().trim() : paymentSetting.liveValue!.phonePeSaltIndex.validate().trim();
    this.paymentSetting = paymentSetting;
    this.totalAmount = totalAmount;
    this.onComplete = onComplete;
    this.bookingId = bookingId;
  }

  final apiEndPoint = "/pg/v1/pay";
  final cardPayType = "PAY_PAGE";
  final phonePeTestEnvironment = 'UAT';
  final phonePeLiveEnvironment = 'PhonePeEnvironment.RELEASE';
  String packageName = "com.phonepe.app";
  Map<String, String> pgHeaders = {"Content-Type": "application/json"};
  String callback = "https://webhook.site/callback-url";
  late String body;
  late String checkSum;
  String txnId = "";
  String generatedUsersId = "";

  Future<void> createBodyAndCheckSum(num amount, String payType) async {
    try {
      if (txnId.trim().isEmpty) {
        txnId = "${generateRandomString(5).toUpperCase()}${bookingId > 0 ? bookingId : appStore.userId}";
      }
      if (generatedUsersId.trim().isEmpty) {
        generatedUsersId = appStore.userEmail.isNotEmpty ? appStore.userEmail : "${generateRandomString(6).toUpperCase()}${appStore.userId}";
      }
      Map<String, dynamic> requestBody = {
        "merchantId": merchantId,
        "merchantTransactionId": txnId,
        "merchantUserId": appStore.userEmail,
        "amount": isTest ? "100" : (amount * 100).toDouble(),
        "redirectUrl": "https://webhook.site/redirect-url",
        "redirectMode": "REDIRECT",
        "callbackUrl": "https://webhook.site/callback-url",
        if (appStore.userContactNumber.isNotEmpty) "mobileNumber": appStore.userContactNumber,
        "paymentInstrument": payType == cardPayType ? {"type": payType} : {"type": "UPI_INTENT", "targetApp": payType}
      };
      String jsonString = jsonEncode(requestBody);
      body = base64Encode(utf8.encode(jsonString));
      String bodyWithSaltKey = body + apiEndPoint + saltKey;
      var shaValue = sha256.convert(utf8.encode(bodyWithSaltKey));
      String shaString = shaValue.toString();
      checkSum = shaString + '###' + saltIndex;
    } catch (e) {
      log('createBodyAndCheckSum error: ${e.toString()}');
      toast(e.toString());
    }
  }

  Future<void> phonePeCheckout(BuildContext context) async {
    bool isInitialized = false;
    try {
      isInitialized = await PhonePePaymentSdk.init(environmentValue, appId, merchantId, kDebugMode);

      if (isInitialized) {
        showModalBottomSheet<void>(
          backgroundColor: context.cardColor,
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SettingItemWidget(
                  title: "Pay With Upi Apps",
                  leading: Icon(Icons.apps, color: context.iconColor),
                  onTap: () async {
                    handlePayClick(context);
                  },
                ),
                SettingItemWidget(
                  title: "Pay with Card",
                  leading: Icon(Icons.credit_card_rounded, color: context.iconColor),
                  onTap: () async {
                    handlePayClick(context, isTypeCard: true);
                  },
                ),
              ],
            ).paddingAll(16.0);
          },
        );
      }
    } catch (e) {
      log('phonePeCheckout error: ${e.toString()}');
      toast(e.toString());
      finish(context);
    }
  }

  Future<void> handlePayClick(BuildContext context, {bool isTypeCard = false}) async {
    if (isTypeCard) {
      await createBodyAndCheckSum(totalAmount, cardPayType);
    } else {
      String? upiAppListResponse = await PhonePePaymentSdk.getInstalledUpiAppsForAndroid();
      Iterable resp = jsonDecode(upiAppListResponse!);
      debugPrint('UPIAPPLISTRESPONSE: $upiAppListResponse');
      List<UpiResponse> installedUpiAppList = resp.map((e) => UpiResponse.fromJson(e)).toList();
      final res = await UpiPayScreen(installedUpiAppList).launch(context);
      if (res is String) {
        packageName = res;
        await createBodyAndCheckSum(totalAmount, packageName);
      }
    }

    Future<Map<dynamic, dynamic>?> response = PhonePePaymentSdk.startTransaction(body, callback, checkSum, packageName);
    await response.then((val) {
      log('startPGTransaction response: $val');
      if (val?['status'] == 'SUCCESS') {
        onComplete.call({
          'transaction_id': txnId,
        });
      }
    }).catchError((error) {
      log('startPGTransaction error: ${error.toString()}');
      toast(error.toString());
    });
  }

  //generateRandomString
  String generateRandomString(int len) {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    var s = String.fromCharCodes(Iterable.generate(len, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    log('generateRandomString(len:$len) --> ${s.toUpperCase()}');
    return s;
  }
}

// getPackageSignatureForAndroid();
void getPackageSignatureForAndroid() {
  if (Platform.isAndroid) {
    PhonePePaymentSdk.getPackageSignatureForAndroid().then((packageSignature) {
      print('PhonePeSdk packageSignature $packageSignature');
    }).catchError((error) {
      return error;
    });
  }
}
