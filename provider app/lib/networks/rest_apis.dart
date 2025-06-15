import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/auth/sign_in_screen.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/package_response.dart';
import 'package:handyman_provider_flutter/models/base_response.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/models/booking_status_response.dart';
import 'package:handyman_provider_flutter/models/caregory_response.dart';
import 'package:handyman_provider_flutter/models/city_list_response.dart';
import 'package:handyman_provider_flutter/models/country_list_response.dart';
import 'package:handyman_provider_flutter/models/dashboard_response.dart';
import 'package:handyman_provider_flutter/models/document_list_response.dart';
import 'package:handyman_provider_flutter/models/handyman_dashboard_response.dart';
import 'package:handyman_provider_flutter/models/login_response.dart';
import 'package:handyman_provider_flutter/models/notification_list_response.dart';
import 'package:handyman_provider_flutter/models/payment_list_reasponse.dart';
import 'package:handyman_provider_flutter/models/plan_list_response.dart';
import 'package:handyman_provider_flutter/models/plan_request_model.dart';
import 'package:handyman_provider_flutter/models/profile_update_response.dart';
import 'package:handyman_provider_flutter/models/provider_document_list_response.dart';
import 'package:handyman_provider_flutter/models/provider_info_model.dart';
import 'package:handyman_provider_flutter/models/provider_subscription_model.dart';
import 'package:handyman_provider_flutter/models/register_response.dart';
import 'package:handyman_provider_flutter/models/search_list_response.dart';
import 'package:handyman_provider_flutter/models/service_address_response.dart';
import 'package:handyman_provider_flutter/models/service_detail_response.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/models/service_response.dart';
import 'package:handyman_provider_flutter/models/service_review_response.dart';
import 'package:handyman_provider_flutter/models/state_list_response.dart';
import 'package:handyman_provider_flutter/models/subscription_history_model.dart';
import 'package:handyman_provider_flutter/models/tax_list_response.dart';
import 'package:handyman_provider_flutter/models/total_earning_response.dart';
import 'package:handyman_provider_flutter/models/update_location_response.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:handyman_provider_flutter/models/user_info_response.dart';
import 'package:handyman_provider_flutter/models/user_list_response.dart';
import 'package:handyman_provider_flutter/models/user_type_response.dart';
import 'package:handyman_provider_flutter/models/verify_transaction_response.dart';
import 'package:handyman_provider_flutter/networks/network_utils.dart';
import 'package:handyman_provider_flutter/provider/jobRequest/models/post_job_detail_response.dart';
import 'package:handyman_provider_flutter/provider/jobRequest/models/post_job_response.dart';
import 'package:handyman_provider_flutter/provider/provider_dashboard_screen.dart';
import 'package:handyman_provider_flutter/provider/timeSlots/models/slot_data.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/addons_service_response.dart';
import '../models/bank_list_response.dart';
import '../models/google_places_model.dart';
import '../models/my_bid_response.dart';
import '../models/request_list_response.dart';
import '../models/wallet_history_list_response.dart';
import '../models/wallet_response.dart';
import '../provider/jobRequest/models/bidder_data.dart';
import '../provider/jobRequest/models/post_job_data.dart';
import '../utils/app_configuration.dart';
import '../utils/firebase_messaging_utils.dart';

//region Auth API

Future<void> logout(BuildContext context) async {
  showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    builder: (_) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(logout_logo, width: context.width(), fit: BoxFit.cover),
              32.height,
              Text(languages.lblDeleteTitle, style: boldTextStyle(size: 18)),
              16.height,
              Text(languages.lblDeleteSubTitle, style: secondaryTextStyle()),
              28.height,
              Row(
                children: [
                  AppButton(
                    child: Text(languages.lblNo, style: boldTextStyle()),
                    color: appStore.isDarkMode ? context.scaffoldBackgroundColor : context.cardColor,
                    elevation: 0,
                    onTap: () {
                      finish(context);
                    },
                  ).expand(),
                  16.width,
                  AppButton(
                    child: Text(languages.lblYes, style: boldTextStyle(color: white)),
                    color: primaryColor,
                    elevation: 0,
                    onTap: () async {
                      if (await isNetworkAvailable()) {
                        appStore.setLoading(true);
                        logoutApi().then((value) async {}).catchError((e) {
                          toast(e.toString());
                        });
                        await clearPreferences();
                        if(appConfigurationStore.isInAppPurchaseEnable)
                          await inAppPurchaseService.logoutToRevenueCate();

                        appStore.setLoading(false);

                        SignInScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                      } else {
                        toast(errorInternetNotAvailable);
                      }
                    },
                  ).expand(),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 24),
          Observer(builder: (_) => LoaderWidget().withSize(width: 60, height: 60).visible(appStore.isLoading)),
        ],
      );
    },
  );
}

Future<void> clearPreferences() async {
  await setValue(LAST_APP_CONFIGURATION_SYNCED_TIME, 0);
  unsubscribeFirebaseTopic(appStore.userId);

  cachedProviderDashboardResponse = null;
  cachedHandymanDashboardResponse = null;
  cachedBookingList = null;
  cachedPaymentList = null;
  cachedNotifications = null;
  cachedBookingStatusDropdown = null;
  cachedWalletList = null;
  cachedHandymanList = null;
  cachedTotalDataList = null;
  cachedBankList = null;
  cachedHelpDeskListData = null;

  await appStore.setFirstName('');
  await appStore.setLastName('');
  if (!getBoolAsync(IS_REMEMBERED)) await appStore.setUserEmail('');
  if (!getBoolAsync(IS_REMEMBERED)) await removeKey(USER_PASSWORD);
  await appStore.setUserName('');
  await appStore.setContactNumber('');
  await appStore.setCountryId(0);
  await appStore.setStateId(0);
  await appStore.setCityId(0);
  await appStore.setUserId(0);
  await appStore.setUId('');
  await appStore.setToken('');
  await appStore.setLoggedIn(false);
  await appStore.setPlanSubscribeStatus(false);
  await appStore.setPlanTitle('');
  await appStore.setIdentifier('');
  await appStore.setPlanEndDate('');
  await appStore.setTester(false);
  await appStore.setActiveRevenueCatIdentifier('');
  await appStore.setProviderCurrentSubscriptionPlan(ProviderSubscriptionModel());
  await removeKey(IS_SUBSCRIBED_FOR_PUSH_NOTIFICATION);

  appStore.setUserWalletAmount();

  try {
    FirebaseAuth.instance.signOut();
  } catch (e) {
    print(e);
  }
}

