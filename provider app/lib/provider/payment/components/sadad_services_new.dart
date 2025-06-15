import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../networks/rest_apis.dart';
import '../../../utils/app_configuration.dart';
import '../payment_webview_screen.dart';

class SadadServicesNew {
  late PaymentSetting paymentSetting;
  String remarks;
  num totalAmount;
  late Function(Map<String, dynamic>) onComplete;

  SadadServicesNew({
    required this.paymentSetting,
    required this.totalAmount,
    this.remarks = "",
    required Function(Map<String, dynamic>) onComplete,
  });

  Future<void> payWithSadad(BuildContext context) async {
    String sadadId = '';
    String sadadKey = '';
    String sadadDomain = '';
    if (paymentSetting.isTest == 1) {
      sadadId = paymentSetting.testValue!.sadadId!;
      sadadKey = paymentSetting.testValue!.sadadKey!;
      sadadDomain = paymentSetting.testValue!.sadadDomain!;
    } else {
      sadadId = paymentSetting.liveValue!.sadadId!;
      sadadKey = paymentSetting.liveValue!.sadadKey!;
      sadadDomain = paymentSetting.liveValue!.sadadDomain!;
    }

    Map request = {
      "sadadId": sadadId,
      "secretKey": sadadKey,
      "domain": sadadDomain,
    };
    appStore.setLoading(true);
    await sadadLogin(request).then((accessToken) async {
      await createInvoice(context, accessToken: accessToken).then((value) async {
        //
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  Future<void> createInvoice(BuildContext context, {required String accessToken}) async {
    Map<String, dynamic> req = {
      "countryCode": 974,
      "clientname": appStore.userName.validate(),
      "cellnumber": appStore.userContactNumber.validate().splitAfter('-'),
      "invoicedetails": [
        {
          "description": 'Name: ${appStore.userFullName} - Email: ${appStore.userEmail}',
          "quantity": 1,
          "amount": totalAmount,
        },
      ],
      "status": 2,
      "remarks": remarks,
      "amount": totalAmount,
    };
    sadadCreateInvoice(request: req, sadadToken: accessToken).then((value) async {
      appStore.setLoading(false);
      log('val:${value[0]['shareUrl']}');

      String? res = await PaymentWebViewScreen(url: value[0]['shareUrl'], accessToken: accessToken).launch(context);

      if (res.validate().isNotEmpty) {
        onComplete.call({
          'transaction_id': res,
        });
      } else {
        toast(languages.lblTransactionFailed, print: true);
      }
    }).catchError((e) {
      appStore.setLoading(false);
      toast('Error: $e', print: true);
    });
  }
}
// Handle CinetPayment
