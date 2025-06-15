import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_common_dialog.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_provider_flutter/components/empty_error_state_widget.dart';
import 'package:handyman_provider_flutter/components/price_widget.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/models/static_data_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/payment/components/airtel_money/airtel_money_service.dart';
import 'package:handyman_provider_flutter/provider/payment/components/cinet_pay_services_new.dart';
import 'package:handyman_provider_flutter/provider/payment/components/flutter_wave_service_new.dart';
import 'package:handyman_provider_flutter/provider/payment/components/midtrans_service.dart';
import 'package:handyman_provider_flutter/provider/payment/components/paypal_service.dart';
import 'package:handyman_provider_flutter/provider/payment/components/paystack_service.dart';
import 'package:handyman_provider_flutter/provider/payment/components/phone_pe/phone_pe_service.dart';
import 'package:handyman_provider_flutter/provider/payment/components/razorpay_service_new.dart';
import 'package:handyman_provider_flutter/provider/payment/components/stripe_service_new.dart';
import 'package:handyman_provider_flutter/provider/promotional_banner/promotional_banner_repository.dart';
import 'package:handyman_provider_flutter/utils/app_configuration.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/extensions/color_extension.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/cached_image_widget.dart';
import '../../main.dart';
import '../../utils/common.dart';
import '../../utils/constant.dart';
import '../payment/components/sadad_services_new.dart';
import '../services/service_detail_screen.dart';
import 'model/promotional_banner_response.dart';

class PromotionalBannerDetailScreen extends StatefulWidget {
  final PromotionalBannerListData promotionalBannerData;

  PromotionalBannerDetailScreen({required this.promotionalBannerData});

  @override
  State<PromotionalBannerDetailScreen> createState() => _PromotionalBannerDetailScreenState();
}

