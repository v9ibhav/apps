import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:uuid/uuid.dart';

import '../../../../components/app_widgets.dart';
import '../../../../components/cached_image_widget.dart';
import '../../../../networks/network_utils.dart';
import '../../../../utils/app_configuration.dart';
import '../../../../utils/common.dart';
import '../../../../utils/configs.dart';
import '../../../../utils/images.dart' hide delete;
import 'airtel_payment_response.dart';
import 'aritel_auth_model.dart';

class AirtelMoneyDialog extends StatefulWidget {
  final String reference;
  final int bookingId;
  final PaymentSetting paymentSetting;
  final num amount;
  final Function(Map<String, dynamic>) onComplete;

  const AirtelMoneyDialog({
    super.key,
    required this.onComplete,
    required this.reference,
    required this.bookingId,
    required this.amount,
    required this.paymentSetting,
  });

  @override
  State<AirtelMoneyDialog> createState() => _AirtelMoneyDialogState();
}

class _AirtelMoneyDialogState extends State<AirtelMoneyDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _textFieldMSISDN = TextEditingController();

  bool isTxnInProgress = false;
  bool isSuccess = false;
  bool isFailToGenerateReq = false;
  String responseCode = "";

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: context.width(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isFailToGenerateReq
                  ? Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
                          child: const Icon(Icons.close_sharp, color: Colors.white),
                        ),
                        10.height,
                        Text(getAirtelMoneyReasonTextFromCode(responseCode).$1, style: boldTextStyle()),
                        16.height,
                        Text(getAirtelMoneyReasonTextFromCode(responseCode).$2, textAlign: TextAlign.center, style: secondaryTextStyle()),
                      ],
                    ).paddingAll(16)
                  : isSuccess
                      ? Column(
                          children: [
                            CachedImageWidget(url: ic_verified, height: 60),
                            10.height,
                            Text(languages.paymentSuccess, style: boldTextStyle()),
                            16.height,
                            Text(languages.redirectingToBookings, textAlign: TextAlign.center, style: secondaryTextStyle()),
                          ],
                        ).paddingAll(16)
                      : isTxnInProgress
                          ? Column(
                              children: [
                                LoaderWidget(),
                                10.height,
                                Text(languages.transactionIsInProcess, style: boldTextStyle()),
                                16.height,
                                Text(languages.pleaseCheckThePayment, textAlign: TextAlign.center, style: secondaryTextStyle()),
                              ],
                            ).paddingAll(16)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Form(
                                  key: formKey,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  child: AppTextField(
                                    controller: _textFieldMSISDN,
                                    textFieldType: TextFieldType.NAME,
                                    decoration: inputDecoration(context, hint: languages.enterYourMsisdnHere),
                                  ),
                                ),
                                16.height,
                                AppButton(
                                  color: primaryColor,
                                  height: 40,
                                  text: languages.lblSubmit,
                                  textStyle: boldTextStyle(color: Colors.white),
                                  width: context.width() - context.navigationBarHeight,
                                  onTap: () {
                                    hideKeyboard(context);
                                    maxApiCallCount = 30;
                                    _handleClick();
                                  },
                                ),
                              ],
                            ).paddingAll(16)
            ],
          ),
        ),
        Observer(
          builder: (context) => LoaderWidget().withSize(height: 80, width: 80).visible(appStore.isLoading && !isTxnInProgress),
        )
      ],
    );
  }

  void _handleClick() async {
    String transactionId = "${const Uuid().v1()}-${widget.bookingId}";

    isFailToGenerateReq = false;
    responseCode = "";

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      appStore.isLoading = true;
      await authorizeAirtelClient(widget.paymentSetting).then((value) async {
        log('acess tokn ${value.accessToken}');
        await paymentAirtelClient(
                reference: APP_NAME, txnId: transactionId, msisdn: _textFieldMSISDN.text.trim(), amount: widget.amount, accessToken: value.accessToken.validate(), currentPaymentMethod: widget.paymentSetting)
            .then((value) async {
          if (value.status != null && value.status!.responseCode == AirtelMoneyResponseCodes.IN_PROCESS) {
            isTxnInProgress = true;
            setState(() {});
            isSuccess = await checkAirtelPaymentStatus(
              txnId: transactionId,
              currentPaymentMethod: widget.paymentSetting,
              loderOnOFF: (p0) {
                appStore.setLoading(p0);
              },
            );
            setState(() {});
            if (isSuccess) {
              widget.onComplete.call({
                'transaction_id': transactionId,
              });
            }
          } else if (value.status != null) {
            isFailToGenerateReq = true;
            responseCode = value.status!.responseCode.validate();
            setState(() {});
          }
        });
        appStore.setLoading(false);
      });
    }
  }
}

