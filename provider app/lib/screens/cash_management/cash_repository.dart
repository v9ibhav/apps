import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/base_response.dart';
import 'package:handyman_provider_flutter/models/user_bank_model.dart';
import 'package:handyman_provider_flutter/networks/network_utils.dart';
import 'package:handyman_provider_flutter/screens/cash_management/model/cash_detail_model.dart';
import 'package:handyman_provider_flutter/screens/cash_management/model/payment_history_model.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

Future<List<PaymentHistoryData>> getPaymentHistory({required String bookingId}) async {
  String bId = "booking_id=$bookingId";
  PaymentHistoryModel res = PaymentHistoryModel.fromJson(await handleResponse(await buildHttpResponse('payment-history?$bId', method: HttpMethodType.GET)));

  return res.data.validate();
}

Future<(num, num, List<PaymentHistoryData>)> getCashDetails({
  int? page,
  int? providerId,
  String? toDate,
  String? fromDate,
  String? statusType,
  required List<PaymentHistoryData> list,
  Function(bool)? lastPageCallback,
  bool disableLoader = false,
}) async {
  final queryParams = <String, dynamic>{
    if (page != null) 'page': page.toString(),
    if (fromDate != null) 'from': fromDate,
    if (toDate != null) 'to': toDate,
    if (statusType != null) 'status': statusType,
    'per_page': PER_PAGE_ITEM,
  };

  try {
    final response = await buildHttpResponse('cash-detail?${queryParams.joinWithMap('&')}', method: HttpMethodType.GET);
    final res = CashHistoryModel.fromJson(await handleResponse(response));

    if (page == 1) {
      list.clear();
    }

    list.addAll(res.data.validate());
    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);
    appStore.setLoading(false);
    return (res.totalCashInHand.validate(), res.todayCash.validate(), list);
  } catch (e) {
    if (!disableLoader) {
      appStore.setLoading(false);
    }

    throw e;
  }
}

Future<UserBankDetails> getUserBankDetail({required int userId}) async {
  return UserBankDetails.fromJson(await handleResponse(await buildHttpResponse('user-bank-detail?user_id=$userId', method: HttpMethodType.GET)));
}

Future<BaseResponseModel> transferCashAPI({required Map<String, dynamic> req}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('transfer-payment', method: HttpMethodType.POST, request: req)));
}

Future<void> transferAmountAPI(
  BuildContext context, {
  required PaymentHistoryData paymentData,
  required String status,
  required String action,
  bool isFinishRequired = true,
  Function()? onTap,
}) async {
  await showConfirmDialogCustom(
    context,
    title: languages.confirmationRequestTxt,
    positiveText: languages.lblYes,
    negativeText: languages.lblNo,
    primaryColor: context.primaryColor,
    onAccept: (p0) async {
      Map<String, dynamic> req = {
        "payment_id": paymentData.paymentId.validate(),
        "booking_id": paymentData.bookingId.validate(),
        "action": action,
        "type": paymentData.type,
        "sender_id": paymentData.senderId,
        "receiver_id": paymentData.receiverId,
        "txn_id": paymentData.txnId,
        "other_transaction_detail": "",
        "datetime": formatBookingDate(DateTime.now().toString(), format: DATE_FORMAT_7),
        "total_amount": paymentData.totalAmount,
        "status": status,
        "p_id": paymentData.id,
        "parent_id": paymentData.parentId,
      };
      log(req);
      appStore.setLoading(true);

      await transferCashAPI(req: req).then((value) {
        onTap?.call();
        if (isFinishRequired) {
          finish(context);
        }
        toast(value.message.validate());

        appStore.setLoading(false);
      }).catchError((e) {
        toast(e.toString());
        appStore.setLoading(false);
      });
    },
  );
}
