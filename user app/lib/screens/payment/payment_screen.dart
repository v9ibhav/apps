import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/booking_detail_model.dart';
import 'package:booking_system_flutter/screens/booking/component/price_common_widget.dart';
import 'package:booking_system_flutter/screens/wallet/user_wallet_balance_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/extensions/num_extenstions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/app_common_dialog.dart';
import '../../component/base_scaffold_widget.dart';
import '../../component/empty_error_state_widget.dart';
import '../../component/wallet_balance_component.dart';
import '../../model/payment_gateway_response.dart';
import '../../network/rest_apis.dart';
import '../../services/airtel_money/airtel_money_service.dart';
import '../../services/cinet_pay_services_new.dart';
import '../../services/flutter_wave_service_new.dart';
import '../../services/midtrans_service.dart';
import '../../services/paypal_service.dart';
import '../../services/paystack_service.dart';
import '../../services/phone_pe/phone_pe_service.dart';
import '../../services/razorpay_service_new.dart';
import '../../services/sadad_services_new.dart';
import '../../services/stripe_service_new.dart';
import '../../utils/configs.dart';
import '../../utils/model_keys.dart';
import '../dashboard/dashboard_screen.dart';

class PaymentScreen extends StatefulWidget {
  final BookingDetailResponse bookings;
  final bool isForAdvancePayment;

  PaymentScreen({required this.bookings, this.isForAdvancePayment = false});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Future<List<PaymentSetting>>? future;

  PaymentSetting? currentPaymentMethod;

  num totalAmount = 0;
  num? advancePaymentAmount;

  @override
  void initState() {
    super.initState();
    init();

    if (widget.bookings.service!.isAdvancePayment && widget.bookings.service!.isFixedService && !widget.bookings.service!.isFreeService && widget.bookings.bookingDetail!.bookingPackage == null) {
      if (widget.bookings.bookingDetail!.paidAmount.validate() == 0) {
        advancePaymentAmount = widget.bookings.bookingDetail!.totalAmount.validate() * widget.bookings.service!.advancePaymentPercentage.validate() / 100;
        totalAmount = widget.bookings.bookingDetail!.totalAmount.validate() * widget.bookings.service!.advancePaymentPercentage.validate() / 100;
      } else {
        totalAmount = widget.bookings.bookingDetail!.totalAmount.validate() - widget.bookings.bookingDetail!.paidAmount.validate();
      }
    } else {
      totalAmount = widget.bookings.bookingDetail!.totalAmount.validate();
    }

    log(totalAmount);
  }

