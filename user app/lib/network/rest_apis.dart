import 'dart:async';
import 'dart:io';

import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/base_response_model.dart';
import 'package:booking_system_flutter/model/booking_data_model.dart';
import 'package:booking_system_flutter/model/booking_detail_model.dart';
import 'package:booking_system_flutter/model/booking_list_model.dart';
import 'package:booking_system_flutter/model/booking_status_model.dart';
import 'package:booking_system_flutter/model/category_model.dart';
import 'package:booking_system_flutter/model/city_list_model.dart';
import 'package:booking_system_flutter/model/country_list_model.dart';
import 'package:booking_system_flutter/model/dashboard_model.dart';
import 'package:booking_system_flutter/model/get_my_post_job_list_response.dart';
import 'package:booking_system_flutter/model/login_model.dart';
import 'package:booking_system_flutter/model/notification_model.dart';
import 'package:booking_system_flutter/model/post_job_detail_response.dart';
import 'package:booking_system_flutter/model/provider_info_response.dart';
import 'package:booking_system_flutter/model/provider_list_model.dart';
import 'package:booking_system_flutter/model/service_data_model.dart';
import 'package:booking_system_flutter/model/service_detail_response.dart';
import 'package:booking_system_flutter/model/service_response.dart';
import 'package:booking_system_flutter/model/service_review_response.dart';
import 'package:booking_system_flutter/model/state_list_model.dart';
import 'package:booking_system_flutter/model/user_data_model.dart';
import 'package:booking_system_flutter/model/user_wallet_history.dart';
import 'package:booking_system_flutter/model/verify_transaction_response.dart';
import 'package:booking_system_flutter/network/network_utils.dart';
import 'package:booking_system_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/configs.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/model_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../model/bank_list_response.dart';
import '../model/coupon_list_model.dart';
import '../model/payment_gateway_response.dart';
import '../model/payment_list_reasponse.dart';
import '../model/update_location_response.dart';
import '../model/wallet_response.dart';
import '../utils/app_configuration.dart';
import '../utils/firebase_messaging_utils.dart';

//region Auth Api
Future<LoginResponse> createUser(Map request) async {
  return LoginResponse.fromJson(await (handleResponse(await buildHttpResponse('register', request: request, method: HttpMethodType.POST))));
}

Future<LoginResponse> loginUser(Map request, {bool isSocialLogin = false}) async {
  try {
    LoginResponse res = LoginResponse.fromJson(await handleResponse(await buildHttpResponse(isSocialLogin ? 'social-login' : 'login', request: request, method: HttpMethodType.POST)));

    if (res.userData != null) {
      if (res.userData!.userType != USER_TYPE_USER) {
        appStore.setLoading(false);
        throw language.lblNotValidUser;
      }
      if (res.userData!.status == 0) {
        appStore.setLoading(false);
        throw language.contactAdmin;
      }
    }
    return res;
  } on Exception catch (e) {
    throw e.toString();
  }
}

Future<LoginResponse> updateProfile(Map request) async {
  return LoginResponse.fromJson(await handleResponse(await buildHttpResponse('update-profile', request: request, method: HttpMethodType.POST)));
}

Future<UserData> getUserDetail(int id, {bool forceUpdate = true}) async {
  DateTime currentTimeStamp = DateTime.timestamp();
  DateTime lastSyncedTimeStamp = DateTime.fromMillisecondsSinceEpoch(getIntAsync(LAST_USER_DETAILS_SYNCED_TIME));
  lastSyncedTimeStamp = lastSyncedTimeStamp.add(Duration(minutes: 5));

  if (!forceUpdate && lastSyncedTimeStamp.isAfter(currentTimeStamp)) {
    log('User details was synced recently');

    /// Throw empty string so that in this case no toast message will be shown
    throw '';
  } else {
    var res = LoginResponse.fromJson(await handleResponse(await buildHttpResponse('user-detail?id=$id', method: HttpMethodType.GET)));

    if (res.userData != null) {
      await setValue(LAST_USER_DETAILS_SYNCED_TIME, DateTime.timestamp().millisecondsSinceEpoch);
      return res.userData!;
    } else {
      throw errorSomethingWentWrong;
    }
  }
}

