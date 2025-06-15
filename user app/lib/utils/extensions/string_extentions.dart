import 'package:booking_system_flutter/main.dart';
import 'package:path/path.dart' as path;

import '../constant.dart';

const int averageWordsPerMinute = 180;

extension StrExt on String {
  int getWordsCount() {
    return this.split(' ').length;
  }

  int getEstimatedTimeInMin() {
    return (this.getWordsCount() / averageWordsPerMinute).ceil();
  }

  String get getFileExtension => path.extension(Uri.parse(this).path);

  String get getFileNameWithoutExtension => path.basenameWithoutExtension(Uri.parse(this).path);

  String get getFileName => path.basename(Uri.parse(this).path);

  String get getChatFileName => path.basename(Uri.parse(this).path).replaceFirst("$CHAT_FILES%2F", "");

  String get toPaymentMethodText {
    switch (this) {
      case PAYMENT_METHOD_COD:
        return language.cash;
      case PAYMENT_METHOD_STRIPE:
        return language.stripe;
      case PAYMENT_METHOD_RAZOR:
        return language.razorPay;
      case PAYMENT_METHOD_FLUTTER_WAVE:
        return language.flutterWave;
      case PAYMENT_METHOD_CINETPAY:
        return language.cinet;
      case PAYMENT_METHOD_SADAD_PAYMENT:
        return language.sadadPayment;
      case PAYMENT_METHOD_FROM_WALLET:
        return language.wallet;
      case PAYMENT_METHOD_PAYPAL:
        return language.payPal;
      case PAYMENT_METHOD_PAYSTACK:
        return language.payStack;
      case PAYMENT_METHOD_AIRTEL:
        return language.airtelMoney;
      case PAYMENT_METHOD_PHONEPE:
        return language.phonePe;
      case PAYMENT_METHOD_PIX:
        return language.pix;
      case PAYMENT_METHOD_MIDTRANS:
        return language.midtrans;
      case PAYMENT_METHOD_BANK:
        return language.bank;
      default:
        return this;
    }
  }
}