  void init() async {
    log("ISaDVANCE${widget.isForAdvancePayment}");
    future = getPaymentGateways(requireCOD: !widget.isForAdvancePayment);
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _handleClick() async {
    appStore.setLoading(true);
    if (currentPaymentMethod!.type == PAYMENT_METHOD_COD) {
      savePay(paymentMethod: PAYMENT_METHOD_COD, paymentStatus: SERVICE_PAYMENT_STATUS_PENDING);
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_STRIPE) {
      StripeServiceNew stripeServiceNew = StripeServiceNew(
        paymentSetting: currentPaymentMethod!,
        totalAmount: totalAmount,
        onComplete: (p0) {
          savePay(
            paymentMethod: PAYMENT_METHOD_STRIPE,
            paymentStatus: widget.isForAdvancePayment ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : SERVICE_PAYMENT_STATUS_PAID,
            txnId: p0['transaction_id'],
          );
        },
      );

      stripeServiceNew.stripePay().catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_RAZOR) {
      RazorPayServiceNew razorPayServiceNew = RazorPayServiceNew(
        paymentSetting: currentPaymentMethod!,
        totalAmount: totalAmount,
        onComplete: (p0) {
          savePay(
            paymentMethod: PAYMENT_METHOD_RAZOR,
            paymentStatus: widget.isForAdvancePayment ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : SERVICE_PAYMENT_STATUS_PAID,
            txnId: p0['paymentId'],
          );
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
        totalAmount: totalAmount,
        onComplete: (p0) {
          savePay(
            paymentMethod: PAYMENT_METHOD_FLUTTER_WAVE,
            paymentStatus: widget.isForAdvancePayment ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : SERVICE_PAYMENT_STATUS_PAID,
            txnId: p0['transaction_id'],
          );
        },
      );
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_CINETPAY) {
      List<String> supportedCurrencies = ["XOF", "XAF", "CDF", "GNF", "USD"];

      if (!supportedCurrencies.contains(appConfigurationStore.currencyCode)) {
        toast(language.cinetPayNotSupportedMessage);
        return;
      } else if (totalAmount < 100) {
        return toast('${language.totalAmountShouldBeMoreThan} ${100.toPriceFormat()}');
      } else if (totalAmount > 1500000) {
        return toast('${language.totalAmountShouldBeLessThan} ${1500000.toPriceFormat()}');
      }

      CinetPayServicesNew cinetPayServices = CinetPayServicesNew(
        paymentSetting: currentPaymentMethod!,
        totalAmount: totalAmount,
        onComplete: (p0) {
          savePay(
            paymentMethod: PAYMENT_METHOD_CINETPAY,
            paymentStatus: widget.isForAdvancePayment ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : SERVICE_PAYMENT_STATUS_PAID,
            txnId: p0['transaction_id'],
          );
        },
      );

      cinetPayServices.payWithCinetPay(context: context).catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_SADAD_PAYMENT) {
      SadadServicesNew sadadServices = SadadServicesNew(
        paymentSetting: currentPaymentMethod!,
        totalAmount: totalAmount,
        remarks: language.topUpWallet,
        onComplete: (p0) {
          savePay(
            paymentMethod: PAYMENT_METHOD_SADAD_PAYMENT,
            paymentStatus: widget.isForAdvancePayment ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : SERVICE_PAYMENT_STATUS_PAID,
            txnId: p0['transaction_id'],
          );
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
        totalAmount: totalAmount,
        onComplete: (p0) {
          log('PayPalService onComplete: $p0');
          savePay(
            paymentMethod: PAYMENT_METHOD_PAYPAL,
            paymentStatus: widget.isForAdvancePayment ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : SERVICE_PAYMENT_STATUS_PAID,
            txnId: p0['transaction_id'],
          );
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
              amount: totalAmount,
              reference: APP_NAME,
              paymentSetting: currentPaymentMethod!,
              bookingId: widget.bookings.bookingDetail != null ? widget.bookings.bookingDetail!.id.validate() : 0,
              onComplete: (res) {
                log('RES: $res');
                savePay(
                  paymentMethod: PAYMENT_METHOD_AIRTEL,
                  paymentStatus: widget.isForAdvancePayment ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : SERVICE_PAYMENT_STATUS_PAID,
                  txnId: res['transaction_id'],
                );
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
        totalAmount: totalAmount.toDouble(),
        bookingId: widget.bookings.bookingDetail != null ? widget.bookings.bookingDetail!.id.validate() : 0,
        onComplete: (res) {
          savePay(
            paymentMethod: PAYMENT_METHOD_PAYSTACK,
            paymentStatus: widget.isForAdvancePayment ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : SERVICE_PAYMENT_STATUS_PAID,
            txnId: res["transaction_id"],
          );
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
        totalAmount: totalAmount,
        serviceId: widget.bookings.bookingDetail != null ? widget.bookings.bookingDetail!.serviceId.validate() : 0,
        serviceName: widget.bookings.bookingDetail != null ? widget.bookings.bookingDetail!.serviceName.validate() : '',
        servicePrice: widget.bookings.bookingDetail != null ? widget.bookings.bookingDetail!.amount.validate() : 0,
        loaderOnOFF: (p0) {
          appStore.setLoading(p0);
        },
        onComplete: (res) {
          savePay(
            paymentMethod: PAYMENT_METHOD_MIDTRANS,
            paymentStatus: widget.isForAdvancePayment ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : SERVICE_PAYMENT_STATUS_PAID,
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
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_PHONEPE) {
      PhonePeServices peServices = PhonePeServices(
        paymentSetting: currentPaymentMethod!,
        totalAmount: totalAmount.toDouble(),
        bookingId: widget.bookings.bookingDetail != null ? widget.bookings.bookingDetail!.id.validate() : 0,
        onComplete: (res) {
          log('RES: $res');
          savePay(
            paymentMethod: PAYMENT_METHOD_PHONEPE,
            paymentStatus: widget.isForAdvancePayment ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : SERVICE_PAYMENT_STATUS_PAID,
            txnId: res["transaction_id"],
          );
        },
      );

      peServices.phonePeCheckout(context).catchError((e) {
        appStore.setLoading(false);
        toast(e);
      });
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_FROM_WALLET) {
      savePay(
        paymentMethod: PAYMENT_METHOD_FROM_WALLET,
        paymentStatus: widget.isForAdvancePayment ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : SERVICE_PAYMENT_STATUS_PAID,
        txnId: '',
      );
    }
  }

  void savePay({String txnId = '', String paymentMethod = '', String paymentStatus = ''}) async {
    Map request = {
      CommonKeys.bookingId: widget.bookings.bookingDetail!.id.validate(),
      CommonKeys.customerId: appStore.userId,
      CouponKeys.discount: widget.bookings.service!.discount,
      BookingServiceKeys.totalAmount: totalAmount,
      CommonKeys.dateTime: DateFormat(BOOKING_SAVE_FORMAT).format(DateTime.now()),
      CommonKeys.txnId: txnId != '' ? txnId : "#${widget.bookings.bookingDetail!.id.validate()}",
      CommonKeys.paymentStatus: paymentStatus,
      CommonKeys.paymentMethod: paymentMethod,
    };

    if (widget.bookings.service != null && widget.bookings.service!.isAdvancePayment && widget.bookings.service!.isFixedService && !widget.bookings.service!.isFreeService && widget.bookings.bookingDetail!.bookingPackage == null) {
      request[AdvancePaymentKey.advancePaymentAmount] = advancePaymentAmount ?? widget.bookings.bookingDetail!.paidAmount;

      if ((widget.bookings.bookingDetail!.paymentStatus == null || widget.bookings.bookingDetail!.paymentStatus != SERVICE_PAYMENT_STATUS_ADVANCE_PAID || widget.bookings.bookingDetail!.paymentStatus != SERVICE_PAYMENT_STATUS_PAID) &&
          (widget.bookings.bookingDetail!.paidAmount == null || widget.bookings.bookingDetail!.paidAmount.validate() <= 0)) {
        // TODO: check this condition  widget.bookings.bookingPackage?.id == -1
        request[CommonKeys.paymentStatus] = SERVICE_PAYMENT_STATUS_ADVANCE_PAID;
      } else if (widget.bookings.bookingDetail!.paymentStatus == SERVICE_PAYMENT_STATUS_ADVANCE_PAID) {
        request[CommonKeys.paymentStatus] = SERVICE_PAYMENT_STATUS_PAID;
      }
    }

    appStore.setLoading(true);
    savePayment(request).then((value) {
      appStore.setLoading(false);
      push(DashboardScreen(redirectToBooking: true), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.payment,
      child: AnimatedScrollView(
        listAnimationType: ListAnimationType.FadeIn,
        fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
        physics: AlwaysScrollableScrollPhysics(),
        onSwipeRefresh: () async {
          if (!appStore.isLoading) init();
          return await 1.seconds.delay;
        },
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PriceCommonWidget(
                    bookingDetail: widget.bookings.bookingDetail!,
                    serviceDetail: widget.bookings.service!,
                    taxes: widget.bookings.bookingDetail!.taxes.validate(),
                    couponData: widget.bookings.couponData,
                    bookingPackage: widget.bookings.bookingDetail!.bookingPackage != null ? widget.bookings.bookingDetail!.bookingPackage : null,
                  ),
                  32.height,
                  Text(language.lblChoosePaymentMethod, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                ],
              ).paddingAll(16),
              SnapHelperWidget<List<PaymentSetting>>(
                future: future,
                onSuccess: (list) {
                  return AnimatedListView(
                    itemCount: list.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    listAnimationType: ListAnimationType.FadeIn,
                    fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                    emptyWidget: NoDataWidget(
                      title: language.noPaymentMethodFound,
                      imageWidget: EmptyStateWidget(),
                    ),
                    itemBuilder: (context, index) {
                      PaymentSetting value = list[index];

                      if (value.status.validate() == 0) return Offstage();

                      return RadioListTile<PaymentSetting>(
                        dense: true,
                        activeColor: primaryColor,
                        value: value,
                        controlAffinity: ListTileControlAffinity.trailing,
                        groupValue: currentPaymentMethod,
                        onChanged: (PaymentSetting? ind) {
                          currentPaymentMethod = ind;

                          setState(() {});
                        },
                        title: Text(value.title.validate(), style: primaryTextStyle()),
                      );
                    },
                  );
                },
              ),
              if (appConfigurationStore.isEnableUserWallet) WalletBalanceComponent().paddingSymmetric(vertical: 8, horizontal: 16),
              if (!appStore.isLoading)
                AppButton(
                  onTap: () async {
                    if (currentPaymentMethod == null) {
                      return toast(language.chooseAnyOnePayment);
                    }

                    if (currentPaymentMethod!.type == PAYMENT_METHOD_COD || currentPaymentMethod!.type == PAYMENT_METHOD_FROM_WALLET) {
                      if (currentPaymentMethod!.type == PAYMENT_METHOD_FROM_WALLET) {
                        appStore.setLoading(true);
                        num walletBalance = await getUserWalletBalance();

                        appStore.setLoading(false);
                        if (walletBalance >= totalAmount) {
                          showConfirmDialogCustom(
                            context,
                            dialogType: DialogType.CONFIRMATION,
                            title: "${language.lblPayWith} ${currentPaymentMethod!.title.validate()}?",
                            primaryColor: primaryColor,
                            positiveText: language.lblYes,
                            negativeText: language.lblCancel,
                            onAccept: (p0) {
                              _handleClick();
                            },
                          );
                        } else {
                          toast(language.insufficientBalanceMessage);

                          if (appConfigurationStore.onlinePaymentStatus) {
                            showConfirmDialogCustom(
                              context,
                              dialogType: DialogType.CONFIRMATION,
                              title: language.doYouWantToTopUpYourWallet,
                              positiveText: language.lblYes,
                              negativeText: language.lblNo,
                              cancelable: false,
                              primaryColor: context.primaryColor,
                              onAccept: (p0) {
                                pop();
                                push(UserWalletBalanceScreen());
                              },
                              onCancel: (p0) {
                                pop();
                              },
                            );
                          }
                        }
                      } else {
                        showConfirmDialogCustom(
                          context,
                          dialogType: DialogType.CONFIRMATION,
                          title: "${language.lblPayWith} ${currentPaymentMethod!.title.validate()}?",
                          primaryColor: primaryColor,
                          positiveText: language.lblYes,
                          negativeText: language.lblCancel,
                          onAccept: (p0) {
                            _handleClick();
                          },
                        );
                      }
                    } else {
                      _handleClick().catchError((e) {
                        appStore.setLoading(false);
                        toast(e.toString());
                      });
                    }
                  },
                  text: "${language.lblPayNow} ${totalAmount.toPriceFormat()}",
                  color: context.primaryColor,
                  width: context.width(),
                ).paddingAll(16),
            ],
          ),
        ],
      ),
    );
  }
}
