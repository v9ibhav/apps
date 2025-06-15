import 'package:midpay/midpay.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../utils/app_configuration.dart';

class MidtransService {
  Midpay midpay = Midpay();
  num totalAmount = 0;
  int serviceId = 0;
  num servicePrice = 0;
  String serviceName = '';
  late Function(Map<String, dynamic>) onComplete;
  late Function(bool) loaderOnOFF;
  late PaymentSetting currentPaymentMethod;

  initialize({
    required PaymentSetting currentPaymentMethod,
    required num totalAmount,
    int? serviceId,
    num? servicePrice,
    String? serviceName,
    required Function(Map<String, dynamic>) onComplete,
    required Function(bool) loaderOnOFF,
  }) {
    this.totalAmount = totalAmount;
    this.serviceId = serviceId.validate();
    this.serviceName = serviceName.validate();
    this.servicePrice = servicePrice.validate();
    this.onComplete = onComplete;
    this.loaderOnOFF = loaderOnOFF;
  }

  Future midtransPaymentCheckout() async {
    //for android auto sandbox when debug and production when release
    midpay.init(
      currentPaymentMethod.isTest == 1 ? currentPaymentMethod.testValue!.midtransClientId.validate() : currentPaymentMethod.liveValue!.midtransClientId.validate(),
      currentPaymentMethod.isTest == 1 ? "https://app.sandbox.midtrans.com/snap/v1/transactions/" : 'https://app.midtrans.com/snap/v1/transactions/',
      environment: currentPaymentMethod.isTest == 1 ? Environment.sandbox : Environment.production,
    );

    var midtransCustomer = MidtransCustomer(appStore.userFirstName, appStore.userLastName, appStore.userEmail, appStore.userContactNumber);

    List<MidtransItem> listitems = [];

    var midtransTransaction = MidtransTransaction(totalAmount.toInt() /*100000*/, midtransCustomer, listitems, skipCustomer: true);

    midpay.makePayment(midtransTransaction).catchError((err) => log("ERROR $err"));

    midpay.setFinishCallback(_callback);
  }

  //callback
  Future<void> _callback(TransactionFinished finished) async {
    log("Finish $finished");
    return Future.value(null);
  }
}
