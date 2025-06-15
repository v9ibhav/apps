// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

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
  Computed<bool>? _$earningTypeCommissionComputed;

  @override
  bool get earningTypeCommission => (_$earningTypeCommissionComputed ??=
          Computed<bool>(() => super.earningTypeCommission,
              name: '_AppStore.earningTypeCommission'))
      .value;
  Computed<bool>? _$earningTypeSubscriptionComputed;

  @override
  bool get earningTypeSubscription => (_$earningTypeSubscriptionComputed ??=
          Computed<bool>(() => super.earningTypeSubscription,
              name: '_AppStore.earningTypeSubscription'))
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

  late final _$isTesterAtom =
      Atom(name: '_AppStore.isTester', context: context);

  @override
  bool get isTester {
    _$isTesterAtom.reportRead();
    return super.isTester;
  }

  @override
  set isTester(bool value) {
    _$isTesterAtom.reportWrite(value, super.isTester, () {
      super.isTester = value;
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

  late final _$isCategoryWisePackageServiceAtom =
      Atom(name: '_AppStore.isCategoryWisePackageService', context: context);

  @override
  bool get isCategoryWisePackageService {
    _$isCategoryWisePackageServiceAtom.reportRead();
    return super.isCategoryWisePackageService;
  }

  @override
  set isCategoryWisePackageService(bool value) {
    _$isCategoryWisePackageServiceAtom
        .reportWrite(value, super.isCategoryWisePackageService, () {
      super.isCategoryWisePackageService = value;
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

  late final _$isPlanSubscribeAtom =
      Atom(name: '_AppStore.isPlanSubscribe', context: context);

  @override
  bool get isPlanSubscribe {
    _$isPlanSubscribeAtom.reportRead();
    return super.isPlanSubscribe;
  }

  @override
  set isPlanSubscribe(bool value) {
    _$isPlanSubscribeAtom.reportWrite(value, super.isPlanSubscribe, () {
      super.isPlanSubscribe = value;
    });
  }

  late final _$planTitleAtom =
      Atom(name: '_AppStore.planTitle', context: context);

  @override
  String get planTitle {
    _$planTitleAtom.reportRead();
    return super.planTitle;
  }

  @override
  set planTitle(String value) {
    _$planTitleAtom.reportWrite(value, super.planTitle, () {
      super.planTitle = value;
    });
  }

  late final _$identifierAtom =
      Atom(name: '_AppStore.identifier', context: context);

  @override
  String get identifier {
    _$identifierAtom.reportRead();
    return super.identifier;
  }

  @override
  set identifier(String value) {
    _$identifierAtom.reportWrite(value, super.identifier, () {
      super.identifier = value;
    });
  }

  late final _$planEndDateAtom =
      Atom(name: '_AppStore.planEndDate', context: context);

  @override
  String get planEndDate {
    _$planEndDateAtom.reportRead();
    return super.planEndDate;
  }

  @override
  set planEndDate(String value) {
    _$planEndDateAtom.reportWrite(value, super.planEndDate, () {
      super.planEndDate = value;
    });
  }

  late final _$notificationCountAtom =
      Atom(name: '_AppStore.notificationCount', context: context);

  @override
  num get notificationCount {
    _$notificationCountAtom.reportRead();
    return super.notificationCount;
  }

  @override
  set notificationCount(num value) {
    _$notificationCountAtom.reportWrite(value, super.notificationCount, () {
      super.notificationCount = value;
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

  late final _$designationAtom =
      Atom(name: '_AppStore.designation', context: context);

  @override
  String get designation {
    _$designationAtom.reportRead();
    return super.designation;
  }

  @override
  set designation(String value) {
    _$designationAtom.reportWrite(value, super.designation, () {
      super.designation = value;
    });
  }

  late final _$providerIdAtom =
      Atom(name: '_AppStore.providerId', context: context);

  @override
  int? get providerId {
    _$providerIdAtom.reportRead();
    return super.providerId;
  }

  @override
  set providerId(int? value) {
    _$providerIdAtom.reportWrite(value, super.providerId, () {
      super.providerId = value;
    });
  }

  late final _$serviceAddressIdAtom =
      Atom(name: '_AppStore.serviceAddressId', context: context);

  @override
  int get serviceAddressId {
    _$serviceAddressIdAtom.reportRead();
    return super.serviceAddressId;
  }

  @override
  set serviceAddressId(int value) {
    _$serviceAddressIdAtom.reportWrite(value, super.serviceAddressId, () {
      super.serviceAddressId = value;
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

  late final _$initialAdCountAtom =
      Atom(name: '_AppStore.initialAdCount', context: context);

  @override
  int get initialAdCount {
    _$initialAdCountAtom.reportRead();
    return super.initialAdCount;
  }

  @override
  set initialAdCount(int value) {
    _$initialAdCountAtom.reportWrite(value, super.initialAdCount, () {
      super.initialAdCount = value;
    });
  }

  late final _$totalBookingAtom =
      Atom(name: '_AppStore.totalBooking', context: context);

  @override
  int get totalBooking {
    _$totalBookingAtom.reportRead();
    return super.totalBooking;
  }

  @override
  set totalBooking(int value) {
    _$totalBookingAtom.reportWrite(value, super.totalBooking, () {
      super.totalBooking = value;
    });
  }

  late final _$completedBookingAtom =
      Atom(name: '_AppStore.completedBooking', context: context);

  @override
  int get completedBooking {
    _$completedBookingAtom.reportRead();
    return super.completedBooking;
  }

  @override
  set completedBooking(int value) {
    _$completedBookingAtom.reportWrite(value, super.completedBooking, () {
      super.completedBooking = value;
    });
  }

  late final _$createdAtAtom =
      Atom(name: '_AppStore.createdAt', context: context);

  @override
  String get createdAt {
    _$createdAtAtom.reportRead();
    return super.createdAt;
  }

  @override
  set createdAt(String value) {
    _$createdAtAtom.reportWrite(value, super.createdAt, () {
      super.createdAt = value;
    });
  }

  late final _$earningTypeAtom =
      Atom(name: '_AppStore.earningType', context: context);

  @override
  String get earningType {
    _$earningTypeAtom.reportRead();
    return super.earningType;
  }

  @override
  set earningType(String value) {
    _$earningTypeAtom.reportWrite(value, super.earningType, () {
      super.earningType = value;
    });
  }

  late final _$handymanAvailabilityAtom =
      Atom(name: '_AppStore.handymanAvailability', context: context);

  @override
  int get handymanAvailability {
    _$handymanAvailabilityAtom.reportRead();
    return super.handymanAvailability;
  }

  @override
  set handymanAvailability(int value) {
    _$handymanAvailabilityAtom.reportWrite(value, super.handymanAvailability,
        () {
      super.handymanAvailability = value;
    });
  }

  late final _$totalHandymanAtom =
      Atom(name: '_AppStore.totalHandyman', context: context);

  @override
  int get totalHandyman {
    _$totalHandymanAtom.reportRead();
    return super.totalHandyman;
  }

  @override
  set totalHandyman(int value) {
    _$totalHandymanAtom.reportWrite(value, super.totalHandyman, () {
      super.totalHandyman = value;
    });
  }

  late final _$selectedServiceListAtom =
      Atom(name: '_AppStore.selectedServiceList', context: context);

  @override
  List<ServiceData> get selectedServiceList {
    _$selectedServiceListAtom.reportRead();
    return super.selectedServiceList;
  }

  @override
  set selectedServiceList(List<ServiceData> value) {
    _$selectedServiceListAtom.reportWrite(value, super.selectedServiceList, () {
      super.selectedServiceList = value;
    });
  }

  late final _$selectedServiceDataAtom =
      Atom(name: '_AppStore.selectedServiceData', context: context);

  @override
  ServiceData get selectedServiceData {
    _$selectedServiceDataAtom.reportRead();
    return super.selectedServiceData;
  }

  @override
  set selectedServiceData(ServiceData value) {
    _$selectedServiceDataAtom.reportWrite(value, super.selectedServiceData, () {
      super.selectedServiceData = value;
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

  late final _$activeRevenueCatIdentifierAtom =
      Atom(name: '_AppStore.activeRevenueCatIdentifier', context: context);

  @override
  String get activeRevenueCatIdentifier {
    _$activeRevenueCatIdentifierAtom.reportRead();
    return super.activeRevenueCatIdentifier;
  }

  @override
  set activeRevenueCatIdentifier(String value) {
    _$activeRevenueCatIdentifierAtom
        .reportWrite(value, super.activeRevenueCatIdentifier, () {
      super.activeRevenueCatIdentifier = value;
    });
  }

  late final _$providerCurrentSubscriptionAtom =
      Atom(name: '_AppStore.providerCurrentSubscription', context: context);

  @override
  ProviderSubscriptionModel? get providerCurrentSubscription {
    _$providerCurrentSubscriptionAtom.reportRead();
    return super.providerCurrentSubscription;
  }

  @override
  set providerCurrentSubscription(ProviderSubscriptionModel? value) {
    _$providerCurrentSubscriptionAtom
        .reportWrite(value, super.providerCurrentSubscription, () {
      super.providerCurrentSubscription = value;
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

  late final _$setIsHelpDeskFirstTimeAsyncAction =
      AsyncAction('_AppStore.setIsHelpDeskFirstTime', context: context);

  @override
  Future<void> setIsHelpDeskFirstTime(bool val) {
    return _$setIsHelpDeskFirstTimeAsyncAction
        .run(() => super.setIsHelpDeskFirstTime(val));
  }

  late final _$setUserWalletAmountAsyncAction =
      AsyncAction('_AppStore.setUserWalletAmount', context: context);

  @override
  Future<void> setUserWalletAmount() {
    return _$setUserWalletAmountAsyncAction
        .run(() => super.setUserWalletAmount());
  }

  late final _$removeSelectedServiceAsyncAction =
      AsyncAction('_AppStore.removeSelectedService', context: context);

  @override
  Future<void> removeSelectedService(ServiceData val,
      {int selectedIndex = -1}) {
    return _$removeSelectedServiceAsyncAction.run(
        () => super.removeSelectedService(val, selectedIndex: selectedIndex));
  }

  late final _$setTesterAsyncAction =
      AsyncAction('_AppStore.setTester', context: context);

  @override
  Future<void> setTester(bool val) {
    return _$setTesterAsyncAction.run(() => super.setTester(val));
  }

  late final _$setEarningTypeAsyncAction =
      AsyncAction('_AppStore.setEarningType', context: context);

  @override
  Future<void> setEarningType(String val) {
    return _$setEarningTypeAsyncAction.run(() => super.setEarningType(val));
  }

  late final _$addSelectedPackageServiceAsyncAction =
      AsyncAction('_AppStore.addSelectedPackageService', context: context);

  @override
  Future<void> addSelectedPackageService(ServiceData val) {
    return _$addSelectedPackageServiceAsyncAction
        .run(() => super.addSelectedPackageService(val));
  }

  late final _$addAllSelectedPackageServiceAsyncAction =
      AsyncAction('_AppStore.addAllSelectedPackageService', context: context);

  @override
  Future<void> addAllSelectedPackageService(List<ServiceData> val) {
    return _$addAllSelectedPackageServiceAsyncAction
        .run(() => super.addAllSelectedPackageService(val));
  }

  late final _$removeSelectedPackageServiceAsyncAction =
      AsyncAction('_AppStore.removeSelectedPackageService', context: context);

  @override
  Future<void> removeSelectedPackageService(ServiceData val) {
    return _$removeSelectedPackageServiceAsyncAction
        .run(() => super.removeSelectedPackageService(val));
  }

  late final _$setCategoryBasedPackageServiceAsyncAction =
      AsyncAction('_AppStore.setCategoryBasedPackageService', context: context);

  @override
  Future<void> setCategoryBasedPackageService(bool val) {
    return _$setCategoryBasedPackageServiceAsyncAction
        .run(() => super.setCategoryBasedPackageService(val));
  }

  late final _$setUserProfileAsyncAction =
      AsyncAction('_AppStore.setUserProfile', context: context);

  @override
  Future<void> setUserProfile(String val) {
    return _$setUserProfileAsyncAction.run(() => super.setUserProfile(val));
  }

  late final _$set24HourFormatAsyncAction =
      AsyncAction('_AppStore.set24HourFormat', context: context);

  @override
  Future<void> set24HourFormat(bool val) {
    return _$set24HourFormatAsyncAction.run(() => super.set24HourFormat(val));
  }

  late final _$setNotificationCountAsyncAction =
      AsyncAction('_AppStore.setNotificationCount', context: context);

  @override
  Future<void> setNotificationCount(num val) {
    return _$setNotificationCountAsyncAction
        .run(() => super.setNotificationCount(val));
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

  late final _$setCityIdAsyncAction =
      AsyncAction('_AppStore.setCityId', context: context);

  @override
  Future<void> setCityId(int val) {
    return _$setCityIdAsyncAction.run(() => super.setCityId(val));
  }

  late final _$setUIdAsyncAction =
      AsyncAction('_AppStore.setUId', context: context);

  @override
  Future<void> setUId(String val) {
    return _$setUIdAsyncAction.run(() => super.setUId(val));
  }

  late final _$setPlanSubscribeStatusAsyncAction =
      AsyncAction('_AppStore.setPlanSubscribeStatus', context: context);

  @override
  Future<void> setPlanSubscribeStatus(bool val) {
    return _$setPlanSubscribeStatusAsyncAction
        .run(() => super.setPlanSubscribeStatus(val));
  }

  late final _$setPlanTitleAsyncAction =
      AsyncAction('_AppStore.setPlanTitle', context: context);

  @override
  Future<void> setPlanTitle(String val) {
    return _$setPlanTitleAsyncAction.run(() => super.setPlanTitle(val));
  }

  late final _$setIdentifierAsyncAction =
      AsyncAction('_AppStore.setIdentifier', context: context);

  @override
  Future<void> setIdentifier(String val) {
    return _$setIdentifierAsyncAction.run(() => super.setIdentifier(val));
  }

  late final _$setPlanEndDateAsyncAction =
      AsyncAction('_AppStore.setPlanEndDate', context: context);

  @override
  Future<void> setPlanEndDate(String val) {
    return _$setPlanEndDateAsyncAction.run(() => super.setPlanEndDate(val));
  }

  late final _$setUserIdAsyncAction =
      AsyncAction('_AppStore.setUserId', context: context);

  @override
  Future<void> setUserId(int val) {
    return _$setUserIdAsyncAction.run(() => super.setUserId(val));
  }

  late final _$setDesignationAsyncAction =
      AsyncAction('_AppStore.setDesignation', context: context);

  @override
  Future<void> setDesignation(String val) {
    return _$setDesignationAsyncAction.run(() => super.setDesignation(val));
  }

  late final _$setUserTypeAsyncAction =
      AsyncAction('_AppStore.setUserType', context: context);

  @override
  Future<void> setUserType(String val) {
    return _$setUserTypeAsyncAction.run(() => super.setUserType(val));
  }

  late final _$setTotalBookingAsyncAction =
      AsyncAction('_AppStore.setTotalBooking', context: context);

  @override
  Future<void> setTotalBooking(int val) {
    return _$setTotalBookingAsyncAction.run(() => super.setTotalBooking(val));
  }

  late final _$setCompletedBookingAsyncAction =
      AsyncAction('_AppStore.setCompletedBooking', context: context);

  @override
  Future<void> setCompletedBooking(int val) {
    return _$setCompletedBookingAsyncAction
        .run(() => super.setCompletedBooking(val));
  }

  late final _$setCreatedAtAsyncAction =
      AsyncAction('_AppStore.setCreatedAt', context: context);

  @override
  Future<void> setCreatedAt(String val) {
    return _$setCreatedAtAsyncAction.run(() => super.setCreatedAt(val));
  }

  late final _$setProviderIdAsyncAction =
      AsyncAction('_AppStore.setProviderId', context: context);

  @override
  Future<void> setProviderId(int val) {
    return _$setProviderIdAsyncAction.run(() => super.setProviderId(val));
  }

  late final _$setServiceAddressIdAsyncAction =
      AsyncAction('_AppStore.setServiceAddressId', context: context);

  @override
  Future<void> setServiceAddressId(int val) {
    return _$setServiceAddressIdAsyncAction
        .run(() => super.setServiceAddressId(val));
  }

  late final _$setUserEmailAsyncAction =
      AsyncAction('_AppStore.setUserEmail', context: context);

  @override
  Future<void> setUserEmail(String val) {
    return _$setUserEmailAsyncAction.run(() => super.setUserEmail(val));
  }

  late final _$setAddressAsyncAction =
      AsyncAction('_AppStore.setAddress', context: context);

  @override
  Future<void> setAddress(String val) {
    return _$setAddressAsyncAction.run(() => super.setAddress(val));
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

  late final _$setLoggedInAsyncAction =
      AsyncAction('_AppStore.setLoggedIn', context: context);

  @override
  Future<void> setLoggedIn(bool val) {
    return _$setLoggedInAsyncAction.run(() => super.setLoggedIn(val));
  }

  late final _$setPushNotificationSubscriptionStatusAsyncAction = AsyncAction(
      '_AppStore.setPushNotificationSubscriptionStatus',
      context: context);

  @override
  Future<void> setPushNotificationSubscriptionStatus(bool val) {
    return _$setPushNotificationSubscriptionStatusAsyncAction
        .run(() => super.setPushNotificationSubscriptionStatus(val));
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
  Future<void> setLanguage(String val, {BuildContext? context}) {
    return _$setLanguageAsyncAction
        .run(() => super.setLanguage(val, context: context));
  }

  late final _$setHandymanAvailabilityAsyncAction =
      AsyncAction('_AppStore.setHandymanAvailability', context: context);

  @override
  Future<void> setHandymanAvailability(int val) {
    return _$setHandymanAvailabilityAsyncAction
        .run(() => super.setHandymanAvailability(val));
  }

  late final _$setActiveRevenueCatIdentifierAsyncAction =
      AsyncAction('_AppStore.setActiveRevenueCatIdentifier', context: context);

  @override
  Future<void> setActiveRevenueCatIdentifier(String val) {
    return _$setActiveRevenueCatIdentifierAsyncAction
        .run(() => super.setActiveRevenueCatIdentifier(val));
  }

  late final _$setProviderCurrentSubscriptionPlanAsyncAction = AsyncAction(
      '_AppStore.setProviderCurrentSubscriptionPlan',
      context: context);

  @override
  Future<void> setProviderCurrentSubscriptionPlan(
      ProviderSubscriptionModel val) {
    return _$setProviderCurrentSubscriptionPlanAsyncAction
        .run(() => super.setProviderCurrentSubscriptionPlan(val));
  }

  late final _$_AppStoreActionController =
      ActionController(name: '_AppStore', context: context);

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
  void setTotalHandyman(int val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setTotalHandyman');
    try {
      return super.setTotalHandyman(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedServiceData(ServiceData data) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setSelectedServiceData');
    try {
      return super.setSelectedServiceData(data);
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
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
isDarkMode: ${isDarkMode},
isLoading: ${isLoading},
isTester: ${isTester},
userId: ${userId},
userFirstName: ${userFirstName},
userLastName: ${userLastName},
userEmail: ${userEmail},
userName: ${userName},
userContactNumber: ${userContactNumber},
userProfileImage: ${userProfileImage},
isCategoryWisePackageService: ${isCategoryWisePackageService},
selectedLanguageCode: ${selectedLanguageCode},
uid: ${uid},
isPlanSubscribe: ${isPlanSubscribe},
planTitle: ${planTitle},
identifier: ${identifier},
planEndDate: ${planEndDate},
notificationCount: ${notificationCount},
token: ${token},
countryId: ${countryId},
stateId: ${stateId},
cityId: ${cityId},
address: ${address},
designation: ${designation},
providerId: ${providerId},
serviceAddressId: ${serviceAddressId},
userType: ${userType},
initialAdCount: ${initialAdCount},
totalBooking: ${totalBooking},
completedBooking: ${completedBooking},
createdAt: ${createdAt},
earningType: ${earningType},
handymanAvailability: ${handymanAvailability},
totalHandyman: ${totalHandyman},
selectedServiceList: ${selectedServiceList},
selectedServiceData: ${selectedServiceData},
is24HourFormat: ${is24HourFormat},
userWalletAmount: ${userWalletAmount},
expansionDynamicHeight: ${expansionDynamicHeight},
selectedLanguage: ${selectedLanguage},
isHelpDeskFirstTime: ${isHelpDeskFirstTime},
activeRevenueCatIdentifier: ${activeRevenueCatIdentifier},
providerCurrentSubscription: ${providerCurrentSubscription},
isSubscribedForPushNotification: ${isSubscribedForPushNotification},
userFullName: ${userFullName},
earningTypeCommission: ${earningTypeCommission},
earningTypeSubscription: ${earningTypeSubscription}
    ''';
  }
}