//region airtel pay
Future<AirtelAuthModel> authorizeAirtelClient(PaymentSetting currentPaymentMethod) async {
  Map<dynamic, dynamic>? request = {
    "client_id": currentPaymentMethod.isTest == 1 ? currentPaymentMethod.testValue!.airtelClientId.validate() : currentPaymentMethod.liveValue!.airtelClientId.validate(),
    "client_secret": currentPaymentMethod.isTest == 1 ? currentPaymentMethod.testValue!.airtelSecretKey.validate() : currentPaymentMethod.liveValue!.airtelSecretKey.validate(),
    "grant_type": "client_credentials"
  };

  return AirtelAuthModel.fromJson(
    await handleResponse(
      await airtelPayBuildHttpResponse(
        'auth/oauth2/token',
        request: request,
        currentPaymentMethod: currentPaymentMethod,
        method: HttpMethodType.POST,
      ),
    ),
  );
}

Future<AirtelPaymentResponse> paymentAirtelClient({
  required String reference,
  required String accessToken,
  required String txnId,
  required String msisdn,
  required num amount,
  required PaymentSetting currentPaymentMethod,
}) async {
  Map<dynamic, dynamic>? request = {
    "reference": reference,
    "subscriber": {"country": AIRTEL_COUNTRY_CODE, "currency": await isIqonicProduct ? AIRTEL_CURRENCY_CODE : '${appConfigurationStore.currencyCode}', "msisdn": msisdn},
    "transaction": {"amount": amount, "country": AIRTEL_COUNTRY_CODE, "currency": await isIqonicProduct ? AIRTEL_CURRENCY_CODE : '${appConfigurationStore.currencyCode}', "id": txnId}
  };

  return AirtelPaymentResponse.fromJson(
    await handleResponse(
      await airtelPayBuildHttpResponse(
        'merchant/v1/payments/',
        request: request,
        currentPaymentMethod: currentPaymentMethod,
        method: HttpMethodType.POST,
        extraKeys: {'X-Country': AIRTEL_COUNTRY_CODE, 'X-Currency': await isIqonicProduct ? AIRTEL_CURRENCY_CODE : '${appConfigurationStore.currencyCode}', 'access_token': accessToken, 'isAirtelMoney': true},
      ),
    ),
  );
}

int maxApiCallCount = 30;
AirtelPaymentResponse res = AirtelPaymentResponse();

Future<bool> checkAirtelPaymentStatus({
  required String txnId,
  required Function(bool) loderOnOFF,
  required PaymentSetting currentPaymentMethod,
}) async {
  bool isSuccess = false;
  if (maxApiCallCount <= 0) {
    return isSuccess;
  }
  await authorizeAirtelClient(currentPaymentMethod).then((value) async {
    log('acess tokn ${value.accessToken}');
    log('maxApiCallCount is $maxApiCallCount');

    res = AirtelPaymentResponse.fromJson(
      await handleResponse(
        await airtelPayBuildHttpResponse(
          'standard/v1/payments/$txnId',
          currentPaymentMethod: currentPaymentMethod,
          extraKeys: {
            'X-Country': AIRTEL_COUNTRY_CODE,
            'X-Currency': await isIqonicProduct ? AIRTEL_CURRENCY_CODE : '${appConfigurationStore.currencyCode}',
            'access_token': '${value.accessToken}',
            'isAirtelMoney': true,
          },
          method: HttpMethodType.GET,
        ),
      ),
    );
    if (res.status != null && res.status!.responseCode == AirtelMoneyResponseCodes.SUCCESS) {
      isSuccess = true;
      return isSuccess;
    } else if (maxApiCallCount > 0 && res.status != null && res.status!.responseCode == AirtelMoneyResponseCodes.IN_PROCESS) {
      await Future.delayed(const Duration(seconds: 2));
      maxApiCallCount--;
      // toast("$maxApiCallCount");
      isSuccess = await checkAirtelPaymentStatus(txnId: txnId, loderOnOFF: loderOnOFF, currentPaymentMethod: currentPaymentMethod);
    } else {
      loderOnOFF(false);
      log('return here');
      return isSuccess;
    }
  });
  return isSuccess;
}

