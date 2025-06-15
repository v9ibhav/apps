//region Get Earning List , Save Handyman Payout
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../models/base_response.dart';
import '../../networks/network_utils.dart';
import '../../utils/constant.dart';
import 'model/earning_list_model.dart';
import 'model/payout_history_response.dart';

Future<List<EarningListModel>> getHandymanEarningList({
  int page = 1,
  List<EarningListModel> earnings = const [],
  Function(bool)? callback,
}) async {
  try {
    Iterable it = await handleResponse(await buildHttpResponse('handyman-earning-list?page=$page&per_page=$PER_PAGE_ITEM', method: HttpMethodType.GET));
    List<EarningListModel> res = it.map((e) => EarningListModel.fromJson(e)).toList();

    if (page == 1) earnings.clear();
    earnings.addAll(res.validate());
    appStore.setLoading(false);

    callback?.call(res.validate().length != PER_PAGE_ITEM);
  } catch (e) {
    appStore.setLoading(false);

    log(e);
    throw errorSomethingWentWrong;
  }

  return earnings;
}

Future<BaseResponseModel> handymanPayout({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('handyman-payout-save', method: HttpMethodType.POST, request: request)));
}

Future<List<PayoutData>> getHandymanPayoutHistoryList(
  int page, {
  required int id,
  List<PayoutData> payoutList = const [],
  String userType = USER_TYPE_PROVIDER,
  var perPage = PER_PAGE_ITEM,
  Function(bool)? callback,
}) async {
  try {
    var res = PayoutHistoryResponse.fromJson(await handleResponse(await buildHttpResponse(
      'handyman-payout-list?handyman_id=$id&per_page=$perPage&page=$page',
      method: HttpMethodType.GET,
    )));
    if (page == 1) payoutList.clear();
    payoutList.addAll(res.payoutData.validate());
    appStore.setLoading(false);
    callback?.call(res.payoutData.validate().length != PER_PAGE_ITEM);
  } catch (e) {
    appStore.setLoading(false);

    log(e);
    throw errorSomethingWentWrong;
  }

  return payoutList;
}