Future<void> logoutApi() async {
  return await handleResponse(await buildHttpResponse('logout', method: HttpMethodType.GET));
}

Future<RegisterResponse> registerUser(Map request) async {
  return RegisterResponse.fromJson(await (handleResponse(await buildHttpResponse('register', request: request, method: HttpMethodType.POST))));
}

Future changeLanguage(Map request) async {
  return RegisterResponse.fromJson(await (handleResponse(await buildHttpResponse('switch-language', request: request, method: HttpMethodType.POST))));
}

Future<UserData> loginUser(Map request) async {
  try {
    LoginResponse res = LoginResponse.fromJson(await (handleResponse(await buildHttpResponse('login', request: request, method: HttpMethodType.POST))));

    if (res.data != null) {
      return res.data!;
    } else {
      throw errorSomethingWentWrong;
    }
  } catch (e) {
    throw e;
  }
}

Future<void> saveUserData(UserData data) async {
  if (data.status == 1) {
    await appStore.setUserId(data.id.validate());
    await appStore.setFirstName(data.firstName.validate());
    await appStore.setUserType(data.userType.validate());
    await appStore.setLastName(data.lastName.validate());
    await appStore.setUserEmail(data.email.validate());
    await appStore.setUserName(data.username.validate());
    await appStore.setContactNumber('${data.contactNumber.validate()}');
    await appStore.setUserProfile(data.profileImage.validate());
    await appStore.setCountryId(data.countryId.validate());
    await appStore.setStateId(data.stateId.validate());
    await appStore.setDesignation(data.designation.validate());
    await appStore.setAddress(data.address.validate().isNotEmpty ? data.address.validate() : '');

    await appStore.setCityId(data.cityId.validate());
    await appStore.setProviderId(data.providerId.validate());

    if (data.serviceAddressId != null) await appStore.setServiceAddressId(data.serviceAddressId!);

    await appStore.setCreatedAt(data.createdAt.validate());

    if (data.subscription != null) {
      await setSaveSubscription(
        isSubscribe: data.isSubscribe,
        subscription: data.subscription!,
      );
    }

    await appStore.setLoggedIn(true);

    // Subscribe to Firebase topics to receive push notifications
    subscribeToFirebaseTopic();

    // Sync new configurations for secret keys
    await setValue(LAST_APP_CONFIGURATION_SYNCED_TIME, 0);
    getAppConfigurations();
  }
}

Future<BaseResponseModel> changeUserPassword(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('change-password', request: request, method: HttpMethodType.POST)));
}

Future<UserInfoResponse> getUserDetail(int id) async {
  appStore.setLoading(true);
  UserInfoResponse res = UserInfoResponse.fromJson(await handleResponse(await buildHttpResponse('user-detail?id=$id', method: HttpMethodType.GET)));
  appStore.setLoading(false);
  return res;
}

Future<HandymanInfoResponse> getProviderDetail(int id) async {
  return HandymanInfoResponse.fromJson(await handleResponse(await buildHttpResponse('user-detail?id=$id', method: HttpMethodType.GET)));
}

Future<BaseResponseModel> forgotPassword(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('forgot-password', request: request, method: HttpMethodType.POST)));
}

Future<CommonResponseModel> updateProfile(Map request) async {
  return CommonResponseModel.fromJson(await handleResponse(await buildHttpResponse('update-profile', request: request, method: HttpMethodType.POST)));
}

Future<VerificationModel> verifyUserEmail(String userEmail) async {
  Map<String, dynamic> request = {'email': userEmail};
  return VerificationModel.fromJson(await handleResponse(await buildHttpResponse('user-email-verify', request: request, method: HttpMethodType.POST)));
}

//endregion

//region Country API
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

//region Category API
Future<CategoryResponse> getCategoryList({String perPage = ''}) async {
  return CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('category-list?per_page=$perPage', method: HttpMethodType.GET)));
}
//endregion

//region SubCategory Api
Future<CategoryResponse> getSubCategoryList({required int catId}) async {
  String categoryId = catId != -1 ? "category_id=$catId" : "";
  String perPage = catId != -1 ? '&per_page=$PER_PAGE_ITEM_ALL' : '?per_page=$PER_PAGE_ITEM_ALL';
  return CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('subcategory-list?$categoryId$perPage', method: HttpMethodType.GET)));
}
//endregion

//region Configuration API
Future<void> getAppConfigurations({bool isCurrentLocation = false, double? lat, double? long}) async {
  DateTime currentTimeStamp = DateTime.timestamp();
  DateTime lastSyncedTimeStamp = DateTime.fromMillisecondsSinceEpoch(getIntAsync(LAST_APP_CONFIGURATION_SYNCED_TIME));
  lastSyncedTimeStamp = lastSyncedTimeStamp.add(Duration(minutes: 5));

  if (lastSyncedTimeStamp.isAfter(currentTimeStamp)) {
    log('App Configurations was synced recently');
  } else {
    try {
      AppConfigurationModel? res = AppConfigurationModel.fromJsonMap(await handleResponse(await buildHttpResponse('configurations?is_authenticated=${appStore.isLoggedIn.getIntBool()}',
          method: HttpMethodType.POST, request: appStore.isLoggedIn ? {'user_id': appStore.userId} : null)));

      await setAppConfigurations(res);
    } catch (e) {
      throw e;
    }
  }
}