Future<Response> airtelPayBuildHttpResponse(
  String endPoint, {
  HttpMethodType method = HttpMethodType.GET,
  Map? request,
  Map? extraKeys,
  required PaymentSetting currentPaymentMethod,
}) async {
  if (await isNetworkAvailable()) {
    var headers = buildHeaderForAirtelMoney(extraKeys!['access_token'], extraKeys['X-Country'], extraKeys['X-Currency']);
    //  Uri url = buildBaseUrl(endPoint);
    Uri url = Uri.parse(endPoint);
    url = Uri.parse('${currentPaymentMethod.isTest == 1 ? AIRTEL_TEST_BASE_URL : AIRTEL_LIVE_BASE_URL}$endPoint');

    Response response;
    print('url : $url');
    if (method == HttpMethodType.POST) {
      log('Request: ${jsonEncode(request)}');
      response = await http.post(url, body: jsonEncode(request), headers: headers);
    } else if (method == HttpMethodType.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethodType.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    log('Response (${method.name}) ${response.statusCode}: ${response.body}');

    return response;
  } else {
    throw errorInternetNotAvailable;
  }
}

//Airtel Money Constants
// region AirtelMoney Const
class AirtelMoneyResponseCodes {
  static const AMBIGUOUS = "DP00800001000";
  static const SUCCESS = "DP00800001001";
  static const INCORRECT_PIN = "DP00800001002";
  static const LIMIT_EXCEEDED = "DP00800001003";
  static const INVALID_AMOUNT = "DP00800001004";
  static const INVALID_TRANSACTION_ID = "DP00800001005";
  static const IN_PROCESS = "DP00800001006";
  static const INSUFFICIENT_BALANCE = "DP00800001007";
  static const REFUSED = "DP00800001008";
  static const DO_NOT_HONOR = "DP00800001009";
  static const TRANSACTION_NOT_PERMITTED = "DP00800001010";
  static const TRANSACTION_TIMED_OUT = "DP00800001024";
  static const TRANSACTION_NOT_FOUND = "DP00800001025";
  static const FORBIDDEN = "DP00800001026";
  static const FETCHED_ENCRYPTION_KEY_SUCCESSFULLY = "DP00800001027";
  static const ERROR_FETCHING_ENCRYPTION_KEY = "DP00800001028";
  static const TRANSACTION_EXPIRED = "DP00800001029";
}

(String, String) getAirtelMoneyReasonTextFromCode(String code) {
  switch (code) {
    case AirtelMoneyResponseCodes.AMBIGUOUS:
      return (languages.ambiguous, languages.theTransactionIsStill);
    case AirtelMoneyResponseCodes.SUCCESS:
      return (languages.success, languages.transactionIsSuccessful);
    case AirtelMoneyResponseCodes.INCORRECT_PIN:
      return (languages.incorrectPin, languages.incorrectPinHasBeen);
    case AirtelMoneyResponseCodes.LIMIT_EXCEEDED:
      return (languages.exceedsWithdrawalAmountLimitS, languages.theUserHasExceeded);
    case AirtelMoneyResponseCodes.INVALID_AMOUNT:
      return (languages.invalidAmount, languages.theAmountUserIs);
    case AirtelMoneyResponseCodes.INVALID_TRANSACTION_ID:
      return (languages.transactionIdIsInvalid, languages.userDidnTEnterThePin);
    case AirtelMoneyResponseCodes.IN_PROCESS:
      return (languages.inProcess, languages.transactionInPendingState);
    case AirtelMoneyResponseCodes.INSUFFICIENT_BALANCE:
      return (languages.notEnoughBalance, languages.userWalletDoesNot);
    case AirtelMoneyResponseCodes.REFUSED:
      return (languages.refused, languages.theTransactionWasRefused);
    case AirtelMoneyResponseCodes.DO_NOT_HONOR:
      return (languages.doNotHonor, languages.thisIsAGeneric);
    case AirtelMoneyResponseCodes.TRANSACTION_NOT_PERMITTED:
      return (languages.transactionNotPermittedTo, languages.payeeIsAlreadyInitiated);
    case AirtelMoneyResponseCodes.TRANSACTION_TIMED_OUT:
      return (languages.transactionTimedOut, languages.theTransactionWasTimed);
    case AirtelMoneyResponseCodes.TRANSACTION_NOT_FOUND:
      return (languages.transactionNotFound, languages.theTransactionWasNot);
    case AirtelMoneyResponseCodes.FORBIDDEN:
      return (languages.forBidden, languages.xSignatureAndPayloadDid);
    case AirtelMoneyResponseCodes.FETCHED_ENCRYPTION_KEY_SUCCESSFULLY:
      return (languages.successfullyFetchedEncryptionKey, languages.encryptionKeyHasBeen);
    case AirtelMoneyResponseCodes.ERROR_FETCHING_ENCRYPTION_KEY:
      return (languages.errorWhileFetchingEncryption, languages.couldNotFetchEncryption);
    case AirtelMoneyResponseCodes.TRANSACTION_EXPIRED:
      return (languages.transactionExpired, languages.transactionHasBeenExpired);
    default:
      return (languages.somethingWentWrong, languages.somethingWentWrong);
  }
}
//endregion AirtelMoney
