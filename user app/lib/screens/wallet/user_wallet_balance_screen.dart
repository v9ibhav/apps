// ignore_for_file: must_be_immutable

import 'package:booking_system_flutter/component/price_widget.dart';
import 'package:booking_system_flutter/services/flutter_wave_service_new.dart';
import 'package:booking_system_flutter/utils/extensions/num_extenstions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/app_common_dialog.dart';
import '../../component/base_scaffold_widget.dart';
import '../../component/empty_error_state_widget.dart';
import '../../main.dart';
import '../../model/payment_gateway_response.dart';
import '../../network/rest_apis.dart';
import '../../services/airtel_money/airtel_money_service.dart';
import '../../services/cinet_pay_services_new.dart';
import '../../services/midtrans_service.dart';
import '../../services/paypal_service.dart';
import '../../services/paystack_service.dart';
import '../../services/phone_pe/phone_pe_service.dart';
import '../../services/razorpay_service_new.dart';
import '../../services/sadad_services_new.dart';
import '../../services/stripe_service_new.dart';
import '../../utils/app_configuration.dart';
import '../../utils/colors.dart';
import '../../utils/configs.dart';
import '../../utils/constant.dart';
import '../../utils/images.dart';

class UserWalletBalanceScreen extends StatefulWidget {
  bool isBackScreen;
  UserWalletBalanceScreen({Key? key, this.isBackScreen = false}) : super(key: key);

  @override
  State<UserWalletBalanceScreen> createState() => _UserWalletBalanceScreenState();
}

class _UserWalletBalanceScreenState extends State<UserWalletBalanceScreen> {
  Future<List<PaymentSetting>>? future;

  TextEditingController walletAmountCont = TextEditingController(text: '0');
  FocusNode walletAmountFocus = FocusNode();

  List<int> defaultAmounts = [150, 200, 500, 1000, 5000, 10000];
  PaymentSetting? currentPaymentMethod;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getPaymentGateways(requireCOD: false, requireWallet: false);

