// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  Computed<String>? _$userFullNameComputed;

  @override
  String get userFullName =>
      (_$userFullNameComputed ??= Computed<String>(() => super.userFullName,
              name: '_AppStore.userFullName'))
          .value;

  late final _$isLoggedInAtom =
      Atom(name: '_AppStore.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$isDarkModeAtom =
      Atom(name: '_AppStore.isDarkMode', context: context);

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AppStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isCurrentLocationAtom =
      Atom(name: '_AppStore.isCurrentLocation', context: context);

  @override
  bool get isCurrentLocation {
    _$isCurrentLocationAtom.reportRead();
    return super.isCurrentLocation;
  }

  @override
  set isCurrentLocation(bool value) {
    _$isCurrentLocationAtom.reportWrite(value, super.isCurrentLocation, () {
      super.isCurrentLocation = value;
    });
  }

  late final _$selectedLanguageCodeAtom =
      Atom(name: '_AppStore.selectedLanguageCode', context: context);

  @override
  String get selectedLanguageCode {
    _$selectedLanguageCodeAtom.reportRead();
    return super.selectedLanguageCode;
  }

  @override
  set selectedLanguageCode(String value) {
    _$selectedLanguageCodeAtom.reportWrite(value, super.selectedLanguageCode,
        () {
      super.selectedLanguageCode = value;
    });
  }

  late final _$userProfileImageAtom =
      Atom(name: '_AppStore.userProfileImage', context: context);

  @override
  String get userProfileImage {
    _$userProfileImageAtom.reportRead();
    return super.userProfileImage;
  }

  @override
  set userProfileImage(String value) {
    _$userProfileImageAtom.reportWrite(value, super.userProfileImage, () {
      super.userProfileImage = value;
    });
  }

  late final _$loginTypeAtom =
      Atom(name: '_AppStore.loginType', context: context);

  @override
  String get loginType {
    _$loginTypeAtom.reportRead();
    return super.loginType;
  }

  @override
  set loginType(String value) {
    _$loginTypeAtom.reportWrite(value, super.loginType, () {
      super.loginType = value;
    });
  }

  late final _$userFirstNameAtom =
      Atom(name: '_AppStore.userFirstName', context: context);

  @override
  String get userFirstName {
    _$userFirstNameAtom.reportRead();
    return super.userFirstName;
  }

  @override
  set userFirstName(String value) {
    _$userFirstNameAtom.reportWrite(value, super.userFirstName, () {
      super.userFirstName = value;
    });
  }

  late final _$userLastNameAtom =
      Atom(name: '_AppStore.userLastName', context: context);

  @override
  String get userLastName {
    _$userLastNameAtom.reportRead();
    return super.userLastName;
  }

  @override
  set userLastName(String value) {
    _$userLastNameAtom.reportWrite(value, super.userLastName, () {
      super.userLastName = value;
    });
  }

  late final _$uidAtom = Atom(name: '_AppStore.uid', context: context);

  @override
  String get uid {
    _$uidAtom.reportRead();
    return super.uid;
  }

  @override
  set uid(String value) {
    _$uidAtom.reportWrite(value, super.uid, () {
      super.uid = value;
    });
  }

  late final _$userContactNumberAtom =
      Atom(name: '_AppStore.userContactNumber', context: context);

  @override
  String get userContactNumber {
    _$userContactNumberAtom.reportRead();
    return super.userContactNumber;
  }

  @override
  set userContactNumber(String value) {
    _$userContactNumberAtom.reportWrite(value, super.userContactNumber, () {
      super.userContactNumber = value;
    });
  }

  late final _$userEmailAtom =
      Atom(name: '_AppStore.userEmail', context: context);

  @override
  String get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  late final _$userNameAtom =
      Atom(name: '_AppStore.userName', context: context);

  @override
  String get userName {
    _$userNameAtom.reportRead();
    return super.userName;
  }

  @override
  set userName(String value) {
    _$userNameAtom.reportWrite(value, super.userName, () {
      super.userName = value;
    });
  }

  late final _$latitudeAtom =
      Atom(name: '_AppStore.latitude', context: context);

  @override
  double get latitude {
    _$latitudeAtom.reportRead();
    return super.latitude;
  }

  @override
  set latitude(double value) {
    _$latitudeAtom.reportWrite(value, super.latitude, () {
      super.latitude = value;
    });
  }

  late final _$longitudeAtom =
      Atom(name: '_AppStore.longitude', context: context);

  @override
  double get longitude {
    _$longitudeAtom.reportRead();
    return super.longitude;
  }

  @override
  set longitude(double value) {
    _$longitudeAtom.reportWrite(value, super.longitude, () {
      super.longitude = value;
    });
  }

  late final _$tokenAtom = Atom(name: '_AppStore.token', context: context);

  @override
  String get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$countryIdAtom =
      Atom(name: '_AppStore.countryId', context: context);

  @override
  int get countryId {
    _$countryIdAtom.reportRead();
    return super.countryId;
  }

  @override
  set countryId(int value) {
    _$countryIdAtom.reportWrite(value, super.countryId, () {
      super.countryId = value;
    });
  }

  late final _$stateIdAtom = Atom(name: '_AppStore.stateId', context: context);

  @override
  int get stateId {
    _$stateIdAtom.reportRead();
    return super.stateId;
  }

  @override
  set stateId(int value) {
    _$stateIdAtom.reportWrite(value, super.stateId, () {
      super.stateId = value;
    });
  }

  late final _$cityIdAtom = Atom(name: '_AppStore.cityId', context: context);

  @override
  int get cityId {
    _$cityIdAtom.reportRead();
    return super.cityId;
  }

  @override
  set cityId(int value) {
    _$cityIdAtom.reportWrite(value, super.cityId, () {
      super.cityId = value;
    });
  }

  late final _$addressAtom = Atom(name: '_AppStore.address', context: context);

  @override
  String get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(String value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  late final _$userIdAtom = Atom(name: '_AppStore.userId', context: context);

  @override
  int get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(int value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  late final _$unreadCountAtom =
      Atom(name: '_AppStore.unreadCount', context: context);

  @override
  int get unreadCount {
    _$unreadCountAtom.reportRead();
    return super.unreadCount;
  }

  @override
  set unreadCount(int value) {
    _$unreadCountAtom.reportWrite(value, super.unreadCount, () {
      super.unreadCount = value;
    });
  }

  late final _$useMaterialYouThemeAtom =
      Atom(name: '_AppStore.useMaterialYouTheme', context: context);

  @override
  bool get useMaterialYouTheme {
    _$useMaterialYouThemeAtom.reportRead();
    return super.useMaterialYouTheme;
  }

  @override
  set useMaterialYouTheme(bool value) {
    _$useMaterialYouThemeAtom.reportWrite(value, super.useMaterialYouTheme, () {
      super.useMaterialYouTheme = value;
    });
  }

  late final _$userTypeAtom =
      Atom(name: '_AppStore.userType', context: context);

  @override
  String get userType {
    _$userTypeAtom.reportRead();
    return super.userType;
  }

  @override
  set userType(String value) {
    _$userTypeAtom.reportWrite(value, super.userType, () {
      super.userType = value;
    });
  }

  late final _$is24HourFormatAtom =
      Atom(name: '_AppStore.is24HourFormat', context: context);

  @override
  bool get is24HourFormat {
    _$is24HourFormatAtom.reportRead();
    return super.is24HourFormat;
  }

  @override
  set is24HourFormat(bool value) {
    _$is24HourFormatAtom.reportWrite(value, super.is24HourFormat, () {
      super.is24HourFormat = value;
    });
  }

  late final _$userWalletAmountAtom =
      Atom(name: '_AppStore.userWalletAmount', context: context);

  @override
  num get userWalletAmount {
    _$userWalletAmountAtom.reportRead();
    return super.userWalletAmount;
  }

  @override
  set userWalletAmount(num value) {
    _$userWalletAmountAtom.reportWrite(value, super.userWalletAmount, () {
      super.userWalletAmount = value;
    });
  }

  late final _$isSubscribedForPushNotificationAtom =
      Atom(name: '_AppStore.isSubscribedForPushNotification', context: context);

  @override
  bool get isSubscribedForPushNotification {
    _$isSubscribedForPushNotificationAtom.reportRead();
    return super.isSubscribedForPushNotification;
  }

  @override
  set isSubscribedForPushNotification(bool value) {
    _$isSubscribedForPushNotificationAtom
        .reportWrite(value, super.isSubscribedForPushNotification, () {
      super.isSubscribedForPushNotification = value;
    });
  }

  late final _$isSpeechActivatedAtom =
      Atom(name: '_AppStore.isSpeechActivated', context: context);

  @override
  bool get isSpeechActivated {
    _$isSpeechActivatedAtom.reportRead();
    return super.isSpeechActivated;
  }

  @override
  set isSpeechActivated(bool value) {
    _$isSpeechActivatedAtom.reportWrite(value, super.isSpeechActivated, () {
      super.isSpeechActivated = value;
    });
  }

  late final _$expansionDynamicHeightAtom =
      Atom(name: '_AppStore.expansionDynamicHeight', context: context);

  @override
  double get expansionDynamicHeight {
    _$expansionDynamicHeightAtom.reportRead();
    return super.expansionDynamicHeight;
  }

  @override
  set expansionDynamicHeight(double value) {
    _$expansionDynamicHeightAtom
        .reportWrite(value, super.expansionDynamicHeight, () {
      super.expansionDynamicHeight = value;
    });
  }

  late final _$selectedLanguageAtom =
      Atom(name: '_AppStore.selectedLanguage', context: context);

  @override
  LanguageDataModel get selectedLanguage {
    _$selectedLanguageAtom.reportRead();
    return super.selectedLanguage;
  }

  @override
  set selectedLanguage(LanguageDataModel value) {
    _$selectedLanguageAtom.reportWrite(value, super.selectedLanguage, () {
      super.selectedLanguage = value;
    });
  }

  late final _$isHelpDeskFirstTimeAtom =
      Atom(name: '_AppStore.isHelpDeskFirstTime', context: context);

  @override
  bool get isHelpDeskFirstTime {
    _$isHelpDeskFirstTimeAtom.reportRead();
    return super.isHelpDeskFirstTime;
  }

  @override
  set isHelpDeskFirstTime(bool value) {
    _$isHelpDeskFirstTimeAtom.reportWrite(value, super.isHelpDeskFirstTime, () {
      super.isHelpDeskFirstTime = value;
    });
  }

  late final _$setIsHelpDeskFirstTimeAsyncAction =
      AsyncAction('_AppStore.setIsHelpDeskFirstTime', context: context);

  @override
  Future<void> setIsHelpDeskFirstTime(bool val) {
    return _$setIsHelpDeskFirstTimeAsyncAction
        .run(() => super.setIsHelpDeskFirstTime(val));
  }

  late final _$setPushNotificationSubscriptionStatusAsyncAction = AsyncAction(
      '_AppStore.setPushNotificationSubscriptionStatus',
      context: context);

  @override
  Future<void> setPushNotificationSubscriptionStatus(bool val) {
    return _$setPushNotificationSubscriptionStatusAsyncAction
        .run(() => super.setPushNotificationSubscriptionStatus(val));
  }

  late final _$setUserWalletAmountAsyncAction =
      AsyncAction('_AppStore.setUserWalletAmount', context: context);

  @override
  Future<void> setUserWalletAmount() {
    return _$setUserWalletAmountAsyncAction
        .run(() => super.setUserWalletAmount());
  }

  late final _$set24HourFormatAsyncAction =
      AsyncAction('_AppStore.set24HourFormat', context: context);

  @override
  Future<void> set24HourFormat(bool val) {
    return _$set24HourFormatAsyncAction.run(() => super.set24HourFormat(val));
  }

  late final _$setUseMaterialYouThemeAsyncAction =
      AsyncAction('_AppStore.setUseMaterialYouTheme', context: context);

  @override
  Future<void> setUseMaterialYouTheme(bool val) {
    return _$setUseMaterialYouThemeAsyncAction
        .run(() => super.setUseMaterialYouTheme(val));
  }

  late final _$setUserTypeAsyncAction =
      AsyncAction('_AppStore.setUserType', context: context);

  @override
  Future<void> setUserType(String val) {
    return _$setUserTypeAsyncAction.run(() => super.setUserType(val));
  }

  late final _$setAddressAsyncAction =
      AsyncAction('_AppStore.setAddress', context: context);

  @override
  Future<void> setAddress(String val) {
    return _$setAddressAsyncAction.run(() => super.setAddress(val));
  }

  late final _$setUserProfileAsyncAction =
      AsyncAction('_AppStore.setUserProfile', context: context);

  @override
  Future<void> setUserProfile(String val) {
    return _$setUserProfileAsyncAction.run(() => super.setUserProfile(val));
  }

  late final _$setLoginTypeAsyncAction =
      AsyncAction('_AppStore.setLoginType', context: context);

  @override
  Future<void> setLoginType(String val) {
    return _$setLoginTypeAsyncAction.run(() => super.setLoginType(val));
  }

  late final _$setTokenAsyncAction =
      AsyncAction('_AppStore.setToken', context: context);

  @override
  Future<void> setToken(String val) {
    return _$setTokenAsyncAction.run(() => super.setToken(val));
  }

  late final _$setCountryIdAsyncAction =
      AsyncAction('_AppStore.setCountryId', context: context);

  @override
  Future<void> setCountryId(int val) {
    return _$setCountryIdAsyncAction.run(() => super.setCountryId(val));
  }

  late final _$setStateIdAsyncAction =
      AsyncAction('_AppStore.setStateId', context: context);

  @override
  Future<void> setStateId(int val) {
    return _$setStateIdAsyncAction.run(() => super.setStateId(val));
  }

  late final _$setUIdAsyncAction =
      AsyncAction('_AppStore.setUId', context: context);

  @override
  Future<void> setUId(String val) {
    return _$setUIdAsyncAction.run(() => super.setUId(val));
  }

  late final _$setCityIdAsyncAction =
      AsyncAction('_AppStore.setCityId', context: context);

  @override
  Future<void> setCityId(int val) {
    return _$setCityIdAsyncAction.run(() => super.setCityId(val));
  }

  late final _$setUserIdAsyncAction =
      AsyncAction('_AppStore.setUserId', context: context);

  @override
  Future<void> setUserId(int val) {
    return _$setUserIdAsyncAction.run(() => super.setUserId(val));
  }

  late final _$setUserEmailAsyncAction =
      AsyncAction('_AppStore.setUserEmail', context: context);

  @override
  Future<void> setUserEmail(String val) {
    return _$setUserEmailAsyncAction.run(() => super.setUserEmail(val));
  }

  late final _$setFirstNameAsyncAction =
      AsyncAction('_AppStore.setFirstName', context: context);

  @override
  Future<void> setFirstName(String val) {
    return _$setFirstNameAsyncAction.run(() => super.setFirstName(val));
  }

  late final _$setLastNameAsyncAction =
      AsyncAction('_AppStore.setLastName', context: context);

  @override
  Future<void> setLastName(String val) {
    return _$setLastNameAsyncAction.run(() => super.setLastName(val));
  }

  late final _$setContactNumberAsyncAction =
      AsyncAction('_AppStore.setContactNumber', context: context);

  @override
  Future<void> setContactNumber(String val) {
    return _$setContactNumberAsyncAction.run(() => super.setContactNumber(val));
  }

  late final _$setUserNameAsyncAction =
      AsyncAction('_AppStore.setUserName', context: context);

  @override
  Future<void> setUserName(String val) {
    return _$setUserNameAsyncAction.run(() => super.setUserName(val));
  }

  late final _$setLatitudeAsyncAction =
      AsyncAction('_AppStore.setLatitude', context: context);

  @override
  Future<void> setLatitude(double val) {
    return _$setLatitudeAsyncAction.run(() => super.setLatitude(val));
  }

  late final _$setLongitudeAsyncAction =
      AsyncAction('_AppStore.setLongitude', context: context);

  @override
  Future<void> setLongitude(double val) {
    return _$setLongitudeAsyncAction.run(() => super.setLongitude(val));
  }

  late final _$setLoggedInAsyncAction =
      AsyncAction('_AppStore.setLoggedIn', context: context);

  @override
  Future<void> setLoggedIn(bool val) {
    return _$setLoggedInAsyncAction.run(() => super.setLoggedIn(val));
  }

  late final _$setCurrentLocationAsyncAction =
      AsyncAction('_AppStore.setCurrentLocation', context: context);

  @override
  Future<void> setCurrentLocation(bool val) {
    return _$setCurrentLocationAsyncAction
        .run(() => super.setCurrentLocation(val));
  }

  late final _$setDarkModeAsyncAction =
      AsyncAction('_AppStore.setDarkMode', context: context);

  @override
  Future<void> setDarkMode(bool val) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(val));
  }

  late final _$setLanguageAsyncAction =
      AsyncAction('_AppStore.setLanguage', context: context);

  @override
  Future<void> setLanguage(String val) {
    return _$setLanguageAsyncAction.run(() => super.setLanguage(val));
  }

  late final _$_AppStoreActionController =
      ActionController(name: '_AppStore', context: context);

  @override
  void setExpansionDynamicHeight(double val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setExpansionDynamicHeight');
    try {
      return super.setExpansionDynamicHeight(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedLanguage(LanguageDataModel val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setSelectedLanguage');
    try {
      return super.setSelectedLanguage(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSpeechStatus(bool val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setSpeechStatus');
    try {
      return super.setSpeechStatus(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUnreadCount(int val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setUnreadCount');
    try {
      return super.setUnreadCount(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
isDarkMode: ${isDarkMode},
isLoading: ${isLoading},
isCurrentLocation: ${isCurrentLocation},
selectedLanguageCode: ${selectedLanguageCode},
userProfileImage: ${userProfileImage},
loginType: ${loginType},
userFirstName: ${userFirstName},
userLastName: ${userLastName},
uid: ${uid},
userContactNumber: ${userContactNumber},
userEmail: ${userEmail},
userName: ${userName},
latitude: ${latitude},
longitude: ${longitude},
token: ${token},
countryId: ${countryId},
stateId: ${stateId},
cityId: ${cityId},
address: ${address},
userId: ${userId},
unreadCount: ${unreadCount},
useMaterialYouTheme: ${useMaterialYouTheme},
userType: ${userType},
is24HourFormat: ${is24HourFormat},
userWalletAmount: ${userWalletAmount},
isSubscribedForPushNotification: ${isSubscribedForPushNotification},
isSpeechActivated: ${isSpeechActivated},
expansionDynamicHeight: ${expansionDynamicHeight},
selectedLanguage: ${selectedLanguage},
isHelpDeskFirstTime: ${isHelpDeskFirstTime},
userFullName: ${userFullName}
    ''';
  }
}