//endregion

//region Provider API
Future<DashboardResponse> providerDashboard({bool forceSyncAppConfigurations = false}) async {
  final completer = Completer<DashboardResponse>();

  try {
    final data = DashboardResponse.fromJson(await handleResponse(await buildHttpResponse('provider-dashboard', method: HttpMethodType.GET)));

    completer.complete(data);

    cachedProviderDashboardResponse = data;

    appStore.setTotalHandyman(data.totalActiveHandyman.validate());

    setValue(IS_EMAIL_VERIFIED, data.isEmailVerified.getBoolInt());

    if (data.commission != null) {
      setValue(DASHBOARD_COMMISSION, jsonEncode(data.commission));
    }

    appStore.setNotificationCount(data.notificationUnreadCount.validate());

    if (data.subscription != null) {
      await setSaveSubscription(
        isSubscribe: data.isSubscribed,
        subscription: data.subscription!,
      );
      if (appConfigurationStore.isInAppPurchaseEnable)
        inAppPurchaseService.checkSubscriptionSync(
          refreshCallBack: () => providerDashboard,
        );
    }

    // Sync new configurations for secret keys
    if (forceSyncAppConfigurations) await setValue(LAST_APP_CONFIGURATION_SYNCED_TIME, 0);
    getAppConfigurations();

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    completer.completeError(e);
  }

  return completer.future;
}

Future<ProviderDocumentListResponse> getProviderDoc() async {
  return ProviderDocumentListResponse.fromJson(await handleResponse(await buildHttpResponse('provider-document-list', method: HttpMethodType.GET)));
}

Future<CommonResponseModel> deleteProviderDoc(int? id) async {
  return CommonResponseModel.fromJson(await handleResponse(await buildHttpResponse('provider-document-delete/$id', method: HttpMethodType.POST)));
}
//endregion

//region Handyman API
Future<HandymanDashBoardResponse> handymanDashboard({bool forceSyncAppConfigurations = false}) async {
  final completer = Completer<HandymanDashBoardResponse>();

  try {
    final response = await buildHttpResponse('handyman-dashboard', method: HttpMethodType.GET);
    final data = HandymanDashBoardResponse.fromJson(await handleResponse(response));

    cachedHandymanDashboardResponse = data;

    setValue(IS_EMAIL_VERIFIED, data.isEmailVerified.getBoolInt());

    appStore.setCompletedBooking(data.completedBooking.validate().toInt());
    appStore.setHandymanAvailability(data.isHandymanAvailable.validate());

    appStore.setNotificationCount(data.notificationUnreadCount.validate());

    if (data.commission != null) {
      setValue(DASHBOARD_COMMISSION, jsonEncode(data.commission));
    }

    // Sync new configurations for secret keys
    if (forceSyncAppConfigurations) await setValue(LAST_APP_CONFIGURATION_SYNCED_TIME, 0);
    getAppConfigurations();

    appStore.setLoading(false);

    completer.complete(data);
  } catch (e) {
    completer.completeError(e);
  }

  return completer.future;
}

Future<BaseResponseModel> updateHandymanStatus(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('user-update-status', request: request, method: HttpMethodType.POST)));
}

Future<List<UserData>> getHandyman({int? page, String providerId = '', String? userTypeHandyman = "handyman", required List<UserData> list, Function(bool)? lastPageCallback}) async {
  String providerIds = providerId.isNotEmpty ? '&provider_id=$providerId' : '';
  try {
    var res = UserListResponse.fromJson(
      await handleResponse(await buildHttpResponse('user-list?user_type=$userTypeHandyman$providerIds&per_page=$PER_PAGE_ITEM&page=$page', method: HttpMethodType.GET)),
    );

    if (page == 1) list.clear();

    list.addAll(res.data.validate());

    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    cachedHandymanList = res.data;

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
  return list;
}

Future<List<UserData>> getProviderList({
  int page = 1,
  int perPage = PER_PAGE_ITEM,
  String? status,
  String? keyword,
  required List<UserData> list,
  Function(bool)? lastPageCallback,
}) async {
  try {
    String search = keyword.validate().isNotEmpty ? '&keyword=$keyword' : '';
    String providerStatus = status.validate().isNotEmpty ? "&status=$status" : "";

    var res = UserListResponse.fromJson(
      await handleResponse(await buildHttpResponse('user-list?user_type=provider$search$providerStatus&per_page=$perPage&page=$page', method: HttpMethodType.GET)),
    );

    if (page == 1) list.clear();

    list.addAll(res.data.validate());

    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
  return list;
}

Future<List<UserData>> getAllHandyman({int? page, int? serviceAddressId, required List<UserData> userData, Function(bool)? lastPageCallback}) async {
  try {
    UserListResponse res = UserListResponse.fromJson(
      await handleResponse(await buildHttpResponse('user-list?user_type=handyman&provider_id=${appStore.userId}&per_page=$PER_PAGE_ITEM&page=$page', method: HttpMethodType.GET)),
    );

    if (page == 1) userData.clear();

    userData.addAll(res.data.validate());

    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }

  return userData;
}

Future<UserData> deleteHandyman(int id) async {
  return UserData.fromJson(await handleResponse(await buildHttpResponse('handyman-delete/$id', method: HttpMethodType.POST)));
}

Future<BaseResponseModel> restoreHandyman(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('handyman-action', request: request, method: HttpMethodType.POST)));
}

//endregion

//region Service API
Future<ServiceResponse> getServiceList(int page, int providerId, {String? searchTxt, bool isSearch = false, int? categoryId, bool isCategoryWise = false}) async {
  if (isCategoryWise) {
    return ServiceResponse.fromJson(
        await handleResponse(await buildHttpResponse('service-list?per_page=$PER_PAGE_ITEM&category_id=$categoryId&page=$page&provider_id=$providerId', method: HttpMethodType.GET)));
  } else if (isSearch) {
    return ServiceResponse.fromJson(
        await handleResponse(await buildHttpResponse('service-list?per_page=$PER_PAGE_ITEM&page=$page&search=$searchTxt&provider_id=$providerId', method: HttpMethodType.GET)));
  } else {
    return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse('service-list?per_page=$PER_PAGE_ITEM&page=$page&provider_id=$providerId', method: HttpMethodType.GET)));
  }
}

