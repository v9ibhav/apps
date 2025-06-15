import 'dart:math';

import 'package:cinetpay/cinetpay.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../utils/app_configuration.dart';

class CinetPayServicesNew {
  late PaymentSetting paymentSetting;
  num totalAmount;
  late Function(Map<String, dynamic>) onComplete;

  // Local Variable
  Map<String, dynamic>? response;

  CinetPayServicesNew({
    required this.paymentSetting,
    required this.totalAmount,
    required Function(Map) onComplete,
  });

  final String transactionId = Random().nextInt(100000000).toString();

  Future<void> payWithCinetPay({required BuildContext context}) async {
    await Navigator.push(getContext, MaterialPageRoute(builder: (_) => cinetPay()));
    appStore.setLoading(false);
  }

  Widget cinetPay() {
    String cinetPayApiKey = '';
    String siteId = '';
    String secretKey = '';

    if (paymentSetting.isTest == 1) {
      cinetPayApiKey = paymentSetting.testValue!.cinetPublicKey!;
      siteId = paymentSetting.testValue!.cinetId!;
      secretKey = paymentSetting.testValue!.cinetKey!;
    } else {
      cinetPayApiKey = paymentSetting.liveValue!.cinetPublicKey!;
      siteId = paymentSetting.liveValue!.cinetId!;
      secretKey = paymentSetting.liveValue!.cinetKey!;
    }

    return CinetPayCheckout(
      title: languages.lblCheckOutWithCinetPay,
      configData: <String, dynamic>{
        'apikey': cinetPayApiKey,
        'site_id': siteId,
        'notify_url': 'http://mondomaine.com/notify/',
        'mode': 'PRODUCTION',
      },
      paymentData: <String, dynamic>{
        'transaction_id': transactionId,
        'amount': totalAmount,
        'currency': appConfigurationStore.currencyCode,
        'channels': 'ALL',
        'description': 'Email: ${appStore.userEmail}',
      },
      waitResponse: (data) {
        response = data;
        log(response);

        if (data['status'] == "REFUSED") {
          toast('Your payment failed please try again');
        } else if (data['status'] == "ACCEPTED") {
          toast(languages.yourPaymentHasBeenMadeSuccessfully);
          appStore.setLoading(false);
          onComplete.call({
            'transaction_id': transactionId,
          });
        }
      },
      onError: (data) {
        response = data;
        log(response);
        appStore.setLoading(false);
      },
    );
  }
}
