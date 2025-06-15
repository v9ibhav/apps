import 'package:booking_system_flutter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:nb_utils/nb_utils.dart';

import '../model/payment_gateway_response.dart';
import '../utils/common.dart';
import '../utils/configs.dart';

class PayStackService {
  late BuildContext ctx;
  PaystackPlugin paystackPlugin = PaystackPlugin();
  num totalAmount = 0;
  int bookingId = 0;
  late Function(Map<String, dynamic>) onComplete;
  late Function(bool) loderOnOFF;
  PaymentSetting? currentPaymentMethod;

  init(
      {required BuildContext context,
      required PaymentSetting currentPaymentMethod,
      required num totalAmount,
      required int bookingId,
      required Function(Map<String, dynamic>) onComplete,
      required Function(bool) loderOnOFF}) {
    ctx = context;
    this.totalAmount = totalAmount;
    this.bookingId = bookingId;
    this.onComplete = onComplete;
    this.loderOnOFF = loderOnOFF;
    this.currentPaymentMethod = currentPaymentMethod;
  }

  Future checkout() async {
    loderOnOFF(true);
    int price = totalAmount.toInt() * 100;
    Charge charge = Charge()
      ..amount = price
      ..reference = 'ref_${DateTime.now().millisecondsSinceEpoch}'
      ..email = appStore.userEmail
      ..currency = await isIqonicProduct
          ? PAYSTACK_CURRENCY_CODE
          : '${appConfigurationStore.currencyCode}';

    String publicKey = currentPaymentMethod!.isTest == 1
        ? currentPaymentMethod!.testValue!.paystackPublicKey.validate()
        : currentPaymentMethod!.liveValue!.paystackPublicKey.validate();
    if (publicKey.isEmpty) throw language.accessDeniedContactYourAdmin;

    await paystackPlugin.initialize(publicKey: publicKey);

    CheckoutResponse response = await paystackPlugin.checkout(
      ctx,
      method: CheckoutMethod.card,
      charge: charge,
    );

    log('Response: $response');

    if (response.status == true) {
      log('Response $response');
      onComplete.call({
        'transaction_id': response.reference.validate(value: "#$bookingId"),
      });
      loderOnOFF(false);
      log('Payment was successful. Ref: ${response.reference}');
    } else {
      loderOnOFF(false);
      toast(response.message, print: true);
    }
  }
}
