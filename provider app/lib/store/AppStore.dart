import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handyman_provider_flutter/locale/applocalizations.dart';
import 'package:handyman_provider_flutter/locale/base_language.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import '../models/provider_subscription_model.dart';
import '../models/service_model.dart';
import '../networks/rest_apis.dart';

part 'AppStore.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool isLoggedIn = getBoolAsync(IS_LOGGED_IN);

  @observable
  bool isDarkMode = false;

  @observable
  bool isLoading = false;

  @observable
  bool isTester = false;

  @observable
  int userId = getIntAsync(USER_ID);

  @observable
  String userFirstName = getStringAsync(FIRST_NAME);

  @observable
  String userLastName = getStringAsync(LAST_NAME);

  @computed
  String get userFullName => '$userFirstName $userLastName'.trim();

  @observable
  String userEmail = getStringAsync(USER_EMAIL);

  @observable
  String userName = getStringAsync(USERNAME);

  @observable
  String userContactNumber = getStringAsync(CONTACT_NUMBER);

  @observable
  String userProfileImage = getStringAsync(PROFILE_IMAGE);

  @observable
  bool isCategoryWisePackageService = getBoolAsync(CATEGORY_BASED_SELECT_PACKAGE_SERVICE);

  @observable
  String selectedLanguageCode = getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE);

  @observable
  String uid = getStringAsync(UID);

  @observable
  bool isPlanSubscribe = getBoolAsync(IS_PLAN_SUBSCRIBE);

  @observable
  String planTitle = getStringAsync(PLAN_TITLE);

  @observable
  String identifier = getStringAsync(PLAN_IDENTIFIER);

  @observable
  String planEndDate = getStringAsync(PLAN_END_DATE);

  @observable
  num notificationCount = -1;

  @observable
  String token = getStringAsync(TOKEN);

  @observable
  int countryId = getIntAsync(COUNTRY_ID);

  @observable
  int stateId = getIntAsync(STATE_ID);

  @observable
  int cityId = getIntAsync(CITY_ID);

  @observable
  String address = getStringAsync(ADDRESS);

  @observable
  String designation = getStringAsync(DESIGNATION);

  @observable
  int? providerId = getIntAsync(PROVIDER_ID);

  @observable
  int serviceAddressId = getIntAsync(SERVICE_ADDRESS_ID);

  @observable
  String userType = getStringAsync(USER_TYPE);

  @observable
  int initialAdCount = 0;

  @observable
  int totalBooking = getIntAsync(TOTAL_BOOKING);

  @observable
  int completedBooking = getIntAsync(COMPLETED_BOOKING);

  @observable
  String createdAt = getStringAsync(CREATED_AT);

  @observable
  String earningType = getStringAsync(EARNING_TYPE, defaultValue: EARNING_TYPE_COMMISSION);

  @computed
  bool get earningTypeCommission => earningType == EARNING_TYPE_COMMISSION;

  @computed
  bool get earningTypeSubscription => earningType == EARNING_TYPE_SUBSCRIPTION;

  @observable
  int handymanAvailability = getIntAsync(HANDYMAN_AVAILABLE_STATUS);

  @observable
  int totalHandyman = 0;

  @observable
  List<ServiceData> selectedServiceList = ObservableList.of([]);

  @observable
  ServiceData selectedServiceData = ServiceData();

  @observable
  bool is24HourFormat = getBoolAsync(HOUR_FORMAT_STATUS);

  @observable
  num userWalletAmount = 0.0;

  @observable
  double expansionDynamicHeight = 65;

  @observable
  LanguageDataModel selectedLanguage = languageList().first;

  @observable
  bool isHelpDeskFirstTime = getBoolAsync(IS_HELP_DESK_FIRST_TIME, defaultValue: true);

  @observable
  String activeRevenueCatIdentifier = getStringAsync(ACTIVE_IN_APP_PURCHASE_IDENTIFIER);

  @observable
  ProviderSubscriptionModel? providerCurrentSubscription;

  @action
  void setSelectedLanguage(LanguageDataModel val) {
    selectedLanguage = val;
  }


 @action
  void setExpansionDynamicHeight(double val) {
    expansionDynamicHeight = val;
  }
  @action
  Future<void> setIsHelpDeskFirstTime(bool val) async {
    isHelpDeskFirstTime = val;
    await setValue(IS_HELP_DESK_FIRST_TIME, isHelpDeskFirstTime);
  }

  @action
  Future<void> setUserWalletAmount() async {
    if (isLoggedIn) {
      userWalletAmount = await getUserWalletBalance();
    } else {
      userWalletAmount = 0.0;
    }
  }

  @action
  void setTotalHandyman(int val) {
    totalHandyman = val;
  }

  @action
  void setSelectedServiceData(ServiceData data) {
    selectedServiceData = data;
  }

  @action
  Future<void> removeSelectedService(ServiceData val, {int selectedIndex = -1}) async {
    if (selectedIndex == val.id) {
      selectedServiceData = ServiceData();
    }
  }

  @action
  Future<void> setTester(bool val) async {
    isTester = val;
    await setValue(IS_TESTER, isTester);
  }

  @action
  Future<void> setEarningType(String val) async {
    earningType = val;
    await setValue(EARNING_TYPE, val);
  }

  @action
  Future<void> addSelectedPackageService(ServiceData val) async {
    selectedServiceList.add(val);
    log('Selected Service length: ${selectedServiceList.length}');
  }

  @action
  Future<void> addAllSelectedPackageService(List<ServiceData> val) async {
    selectedServiceList.addAll(val);
    log('Selected All Service length: ${selectedServiceList.length}');
  }

  @action
  Future<void> removeSelectedPackageService(ServiceData val) async {
    selectedServiceList.remove(selectedServiceList.firstWhere((element) => element.id == val.id));
    log('After remove Selected Service length: ${selectedServiceList.length}');
  }

  @action
  Future<void> setCategoryBasedPackageService(bool val) async {
    isCategoryWisePackageService = val;
    await setValue(CATEGORY_BASED_SELECT_PACKAGE_SERVICE, isCategoryWisePackageService);
  }

  @action
  Future<void> setUserProfile(String val) async {
    userProfileImage = val;
    await setValue(PROFILE_IMAGE, val);
  }

  @action
  Future<void> set24HourFormat(bool val) async {
    is24HourFormat = val;
    await setValue(HOUR_FORMAT_STATUS, val);
  }

  @action
  Future<void> setNotificationCount(num val) async {
    notificationCount = val;
  }

  @action
  Future<void> setToken(String val) async {
    token = val;
    await setValue(TOKEN, val);
  }

  @action
  Future<void> setCountryId(int val) async {
    countryId = val;
    await setValue(COUNTRY_ID, val);
  }

  @action
  Future<void> setStateId(int val) async {
    stateId = val;
    await setValue(STATE_ID, val);
  }

  @action
  Future<void> setCityId(int val) async {
    cityId = val;
    await setValue(CITY_ID, val);
  }

  @action
  Future<void> setUId(String val) async {
    uid = val;
    await setValue(UID, val);
  }

  @action
  Future<void> setPlanSubscribeStatus(bool val) async {
    isPlanSubscribe = val && planTitle.isNotEmpty;
    await setValue(IS_PLAN_SUBSCRIBE, val);
  }

  @action
  Future<void> setPlanTitle(String val) async {
    planTitle = val;
    await setValue(PLAN_TITLE, val);
  }

  @action
  Future<void> setIdentifier(String val) async {
    identifier = val;
    await setValue(PLAN_IDENTIFIER, val);
  }

  @action
  Future<void> setPlanEndDate(String val) async {
    planEndDate = val;
    await setValue(PLAN_END_DATE, val);
  }

  @action
  Future<void> setUserId(int val) async {
    userId = val;
    await setValue(USER_ID, val);
  }

  @action
  Future<void> setDesignation(String val) async {
    designation = val;
    await setValue(DESIGNATION, val);
  }

  @action
  Future<void> setUserType(String val) async {
    userType = val;
    await setValue(USER_TYPE, val);
  }

  @action
  Future<void> setTotalBooking(int val) async {
    totalBooking = val;
    await setValue(TOTAL_BOOKING, val);
  }

  @action
  Future<void> setCompletedBooking(int val) async {
    completedBooking = val;
    await setValue(COMPLETED_BOOKING, val);
  }

  @action
  Future<void> setCreatedAt(String val) async {
    createdAt = val;
    await setValue(CREATED_AT, val);
  }

  @action
  Future<void> setProviderId(int val) async {
    providerId = val;
    await setValue(PROVIDER_ID, val);
  }

  @action
  Future<void> setServiceAddressId(int val) async {
    serviceAddressId = val;
    await setValue(SERVICE_ADDRESS_ID, val);
  }

  @action
  Future<void> setUserEmail(String val) async {
    userEmail = val;
    await setValue(USER_EMAIL, val);
  }

  @action
  Future<void> setAddress(String val) async {
    address = val;
    await setValue(ADDRESS, val);
  }

  @action
  Future<void> setFirstName(String val) async {
    userFirstName = val;
    await setValue(FIRST_NAME, val);
  }

  @action
  Future<void> setLastName(String val) async {
    userLastName = val;
    await setValue(LAST_NAME, val);
  }

  @action
  Future<void> setContactNumber(String val) async {
    userContactNumber = val;
    await setValue(CONTACT_NUMBER, val);
  }

  @action
  Future<void> setUserName(String val) async {
    userName = val;
    await setValue(USERNAME, val);
  }

  @action
  Future<void> setLoggedIn(bool val) async {
    isLoggedIn = val;
    await setValue(IS_LOGGED_IN, val);
  }

  @action
  void setLoading(bool val) {
    isLoading = val;
  }

  @observable
  bool isSubscribedForPushNotification = getBoolAsync(IS_SUBSCRIBED_FOR_PUSH_NOTIFICATION, defaultValue: true);

  @action
  Future<void> setPushNotificationSubscriptionStatus(bool val) async {
    isSubscribedForPushNotification = val;
    await setValue(IS_SUBSCRIBED_FOR_PUSH_NOTIFICATION, val);
  }

  @action
  Future<void> setDarkMode(bool val) async {
    isDarkMode = val;
    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = scaffoldSecondaryDark;
      appButtonBackgroundColorGlobal = appButtonColorDark;
      shadowColorGlobal = Colors.white12;
      setStatusBarColor(appButtonColorDark);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: scaffoldColorDark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.black12;
      setStatusBarColor(primaryColor);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }
  }

  @action
  Future<void> setLanguage(String val, {BuildContext? context}) async {
    selectedLanguageCode = val;
    selectedLanguageDataModel = getSelectedLanguageModel();

    await setValue(SELECTED_LANGUAGE_CODE, selectedLanguageCode);
    languages = await AppLocalizations().load(Locale(selectedLanguageCode));

    if (context != null) languages = Languages.of(context);

    errorMessage = languages.pleaseTryAgain;
    errorSomethingWentWrong = languages.somethingWentWrong;
    errorThisFieldRequired = languages.hintRequired;
    errorInternetNotAvailable = languages.internetNotAvailable;
  }

  @action
  Future<void> setHandymanAvailability(int val) async {
    handymanAvailability = val;
    await setValue(HANDYMAN_AVAILABLE_STATUS, val);
  }

  @action
  Future<void> setActiveRevenueCatIdentifier(String val) async {
    activeRevenueCatIdentifier = val;
    await setValue(ACTIVE_IN_APP_PURCHASE_IDENTIFIER, val);
  }
  @action
  Future<void> setProviderCurrentSubscriptionPlan(ProviderSubscriptionModel val) async {
    providerCurrentSubscription = val;
    await setValue(ACTIVE_SUBSCRIPTION_PLAN, val.toJson());
  }
}