Future<ServiceDetailResponse> getServiceDetail(Map request) async {
  ServiceDetailResponse res = ServiceDetailResponse.fromJson(await handleResponse(await buildHttpResponse('service-detail', request: request, method: HttpMethodType.POST)));
  if (!listOfCachedData.any((element) => element?.$1 == request['service_id'])) {
    listOfCachedData.add((request['service_id'], res));
  } else {
    int index = listOfCachedData.indexWhere((element) => element?.$1 == request['service_id']);
    listOfCachedData[index] = (request['service_id'], res);
  }

  return res;
}

Future<CommonResponseModel> deleteService(int id) async {
  return CommonResponseModel.fromJson(await handleResponse(await buildHttpResponse('service-delete/$id', method: HttpMethodType.POST)));
}

Future<BaseResponseModel> deleteImage(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('remove-file', request: request, method: HttpMethodType.POST)));
}

Future<void> addServiceMultiPart({required Map<String, dynamic> value, List<int>? serviceAddressList, List<File>? imageFile}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('service-save');

  multiPartRequest.fields.addAll(await getMultipartFields(val: value));

  if (serviceAddressList.validate().isNotEmpty) {
    for (int i = 0; i < serviceAddressList!.length; i++) {
      multiPartRequest.fields[AddServiceKey.providerAddressId + '[$i]'] = serviceAddressList[i].toString().validate();
    }
  }

  if (imageFile.validate().isNotEmpty) {
    multiPartRequest.files.addAll(await getMultipartImages(files: imageFile.validate(), name: AddServiceKey.serviceAttachment));
    multiPartRequest.fields[AddServiceKey.attachmentCount] = imageFile.validate().length.toString();
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

//region Booking API
Future<List<BookingStatusResponse>> bookingStatus({required List<BookingStatusResponse> list}) async {
  Iterable res = await (handleResponse(await buildHttpResponse('booking-status', method: HttpMethodType.GET)));
  list = res.map((e) => BookingStatusResponse.fromJson(e)).toList();
  cachedBookingStatusDropdown = list;
  return list;
}

Future<UpdateLocationResponse> updateLocation(int bookingId, String latitude, String longitude) async {
  return UpdateLocationResponse.fromJson(await handleResponse(await buildHttpResponse("update-location?booking_id=$bookingId&latitude=$latitude&longitude=$longitude", method: HttpMethodType.POST)
      .timeout(Duration(seconds: GET_LOCATION_API_TIMEOUT_SECOND))));
}

Future<UpdateLocationResponse> getHandymanLocation(int bookingId) async {
  return UpdateLocationResponse.fromJson(
      await handleResponse(await buildHttpResponse("get-location?booking_id=$bookingId", method: HttpMethodType.GET).timeout(Duration(seconds: GET_LOCATION_API_TIMEOUT_SECOND))));
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

Future<List<BookingData>> getBookingList(
  int page, {
  var perPage = PER_PAGE_ITEM,
  String serviceId = '',
  String dateFrom = '',
  String dateTo = '',
  String customerId = '',
  String providerId = '',
  String handymanId = '',
  String bookingStatus = '',
  String paymentStatus = '',
  String paymentType = '',
  String searchText = '',
  required List<BookingData> bookings,
  Function(bool)? lastPageCallback,
  Function(String totalEarning, PaymentBreakdown paymentBreakdown)? paymentBreakdownCallBack,
}) async {
  try {
    BookingListResponse res;
    String serviceIds = serviceId.isNotEmpty ? 'service_id=$serviceId&' : '';
    String dateStart = dateFrom.isNotEmpty ? 'date_from=$dateFrom&' : '';
    String dateEnd = dateTo.isNotEmpty ? '&date_to=$dateTo&' : '';
    String customerIds = customerId.isNotEmpty ? 'customer_id=$customerId&' : '';
    String providerIds = providerId.isNotEmpty ? 'provider_id=$providerId&' : '';
    String handymanIds = handymanId.isNotEmpty ? 'handyman_id=$handymanId&' : '';
    String status = bookingStatus.isNotEmpty ? 'status=$bookingStatus&' : '';
    String paymentStatuss = paymentStatus.isNotEmpty ? 'payment_status=$paymentStatus&' : '';
    String paymentTypes = paymentType.isNotEmpty ? 'payment_type=$paymentType&' : '';
    String searchParam = searchText.isNotEmpty ? '&search=$searchText&' : '';

    String perPageItem = 'per_page=$perPage&';
    String pageCount = 'page=$page';

    if (status == BOOKING_PAYMENT_STATUS_ALL) {
      res = BookingListResponse.fromJson(await handleResponse(await buildHttpResponse('booking-list?per_page=$perPage&page=$page$searchParam', method: HttpMethodType.GET)));
    } else {
      res = BookingListResponse.fromJson(await handleResponse(await buildHttpResponse(
          'booking-list?$serviceIds$dateStart$dateEnd$customerIds$providerIds$handymanIds$status$paymentStatuss$paymentTypes$perPageItem$pageCount$searchParam',
          method: HttpMethodType.GET)));
    }

    if (page == 1) bookings.clear();
    bookings.addAll(res.data.validate());
    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    if (res.totalEarning.validate().isNotEmpty && res.paymentBreakdown != null) {
      paymentBreakdownCallBack?.call(res.totalEarning.validate(), res.paymentBreakdown!);
    }

    cachedBookingList = bookings;

    appStore.setLoading(false);

    return bookings;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

//region All Service List API
Future<ServiceResponse> getAllServiceList({int? providerId, String perPage = ''}) async {
  String providerIds = appStore.isLoggedIn ? 'provider_id=${appStore.userId}' : '';
  return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse('search-list?$providerIds&per_page=$perPage', method: HttpMethodType.GET)));
}
//endregion

//region All Customer List API
Future<UserListResponse> getAllUserList({String userType = "", String perPage = ''}) async {
  String userTypes = userType.isNotEmpty ? 'user_type=$userType' : '';

  return UserListResponse.fromJson(await handleResponse(await buildHttpResponse('user-list?$userTypes&per_page=$perPage', method: HttpMethodType.GET)));
}
//endregion

Future<SearchListResponse> getServicesList(int page, {var perPage = PER_PAGE_ITEM, int? categoryId = -1, int? subCategoryId = -1, int? providerId, String? search, String? type}) async {
  String? req;
  String categoryIds = categoryId != -1 ? 'category_id=$categoryId&' : '';
  String searchPara = search.validate().isNotEmpty ? 'search=$search&' : '';
  String subCategorys = subCategoryId != -1 ? 'subcategory_id=$subCategoryId&' : '';
  String pages = 'page=$page&';
  String perPages = 'per_page=$PER_PAGE_ITEM';
  String providerIds = appStore.isLoggedIn ? 'provider_id=${appStore.userId}&' : '';
  String serviceType = type.validate().isNotEmpty ? 'type=$type&' : "";

  req = '?$categoryIds$providerIds$subCategorys$serviceType$searchPara$pages$perPages';
  return SearchListResponse.fromJson(await handleResponse(await buildHttpResponse('search-list$req', method: HttpMethodType.GET)));
}

Future<List<ServiceData>> getSearchList(
  int page, {
  var perPage = PER_PAGE_ITEM,
  int? categoryId = -1,
  int? subCategoryId = -1,
  int? providerId,
  String? search,
  String? type,
  String status = '',
  required List<ServiceData> services,
  Function(bool)? lastPageCallback,
}) async {
  try {
    // appStore.setLoading(true);
    SearchListResponse res;

    String? req;
    String categoryIds = categoryId != -1 ? 'category_id=$categoryId&' : '';
    String searchPara = search.validate().isNotEmpty ? 'search=$search&' : '';
    String subCategorys = subCategoryId != -1 ? 'subcategory_id=$subCategoryId&' : '';
    String pages = 'page=$page&';
    String perPages = 'per_page=$perPage';
    String providerIds = providerId != -1 ? 'provider_id=$providerId&' : '';
    String serviceType = type.validate().isNotEmpty ? 'type=$type&' : "";
    String approvalStatus = status.isNotEmpty ? 'request_status=$status&' : "";

    req = '?$categoryIds$providerIds$subCategorys$serviceType$approvalStatus$searchPara$pages$perPages';
    res = SearchListResponse.fromJson(await handleResponse(await buildHttpResponse('search-list$req', method: HttpMethodType.GET)));

    if (page == 1) services.clear();
    services.addAll(res.data.validate());
    lastPageCallback?.call(res.data.validate().length != perPage);

    appStore.setLoading(false);

    return services;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

Future<BookingDetailResponse> bookingDetail(Map request, {Function(String, int)? callbackForStatus}) async {
  BookingDetailResponse bookingDetailResponse = BookingDetailResponse.fromJson(
    await handleResponse(await buildHttpResponse('booking-detail', request: request, method: HttpMethodType.POST)),
  );
  callbackForStatus?.call(bookingDetailResponse.bookingDetail!.status.validate(),
      bookingDetailResponse.handymanData?.isNotEmpty ?? false ? bookingDetailResponse.handymanData!.firstOrNull!.id.validate() : bookingDetailResponse.providerData!.id.validate());
  appStore.setLoading(false);
  if (cachedBookingDetailList.any((element) => element.bookingDetail!.id == bookingDetailResponse.bookingDetail!.id)) {
    cachedBookingDetailList.removeWhere((element) => element.bookingDetail!.id == bookingDetailResponse.bookingDetail!.id);
  }
  cachedBookingDetailList.add(bookingDetailResponse);
  return bookingDetailResponse;
}

Future<BaseResponseModel> bookingUpdate(Map request) async {
  var res = BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('booking-update', request: request, method: HttpMethodType.POST)));
  LiveStream().emit(LIVESTREAM_UPDATE_BOOKINGS);

  appStore.setLoading(false);

  return res;
}

Future<BaseResponseModel> assignBooking(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('booking-assigned', request: request, method: HttpMethodType.POST)));
}
//endregion

//region Address API
Future<ServiceAddressesResponse> getAddresses({int? providerId}) async {
  return ServiceAddressesResponse.fromJson(await handleResponse(await buildHttpResponse('provideraddress-list?provider_id=$providerId', method: HttpMethodType.GET)));
}

Future<List<AddressResponse>> getAddressesWithPagination({
  int? page,
  int? perPage = PER_PAGE_ITEM,
  required List<AddressResponse> addressList,
  required int providerId,
  Function(bool)? lastPageCallback,
}) async {
  try {
    ServiceAddressesResponse res =
        ServiceAddressesResponse.fromJson(await handleResponse(await buildHttpResponse('provideraddress-list?provider_id=$providerId&per_page=$perPage&page=$page', method: HttpMethodType.GET)));

    if (page == 1) addressList.clear();

    addressList.addAll(res.addressResponse.validate());

    lastPageCallback?.call(res.addressResponse.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
  return addressList;
}

Future<BaseResponseModel> addAddresses(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-provideraddress', request: request, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> removeAddress(int? id) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('provideraddress-delete/$id', method: HttpMethodType.POST)));
}
//endregion

//region Reviews API
Future<List<RatingData>> serviceReviews(Map request) async {
  ServiceReviewResponse res =
      ServiceReviewResponse.fromJson(await handleResponse(await buildHttpResponse('service-reviews?per_page=$PER_PAGE_ITEM_ALL', request: request, method: HttpMethodType.POST)));

  return res.data.validate();
}

Future<List<RatingData>> handymanReviews(Map request) async {
  ServiceReviewResponse res =
      ServiceReviewResponse.fromJson(await handleResponse(await buildHttpResponse('handyman-reviews?per_page=$PER_PAGE_ITEM_ALL', request: request, method: HttpMethodType.POST)));
  return res.data.validate();
}
//endregion

//region Subscription API
Future<List<ProviderSubscriptionModel>> getPricingPlanList() async {
  try {
    PlanListResponse res = PlanListResponse.fromJson(await handleResponse(await buildHttpResponse('plan-list', method: HttpMethodType.GET)));

    appStore.setLoading(false);

    List<ProviderSubscriptionModel> list = res.data.validate();

    return list;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

Future<ProviderSubscriptionModel> saveSubscription(Map request) async {
  return ProviderSubscriptionModel.fromJson(await handleResponse(await buildHttpResponse('save-subscription', request: request, method: HttpMethodType.POST)));
}

Future<List<ProviderSubscriptionModel>> getSubscriptionHistory({
  int? page,
  int? perPage = PER_PAGE_ITEM,
  required List<ProviderSubscriptionModel> providerSubscriptionList,
  Function(bool)? lastPageCallback,
}) async {
  try {
    SubscriptionHistoryResponse res = SubscriptionHistoryResponse.fromJson(await handleResponse(await buildHttpResponse(
      'subscription-history?per_page=$perPage&page=$page&orderby=desc',
      method: HttpMethodType.GET,
    )));

    if (page == 1) providerSubscriptionList.clear();

    providerSubscriptionList.addAll(res.data.validate());

    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);

    return providerSubscriptionList;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

Future<void> cancelSubscription(Map request) async {
  return await handleResponse(await buildHttpResponse('cancel-subscription', request: request, method: HttpMethodType.POST));
}

Future<void> savePayment({
  ProviderSubscriptionModel? data,
  String? paymentStatus = BOOKING_PAYMENT_STATUS_ALL,
  String? paymentMethod,
  String? txnId,
}) async {
  if (data != null) {
    PlanRequestModel planRequestModel = PlanRequestModel()
      ..amount = data.amount
      ..description = data.description
      ..duration = data.duration
      ..identifier = data.identifier
      ..otherTransactionDetail = ''
      ..paymentStatus = paymentStatus.validate()
      ..paymentType = paymentMethod.validate()
      ..planId = data.id
      ..planLimitation = data.planLimitation
      ..planType = data.planType
      ..title = data.title
      ..txnId = txnId
      ..type = data.type
      ..userId = appStore.userId;

    appStore.setLoading(true);
    log('Request : $planRequestModel');

    await saveSubscription(planRequestModel.toJson()).then((value) async {
      toast("${data.title.validate()} ${languages.successfullyActivated}");
      await setValue(LAST_APP_CONFIGURATION_SYNCED_TIME, 0);
      push(ProviderDashboardScreen(index: 0), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    }).catchError((e) {
      log(e.toString());
    }).whenComplete(() => appStore.setLoading(false));
  }
}

Future<List<WalletHistory>> getWalletHistory({
  int? page,
  var perPage = PER_PAGE_ITEM,
  required List<WalletHistory> list,
  Function(bool)? lastPageCallback,
  Function(num)? availableBalance,
}) async {
  try {
    WalletHistoryListResponse res = WalletHistoryListResponse.fromJson(
      await handleResponse(await buildHttpResponse('wallet-history?per_page=$perPage&page=$page&orderby=desc', method: HttpMethodType.GET)),
    );
    if (page == 1) list.clear();
    list.addAll(res.data.validate());
    if (res.availableBalance != null) {
      availableBalance?.call(res.availableBalance ?? 0);
    }
    cachedWalletList = list;
    appStore.setLoading(false);
    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);
    return list;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
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

Future<BaseResponseModel> chooseDefaulBank({required int bankId}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('default-bank?id=$bankId', request: {}, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> deleteBank({int? bankId}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-bank/$bankId', request: {}, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> updateHandymanAvailabilityApi({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('handyman-update-available-status', request: request, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> walletMoneyWithdrawal({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('withdraw-money', request: request, method: HttpMethodType.POST)));
}

//endregion

//region Payment API

Future<List<PaymentSetting>> getPaymentGateways({bool isAdvancePayment = false, bool requireCOD = true, bool requireWallet = true, bool isAddWallet = false}) async {
  String isAddWalletStatus = isAddWallet ? '?is_add_wallet=$isAddWallet' : '';

  try {
    Iterable it = await handleResponse(await buildHttpResponse('payment-gateways$isAddWalletStatus', method: HttpMethodType.GET));
    List<PaymentSetting> res = it.map((e) => PaymentSetting.fromJson(e)).toList();

    if (!requireCOD) res.removeWhere((element) => element.type == PAYMENT_METHOD_COD);
    if (!requireWallet) res.removeWhere((element) => element.type == PAYMENT_METHOD_FROM_WALLET);

    if (!appConfigurationStore.onlinePaymentStatus) {
      res.removeWhere((element) => onlinePaymentGateways.contains(element.type));
    }
    return res;
  } catch (e) {
    throw e;
  }
}

Future<PaymentListResponse> getPaymentList(int page, {var perPage = PER_PAGE_ITEM}) async {
  return PaymentListResponse.fromJson(await handleResponse(await buildHttpResponse('payment-list?per_page=$perPage&page=$page', method: HttpMethodType.GET)));
}

Future<List<PaymentData>> getPaymentAPI(int page, List<PaymentData> list, Function(bool)? lastPageCallback, {var perPage = PER_PAGE_ITEM}) async {
  try {
    var res = PaymentListResponse.fromJson(await handleResponse(await buildHttpResponse('payment-list?per_page=$perPage&page=$page', method: HttpMethodType.GET)));

    if (page == 1) list.clear();
    list.addAll(res.data.validate());

    cachedPaymentList = list;

    appStore.setLoading(false);

    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    return list;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<List<PaymentData>> getUserPaymentList(int page, int id, List<PaymentData> list, Function(bool)? lastPageCallback) async {
  appStore.setLoading(true);
  var res = PaymentListResponse.fromJson(await handleResponse(await buildHttpResponse('payment-list?booking_id=$id&page=$page', method: HttpMethodType.GET)));

  if (page == 1) list.clear();
  list.addAll(res.data.validate());

  appStore.setLoading(false);

  lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

  return list;
}

Future<List<RequestListModel>> getRequestList(int page, int id, List<RequestListModel> list, Function(bool)? lastPageCallback) async {
  var res = RequestListResponse.fromJson(await handleResponse(await buildHttpResponse('provider-payout-list?provider_id=$id&page=$page', method: HttpMethodType.GET)));

  if (page == 1) list.clear();

  list.addAll(res.data.validate());
  appStore.setLoading(false);
  lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

  return list;
}
//endregion

//region Common API
Future<List<TaxData>> getTaxList({
  int? page,
  required List<TaxData> list,
  Function(bool)? lastPageCallback,
}) async {
  try {
    TaxListResponse res = TaxListResponse.fromJson(
      await (handleResponse(await buildHttpResponse('tax-list', method: HttpMethodType.GET))),
    );

    if (page == 1) list.clear();
    list.addAll(res.taxData.validate());

    lastPageCallback?.call(res.taxData.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
  return list;
}

//notification
Future<List<NotificationData>> getNotification(Map request, {int? page = 1, required List<NotificationData> notificationList, var perPage = PER_PAGE_ITEM, Function(bool)? lastPageCallback}) async {
  try {
    var res = NotificationListResponse.fromJson(await handleResponse(await buildHttpResponse('notification-list?per_page=$perPage&page=$page', request: request, method: HttpMethodType.POST)));

    if (page == 1) {
      notificationList.clear();
    }

    lastPageCallback?.call(res.notificationData.validate().length != PER_PAGE_ITEM);

    notificationList.addAll(res.notificationData.validate());
    cachedNotifications = notificationList;

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }

  return notificationList;
}

Future<DocumentListResponse> getDocList() async {
  return DocumentListResponse.fromJson(await handleResponse(await buildHttpResponse('document-list', method: HttpMethodType.GET)));
}

Future<List<TotalData>> getTotalEarningList(int page, List<TotalData> list, Function(bool)? lastPageCallback, {var perPage = PER_PAGE_ITEM}) async {
  try {
    var res = TotalEarningResponse.fromJson(
      await handleResponse(await buildHttpResponse('${isUserTypeProvider ? 'provider-payout-list' : 'handyman-payout-list'}?per_page=$perPage&page=$page', method: HttpMethodType.GET)),
    );

    if (page == 1) list.clear();
    list.addAll(res.data.validate());

    appStore.setLoading(false);

    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);
    cachedTotalDataList = list;
    return list;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<UserTypeResponse> getCommissionType({String type = USER_TYPE_PROVIDER, int? providerId, bool? isDelete}) async {
  String providerUserId = providerId != null ? "&provider_id=$providerId" : '';
  String isDeleteFlag = isDelete ?? false ? "&is_delete=true" : "";
  return UserTypeResponse.fromJson(await handleResponse(await buildHttpResponse('type-list?type=$type$providerUserId$isDeleteFlag')));
}

Future<BaseResponseModel> deleteAccountCompletely() async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-account', request: {}, method: HttpMethodType.POST)));
}
//endregion

//region Post Job Request
Future<List<PostJobData>> getPostJobList(int page, {var perPage = PER_PAGE_ITEM, required List<PostJobData> postJobList, Function(bool)? lastPageCallback}) async {
  try {
    var res = PostJobResponse.fromJson(await handleResponse(await buildHttpResponse('get-post-job?per_page=$perPage&page=$page', method: HttpMethodType.GET)));

    if (page == 1) {
      postJobList.clear();
    }

    lastPageCallback?.call(res.postJobData.validate().length != PER_PAGE_ITEM);

    postJobList.addAll(res.postJobData.validate());
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

    if (!cachedPostJobList.any((element) => element?.$1 == request[PostJob.postRequestId])) {
      cachedPostJobList.add((request[PostJob.postRequestId].toString().toInt().validate(), res));
    } else {
      int index = cachedPostJobList.indexWhere((element) => element?.$1 == request[PostJob.postRequestId].toString().toInt().validate());
      cachedPostJobList[index] = (request[PostJob.postRequestId].toString().toInt().validate(), res);
    }

    log(cachedPostJobList.map((e) => e));

    return res;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

Future<BaseResponseModel> saveBid(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-bid', request: request, method: HttpMethodType.POST)));
}

Future<List<BidderData>> getBidList({int page = 1, var perPage = PER_PAGE_ITEM, required List<BidderData> bidList, Function(bool)? lastPageCallback}) async {
  try {
    var res = MyBidResponse.fromJson(await handleResponse(await buildHttpResponse('get-bid-list?orderby=desc&per_page=$perPage&page=$page', method: HttpMethodType.GET)));

    if (page == 1) {
      bidList.clear();
    }

    lastPageCallback?.call(res.bidData.validate().length != PER_PAGE_ITEM);

    bidList.addAll(res.bidData.validate());
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
  return bidList;
}
//endregion

// region Addons service API
Future<List<ServiceAddon>> getAddonsServiceList({int? page, required List<ServiceAddon> addonServiceData, Function(bool)? lastPageCallback}) async {
  try {
    AddonsServiceResponse res = AddonsServiceResponse.fromJson(
      await handleResponse(await buildHttpResponse('service-addon-list?per_page=$PER_PAGE_ITEM&page=$page', method: HttpMethodType.GET)),
    );

    if (page == 1) addonServiceData.clear();

    addonServiceData.addAll(res.addonsServiceList.validate());

    lastPageCallback?.call(res.addonsServiceList.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);

    return addonServiceData;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<void> addAddonMultiPart({required Map<String, dynamic> value, File? imageFile}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('service-addon-save');

  multiPartRequest.fields.addAll(await getMultipartFields(val: value));

  if (imageFile != null) {
    multiPartRequest.files.add(await MultipartFile.fromPath(AddonServiceKey.serviceAddonImage, imageFile.path));
  }

  log("${multiPartRequest.fields}");

  multiPartRequest.headers.addAll(buildHeaderTokens());

  log("MultiPart Request : ${jsonEncode(multiPartRequest.fields)} ${multiPartRequest.files.map((e) => e.field + ": " + e.filename.validate())}");

  appStore.setLoading(true);

  await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
    appStore.setLoading(false);

    appStore.selectedServiceList.clear();
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

Future<CommonResponseModel> deleteAddonService(int id) async {
  return CommonResponseModel.fromJson(await handleResponse(await buildHttpResponse('service-addon-delete/$id', method: HttpMethodType.POST)));
}
//endregion

// region Package service API
Future<List<PackageData>> getAllPackageList({int? page, required List<PackageData> packageData, Function(bool)? lastPageCallback}) async {
  try {
    PackageResponse res = PackageResponse.fromJson(
      await handleResponse(await buildHttpResponse('package-list?per_page=$PER_PAGE_ITEM&page=$page', method: HttpMethodType.GET)),
    );

    if (page == 1) packageData.clear();

    packageData.addAll(res.packageList.validate());

    lastPageCallback?.call(res.packageList.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);

    return packageData;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<void> addPackageMultiPart({required Map<String, dynamic> value, List<File>? imageFile}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('package-save');

  multiPartRequest.fields.addAll(await getMultipartFields(val: value));

  if (imageFile.validate().isNotEmpty) {
    multiPartRequest.files.addAll(await getMultipartImages(files: imageFile.validate(), name: PackageKey.packageAttachment));
    multiPartRequest.fields[AddServiceKey.attachmentCount] = imageFile.validate().length.toString();
  }

  log("${multiPartRequest.fields}");

  multiPartRequest.headers.addAll(buildHeaderTokens());

  log("MultiPart Request : ${jsonEncode(multiPartRequest.fields)} ${multiPartRequest.files.map((e) => e.field + ": " + e.filename.validate())}");

  appStore.setLoading(true);

  await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
    appStore.setLoading(false);

    appStore.selectedServiceList.clear();
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

Future<CommonResponseModel> deletePackage(int id) async {
  return CommonResponseModel.fromJson(await handleResponse(await buildHttpResponse('package-delete/$id', method: HttpMethodType.POST)));
}
//endregion

//region FlutterWave Verify Transaction API
Future<VerifyTransactionResponse> verifyPayment({required String transactionId, required String flutterWaveSecretKey}) async {
  return VerifyTransactionResponse.fromJson(
    await handleResponse(await buildHttpResponse("https://api.flutterwave.com/v3/transactions/$transactionId/verify", header: buildHeaderForFlutterWave(flutterWaveSecretKey))),
  );
}
//endregion

//region TimeSlots
Future<BaseResponseModel> updateAllServicesApi({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('provider-all-services-timeslots', request: request, method: HttpMethodType.POST)));
}

Future<List<SlotData>> getProviderSlot({int? val}) async {
  String providerId = val != null ? "?provider_id=$val" : '';
  Iterable res = await handleResponse(await buildHttpResponse('get-provider-slot$providerId', method: HttpMethodType.GET));
  return res.map((e) => SlotData.fromJson(e)).toList();
}

Future<List<SlotData>> getProviderServiceSlot({int? providerId, int? serviceId}) async {
  String pId = providerId != null ? "?provider_id=$providerId" : '';
  String sId = serviceId != null ? "&service_id=$serviceId" : '';
  Iterable res = await handleResponse(await buildHttpResponse('get-service-slot$pId$sId', method: HttpMethodType.GET));
  return res.map((e) => SlotData.fromJson(e)).toList();
}

Future<BaseResponseModel> saveProviderSlot(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-provider-slot', request: request, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> saveServiceSlot(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-service-slot', request: request, method: HttpMethodType.POST)));
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

//region Google Maps
Future<List<GooglePlacesModel>> getSuggestion(String input) async {
  String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  String request = '$baseURL?input=$input&key=${appConfigurationStore.googleMapKey}&sessiontoken=${appStore.token}';

  var response = await buildHttpResponse(request);

  if (response.statusCode == 200) {
    Iterable it = jsonDecode(response.body)['predictions'];
    return it.map((e) => GooglePlacesModel.fromJson(e)).toList().validate();
  } else {
    throw Exception('${languages.lblFailedToLoadPredictions}');
  }
}
//endregion

Future<UserInfoResponse> getBankDetail(int id) async {
  appStore.setLoading(true);
  UserInfoResponse res = UserInfoResponse.fromJson(await handleResponse(await buildHttpResponse('user-bank-detail?user_id=$id', method: HttpMethodType.GET)));
  appStore.setLoading(false);
  return res;
}

Future<BaseResponseModel> withdrawRequest(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-provideraddress', request: request, method: HttpMethodType.POST)));
}

//region Add Handyman Commission
Future<BaseResponseModel> saveProviderHandymanTypeList({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('handymantype-save', method: HttpMethodType.POST, request: request)));
}

Future<BaseResponseModel> deleteProviderHandymanTypeList(int id) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('handymantype-delete/$id', method: HttpMethodType.POST)));
}

Future<BaseResponseModel> restoreProviderHandymanType(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('handymantype-action', request: request, method: HttpMethodType.POST)));
}
//end region Add Handyman Commission