class _PromotionalBannerDetailScreenState extends State<PromotionalBannerDetailScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UniqueKey uniqueKey = UniqueKey();
  List<PaymentSetting> paymentList = [];

  PaymentSetting? selectedPaymentSetting;
  String totalDaysCount = '';

  TextEditingController titleCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();
  TextEditingController linkCont = TextEditingController();

  bool isPaymentPending = false;

  List<ServiceData> serviceList = [];

  String selectedType = PROMOTIONAL_TYPE_SERVICE;

  ServiceData? selectedService;

  String bannerId = '';

  List<StaticDataModel> typeStaticData = [
    StaticDataModel(key: PROMOTIONAL_TYPE_SERVICE, value: languages.lblService),
    StaticDataModel(key: PROMOTIONAL_TYPE_LINK, value: languages.link),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    getAllService();
    getPaymentMethods();

    // Sync new configurations for secret keys
    await setValue(LAST_APP_CONFIGURATION_SYNCED_TIME, 0);
    getAppConfigurations();
  }

  /// Get All Service API
  Future<void> getAllService() async {
    appStore.setLoading(true);

    await getAllServiceList(providerId: appStore.providerId, perPage: 'all').then((value) {
      serviceList = value.data.validate();

      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    appStore.setLoading(false);
  }

  /// Get Payment Methods API
  Future<void> getPaymentMethods() async {
    appStore.setLoading(true);

    await getPaymentGateways(requireCOD: false).then((paymentListData) {
      paymentList = paymentListData.validate();

      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    appStore.setLoading(false);
  }
  //endregion

  /// Region Handle Payment Method Click
  Future<void> _handleClick() async {

    if (widget.promotionalBannerData.id == null) {
      toast('Banner ID is required before proceeding with payment.');
      return;
    }

    if (selectedPaymentSetting == null) {
      toast('Please choose a payment method');
      return;
    }

    try {
      await _handlePayment();
      isPaymentPending = false;
      setState(() {});
    } catch (e) {
      isPaymentPending = true;
      setState(() {});
      appStore.setLoading(false);
      toast(e.toString());
    }
  }

  Future<void> _handlePayment() async {
    if (selectedPaymentSetting!.type == PAYMENT_METHOD_STRIPE) {
      StripeServiceNew stripeServiceNew = StripeServiceNew(
        paymentSetting: selectedPaymentSetting!,
        totalAmount: widget.promotionalBannerData.totalAmount.toDouble(),
        onComplete: (p0) {
          savePay(
            paymentMethod: PAYMENT_METHOD_STRIPE,
            paymentStatus: SERVICE_PAYMENT_STATUS_PAID,
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
        totalAmount: widget.promotionalBannerData.totalAmount.toDouble(),
        onComplete: (p0) {
          savePay(
            paymentMethod: PAYMENT_METHOD_RAZOR,
            paymentStatus: SERVICE_PAYMENT_STATUS_PAID,
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
        totalAmount: widget.promotionalBannerData.totalAmount.toDouble(),
        onComplete: (p0) {
          savePay(
            paymentMethod: PAYMENT_METHOD_FLUTTER_WAVE,
            paymentStatus: SERVICE_PAYMENT_STATUS_PAID,
            txnId: p0['transaction_id'],
          );
        },
      );
    } else if (selectedPaymentSetting!.type == PAYMENT_METHOD_CINETPAY) {
      List<String> supportedCurrencies = ["XOF", "XAF", "CDF", "GNF", "USD"];

      if (!supportedCurrencies.contains(appConfigurationStore.currencyCode)) {
        toast(languages.cinetpayIsnTSupportedByCurrencies);
        return;
      } else if (totalAmount < 100) {
        return toast('${languages.totalAmountShouldBeMoreThan} ${100.toPriceFormat()}');
      } else if (totalAmount > 1500000) {
        return toast('${languages.totalAmountShouldBeLessThan} ${1500000.toPriceFormat()}');
      }

      CinetPayServicesNew cinetPayServices = CinetPayServicesNew(
        paymentSetting: selectedPaymentSetting!,
        totalAmount: widget.promotionalBannerData.totalAmount.toDouble(),
        onComplete: (p0) {
          savePay(
            paymentMethod: PAYMENT_METHOD_CINETPAY,
            paymentStatus: SERVICE_PAYMENT_STATUS_PAID,
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
        totalAmount: widget.promotionalBannerData.totalAmount.toDouble(),
        onComplete: (p0) {
          savePay(
            paymentMethod: PAYMENT_METHOD_SADAD_PAYMENT,
            paymentStatus: SERVICE_PAYMENT_STATUS_PAID,
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
        totalAmount: widget.promotionalBannerData.totalAmount.toDouble(),
        onComplete: (p0) {
          log('PayPalService onComplete: $p0');
          savePay(
            paymentMethod: PAYMENT_METHOD_PAYPAL,
            paymentStatus: SERVICE_PAYMENT_STATUS_PAID,
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
              amount: widget.promotionalBannerData.totalAmount.toDouble(),
              reference: APP_NAME,
              paymentSetting: selectedPaymentSetting!,
              bookingId: appStore.userId.validate().toInt(),
              //TODO: set banner id if possible
              onComplete: (res) {
                log('RES: $res');
                savePay(
                  paymentMethod: PAYMENT_METHOD_AIRTEL,
                  paymentStatus: SERVICE_PAYMENT_STATUS_PAID,
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
        totalAmount: widget.promotionalBannerData.totalAmount.toDouble(),
        bookingId: appStore.userId.validate().toInt(),
        //TODO: set banner id if possible
        onComplete: (res) {
          savePay(
            paymentMethod: PAYMENT_METHOD_PAYSTACK,
            paymentStatus: SERVICE_PAYMENT_STATUS_PAID,
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
    } else if (selectedPaymentSetting!.type == PAYMENT_METHOD_MIDTRANS) {
      MidtransService midtransService = MidtransService();
      appStore.setLoading(true);
      await midtransService.initialize(
        currentPaymentMethod: selectedPaymentSetting!,
        totalAmount:widget.promotionalBannerData.totalAmount.toDouble(),
        loaderOnOFF: (p0) {
          appStore.setLoading(p0);
        },
        onComplete: (res) {
          savePay(
            paymentMethod: PAYMENT_METHOD_MIDTRANS,
            paymentStatus: SERVICE_PAYMENT_STATUS_PAID,
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
        totalAmount: widget.promotionalBannerData.totalAmount.toDouble(),
        bookingId: appStore.userId.validate().toInt(), //TODO: set banner id if possible
        onComplete: (res) {
          log('RES: $res');
          savePay(
            paymentMethod: PAYMENT_METHOD_PHONEPE,
            paymentStatus: SERVICE_PAYMENT_STATUS_PAID,
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

  Future<void> savePay({String txnId = '', String paymentMethod = '', String paymentStatus = ''}) async {
    if (widget.promotionalBannerData.id == null) {
      toast('Banner ID is required to update payment status');
      return;
    }

    Map request = {
      PromotionalBannerKey.bannerId: widget.promotionalBannerData.id,
      PromotionalBannerKey.txnId: txnId.isNotEmpty ? txnId : "#${widget.promotionalBannerData.id}",
      PromotionalBannerKey.paymentStatus: paymentStatus,
      PromotionalBannerKey.paymentType: paymentMethod,
      PromotionalBannerKey.startDate: widget.promotionalBannerData.startDate.toString(),
      PromotionalBannerKey.endDate: widget.promotionalBannerData.endDate.toString(),
    };

    appStore.setLoading(true);
    log('Updating Payment Status: $request');

    await savePromotionalBannerPayment(request).then((value) {
      toast(value.message.validate());
      isPaymentPending = false;
      setState(() {});
      finish(context);
    }).catchError((e) {
      appStore.setLoading(false);
      log(e.toString());
    }).whenComplete(() => appStore.setLoading(false));
  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (appStore.isLoading) {
      appStore.setLoading(false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.promotionalBannerDetail,
      showLoader: false,
      body: AnimatedScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        listAnimationType: ListAnimationType.FadeIn,
        fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedImageWidget(
            url: widget.promotionalBannerData.image.validate(),
            fit: BoxFit.fill,
            height: 200,
            width: context.width(),
            radius: defaultRadius,
          ),
          16.height,
          Row(
            children: [
              Text(
                '${formatBookingDate(widget.promotionalBannerData.startDate, format: DATE_FORMAT_2)} ${languages.to} ${formatBookingDate(widget.promotionalBannerData.endDate, format: DATE_FORMAT_2)}',
                style: boldTextStyle(),
              ).expand(),
              16.width,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: radius(16),
                  backgroundColor: widget.promotionalBannerData.status.validate().getPromBannerStatusBackgroundColor,
                ),
                child: Text(
                  widget.promotionalBannerData.status.validate().toPromotionalBannerStatus(),
                  style: boldTextStyle(color: Colors.white, size: 12),
                ),
              ),
            ],
          ),
          if(widget.promotionalBannerData.description.validate().isNotEmpty)...[
            16.height,
            ReadMoreText(
              widget.promotionalBannerData.description.validate(),
              style: secondaryTextStyle(),
              colorClickableText: context.primaryColor,
            ),
          ],
          16.height,
          Row(
            children: [
              Text('${languages.type} ', style: secondaryTextStyle()),
              4.width,
              Text(widget.promotionalBannerData.bannerType.validate().toPromotionalBannerType(), style: boldTextStyle()),
            ],
          ),
          if (widget.promotionalBannerData.bannerType == PROMOTIONAL_TYPE_SERVICE)
            Text(widget.promotionalBannerData.serviceName.validate(), style: boldTextStyle()).onTap(() {
              ServiceDetailScreen(serviceId: widget.promotionalBannerData.serviceId.validate()).launch(context);
            }).paddingTop(16),
          if (widget.promotionalBannerData.bannerType == PROMOTIONAL_TYPE_LINK)
            Text(
              widget.promotionalBannerData.bannerRedirectUrl.validate(),
              style: boldTextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue,
              ),
            ).onTap(() {
              commonLaunchUrl(
                widget.promotionalBannerData.bannerRedirectUrl.validate(),
                launchMode: LaunchMode.externalApplication,
              );
            }).paddingTop(16),
          16.height,
          Row(
            children: [
              Text('${languages.paymentStatus}:', style: secondaryTextStyle()),
              4.width,
              Text(widget.promotionalBannerData.paymentStatus.validate().toPaymentStatus(), style: boldTextStyle(color: widget.promotionalBannerData.paymentStatus == 'paid' ? greenColor : redColor)),
            ],
          ),
            if(widget.promotionalBannerData.paymentStatus  == 'paid')...[
              16.height,
              Row(
                children: [
                  Text(languages.totalAmount, style: secondaryTextStyle()),
                  4.width,
                  PriceWidget(price: widget.promotionalBannerData.totalAmount.toDouble()),
                ],
              ),
            ],

          if (paymentList.isNotEmpty) ...[
            if(widget.promotionalBannerData.paymentStatus  == 'pending' && widget.promotionalBannerData.status == 'pending')...[
              20.height,
              Text(languages.lblChoosePaymentMethod, style: boldTextStyle()),
              4.height,
              AnimatedListView(
                itemCount: paymentList.length,
                shrinkWrap: true,
                listAnimationType: ListAnimationType.FadeIn,
                physics: NeverScrollableScrollPhysics(),
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                emptyWidget: NoDataWidget(
                  imageWidget: EmptyStateWidget(),
                  title: languages.noPaymentMethodsFound,
                ),
                itemBuilder: (context, index) {
                  PaymentSetting paymentData = paymentList[index];

                  return RadioListTile<PaymentSetting>(
                    dense: true,
                    activeColor: primaryColor,
                    value: paymentData,
                    controlAffinity: ListTileControlAffinity.trailing,
                    groupValue: selectedPaymentSetting,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    onChanged: (PaymentSetting? ind) {
                      selectedPaymentSetting = ind;
                      setState(() {});
                    },
                    title: Text(paymentData.title.validate(), style: primaryTextStyle()),
                  );
                },
              ),
              16.height,
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(languages.lblTotalAmount, style: boldTextStyle()),
                        16.width,
                        Observer(builder: (context) {
                          return PriceWidget(price: widget.promotionalBannerData.totalAmount.toDouble(), color: primaryColor);
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              16.height,
              Observer(
                builder: (_) => AppButton(
                  text: languages.pay,
                  height: 40,
                  enabled: selectedPaymentSetting != null,
                  disabledColor: primaryColor.withValues(alpha: 0.5),
                  color:primaryColor,
                  textStyle: boldTextStyle(color: Colors.white),
                  width: context.width(),
                  onTap: appStore.isLoading
                      ? () {}
                      : () {
                    _handleClick(); // Retry payment if pending
                  },
                ),
              ),
            ]

          ],
        ],
      ),
    );
  }

  num get totalAmount => (appConfigurationStore.bannerPerDayAmount * totalDaysCount.toInt(defaultValue: 1));
}