Future<void> saveUserData(UserData data, {bool forceSyncAppConfigurations = true}) async {
  if (data.apiToken.validate().isNotEmpty) await appStore.setToken(data.apiToken!);
  appStore.setLoggedIn(true);

  await appStore.setUserId(data.id.validate());
  await appStore.setUId(data.uid.validate());
  await appStore.setFirstName(data.firstName.validate());
  await appStore.setLastName(data.lastName.validate());
  await appStore.setUserEmail(data.email.validate());
  await appStore.setUserName(data.username.validate());
  await appStore.setCountryId(data.countryId.validate());
  await appStore.setStateId(data.stateId.validate());
  await appStore.setCityId(data.cityId.validate());
  await appStore.setContactNumber(data.contactNumber.validate());
  await appStore.setLoginType(data.loginType.validate(value: LOGIN_TYPE_USER));
  await appStore.setAddress(data.address.validate());

  await appStore.setUserProfile(data.profileImage.validate());

  /// Subscribe Firebase Topic
  subscribeToFirebaseTopic();

  // Sync new configurations for secret keys
  if (forceSyncAppConfigurations) await setValue(LAST_APP_CONFIGURATION_SYNCED_TIME, 0);
  getAppConfigurations();
}

Future<void> clearPreferences() async {
  cachedDashboardResponse = null;
  cachedBookingList = null;
  cachedCategoryList = null;
  cachedBookingStatusDropdown = null;
  cachedHelpDeskListData = null;

  if (!getBoolAsync(IS_REMEMBERED)) {
    await appStore.setUserEmail('');
    await removeKey(IS_EMAIL_VERIFIED);
  }
  setValue(CURRENT_ADDRESS, '');
  await appStore.setCurrentLocation(false);

  /// Firebase Notification
  unsubscribeFirebaseTopic(appStore.userId);
  await removeKey(LOGIN_TYPE);

  await appStore.setLoggedIn(false);
  await appStore.setFirstName('');
  await appStore.setLastName('');
  await appStore.setUserId(0);
  await appStore.setUserName('');
  await appStore.setContactNumber('');
  await appStore.setCountryId(0);
  await appStore.setStateId(0);
  await appStore.setUserProfile('');
  await appStore.setAddress('');
  await appStore.setCityId(0);
  await appStore.setUId('');
  await appStore.setLatitude(0.0);
  await appStore.setLongitude(0.0);
  await appStore.setToken('');
  await appStore.setLoginType('');
  await setValue(USER_PASSWORD, '');
  await removeKey(IS_SUBSCRIBED_FOR_PUSH_NOTIFICATION);

  try {
    FirebaseAuth.instance.signOut();
  } catch (e) {
    print(e);
  }

  appStore.setUserWalletAmount();
}

Future<void> logout(BuildContext context) async {
  return showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    builder: (p0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(logout_image, width: context.width(), fit: BoxFit.cover),
          32.height,
          Text(language.lblLogoutTitle, style: boldTextStyle(size: 18)),
          16.height,
          Text(language.lblLogoutSubTitle, style: secondaryTextStyle()),
          28.height,
          Row(
            children: [
              AppButton(
                elevation: 0,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: radius(defaultAppButtonRadius),
                  side: BorderSide(color: viewLineColor),
                ),
                child: Text(language.lblNo, style: boldTextStyle()),
                onTap: () {
                  finish(context);
                },
              ).expand(),
              16.width,
              AppButton(
                child: Text(language.lblYes, style: boldTextStyle(color: white)),
                color: primaryColor,
                elevation: 0,
                onTap: () async {
                  finish(context);

                  if (await isNetworkAvailable()) {
                    appStore.setLoading(true);

                    logoutApi().then((value) async {
                      //
                    }).catchError((e) {
                      log(e.toString());
                    });

                    await clearPreferences();
                    if (cachedWalletHistoryList != null && cachedWalletHistoryList!.isNotEmpty) cachedWalletHistoryList!.clear();

                    appStore.setLoading(false);
                    DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                  } else {
                    toast(errorInternetNotAvailable);
                  }
                },
              ).expand(),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: 16, vertical: 24);
    },
  );
}

Future<void> logoutApi() async {
  return await handleResponse(await buildHttpResponse('logout', method: HttpMethodType.GET));
}

