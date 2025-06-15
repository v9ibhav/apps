import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/provider_subscription_model.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_common_dialog.dart';
import '../../components/empty_error_state_widget.dart';
import '../../networks/rest_apis.dart';
import '../../utils/app_configuration.dart';
import 'components/airtel_money/airtel_money_service.dart';
import 'components/cinet_pay_services_new.dart';
import 'components/flutter_wave_service_new.dart';
import 'components/midtrans_service.dart';
import 'components/paypal_service.dart';
import 'components/paystack_service.dart';
import 'components/phone_pe/phone_pe_service.dart';
import 'components/razorpay_service_new.dart';
import 'components/sadad_services_new.dart';
import 'components/stripe_service_new.dart';

class PaymentScreen extends StatefulWidget {
  final ProviderSubscriptionModel selectedPricingPlan;

  const PaymentScreen(this.selectedPricingPlan);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Future<List<PaymentSetting>>? future;

  PaymentSetting? selectedPaymentSetting;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getPaymentGateways(requireCOD: false, requireWallet: false);
  }

  void _handleClick() async {
    if (appStore.isLoading) return;

    if (selectedPaymentSetting!.type == PAYMENT_METHOD_STRIPE) {
      StripeServiceNew stripeServiceNew = StripeServiceNew(
        paymentSetting: selectedPaymentSetting!,
        totalAmount: widget.selectedPricingPlan.amount.validate(),
        onComplete: (p0) {
          savePayment(
            data: widget.selectedPricingPlan,
            paymentMethod: PAYMENT_METHOD_STRIPE,
            paymentStatus: BOOKING_STATUS_PAID,
            txnId: p0['transaction_id'],
          );
        },
      );

      stripeServiceNew.stripePay().catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    } else if (selectedPaymentSetting!.type == PAYMENT_METHOD_RAZOR) {
      RazorPayServiceNew razorPayServiceNew = RazorPayServiceNew(
        paymentSetting: selectedPaymentSetting!,
        totalAmount: widget.selectedPricingPlan.amount.validate(),
        onComplete: (p0) {
          savePayment(
            data: widget.selectedPricingPlan,
            paymentMethod: PAYMENT_METHOD_RAZOR,
            paymentStatus: BOOKING_STATUS_PAID,
            txnId: p0['paymentId'],
          );
        },
      );
      razorPayServiceNew.razorPayCheckout().catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    } else if (selectedPaymentSetting!.type == PAYMENT_METHOD_FLUTTER_WAVE) {
      FlutterWaveServiceNew flutterWaveServiceNew = FlutterWaveServiceNew();

      flutterWaveServiceNew.checkout(
        paymentSetting: selectedPaymentSetting!,
        totalAmount: widget.selectedPricingPlan.amount.validate(),
        onComplete: (p0) {
          savePayment(
            data: widget.selectedPricingPlan,
            paymentMethod: PAYMENT_METHOD_FLUTTER_WAVE,
            paymentStatus: BOOKING_STATUS_PAID,
            txnId: p0['transaction_id'],
          );
        },
      );
    } else if (selectedPaymentSetting!.type == PAYMENT_METHOD_CINETPAY) {
      List<String> supportedCurrencies = ["XOF", "XAF", "CDF", "GNF", "USD"];

      if (!supportedCurrencies.contains(appConfigurationStore.currencyCode)) {
        toast(languages.cinetpayIsnTSupportedByCurrencies);
        return;
      } else if (widget.selectedPricingPlan.amount.validate() < 100) {
        return toast('${languages.totalAmountShouldBeMoreThan} ${100.toPriceFormat()}');
      } else if (widget.selectedPricingPlan.amount.validate() > 1500000) {
        return toast('${languages.totalAmountShouldBeLessThan} ${1500000.toPriceFormat()}');
      }

      CinetPayServicesNew cinetPayServices = CinetPayServicesNew(
        paymentSetting: selectedPaymentSetting!,
        totalAmount: widget.selectedPricingPlan.amount.validate(),
        onComplete: (p0) {
          savePayment(
            data: widget.selectedPricingPlan,
            paymentMethod: PAYMENT_METHOD_CINETPAY,
            paymentStatus: BOOKING_STATUS_PAID,
            txnId: p0['transaction_id'],
          );
        },
      );

      cinetPayServices.payWithCinetPay(context: context).catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    } else if (selectedPaymentSetting!.type == PAYMENT_METHOD_SADAD_PAYMENT) {
      SadadServicesNew sadadServices = SadadServicesNew(
        paymentSetting: selectedPaymentSetting!,
        totalAmount: widget.selectedPricingPlan.amount.validate(),
        onComplete: (p0) {
          savePayment(
            data: widget.selectedPricingPlan,
            paymentMethod: PAYMENT_METHOD_SADAD_PAYMENT,
            paymentStatus: BOOKING_STATUS_PAID,
            txnId: p0['transaction_id'],
          );
        },
      );

      sadadServices.payWithSadad(context).catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    } else if (selectedPaymentSetting!.type == PAYMENT_METHOD_PAYPAL) {
      PayPalService.paypalCheckOut(
        context: context,
        paymentSetting: selectedPaymentSetting!,
        totalAmount: widget.selectedPricingPlan.amount.validate(),
        onComplete: (p0) {
          savePayment(
            data: widget.selectedPricingPlan,
            paymentMethod: PAYMENT_METHOD_PAYPAL,
            paymentStatus: BOOKING_STATUS_PAID,
            txnId: p0['transaction_id'],
          );
        },
      );
    } else if (selectedPaymentSetting!.type == PAYMENT_METHOD_AIRTEL) {
      showInDialog(
        context,
        contentPadding: EdgeInsets.zero,
        barrierDismissible: false,
        builder: (context) {
          return AppCommonDialog(
            title: languages.airtelMoneyPayment,
            child: AirtelMoneyDialog(
              amount: widget.selectedPricingPlan.amount.validate(),
              reference: APP_NAME,
              paymentSetting: selectedPaymentSetting!,
              bookingId: widget.selectedPricingPlan.planId.validate(),
              onComplete: (res) {
                log('RES: $res');
                savePayment(
                  data: widget.selectedPricingPlan,
                  paymentMethod: PAYMENT_METHOD_AIRTEL,
                  paymentStatus: BOOKING_STATUS_PAID,
                  txnId: res['transaction_id'],
                );
              },
            ),
          );
        },
      ).then((value) => appStore.setLoading(false));
    } else if (selectedPaymentSetting!.type == PAYMENT_METHOD_PAYSTACK) {
      PayStackService paystackServices = PayStackService();
      appStore.setLoading(true);
      await paystackServices.init(
        context: context,
        currentPaymentMethod: selectedPaymentSetting!,
        loderOnOFF: (p0) {
          appStore.setLoading(p0);
        },
        totalAmount: widget.selectedPricingPlan.amount.validate(),
        bookingId: appStore.userId.validate().toInt(),
        onComplete: (res) {
          log('RES: $res');
          savePayment(
            data: widget.selectedPricingPlan,
            paymentMethod: PAYMENT_METHOD_PAYSTACK,
            paymentStatus: BOOKING_STATUS_PAID,
            txnId: res['transaction_id'],
          );
        },
      );
      await Future.delayed(const Duration(seconds: 1));
      appStore.setLoading(false);
      paystackServices.checkout().catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    } else if (selectedPaymentSetting!.type == PAYMENT_METHOD_MIDTRANS) {
      MidtransService midtransService = MidtransService();
      appStore.setLoading(true);
      await midtransService.initialize(
        currentPaymentMethod: selectedPaymentSetting!,
        totalAmount: widget.selectedPricingPlan.amount.validate(),
        loaderOnOFF: (p0) {
          appStore.setLoading(p0);
        },
        onComplete: (res) {
          log('RES: $res');
          savePayment(
            data: widget.selectedPricingPlan,
            paymentMethod: PAYMENT_METHOD_MIDTRANS,
            paymentStatus: BOOKING_STATUS_PAID,
            txnId: res["transaction_id"],
          );
        },
      );
      await Future.delayed(const Duration(seconds: 1));
      appStore.setLoading(false);
      midtransService.midtransPaymentCheckout().catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    } else if (selectedPaymentSetting!.type == PAYMENT_METHOD_PHONEPE) {
      PhonePeServices peServices = PhonePeServices(
        paymentSetting: selectedPaymentSetting!,
        totalAmount: widget.selectedPricingPlan.amount.validate(),
        onComplete: (res) {
          log('RES: $res');
          savePayment(
            data: widget.selectedPricingPlan,
            paymentMethod: PAYMENT_METHOD_PHONEPE,
            paymentStatus: BOOKING_STATUS_PAID,
            txnId: res["transaction_id"],
          );
        },
      );

      peServices.phonePeCheckout(context).catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblPayment, color: context.primaryColor, textColor: Colors.white, backWidget: BackWidget()),
      body: Stack(
        children: [
          SnapHelperWidget<List<PaymentSetting>>(
            future: future,
            onSuccess: (paymentList) {
              if (paymentList.isEmpty) {
                return NoDataWidget(
                  imageWidget: EmptyStateWidget(),
                  title: languages.lblNoPayments,
                  imageSize: Size(150, 150),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Text(languages.lblChoosePaymentMethod, style: boldTextStyle(size: 18)).paddingOnly(left: 16),
                  16.height,
                  AnimatedListView(
                    itemCount: paymentList.length,
                    shrinkWrap: true,
                    listAnimationType: ListAnimationType.FadeIn,
                    fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                    itemBuilder: (context, index) {
                      PaymentSetting value = paymentList[index];

                      return RadioListTile<PaymentSetting>(
                        dense: true,
                        activeColor: primaryColor,
                        value: value,
                        controlAffinity: ListTileControlAffinity.trailing,
                        groupValue: selectedPaymentSetting,
                        onChanged: (PaymentSetting? ind) {
                          selectedPaymentSetting = ind;
                          setState(() {});
                        },
                        title: Text(value.title.validate(), style: primaryTextStyle()),
                      );
                    },
                  ),
                  Spacer(),
                  AppButton(
                    onTap: () {
                      if (selectedPaymentSetting == null) return toast(languages.chooseAnyOnePayment);

                      _handleClick();
                    },
                    text: languages.lblProceed,
                    color: context.primaryColor,
                    width: context.width(),
                  ).paddingAll(16),
                ],
              );
            },
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                imageWidget: ErrorStateWidget(),
              );
            },
          ),
          Observer(builder: (context) => LoaderWidget().center().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
