import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../models/base_response.dart';
import '../../networks/network_utils.dart';
import '../../networks/rest_apis.dart';
import '../../utils/constant.dart';
import '../../utils/model_keys.dart';
import 'model/promotional_banner_response.dart';

// region Save Help Desk API
Future<void> savePromotionalBannerMultiPart({required Map<String, dynamic> value, List<File>? imageFile, Function(int)? callback}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('save-banner');

  multiPartRequest.fields.addAll(await getMultipartFields(val: value));

  if (imageFile.validate().isNotEmpty) {
    multiPartRequest.files.addAll(await getMultipartImages(files: imageFile.validate(), name: PromotionalBannerKey.bannerAttachment));
    multiPartRequest.fields[PromotionalBannerKey.attachmentCount] = imageFile.validate().length.toString();
  }

  log("${multiPartRequest.fields}");

  multiPartRequest.headers.addAll(buildHeaderTokens());

  log("Multi Part Request : ${jsonEncode(multiPartRequest.fields)} ${multiPartRequest.files.map((e) => e.field + ": " + e.filename.validate())}");

  appStore.setLoading(true);

  await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
    appStore.setLoading(false);

    log("Response: ${jsonDecode(temp)}");

    toast(jsonDecode(temp)['message'], print: true);

    callback?.call(jsonDecode(temp)['banner']['id']);
  }, onError: (error) {
    toast(error.toString(), print: true);
    appStore.setLoading(false);
  }).catchError((e) {
    appStore.setLoading(false);
    toast(e.toString());
  });
}
//endregion

// region Promotional Banner List API
Future<List<PromotionalBannerListData>> getPromotionalBannerList({
  int? page,
  required String status,
  required List<PromotionalBannerListData> promotionalBannerListData,
  Function(bool)? lastPageCallback,
}) async {
  try {
    PromotionalBannerResponse res = PromotionalBannerResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'promotional-banner-list?status=$status&per_page=$PER_PAGE_ITEM&page=$page',
          method: HttpMethodType.GET,
        ),
      ),
    );

    if (page == 1) promotionalBannerListData.clear();

    promotionalBannerListData.addAll(res.data.validate());

    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);

    cachedPromotionalBannerListData = promotionalBannerListData;

    return promotionalBannerListData;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}
//endregion

//region Payment Api
Future<BaseResponseModel> savePromotionalBannerPayment(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('banner-payment', request: request, method: HttpMethodType.POST)));
}
//endregion

Future<BaseResponseModel> deleteBanner({required num bannerId}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-banner/$bannerId', method: HttpMethodType.POST)));
}
//endregion
