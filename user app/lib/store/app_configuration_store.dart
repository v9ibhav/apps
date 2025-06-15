import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/app_configuration.dart';
import '../utils/constant.dart';

part 'app_configuration_store.g.dart';

class AppConfigurationStore = _AppConfigurationStore with _$AppConfigurationStore;

abstract class _AppConfigurationStore with Store {
  @observable
  int priceDecimalPoint = getIntAsync(PRICE_DECIMAL_POINTS, defaultValue: DECIMAL_POINT);

  @observable
  bool jobRequestStatus = getBoolAsync(JOB_REQUEST_SERVICE_STATUS);

  @observable
  bool blogStatus = getBoolAsync(BLOG_STATUS);

  @observable
  bool socialLoginStatus = getBoolAsync(SOCIAL_LOGIN_STATUS);

  @observable
  bool googleLoginStatus = getBoolAsync(GOOGLE_LOGIN_STATUS);

  @observable
  bool appleLoginStatus = getBoolAsync(APPLE_LOGIN_STATUS);

  @observable
  bool otpLoginStatus = getBoolAsync(OTP_LOGIN_STATUS);

  @observable
  bool maintenanceModeStatus = getBoolAsync(IN_MAINTENANCE_MODE);

  @observable
  bool chatGPTStatus = getBoolAsync(CHAT_GPT_STATUS);

  @observable
  bool testWithoutKey = getBoolAsync(TEST_CHAT_GPT_WITHOUT_KEY);

  @observable
  String firebaseServerKey = '';

  @observable
  String googleMapKey = '';

  @observable
  String inquiryEmail = getStringAsync(INQUIRY_EMAIL);

  @observable
  String helplineNumber = getStringAsync(HELPLINE_NUMBER);

  @observable
  String currencyPosition = getStringAsync(CURRENCY_POSITION, defaultValue: CURRENCY_POSITION_LEFT);

  @observable
  String currencySymbol = getStringAsync(CURRENCY_COUNTRY_SYMBOL);

  @observable
  String currencyCode = getStringAsync(CURRENCY_COUNTRY_CODE);

  @observable
  bool isEnableUserWallet = getBoolAsync(ENABLE_USER_WALLET);

  @observable
  bool isAdvancePaymentAllowed = getBoolAsync(IS_ADVANCE_PAYMENT_ALLOWED);

  @observable
  bool slotServiceStatus = getBoolAsync(SLOT_SERVICE_STATUS);

  @observable
  bool digitalServiceStatus = getBoolAsync(DIGITAL_SERVICE_STATUS);

  @observable
  bool servicePackageStatus = getBoolAsync(SERVICE_PACKAGE_STATUS);

  @observable
  bool serviceAddonStatus = getBoolAsync(SERVICE_ADDON_STATUS);

  @observable
  bool onlinePaymentStatus = getBoolAsync(ONLINE_PAYMENT_STATUS);

  @observable
  String privacyPolicy = getStringAsync(PRIVACY_POLICY);

  @observable
  String termConditions = getStringAsync(TERM_CONDITIONS);

  @observable
  String helpAndSupport = getStringAsync(HELP_AND_SUPPORT);

  @observable
  String refundPolicy = getStringAsync(REFUND_POLICY);

  @observable
  String userDashboardType = getStringAsync(USER_DASHBOARD);

  @observable
  bool isUserAuthorized = getBoolAsync(IS_USER_AUTHORIZED);

  @observable
  bool cancellationCharge  = getBoolAsync(CANCELLATION_CHARGE);

  @observable
  num cancellationChargeAmount = getDoubleAsync(CANCELLATION_CHARGE_AMOUNT);

  @observable
  int cancellationChargeHours = getIntAsync(CANCELLATION_CHARGE_HOURS);

  @observable
  bool isPromotionalBanner = getBoolAsync(PROMOTIONAL_BANNER_STATUS);

  @action
  Future<void> setPromotionalBannerStatus(bool val) async {
    isPromotionalBanner = val;
    await setValue(PROMOTIONAL_BANNER_STATUS, val);
  }

  @action
  Future<void> setRefundPolicy(String val) async {
    refundPolicy = val;
    await setValue(REFUND_POLICY, val);
  }

  @action
  Future<void> setHelpAndSupport(String val) async {
    helpAndSupport = val;
    await setValue(HELP_AND_SUPPORT, val);
  }

  @action
  Future<void> setPrivacyPolicy(String val) async {
    privacyPolicy = val;
    await setValue(PRIVACY_POLICY, val);
  }

  @action
  Future<void> setTermConditions(String val) async {
    termConditions = val;
    await setValue(TERM_CONDITIONS, val);
  }