Future<BaseResponseModel> changeUserPassword(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('change-password', request: request, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> forgotPassword(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('forgot-password', request: request, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> deleteAccountCompletely() async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-user-account', request: {}, method: HttpMethodType.POST)));
}

Future<VerificationModel> verifyUserEmail(String userEmail) async {
  Map<String, dynamic> request = {'email': userEmail};
  return VerificationModel.fromJson(await handleResponse(await buildHttpResponse('user-email-verify', request: request, method: HttpMethodType.POST)));
}

//endregion

//region Country Api
Future<List<CountryListResponse>> getCountryList() async {
  Iterable res = await (handleResponse(await buildHttpResponse('country-list', method: HttpMethodType.POST)));
  return res.map((e) => CountryListResponse.fromJson(e)).toList();
}

Future<List<StateListResponse>> getStateList(Map request) async {
  Iterable res = await (handleResponse(await buildHttpResponse('state-list', request: request, method: HttpMethodType.POST)));
  return res.map((e) => StateListResponse.fromJson(e)).toList();
}

Future<List<CityListResponse>> getCityList(Map request) async {
  Iterable res = await (handleResponse(await buildHttpResponse('city-list', request: request, method: HttpMethodType.POST)));
  return res.map((e) => CityListResponse.fromJson(e)).toList();
}
//endregion

//region Configurations Api
Future<void> getAppConfigurations({bool isCurrentLocation = false, double? lat, double? long}) async {
  DateTime currentTimeStamp = DateTime.timestamp();
  DateTime lastSyncedTimeStamp = DateTime.fromMillisecondsSinceEpoch(getIntAsync(LAST_APP_CONFIGURATION_SYNCED_TIME));
  lastSyncedTimeStamp = lastSyncedTimeStamp.add(Duration(minutes: 5));

  if (lastSyncedTimeStamp.isAfter(currentTimeStamp)) {
    log('App Configurations was synced recently');
  } else {
    try {
      AppConfigurationModel? res = AppConfigurationModel.fromJsonMap(await handleResponse(await buildHttpResponse('configurations?is_authenticated=${appStore.isLoggedIn.getIntBool()}', method: HttpMethodType.POST, request:appStore.isLoggedIn? {"user_id":appStore.userId}:null)));
      await setAppConfigurations(res);
    } catch (e) {
      throw e;
    }
  }
}

//endregion

//region User Api
Future<DashboardResponse> userDashboard({bool isCurrentLocation = false, double? lat, double? long}) async {
  Completer<DashboardResponse> completer = Completer();

  String endPoint = 'dashboard-detail';

  if (isCurrentLocation && appStore.isLoggedIn && appStore.userId.validate() != 0) {
    endPoint = "$endPoint?latitude=$lat&longitude=$long&customer_id=${appStore.userId.validate()}";
  } else if (isCurrentLocation) {
    endPoint = "$endPoint?latitude=$lat&longitude=$long";
  } else if (appStore.isLoggedIn && appStore.userId.validate() != 0) {
    endPoint = "$endPoint?customer_id=${appStore.userId.validate()}";
  }

  try {
    final dashboardResponse = DashboardResponse.fromJson(await handleResponse(await buildHttpResponse(endPoint, method: HttpMethodType.GET)));
    appStore.setLoading(false);

    cachedDashboardResponse = dashboardResponse;

    setValue(IS_EMAIL_VERIFIED, dashboardResponse.isEmailVerified.getBoolInt());
    appStore.setUnreadCount(dashboardResponse.notificationUnreadCount.validate());

    ///Set app configurations
    getAppConfigurations();

    completer.complete(dashboardResponse);
  } catch (e) {
    appStore.setLoading(false);
    completer.completeError(e);
  }

  return completer.future;
}

Future<num> getUserWalletBalance() async {
  try {
    var res = WalletResponse.fromJson(await handleResponse(await buildHttpResponse('user-wallet-balance', method: HttpMethodType.GET)));

    return res.balance.validate();
  } catch (e) {
    appStore.setLoading(false);
    log(e);
    return appStore.userWalletAmount;
  }
}

Future<List<WalletDataElement>> getUserWalletHistory(
  int page, {
  var perPage = PER_PAGE_ITEM,
  required List<WalletDataElement> walletDataList,
  Function(bool)? lastPageCallBack,
  Function(num)? availableBalance,
}) async {
  appStore.setLoading(true);
  try {
    var res = UserWalletHistoryResponse.fromJson(await handleResponse(await buildHttpResponse('wallet-history?per_page=$perPage&page=$page&orderby=desc', method: HttpMethodType.GET)));

    if (page == 1) walletDataList.clear();
    walletDataList.addAll(res.data.validate());
    if (res.availableBalance != null) {
      availableBalance?.call(res.availableBalance ?? 0);
    }
    lastPageCallBack?.call(res.data.validate().length != PER_PAGE_ITEM);
    cachedWalletHistoryList = walletDataList;
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }

  return walletDataList;
}

Future<BaseResponseModel> walletTopUp(Map req) async {
  // Delay is for showing loader again after loader was hidden from payment gateway
  await 100.milliseconds.delay;
  appStore.setLoading(true);
  try {
    var res = BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('wallet-top-up', method: HttpMethodType.POST, request: req)));

    await appStore.setUserWalletAmount();

    toast(language.yourWalletIsUpdated);
    appStore.setLoading(false);

    return res;
  } catch (e) {
    log(e);
    appStore.setLoading(false);
    toast(e.toString());
    throw e;
  }
}
//endregion

//region Service Api
Future<ServiceDetailResponse> getServiceDetails({required int serviceId, int? customerId, bool fromBooking = false}) async {
  if (fromBooking) {
    toast(language.pleaseWait);
  }
  Map request = {CommonKeys.serviceId: serviceId, if (appStore.isLoggedIn) CommonKeys.customerId: customerId};
  try {
    var res = ServiceDetailResponse.fromJson(await handleResponse(await buildHttpResponse('service-detail', request: request, method: HttpMethodType.POST)));

    appStore.setLoading(false);
    return res;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<List<ServiceData>> searchServiceAPI({
  String categoryId = '',
  String providerId = '',
  String isPriceMin = '',
  String isPriceMax = '',
  String ratingId = '',
  String search = '',
  String latitude = '',
  String longitude = '',
  String isFeatured = '',
  String subCategory = '',
  int page = 1,
  required List<ServiceData> list,
  Function(bool)? lastPageCallBack,
}) async {
  String categoryIds = categoryId.isNotEmpty ? 'category_id=$categoryId&' : '';
  String searchPara = search.isNotEmpty ? 'search=$search&' : '';
  String providerIds = providerId.isNotEmpty ? 'provider_id=$providerId&' : '';
  String isPriceMinPara = isPriceMin.isNotEmpty ? 'is_price_min=$isPriceMin&' : '';
  String isPriceMaxPara = isPriceMax.isNotEmpty ? 'is_price_max=$isPriceMax&' : '';
  String ratingPara = ratingId.isNotEmpty ? 'is_rating=$ratingId&' : '';
  String latitudes = latitude.isNotEmpty ? 'latitude=$latitude&' : '';
  String longitudes = longitude.isNotEmpty ? 'longitude=$longitude&' : '';
  String isFeatures = isFeatured.isNotEmpty ? 'is_featured=$isFeatured&' : '';
  String subCategorys = subCategory.validate().isNotEmpty
      ? subCategory != "-1"
          ? 'subcategory_id=$subCategory&'
          : ''
      : '';
  String pages = 'page=$page&';
  String perPages = 'per_page=$PER_PAGE_ITEM';
  String customerId = appStore.isLoggedIn ? 'customer_id=${appStore.userId}&' : '';

  try {
    var res = ServiceResponse.fromJson(await handleResponse(
      await buildHttpResponse('search-list?$categoryIds$customerId$providerIds$isPriceMinPara$isPriceMaxPara$ratingPara$subCategorys$searchPara$latitudes$longitudes$isFeatures$pages$perPages'),
    ));

    if (page == 1) list.clear();
    list.addAll(res.serviceList.validate());

    lastPageCallBack?.call(res.serviceList.validate().length != PER_PAGE_ITEM);
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }

  return list;
}
//endregion

//region Category Api

Future<CategoryResponse> getCategoryList(String page) async {
  return CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('category-list?page=$page&per_page=50', method: HttpMethodType.GET)));
}

Future<List<CategoryData>> getCategoryListWithPagination(int page, {var perPage = PER_PAGE_CATEGORY_ITEM, required List<CategoryData> categoryList, Function(bool)? lastPageCallBack}) async {
  try {
    CategoryResponse res = CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('category-list?per_page=$perPage&page=$page', method: HttpMethodType.GET)));

    if (page == 1) categoryList.clear();
    categoryList.addAll(res.categoryList.validate());

    cachedCategoryList = categoryList;

    lastPageCallBack?.call(res.categoryList.validate().length != PER_PAGE_CATEGORY_ITEM);

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }

  return categoryList;
}
//endregion

