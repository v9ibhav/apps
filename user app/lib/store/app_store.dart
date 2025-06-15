import 'package:booking_system_flutter/locale/app_localizations.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/configs.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../network/rest_apis.dart';
import '../utils/common.dart';

part 'app_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool isLoggedIn = getBoolAsync(IS_LOGGED_IN);

  @observable
  bool isDarkMode = false;

  @observable
  bool isLoading = false;

  @observable
  bool isCurrentLocation = getBoolAsync(IS_CURRENT_LOCATION);

  @observable
  String selectedLanguageCode = getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE);

  @observable
  String userProfileImage = getStringAsync(PROFILE_IMAGE);

  @observable
  String loginType = getStringAsync(LOGIN_TYPE);

  @observable
  String userFirstName = getStringAsync(FIRST_NAME);

  @observable
  String userLastName = getStringAsync(LAST_NAME);

  @observable
  String uid = getStringAsync(UID);

  @observable
  String userContactNumber = getStringAsync(CONTACT_NUMBER);

  @observable
  String userEmail = getStringAsync(USER_EMAIL);

  @observable
  String userName = getStringAsync(USERNAME);

  @observable
  double latitude = 0.0;

  @observable
  double longitude = 0.0;

  @observable
  String token = getStringAsync(TOKEN);

  @observable
  int countryId = getIntAsync(COUNTRY_ID);

  @observable
  int stateId = getIntAsync(STATE_ID);

  @observable
  int cityId = getIntAsync(COUNTRY_ID);

  @observable
  String address = getStringAsync(ADDRESS);

  @computed
  String get userFullName => '$userFirstName $userLastName'.trim();

  @observable
  int userId = getIntAsync(USER_ID);

  @observable
  int unreadCount = 0;

  @observable
  bool useMaterialYouTheme = getBoolAsync(USE_MATERIAL_YOU_THEME);

  @observable
  String userType = getStringAsync(USER_TYPE);

  @observable
  bool is24HourFormat = getBoolAsync(HOUR_FORMAT_STATUS);

  @observable
  num userWalletAmount = 0.0;

  @observable
  bool isSubscribedForPushNotification = getBoolAsync(IS_SUBSCRIBED_FOR_PUSH_NOTIFICATION, defaultValue: true);

  @observable
  bool isSpeechActivated = false;

  @observable
  double expansionDynamicHeight = 65;

  @observable
  LanguageDataModel selectedLanguage = languageList().first;

  @observable
  bool isHelpDeskFirstTime = getBoolAsync(IS_HELP_DESK_FIRST_TIME, defaultValue: true);

  @action
  void setExpansionDynamicHeight(double val) {
    expansionDynamicHeight = val;
  }

  @action
  void setSelectedLanguage(LanguageDataModel val) {
    selectedLanguage = val;
  }

  @action
  Future<void> setIsHelpDeskFirstTime(bool val) async {
    isHelpDeskFirstTime = val;
    await setValue(IS_HELP_DESK_FIRST_TIME, isHelpDeskFirstTime);
  }

  @action
  void setSpeechStatus(bool val) {
    isSpeechActivated = val;
  }

  @action
  Future<void> setPushNotificationSubscriptionStatus(bool val) async {
    isSubscribedForPushNotification = val;
    await setValue(IS_SUBSCRIBED_FOR_PUSH_NOTIFICATION, val);
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
  Future<void> set24HourFormat(bool val) async {
    is24HourFormat = val;
    await setValue(HOUR_FORMAT_STATUS, val);
  }

  @action
  Future<void> setUseMaterialYouTheme(bool val) async {
    useMaterialYouTheme = val;
    await setValue(USE_MATERIAL_YOU_THEME, val);
  }

  @action
  Future<void> setUserType(String val) async {
    userType = val;
    await setValue(USER_TYPE, val);
  }

  @action
  Future<void> setAddress(String val) async {
    address = val;
    await setValue(ADDRESS, val);
  }

  @action
  Future<void> setUserProfile(String val) async {
    userProfileImage = val;
    await setValue(PROFILE_IMAGE, val);
  }

  @action
  Future<void> setLoginType(String val) async {
    loginType = val;
    await setValue(LOGIN_TYPE, val);
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
  Future<void> setUId(String val) async {
    uid = val;
    await setValue(UID, val);
  }

  @action
  Future<void> setCityId(int val) async {
    cityId = val;
    await setValue(CITY_ID, val);
  }

  @action
  Future<void> setUserId(int val) async {
    userId = val;
    await setValue(USER_ID, val);
  }

  @action
  Future<void> setUserEmail(String val) async {
    userEmail = val;
    await setValue(USER_EMAIL, val);
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
  Future<void> setLatitude(double val) async {
    latitude = val;
    await setValue(LATITUDE, val);
  }

  @action
  Future<void> setLongitude(double val) async {
    longitude = val;
    await setValue(LONGITUDE, val);
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

  @action
  Future<void> setCurrentLocation(bool val) async {
    isCurrentLocation = val;
    await setValue(IS_CURRENT_LOCATION, val);
  }

  @action
  void setUnreadCount(int val) {
    unreadCount = val;
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
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }
  }

  @action
  Future<void> setLanguage(String val) async {
    selectedLanguageCode = val;
    selectedLanguageDataModel = getSelectedLanguageModel();

    await setValue(SELECTED_LANGUAGE_CODE, selectedLanguageCode);

    language = await AppLocalizations().load(Locale(selectedLanguageCode));

    errorMessage = language.pleaseTryAgain;
    errorSomethingWentWrong = language.somethingWentWrong;
    errorThisFieldRequired = language.requiredText;
    errorInternetNotAvailable = language.internetNotAvailable;
  }
}