  @action
  Future<void> setAdvancePaymentAllowed(bool val) async {
    isAdvancePaymentAllowed = val;
    await setValue(IS_ADVANCE_PAYMENT_ALLOWED, val);
  }

  @action
  Future<void> setSlotServiceStatus(bool val) async {
    slotServiceStatus = val;
    await setValue(SLOT_SERVICE_STATUS, val);
  }

  @action
  Future<void> setDigitalServiceStatus(bool val) async {
    digitalServiceStatus = val;
    await setValue(DIGITAL_SERVICE_STATUS, val);
  }

  @action
  Future<void> setServicePackageStatus(bool val) async {
    servicePackageStatus = val;
    await setValue(SERVICE_PACKAGE_STATUS, val);
  }

  @action
  Future<void> setServiceAddonStatus(bool val) async {
    serviceAddonStatus = val;
    await setValue(SERVICE_ADDON_STATUS, val);
  }

  @action
  Future<void> setOnlinePaymentStatus(bool val) async {
    onlinePaymentStatus = val;
    await setValue(ONLINE_PAYMENT_STATUS, val);
  }

  @action
  Future<void> setPriceDecimalPoint(int val) async {
    priceDecimalPoint = val;
    await setValue(PRICE_DECIMAL_POINTS, val);
  }

  @action
  Future<void> setEnableUserWallet(bool val) async {
    isEnableUserWallet = val;
    await setValue(ENABLE_USER_WALLET, val);
  }

  @action
  Future<void> setInquiryEmail(String val) async {
    inquiryEmail = val;
    await setValue(INQUIRY_EMAIL, val);
  }

  @action
  Future<void> setHelplineNumber(String val) async {
    helplineNumber = val;
    await setValue(HELPLINE_NUMBER, val);
  }

  @action
  Future<void> setCurrencyPosition(String val) async {
    currencyPosition = val;
    await setValue(CURRENCY_POSITION, val);
  }

  @action
  Future<void> setCurrencySymbol(String val) async {
    currencySymbol = val;
    await setValue(CURRENCY_COUNTRY_SYMBOL, val);
  }

  @action
  Future<void> setCurrencyCode(String val) async {
    currencyCode = val;
    await setValue(CURRENCY_COUNTRY_CODE, val);
  }

  @action
  Future<void> setChatGptStatus(bool val) async {
    chatGPTStatus = val;
    await setValue(CHAT_GPT_STATUS, val);
  }

  @action
  Future<void> setTestWithoutKey(bool val) async {
    testWithoutKey = val;
    await setValue(TEST_CHAT_GPT_WITHOUT_KEY, val);
  }

  @action
  Future<void> setJobRequestStatus(bool val) async {
    jobRequestStatus = val;
    await setValue(JOB_REQUEST_SERVICE_STATUS, val);
  }

  @action
  Future<void> setBlogStatus(bool val) async {
    blogStatus = val;
    await setValue(BLOG_STATUS, val);
  }

  @action
  Future<void> setSocialLoginStatus(bool val) async {
    socialLoginStatus = val;
    await setValue(SOCIAL_LOGIN_STATUS, val);
  }

  @action
  Future<void> setGoogleLoginStatus(bool val) async {
    googleLoginStatus = val;
    await setValue(GOOGLE_LOGIN_STATUS, val);
  }

  @action
  Future<void> setAppleLoginStatus(bool val) async {
    appleLoginStatus = val;
    await setValue(APPLE_LOGIN_STATUS, val);
  }

  @action
  Future<void> setOTPLoginStatus(bool val) async {
    otpLoginStatus = val;
    await setValue(OTP_LOGIN_STATUS, val);
  }

  @action
  Future<void> setMaintenanceModeStatus(bool val) async {
    maintenanceModeStatus = val;
    await setValue(IN_MAINTENANCE_MODE, val);
  }

  @action
  void setGoogleMapKey(String val) {
    googleMapKey = val;
  }

  @action
  void setFirebaseKey(String val) {
    firebaseServerKey = val;
  }

  @action
  Future<void> setUserDashboardType(String val) async {
    userDashboardType = val;
    await setValue(USER_DASHBOARD, val);
  }

  @action
  Future<void> setISUserAuthorized(bool val) async {
    isUserAuthorized = val;
    await setValue(IS_USER_AUTHORIZED, val);
  }

  @action
  Future<void> setCancellationChargeAmount(num val) async {
    cancellationChargeAmount = val;
    await setValue(CANCELLATION_CHARGE_AMOUNT, val);
  }

  @action
  Future<void> setCancellationChargeHours(int val) async {
    cancellationChargeHours = val;
    await setValue(CANCELLATION_CHARGE_HOURS, val);
  }

  @action
    Future<void> setCancellationCharge(bool val) async {
     cancellationCharge = val;
    await setValue(CANCELLATION_CHARGE, val);
  }
}