//region SubCategory Api
Future<CategoryResponse> getSubCategoryList({required int catId}) async {
  try {
    CategoryResponse res = CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('subcategory-list?category_id=$catId&per_page=all', method: HttpMethodType.GET)));
    appStore.setLoading(false);

    return res;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<List<CategoryData>> getSubCategoryListAPI({required int catId}) async {
  try {
    CategoryResponse res = CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('subcategory-list?category_id=$catId&per_page=all', method: HttpMethodType.GET)));

    appStore.setLoading(false);

    CategoryData allValue = CategoryData(id: -1, name: language.lblAll);
    if (!res.categoryList!.any((element) => element.id == allValue.id)) {
      res.categoryList!.insert(0, allValue);
    }

    if (!cachedSubcategoryList.any((element) => element?.$1 == catId)) {
      cachedSubcategoryList.add((catId, res.categoryList.validate()));
    } else {
      int index = cachedSubcategoryList.indexWhere((element) => element?.$1 == catId);
      cachedSubcategoryList[index] = (catId, res.categoryList.validate());
    }

    return res.categoryList.validate();
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}
//endregion

//region Provider Api
Future<ProviderInfoResponse> getProviderDetail(int id, {int? userId}) async {
  try {
    ProviderInfoResponse res = ProviderInfoResponse.fromJson(await handleResponse(await buildHttpResponse('user-detail?id=$id&login_user_id=$userId', method: HttpMethodType.GET)));
    appStore.setLoading(false);
    if (!cachedProviderList.any((element) => element?.$1 == id)) {
      cachedProviderList.add((id, res));
    } else {
      int index = cachedProviderList.indexWhere((element) => element?.$1 == id);
      cachedProviderList[index] = (id, res);
    }
    return res;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<List<UserData>> getHandyman({int? page, String? userTypeHandyman = "handyman", required List<UserData> list, Function(bool)? lastPageCallback}) async {
  try {
    var res = ProviderListResponse.fromJson(
      await handleResponse(await buildHttpResponse('user-list?user_type=$userTypeHandyman&per_page=$PER_PAGE_ITEM&page=$page', method: HttpMethodType.GET)),
    );

    if (page == 1) list.clear();

    list.addAll(res.providerList.validate());

    lastPageCallback?.call(res.providerList.validate().length != PER_PAGE_ITEM);

    cachedHandymanList = res.providerList;

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
  return list;
}

Future<ProviderListResponse> getProvider({String? userType = "provider", required String type}) async {
  return ProviderListResponse.fromJson(await handleResponse(await buildHttpResponse('user-list?user_type=$userType&type=$type&per_page=all', method: HttpMethodType.GET)));
}
//endregion

//region Handyman Api
Future<UserData> getHandymanDetail(int id) async {
  return UserData.fromJson(await handleResponse(await buildHttpResponse('user-detail?id=$id', method: HttpMethodType.GET)));
}

Future<BaseResponseModel> handymanRating(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-handyman-rating', request: request, method: HttpMethodType.POST)));
}
//endregion

//region Booking Api
Future<List<BookingData>> getBookingList(
  int page, {
  var perPage = PER_PAGE_ITEM,
  String serviceId = '',
  String dateFrom = '',
  String dateTo = '',
  String providerId = '',
  String handymanId = '',
  String bookingStatus = '',
  String paymentStatus = '',
  String paymentType = '',
  String searchText = '',
  required List<BookingData> bookings,
  Function(bool)? lastPageCallback,
}) async {
  try {
    BookingListResponse res;
    String serviceIds = serviceId.isNotEmpty ? 'service_id=$serviceId&' : '';
    String dateStart = dateFrom.isNotEmpty ? 'date_from=$dateFrom&' : '';
    String dateEnd = dateTo.isNotEmpty ? '&date_to=$dateTo&' : '';
    String providerIds = providerId.isNotEmpty ? 'provider_id=$providerId&' : '';
    String handymanIds = handymanId.isNotEmpty ? 'handyman_id=$handymanId&' : '';
    String status = bookingStatus.isNotEmpty ? 'status=$bookingStatus&' : '';
    String paymentStatuss = paymentStatus.isNotEmpty ? 'payment_status=$paymentStatus&' : '';
    String paymentTypes = paymentType.isNotEmpty ? 'payment_type=$paymentType&' : '';

    String perPageItem = 'per_page=$perPage&';
    String pageCount = 'page=$page';

    if (status == BOOKING_TYPE_ALL) {
      res = BookingListResponse.fromJson(await handleResponse(await buildHttpResponse('booking-list?per_page=$perPage&page=$page', method: HttpMethodType.GET)));
    } else {
      res = BookingListResponse.fromJson(await handleResponse(await buildHttpResponse('booking-list?$serviceIds$dateStart$dateEnd$providerIds$handymanIds$status$paymentStatuss$paymentTypes$perPageItem$pageCount', method: HttpMethodType.GET)));
    }

    if (page == 1) bookings.clear();
    bookings.addAll(res.data.validate());
    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    cachedBookingList = bookings;

    appStore.setLoading(false);

    return bookings;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<BookingDetailResponse> getBookingDetail(Map<String, dynamic> request, {Function(String)? callbackForStatus}) async {
  try {
    BookingDetailResponse bookingDetailResponse = BookingDetailResponse.fromJson(await handleResponse(await buildHttpResponse('booking-detail', request: request, method: HttpMethodType.POST)));
    callbackForStatus?.call(bookingDetailResponse.bookingDetail!.status.validate());
    bookingDetailResponse.bookingDetail?.couponData = bookingDetailResponse.couponData;

    int bookingId = request[CommonKeys.bookingId].toString().toInt();

    if (!cachedBookingDetailList.any((element) => element?.$1 == bookingId)) {
      cachedBookingDetailList.add((bookingId, bookingDetailResponse));
    } else {
      int index = cachedBookingDetailList.indexWhere((element) => element?.$1 == bookingId);
      cachedBookingDetailList[index] = (bookingId, bookingDetailResponse);
    }

    appStore.setLoading(false);
    return bookingDetailResponse;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<BaseResponseModel> updateBooking(Map request) async {
  BaseResponseModel baseResponse = BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('booking-update', request: request, method: HttpMethodType.POST)));
  LiveStream().emit(LIVESTREAM_UPDATE_BOOKING_LIST);

  return baseResponse;
}

Future<BookingDetailResponse> saveBooking(Map request) async {
  var res = await handleResponse(await buildHttpResponse('booking-save', request: request, method: HttpMethodType.POST));

  return await getBookingDetail({
    CommonKeys.bookingId: res[CommonKeys.bookingId],
    CommonKeys.customerId: appStore.userId,
  });
}

Future<UpdateLocationResponse> getProviderLocation(int bookingId) async {
  return UpdateLocationResponse.fromJson(await handleResponse(await buildHttpResponse("get-location?booking_id=$bookingId", method: HttpMethodType.GET).timeout(Duration(seconds: GET_LOCATION_API_TIMEOUT_SECOND))));
}

Future<List<BookingStatusResponse>> bookingStatus({required List<BookingStatusResponse> list}) async {
  Iterable res = await (handleResponse(await buildHttpResponse('booking-status', method: HttpMethodType.GET)));
  list = res.map((e) => BookingStatusResponse.fromJson(e)).toList();
  cachedBookingStatusDropdown = list;

  return list.validate();
}
//endregion

//region Payment Api
Future<BaseResponseModel> savePayment(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-payment', request: request, method: HttpMethodType.POST)));
}

Future<List<PaymentSetting>> getPaymentGateways({bool requireCOD = true, bool requireWallet = true, bool isAddWallet = false}) async {
  String isAddWalletStatus = isAddWallet ? '?is_add_wallet=$isAddWallet' : '';

  try {
    Iterable it = await handleResponse(await buildHttpResponse('payment-gateways$isAddWalletStatus', method: HttpMethodType.GET));
    List<PaymentSetting> res = it.map((e) => PaymentSetting.fromJson(e)).toList();

    if (!requireCOD) res.removeWhere((element) => element.type == PAYMENT_METHOD_COD);

    if (requireWallet && appConfigurationStore.isEnableUserWallet) {
      res.add(PaymentSetting(title: language.wallet, type: PAYMENT_METHOD_FROM_WALLET, status: 1));
    } else {
      res.removeWhere((element) => element.type == PAYMENT_METHOD_FROM_WALLET);
    }

    if (!appConfigurationStore.onlinePaymentStatus) {
      res.removeWhere((element) => onlinePaymentGateways.contains(element.type));
    }

    return res;
  } catch (e) {
    throw e;
  }
}

Future<List<PaymentData>> getPaymentList(int page, int id, List<PaymentData> list, Function(bool)? lastPageCallback) async {
  appStore.setLoading(true);
  var res = PaymentListResponse.fromJson(await handleResponse(await buildHttpResponse('payment-list?booking_id=$id', method: HttpMethodType.GET)));

  if (page == 1) list.clear();

  list.addAll(res.data.validate());
  appStore.setLoading(false);

  lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

  return list;
}

//endregion

//region Notification Api
Future<List<NotificationData>> getNotification({Map? request}) async {
  try {
    NotificationListResponse res = NotificationListResponse.fromJson(
      await (handleResponse(await buildHttpResponse('notification-list?customer_id=${appStore.userId}', request: request, method: HttpMethodType.POST))),
    );

    appStore.setLoading(false);
    cachedNotificationList = res.notificationData.validate();
    return res.notificationData.validate();
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}
//endregion

//region Notification Api
Future<CouponListResponse> getCouponList({required int serviceId}) async {
  try {
    CouponListResponse res = CouponListResponse.fromJson(
      await (handleResponse(await buildHttpResponse('coupon-list?service_id=$serviceId', method: HttpMethodType.GET))),
    );

    appStore.setLoading(false);
    cachedCouponListResponse = res;
    return res;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}
//endregion

//region Review Api
Future<BaseResponseModel> updateReview(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-booking-rating', request: request, method: HttpMethodType.POST)));
}

Future<List<RatingData>> serviceReviews(Map request) async {
  try {
    ServiceReviewResponse res = ServiceReviewResponse.fromJson(await handleResponse(await buildHttpResponse('service-reviews?per_page=all', request: request, method: HttpMethodType.POST)));
    appStore.setLoading(false);
    return res.ratingList.validate();
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

Future<List<RatingData>> customerReviews() async {
  try {
    ServiceReviewResponse res = ServiceReviewResponse.fromJson(await handleResponse(await buildHttpResponse('get-user-ratings?per_page=all', method: HttpMethodType.GET)));
    appStore.setLoading(false);
    cachedRatingList = res.ratingList;
    return res.ratingList.validate();
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

Future<List<RatingData>> handymanReviews(Map request) async {
  try {
    ServiceReviewResponse res = ServiceReviewResponse.fromJson(await handleResponse(await buildHttpResponse('handyman-reviews?per_page=all', request: request, method: HttpMethodType.POST)));
    appStore.setLoading(false);
    return res.ratingList.validate();
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

Future<BaseResponseModel> deleteReview({required int id}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-booking-rating', request: {"id": id}, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> deleteHandymanReview({required int id}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-handyman-rating', request: {"id": id}, method: HttpMethodType.POST)));
}
//endregion

//region WishList Api
Future<List<ServiceData>> getWishlist(int page, {var perPage = PER_PAGE_ITEM, required List<ServiceData> services, Function(bool)? lastPageCallBack}) async {
  try {
    ServiceResponse serviceResponse = ServiceResponse.fromJson(await (handleResponse(await buildHttpResponse('user-favourite-service?per_page=$perPage&page=$page', method: HttpMethodType.GET))));

    if (page == 1) services.clear();
    services.addAll(serviceResponse.serviceList.validate());

    lastPageCallBack?.call(serviceResponse.serviceList.validate().length != PER_PAGE_ITEM);

    cachedServiceFavList = services;
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
  return services;
}

Future<BaseResponseModel> addWishList(request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-favourite', method: HttpMethodType.POST, request: request)));
}

Future<BaseResponseModel> removeWishList(request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-favourite', method: HttpMethodType.POST, request: request)));
}

//endregion

//region Provider WishList Api
Future<List<UserData>> getProviderWishlist(int page, {var perPage = PER_PAGE_ITEM, required List<UserData> providers, Function(bool)? lastPageCallBack}) async {
  try {
    ProviderListResponse res = ProviderListResponse.fromJson(await (handleResponse(await buildHttpResponse('user-favourite-provider?per_page=$perPage&page=$page', method: HttpMethodType.GET))));

    if (page == 1) providers.clear();
    providers.addAll(res.providerList.validate());

    lastPageCallBack?.call(res.providerList.validate().length != PER_PAGE_ITEM);

    cachedProviderFavList = providers;
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
  return providers;
}

Future<BaseResponseModel> addProviderWishList(request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-favourite-provider', method: HttpMethodType.POST, request: request)));
}

Future<BaseResponseModel> removeProviderWishList(request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-favourite-provider', method: HttpMethodType.POST, request: request)));
}
//endregion

//region Get My Service List API
Future<ServiceResponse> getMyServiceList() async {
  return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse('service-list?customer_id=${appStore.userId.validate()}', method: HttpMethodType.GET)));
}
//endregion

//region Get My post job

Future<BaseResponseModel> savePostJob(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-post-job', request: request, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> deletePostRequest({required num id}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('post-job-delete/$id', request: {}, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> deleteServiceRequest(int id) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('service-delete/$id', request: {}, method: HttpMethodType.POST)));
}

Future<List<PostJobData>> getPostJobList(int page, {var perPage = PER_PAGE_ITEM, required List<PostJobData> postJobList, Function(bool)? lastPageCallBack}) async {
  try {
    var res = GetPostJobResponse.fromJson(await handleResponse(await buildHttpResponse('get-post-job?per_page=$perPage&page=$page', method: HttpMethodType.GET)));

    if (page == 1) postJobList.clear();
    postJobList.addAll(res.myPostJobData.validate());

    lastPageCallBack?.call(res.myPostJobData.validate().length != PER_PAGE_ITEM);
    cachedPostJobList = postJobList;
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }

  return postJobList;
}

Future<PostJobDetailResponse> getPostJobDetail(Map request) async {
  try {
    var res = PostJobDetailResponse.fromJson(await handleResponse(await buildHttpResponse('get-post-job-detail', request: request, method: HttpMethodType.POST)));
    appStore.setLoading(false);

    return res;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

//endregion

//region FlutterWave Verify Transaction API
Future<VerifyTransactionResponse> verifyPayment({required String transactionId, required String flutterWaveSecretKey}) async {
  return VerifyTransactionResponse.fromJson(
    await handleResponse(await buildHttpResponse("https://api.flutterwave.com/v3/transactions/$transactionId/verify", header: buildHeaderForFlutterWave(flutterWaveSecretKey))),
  );
}
//endregion

//region Sadad Payment Api
Future<String> sadadLogin(Map request) async {
  try {
    var res = await handleSadadResponse(
      await buildHttpResponse(
        '$SADAD_API_URL/api/userbusinesses/login',
        method: HttpMethodType.POST,
        request: request,
        header: buildHeaderForSadad(),
      ),
    );

    return res['accessToken'];
  } catch (e) {
    throw errorSomethingWentWrong;
  }
}

Future sadadCreateInvoice({required Map<String, dynamic> request, required String sadadToken}) async {
  return await handleSadadResponse(await buildHttpResponse(
    '$SADAD_API_URL/api/invoices/createInvoice',
    method: HttpMethodType.POST,
    request: request,
    header: buildHeaderForSadad(sadadToken: sadadToken),
  ));
}
//endregion

// region Send Invoice on Email
Future<BaseResponseModel> sentInvoiceOnMail(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('download-invoice', request: request, method: HttpMethodType.POST)));
}
//endregion

//region CommonFunctions
Future<Map<String, String>> getMultipartFields({required Map<String, dynamic> val}) async {
  Map<String, String> data = {};

  val.forEach((key, value) {
    data[key] = '$value';
  });

  return data;
}

Future<List<MultipartFile>> getMultipartImages({required List<File> files, required String name}) async {
  List<MultipartFile> multiPartRequest = [];

  await Future.forEach<File>(files, (element) async {
    int i = files.indexOf(element);

    multiPartRequest.add(await MultipartFile.fromPath('${'$name' + i.toString()}', element.path));
  });

  return multiPartRequest;
}
//endregion

Future<BaseResponseModel> deleteImage(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('remove-file', request: request, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> chooseDefaulBank({required int bankId}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('default-bank?id=$bankId', request: {}, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> deleteBank({int? bankId}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-bank/$bankId', request: {}, method: HttpMethodType.POST)));
}

Future<List<BankHistory>> getBankListDetail({
  required int userId,
  int? page,
  var perPage = PER_PAGE_ITEM,
  required List<BankHistory> list,
  Function(bool)? lastPageCallback,
}) async {
  BankListResponse res = BankListResponse.fromJson(
    await handleResponse(await buildHttpResponse('user-bank-detail?per_page=$perPage&page=$page&user_id=$userId', method: HttpMethodType.GET)),
  );

  if (page == 1) list.clear();
  list.addAll(res.data.validate());

  cachedBankList = list;

  appStore.setLoading(false);

  lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

  return list;
}

Future<BaseResponseModel> providerPayOut({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('provider-payout', request: request, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> walletMoneyWithdrawal({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('withdraw-money', request: request, method: HttpMethodType.POST)));
}