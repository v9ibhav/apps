import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../model/base_response_model.dart';
import '../../network/network_utils.dart';
import '../../network/rest_apis.dart';
import '../../utils/constant.dart';
import '../../utils/model_keys.dart';
import 'model/help_desk_detail_response.dart';
import 'model/help_desk_response.dart';

// region Save Help Desk API
Future<void> saveHelpDeskMultiPart({required Map<String, dynamic> value, List<File>? imageFile}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('helpdesk-save');

  multiPartRequest.fields.addAll(await getMultipartFields(val: value));

  if (imageFile.validate().isNotEmpty) {
    multiPartRequest.files.addAll(await getMultipartImages(files: imageFile.validate(), name: HelpDeskKey.helpdeskAttachment));
    multiPartRequest.fields[HelpDeskKey.attachmentCount] = imageFile.validate().length.toString();
  }

  log("${multiPartRequest.fields}");

  multiPartRequest.headers.addAll(buildHeaderTokens());

  log("Multi Part Request : ${jsonEncode(multiPartRequest.fields)} ${multiPartRequest.files.map((e) => e.field + ": " + e.filename.validate())}");

  appStore.setLoading(true);

  await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
    appStore.setLoading(false);

    log("Response: ${jsonDecode(temp)}");

    toast(jsonDecode(temp)['message'], print: true);
    finish(getContext, true);
  }, onError: (error) {
    toast(error.toString(), print: true);
    appStore.setLoading(false);
  }).catchError((e) {
    appStore.setLoading(false);
    toast(e.toString());
  });
}
//endregion

// region Help Desk List API
Future<List<HelpDeskListData>> getHelpDeskList({
  int? page,
  required String status,
  required List<HelpDeskListData> helpDeskListData,
  Function(bool)? lastPageCallback,
}) async {
  try {
    HelpDeskResponse res = HelpDeskResponse.fromJson(
      await handleResponse(await buildHttpResponse('helpdesk-list?status=$status&per_page=$PER_PAGE_ITEM&page=$page', method: HttpMethodType.GET)),
    );

    if (page == 1) helpDeskListData.clear();

    helpDeskListData.addAll(res.data.validate());

    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);

    cachedHelpDeskListData = helpDeskListData;

    return helpDeskListData;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}
//endregion

// region Get Help Desk Detail API
Future<List<HelpDeskActivityData>> getHelpDeskDetailAPI({
  int? page,
  required int helpDeskId,
  required List<HelpDeskActivityData> helpDeskActivityListData,
  Function(bool, String)? lastPageCallback,
}) async {
  try {
    HelpDeskDetailResponse res = HelpDeskDetailResponse.fromJson(
      await handleResponse(await buildHttpResponse('helpdesk-detail?id=$helpDeskId&per_page=$PER_PAGE_ITEM&page=$page', method: HttpMethodType.GET)),
    );

    if (page == 1) helpDeskActivityListData.clear();

    helpDeskActivityListData.addAll(res.data.validate());

    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM, res.status.validate());

    appStore.setLoading(false);

    return helpDeskActivityListData;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}
//endregion

// region Save Help Desk API
Future<void> saveHelpDeskActivityMultiPart({required int helpDeskId, required Map<String, dynamic> value, List<File>? imageFile}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('helpdesk-activity-save/$helpDeskId');

  multiPartRequest.fields.addAll(await getMultipartFields(val: value));

  if (imageFile.validate().isNotEmpty) {
    multiPartRequest.files.addAll(await getMultipartImages(files: imageFile.validate(), name: HelpDeskKey.helpdeskActivityAttachment));
    multiPartRequest.fields[HelpDeskKey.attachmentCount] = imageFile.validate().length.toString();
  }

  log("${multiPartRequest.fields}");

  multiPartRequest.headers.addAll(buildHeaderTokens());

  log("Multi Part Request : ${jsonEncode(multiPartRequest.fields)} ${multiPartRequest.files.map((e) => e.field + ": " + e.filename.validate())}");

  appStore.setLoading(true);

  await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
    appStore.setLoading(false);

    log("Response: ${jsonDecode(temp)}");

    toast(jsonDecode(temp)['message'], print: true);
  }, onError: (error) {
    toast(error.toString(), print: true);
    appStore.setLoading(false);
  }).catchError((e) {
    appStore.setLoading(false);
    toast(e.toString());
  });
}

// region Help Desk Closed API
Future<BaseResponseModel> helpDeskClosedAPI({required num helpDeskId}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('helpdesk-closed/$helpDeskId', request: {}, method: HttpMethodType.POST)));
}
//endregion