    appStore.setUserWalletAmount();
  }

  void _handleClick() async {
    if (currentPaymentMethod == null) {
      return toast(language.pleaseChooseAnyOnePayment);
    } else if (walletAmountCont.text.toDouble() == 0) {
      return toast(language.theAmountShouldBeEntered);
    }

    if (currentPaymentMethod!.type == PAYMENT_METHOD_STRIPE) {
      StripeServiceNew stripeServiceNew = StripeServiceNew(
        paymentSetting: currentPaymentMethod!,
        totalAmount: walletAmountCont.text.toDouble(),
        onComplete: (p0) {
          Map req = {"amount": walletAmountCont.text.toDouble(), "transaction_type": PAYMENT_METHOD_STRIPE, "transaction_id": p0['transaction_id']};

          walletTopUpApi(request: req);
        },
      );

      stripeServiceNew.stripePay().catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_RAZOR) {
      RazorPayServiceNew razorPayServiceNew = RazorPayServiceNew(
        paymentSetting: currentPaymentMethod!,
        totalAmount: walletAmountCont.text.toDouble(),
        onComplete: (p0) {
          log(p0);
          Map req = {"amount": walletAmountCont.text.toDouble(), "transaction_type": PAYMENT_METHOD_RAZOR, "transaction_id": p0['orderId']};

          walletTopUpApi(request: req);
        },
      );
      razorPayServiceNew.razorPayCheckout().catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_FLUTTER_WAVE) {
      FlutterWaveServiceNew flutterWaveServiceNew = FlutterWaveServiceNew();

      flutterWaveServiceNew.checkout(
        paymentSetting: currentPaymentMethod!,
        totalAmount: walletAmountCont.text.toDouble(),
        onComplete: (p0) {
          Map req = {"amount": walletAmountCont.text.toDouble(), "transaction_type": PAYMENT_METHOD_FLUTTER_WAVE, "transaction_id": p0['transaction_id']};

          walletTopUpApi(request: req);
        },
      );
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_CINETPAY) {
      List<String> supportedCurrencies = ["XOF", "XAF", "CDF", "GNF", "USD"];

      if (!supportedCurrencies.contains(appConfigurationStore.currencyCode)) {
        toast(language.cinetPayNotSupportedMessage);
        return;
      } else if (walletAmountCont.text.toDouble() < 100) {
        return toast('${language.totalAmountShouldBeMoreThan} ${100.toPriceFormat()}');
      } else if (walletAmountCont.text.toDouble() > 1500000) {
        return toast('${language.totalAmountShouldBeLessThan} ${1500000.toPriceFormat()}');
      }

      CinetPayServicesNew cinetPayServices = CinetPayServicesNew(
        paymentSetting: currentPaymentMethod!,
        totalAmount: walletAmountCont.text.toDouble(),
        onComplete: (p0) {
          Map req = {"amount": walletAmountCont.text.toDouble(), "transaction_type": PAYMENT_METHOD_CINETPAY, "transaction_id": p0['transaction_id']};

          walletTopUpApi(request: req);
        },
      );

      cinetPayServices.payWithCinetPay(context: context).catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_SADAD_PAYMENT) {
      SadadServicesNew sadadServices = SadadServicesNew(
        paymentSetting: currentPaymentMethod!,
        totalAmount: walletAmountCont.text.toDouble(),
        remarks: language.topUpWallet,
        onComplete: (p0) {
          Map req = {
            "amount": walletAmountCont.text.toDouble(),
            "transaction_type": PAYMENT_METHOD_SADAD_PAYMENT,
            "transaction_id": p0['transaction_id'],
          };

          walletTopUpApi(request: req);
        },
      );

      sadadServices.payWithSadad(context).catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_PAYPAL) {
      PayPalService.paypalCheckOut(
        context: context,
        paymentSetting: currentPaymentMethod!,
        totalAmount: walletAmountCont.text.toDouble(),
        onComplete: (p0) {
          log('PayPalService onComplete: $p0');
          Map req = {"amount": walletAmountCont.text.toDouble(), "transaction_type": PAYMENT_METHOD_PAYPAL, "transaction_id": p0['transaction_id']};
          walletTopUpApi(request: req);
        },
      );
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_AIRTEL) {
      showInDialog(
        context,
        contentPadding: EdgeInsets.zero,
        barrierDismissible: false,
        builder: (context) {
          return AppCommonDialog(
            title: language.airtelMoneyPayment,
            child: AirtelMoneyDialog(
              amount: walletAmountCont.text.toDouble(),
              paymentSetting: currentPaymentMethod!,
              reference: APP_NAME,
              bookingId: appStore.userId.validate().toInt(),
              onComplete: (res) {
                log('RES: $res');
                Map req = {"amount": walletAmountCont.text.toDouble(), "transaction_type": PAYMENT_METHOD_AIRTEL, "transaction_id": res['transaction_id']};
                walletTopUpApi(request: req);
              },
            ),
          );
        },
      ).then((value) => appStore.setLoading(false));
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_PAYSTACK) {
      PayStackService paystackServices = PayStackService();
      appStore.setLoading(true);
      await paystackServices.init(
        context: context,
        currentPaymentMethod: currentPaymentMethod!,
        loderOnOFF: (p0) {
          appStore.setLoading(p0);
        },
        totalAmount: walletAmountCont.text.toDouble(),
        bookingId: appStore.userId.validate().toInt(),
        onComplete: (res) {
          log('RES: $res');
          Map req = {"amount": walletAmountCont.text.toDouble(), "transaction_type": PAYMENT_METHOD_PAYSTACK, "transaction_id": res['transaction_id']};
          walletTopUpApi(request: req);
        },
      );
      await Future.delayed(const Duration(seconds: 1));
      appStore.setLoading(false);
      paystackServices.checkout().catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_MIDTRANS) {
      MidtransService midtransService = MidtransService();
      appStore.setLoading(true);
      await midtransService.initialize(
        currentPaymentMethod: currentPaymentMethod!,
        totalAmount: walletAmountCont.text.toDouble(),
        loaderOnOFF: (p0) {
          appStore.setLoading(p0);
        },
        onComplete: (res) {
          log('RES: $res');
          Map req = {"amount": walletAmountCont.text.toDouble(), "transaction_type": PAYMENT_METHOD_MIDTRANS, "transaction_id": res['transaction_id']};
          walletTopUpApi(request: req);
        },
      );
      await Future.delayed(const Duration(seconds: 1));
      appStore.setLoading(false);
      midtransService.midtransPaymentCheckout().catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_PHONEPE) {
      PhonePeServices peServices = PhonePeServices(
        paymentSetting: currentPaymentMethod!,
        totalAmount: walletAmountCont.text.toDouble(),
        onComplete: (res) {
          log('RES: $res');
          Map req = {"amount": walletAmountCont.text.toDouble(), "transaction_type": PAYMENT_METHOD_PHONEPE, "transaction_id": res['transaction_id']};
          walletTopUpApi(request: req);
        },
      );

      peServices.phonePeCheckout(context).catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    }
  }

  String getPaymentMethodIcon(String value) {
    if (value == PAYMENT_METHOD_STRIPE) {
      return stripe_logo;
    } else if (value == PAYMENT_METHOD_RAZOR) {
      return razorpay_logo;
    } else if (value == PAYMENT_METHOD_CINETPAY) {
      return cinetpay_logo;
    } else if (value == PAYMENT_METHOD_FLUTTER_WAVE) {
      return flutter_wave_logo;
    } else if (value == PAYMENT_METHOD_SADAD_PAYMENT) {
      return "";
    } else if (value == PAYMENT_METHOD_PAYPAL) {
      return paypal_logo;
    } else if (value == PAYMENT_METHOD_AIRTEL) {
      return airtel_logo;
    } else if (value == PAYMENT_METHOD_PAYSTACK) {
      return paystack_logo;
    } else if (value == PAYMENT_METHOD_PHONEPE) {
      return phonepe_logo;
    }

    return '';
  }

  walletTopUpApi({required Map request}) {
    walletTopUp(request).then((value) {
      if (widget.isBackScreen) {
        finish(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.myWallet,
      child: Stack(
        children: [
          AnimatedScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            listAnimationType: ListAnimationType.None,
            onSwipeRefresh: () {
              appStore.setUserWalletAmount();

              return 1.seconds.delay;
            },
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: context.width(),
                    padding: EdgeInsets.all(16),
                    color: context.cardColor,
                    child: Row(
                      children: [
                        Text(language.balance, style: boldTextStyle(color: context.primaryColor)).expand(),
                        Observer(builder: (context) => PriceWidget(price: appStore.userWalletAmount, size: 16, isBoldText: true, color: Colors.green)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.height,
                      Text(language.topUpWallet, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                      8.height,
                      Text(language.topUpAmountQuestion, style: secondaryTextStyle()),
                      Container(
                        width: context.width(),
                        margin: EdgeInsets.symmetric(vertical: 16),
                        padding: EdgeInsets.all(16),
                        decoration: boxDecorationDefault(
                          color: walletCardColor,
                          borderRadius: radius(8),
                        ),
                        child: Column(
                          children: [
                            AppTextField(
                              textFieldType: TextFieldType.NUMBER,
                              //  textAlign: TextAlign.center,
                              controller: walletAmountCont,
                              focus: walletAmountFocus,
                              textStyle: primaryTextStyle(color: Colors.white),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onTap: () {
                                if (walletAmountCont.text == '0') {
                                  walletAmountCont.selection = TextSelection(baseOffset: 0, extentOffset: walletAmountCont.text.length);
                                }
                              },
                              decoration: InputDecoration(
                                prefixText: isCurrencyPositionLeft ? appConfigurationStore.currencySymbol + " " : '',
                                prefixStyle: primaryTextStyle(color: Colors.white),
                                suffixText: isCurrencyPositionRight ? appConfigurationStore.currencySymbol + " " : '',
                                suffixStyle: primaryTextStyle(color: Colors.white),
                              ),
                              onChanged: (p0) {
                                //
                              },
                            ),
                            24.height,
                            Wrap(
                              spacing: 30,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: List.generate(defaultAmounts.length, (index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  decoration: boxDecorationDefault(
                                    color: defaultAmounts[index].toString() == walletAmountCont.text ? white : Colors.white12,
                                    borderRadius: radius(8),
                                    border: Border.all(color: defaultAmounts[index].toString() == walletAmountCont.text ? context.primaryColor : Colors.white12),
                                  ),
                                  child: Text(
                                    defaultAmounts[index].toString().formatNumberWithComma(),
                                    style: primaryTextStyle(color: defaultAmounts[index].toString() == walletAmountCont.text ? context.primaryColor : Colors.white),
                                  ),
                                ).onTap(() {
                                  walletAmountCont.text = defaultAmounts[index].toString();
                                  setState(() {});
                                });
                              }),
                            ),
                          ],
                        ),
                      ),
                      16.height,
                      Text(language.paymentMethod, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                      4.height,
                      Text(language.selectYourPaymentMethodToAddBalance, style: secondaryTextStyle()),
                      4.height,
                      SnapHelperWidget<List<PaymentSetting>>(
                        future: future,
                        onSuccess: (list) {
                          return AnimatedWrap(
                            itemCount: list.length,
                            listAnimationType: ListAnimationType.FadeIn,
                            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                            spacing: 8,
                            runSpacing: 16,
                            itemBuilder: (context, index) {
                              if (list.isEmpty)
                                return NoDataWidget(
                                  title: language.lblNoPayments,
                                  imageWidget: EmptyStateWidget(),
                                );
                              PaymentSetting value = list[index];
                              if (value.status.validate() == 0) return Offstage();
                              String icon = getPaymentMethodIcon(value.type.validate());

                              return Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                    child: Container(
                                      width: context.width() * 0.240,
                                      height: 60,
                                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                      decoration: boxDecorationDefault(
                                        borderRadius: radius(8),
                                        border: Border.all(color: primaryColor),
                                      ),
                                      alignment: Alignment.center,
                                      child: icon.isNotEmpty ? Image.asset(icon) : Text(value.type.validate(), style: primaryTextStyle()),
                                    ).onTap(() {
                                      currentPaymentMethod = value;

                                      setState(() {});
                                    }),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: currentPaymentMethod == value ? EdgeInsets.all(2) : EdgeInsets.zero,
                                      decoration: boxDecorationDefault(color: context.primaryColor),
                                      child: currentPaymentMethod == value ? Icon(Icons.done, size: 16, color: Colors.white) : Offstage(),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      100.height,
                    ],
                  ).paddingSymmetric(horizontal: 16),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: AppButton(
              width: context.width(),
              height: 16,
              color: context.primaryColor,
              text: language.proceedToTopUp,
              textStyle: boldTextStyle(color: white),
              onTap: () async {
                hideKeyboard(context);
                _handleClick();
              },
            ),
          ),
        ],
      ),
    );
  }
}
