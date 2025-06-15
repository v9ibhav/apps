import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'common.dart';
import 'configs.dart';
import 'constant.dart';

//region Get Configurations

bool get isCurrencyPositionLeft => appConfigurationStore.currencyPosition == CURRENCY_POSITION_LEFT;

bool get isCurrencyPositionRight => appConfigurationStore.currencyPosition == CURRENCY_POSITION_RIGHT;

//endregion

//region Set Configurations
Future<void> setAppConfigurations(AppConfigurationModel data) async {
  appStore.setEarningType(data.earningType.validate());

  appConfigurationStore.setInquiryEmail(data.inquiryEmail.validate(value: INQUIRY_SUPPORT_EMAIL));
  appConfigurationStore.setHelplineNumber(data.helplineNumber.validate(value: HELP_LINE_NUMBER));
  appConfigurationStore.setGoogleMapKey(data.googleMapKey.validate());

  await appConfigurationStore.setCurrencyCode(data.currencyCode.validate());
  await appConfigurationStore.setCurrencyPosition(data.currencyPosition.validate());
  await appConfigurationStore.setCurrencySymbol(data.currencySymbol.validate());
  await appConfigurationStore.setPriceDecimalPoint(data.decimalPoint.toInt());

  await appConfigurationStore.setJobRequestStatus(data.jobRequestServiceStatus.validate().getBoolInt());
  await appConfigurationStore.setChatGptStatus(data.chatGptStatus.validate().getBoolInt());
  await appConfigurationStore.setTestWithoutKey(data.testChatGptWithoutKey.validate().getBoolInt());

  await appConfigurationStore.setAdvancePaymentAllowed(data.advancePaymentStatus.validate().getBoolInt());
  await appConfigurationStore.setSlotServiceStatus(data.slotServiceStatus.validate().getBoolInt());
  await appConfigurationStore.setDigitalServiceStatus(data.digitalServiceStatus.validate().getBoolInt());
  await appConfigurationStore.setServicePackageStatus(data.servicePackageStatus.validate().getBoolInt());
  await appConfigurationStore.setServiceAddonStatus(data.serviceAddonStatus.validate().getBoolInt());
  await appConfigurationStore.setOnlinePaymentStatus(data.onlinePaymentStatus.getBoolInt());
  await appConfigurationStore.setMaintenanceModeStatus(data.maintenanceMode.validate().getBoolInt());
  await appConfigurationStore.setEnableUserWallet(data.walletStatus.validate().getBoolInt());
  await appConfigurationStore.setBlogStatus(data.blogStatus.validate().getBoolInt());
  await appConfigurationStore.setAutoAssignStatus(data.autoAssignStatus.validate().getBoolInt());
  await appConfigurationStore.setISUserAuthorized(data.isUserAuthorized ?? false);

  await appConfigurationStore.setPrivacyPolicy(data.privacyPolicy ?? PRIVACY_POLICY_URL);
  await appConfigurationStore.setTermConditions(data.termsConditions ?? TERMS_CONDITION_URL);
  await appConfigurationStore.setHelpAndSupport(data.helpAndSupport ?? HELP_AND_SUPPORT_URL);
  await appConfigurationStore.setRefundPolicy(data.refundPolicy ?? REFUND_POLICY_URL);

  await appConfigurationStore.setBannerPerDayAmount(data.providerBannerAmount);

  await appConfigurationStore.setPromotionalBannerStatus(data.promotional_banner);

  await appConfigurationStore.setPromotionalBannerStatus(data.promotional_banner);

  await appConfigurationStore.setEnableChat(data.enable_chat.validate().getBoolInt());
  ///In APP PURCHASE
  await appConfigurationStore.setInAppPurchaseEnable(data.isInAppPurchaseEnable.getBoolInt());

  if (appConfigurationStore.isInAppPurchaseEnable) {
    appConfigurationStore.setInAppPurchaseEntitlementIdentifier(data.revenueCatEntitlementIdentifier);
    appConfigurationStore.setInAppPurchaseGoogleAPIKey(data.revenueCatGoogleAPIKey);
    appConfigurationStore.setInAppPurchaseAppleAPIKey(data.revenueCatAppleAPIKey);
    await inAppPurchaseService.init().then((value){
    if (appStore.isLoggedIn) {
      inAppPurchaseService.checkSubscriptionSync();
    }
    });
  }
  await setValue(SITE_DESCRIPTION, data.siteDescription);
  await setValue(SITE_COPYRIGHT, data.siteCopyright);
  await setValue(TIMEZONE, data.timeZone);
  await setValue(DISTANCE_TYPE, data.distanceType);

  await setValue(DATE_FORMAT, getDateFormat(data.dateFormat.validate()));
  await setValue(TIME_FORMAT, getDisplayTimeFormat(data.timeFormat.validate()));

  await setValue(CUSTOMER_APP_STORE_URL, data.appstoreUrl.validate());
  await setValue(CUSTOMER_PLAY_STORE_URL, data.playStoreUrl.validate());
  await setValue(PROVIDER_PLAY_STORE_URL, data.providerPlayStoreUrl.validate());
  await setValue(PROVIDER_APPSTORE_URL, data.providerAppstoreUrl.validate());

  await setValue(FACEBOOK_URL, data.facebookUrl.validate());
  await setValue(INSTAGRAM_URL, data.instagramUrl.validate());
  await setValue(TWITTER_URL, data.twitterUrl.validate());
  await setValue(LINKEDIN_URL, data.linkedinUrl.validate());
  await setValue(YOUTUBE_URL, data.youtubeUrl.validate());

  await setValue(FORCE_UPDATE_PROVIDER_APP, data.forceUpdateProviderApp.getBoolInt());
  await setValue(PROVIDER_APP_MINIMUM_VERSION, data.providerAppMinimumVersion);
  await setValue(PROVIDER_APP_LATEST_VERSION, data.providerAppLatestVersion);

  // Roles And Permission
  if (data.roleAndPermission != null) {
  await rolesAndPermissionStore.setRole(data.roleAndPermission!.role.getBoolInt());
  await rolesAndPermissionStore.setRoleList(data.roleAndPermission!.roleList.getBoolInt());
  await rolesAndPermissionStore.setRoleAdd(data.roleAndPermission!.roleAdd.getBoolInt());

  await rolesAndPermissionStore.setPermission(data.roleAndPermission!.permission.getBoolInt());
  await rolesAndPermissionStore.setPermissionList(data.roleAndPermission!.permissionList.getBoolInt());
  await rolesAndPermissionStore.setPermissionAdd(data.roleAndPermission!.permissionAdd.getBoolInt());

  await rolesAndPermissionStore.setCategory(data.roleAndPermission!.category.getBoolInt());
  await rolesAndPermissionStore.setCategoryAdd(data.roleAndPermission!.categoryAdd.getBoolInt());
  await rolesAndPermissionStore.setCategoryEdit(data.roleAndPermission!.categoryEdit.getBoolInt());
  await rolesAndPermissionStore.setCategoryList(data.roleAndPermission!.categoryList.getBoolInt());
  await rolesAndPermissionStore.setCategoryDelete(data.roleAndPermission!.categoryDelete.getBoolInt());

  await rolesAndPermissionStore.setService(data.roleAndPermission!.service.getBoolInt());
  await rolesAndPermissionStore.setServiceAdd(data.roleAndPermission!.serviceAdd.getBoolInt());
  await rolesAndPermissionStore.setServiceList(data.roleAndPermission!.serviceList.getBoolInt());
  await rolesAndPermissionStore.setServiceEdit(data.roleAndPermission!.serviceEdit.getBoolInt());
  await rolesAndPermissionStore.setServiceDelete(data.roleAndPermission!.serviceDelete.getBoolInt());

  await rolesAndPermissionStore.setProvider(data.roleAndPermission!.provider.getBoolInt());
  await rolesAndPermissionStore.setPermissionAdd(data.roleAndPermission!.permissionAdd.getBoolInt());
  await rolesAndPermissionStore.setProviderList(data.roleAndPermission!.providerList.getBoolInt());
  await rolesAndPermissionStore.setProviderEdit(data.roleAndPermission!.providerEdit.getBoolInt());
  await rolesAndPermissionStore.setProviderDelete(data.roleAndPermission!.providerDelete.getBoolInt());

  await rolesAndPermissionStore.setHandyman(data.roleAndPermission!.handyman.getBoolInt());
  await rolesAndPermissionStore.setHandymanAdd(data.roleAndPermission!.handymanAdd.getBoolInt());
  await rolesAndPermissionStore.setHandymanList(data.roleAndPermission!.handymanList.getBoolInt());
  await rolesAndPermissionStore.setHandymanEdit(data.roleAndPermission!.handymanEdit.getBoolInt());
  await rolesAndPermissionStore.setHandymanDelete(data.roleAndPermission!.handymanDelete.getBoolInt());

  await rolesAndPermissionStore.setBooking(data.roleAndPermission!.booking.getBoolInt());
  await rolesAndPermissionStore.setBookingEdit(data.roleAndPermission!.bookingEdit.getBoolInt());
  await rolesAndPermissionStore.setBookingList(data.roleAndPermission!.bookingList.getBoolInt());
  await rolesAndPermissionStore.setBookingView(data.roleAndPermission!.bookingView.getBoolInt());
  await rolesAndPermissionStore.setBookingDelete(data.roleAndPermission!.bookingDelete.getBoolInt());

  await rolesAndPermissionStore.setPayment(data.roleAndPermission!.payment.getBoolInt());
  await rolesAndPermissionStore.setPaymentList(data.roleAndPermission!.paymentList.getBoolInt());

  await rolesAndPermissionStore.setUser(data.roleAndPermission!.user.getBoolInt());
  await rolesAndPermissionStore.setUserList(data.roleAndPermission!.userList.getBoolInt());
  await rolesAndPermissionStore.setUserView(data.roleAndPermission!.userView.getBoolInt());
  await rolesAndPermissionStore.setUserDelete(data.roleAndPermission!.userDelete.getBoolInt());
  await rolesAndPermissionStore.setUserAdd(data.roleAndPermission!.userAdd.getBoolInt());
  await rolesAndPermissionStore.setUserEdit(data.roleAndPermission!.userEdit.getBoolInt());

  await rolesAndPermissionStore.setProviderType(data.roleAndPermission!.providerType.getBoolInt());
  await rolesAndPermissionStore.setProviderTypeList(data.roleAndPermission!.providerTypeList.getBoolInt());
  await rolesAndPermissionStore.setProviderTypeAdd(data.roleAndPermission!.providerTypeAdd.getBoolInt());
  await rolesAndPermissionStore.setProviderTypeEdit(data.roleAndPermission!.providerTypeEdit.getBoolInt());
  await rolesAndPermissionStore.setProviderTypeDelete(data.roleAndPermission!.providerTypeDelete.getBoolInt());

  await rolesAndPermissionStore.setCoupon(data.roleAndPermission!.coupon.getBoolInt());
  await rolesAndPermissionStore.setCouponAdd(data.roleAndPermission!.couponAdd.getBoolInt());
  await rolesAndPermissionStore.setCouponEdit(data.roleAndPermission!.couponEdit.getBoolInt());
  await rolesAndPermissionStore.setCouponDelete(data.roleAndPermission!.couponDelete.getBoolInt());
  await rolesAndPermissionStore.setCouponList(data.roleAndPermission!.couponList.getBoolInt());

  await rolesAndPermissionStore.setSlider(data.roleAndPermission!.slider.getBoolInt());
  await rolesAndPermissionStore.setSliderAdd(data.roleAndPermission!.sliderAdd.getBoolInt());
  await rolesAndPermissionStore.setSliderEdit(data.roleAndPermission!.sliderEdit.getBoolInt());
  await rolesAndPermissionStore.setSliderList(data.roleAndPermission!.sliderList.getBoolInt());
  await rolesAndPermissionStore.setSliderDelete(data.roleAndPermission!.sliderDelete.getBoolInt());

  await rolesAndPermissionStore.setPendingHandyman(data.roleAndPermission!.pendingHandyman.getBoolInt());
  await rolesAndPermissionStore.setPendingProvider(data.roleAndPermission!.pendingProvider.getBoolInt());

  await rolesAndPermissionStore.setPages(data.roleAndPermission!.pages.getBoolInt());
  await rolesAndPermissionStore.setHelpAndSupport(data.roleAndPermission!.helpAndSupport.getBoolInt());
  await rolesAndPermissionStore.setTermCondition(data.roleAndPermission!.termsAndcondition.getBoolInt());
  await rolesAndPermissionStore.setPrivacyPolicy(data.roleAndPermission!.privacyPolicy.getBoolInt());

  await rolesAndPermissionStore.setProviderAddress(data.roleAndPermission!.providerAddress.getBoolInt());
  await rolesAndPermissionStore.setProviderAddressList(data.roleAndPermission!.providerAddressList.getBoolInt());
  await rolesAndPermissionStore.setProviderAddressEdit(data.roleAndPermission!.providerAddressEdit.getBoolInt());
  await rolesAndPermissionStore.setProviderAddressAdd(data.roleAndPermission!.providerAddressAdd.getBoolInt());
  await rolesAndPermissionStore.setProviderAddressDelete(data.roleAndPermission!.providerAddressDelete.getBoolInt());

  await rolesAndPermissionStore.setDocument(data.roleAndPermission!.document.getBoolInt());
  await rolesAndPermissionStore.setDocumentAdd(data.roleAndPermission!.documentAdd.getBoolInt());
  await rolesAndPermissionStore.setDocumentEdit(data.roleAndPermission!.documentEdit.getBoolInt());
  await rolesAndPermissionStore.setDocumentList(data.roleAndPermission!.documentList.getBoolInt());
  await rolesAndPermissionStore.setDocumentDelete(data.roleAndPermission!.documentDelete.getBoolInt());

  await rolesAndPermissionStore.setProviderDocument(data.roleAndPermission!.providerDocument.getBoolInt());
  await rolesAndPermissionStore.setProviderDocumentAdd(data.roleAndPermission!.providerDocumentAdd.getBoolInt());
  await rolesAndPermissionStore.setProviderDocumentList(data.roleAndPermission!.providerDocumentList.getBoolInt());
  await rolesAndPermissionStore.setProviderDocumentEdit(data.roleAndPermission!.providerDocumentEdit.getBoolInt());
  await rolesAndPermissionStore.setProviderDocumentDelete(data.roleAndPermission!.providerDocumentDelete.getBoolInt());

  await rolesAndPermissionStore.setHandymanPayout(data.roleAndPermission!.handymanPayout.getBoolInt());
  await rolesAndPermissionStore.setProviderPayout(data.roleAndPermission!.providerPayout.getBoolInt());

  await rolesAndPermissionStore.setServiceFAQ(data.roleAndPermission!.serviceFAQ.getBoolInt());
  await rolesAndPermissionStore.setServiceFAQList(data.roleAndPermission!.serviceFAQList.getBoolInt());
  await rolesAndPermissionStore.setServiceFAQAdd(data.roleAndPermission!.serviceFAQAdd.getBoolInt());
  await rolesAndPermissionStore.setServiceFAQEdit(data.roleAndPermission!.serviceFAQEdit.getBoolInt());
  await rolesAndPermissionStore.setServiceFAQDelete(data.roleAndPermission!.serviceFAQDelete.getBoolInt());

  await rolesAndPermissionStore.setSubcategory(data.roleAndPermission!.subCategory.getBoolInt());
  await rolesAndPermissionStore.setSubcategoryList(data.roleAndPermission!.subCategoryList.getBoolInt());
  await rolesAndPermissionStore.setSubcategoryAdd(data.roleAndPermission!.subCategoryAdd.getBoolInt());
  await rolesAndPermissionStore.setSubcategoryEdit(data.roleAndPermission!.subCategoryEdit.getBoolInt());
  await rolesAndPermissionStore.setSubcategoryDelete(data.roleAndPermission!.subCategoryDelete.getBoolInt());

  await rolesAndPermissionStore.setHandymanType(data.roleAndPermission!.handymanType.getBoolInt());
  await rolesAndPermissionStore.setHandymanTypeAdd(data.roleAndPermission!.handymanTypeAdd.getBoolInt());
  await rolesAndPermissionStore.setHandymanTypeList(data.roleAndPermission!.handymanTypeList.getBoolInt());
  await rolesAndPermissionStore.setHandymanTypeEdit(data.roleAndPermission!.handymanTypeEdit.getBoolInt());
  await rolesAndPermissionStore.setHandymanTypeDelete(data.roleAndPermission!.handymanTypeDelete.getBoolInt());

  await rolesAndPermissionStore.setPostJob(data.roleAndPermission!.postJob.getBoolInt());
  await rolesAndPermissionStore.setPostJobList(data.roleAndPermission!.postJobList.getBoolInt());

  await rolesAndPermissionStore.setServicePackage(data.roleAndPermission!.servicePackage.getBoolInt());
  await rolesAndPermissionStore.setServicePackageList(data.roleAndPermission!.servicePackageList.getBoolInt());
  await rolesAndPermissionStore.setServicePackageAdd(data.roleAndPermission!.servicePackageAdd.getBoolInt());
  await rolesAndPermissionStore.setServicePackageEdit(data.roleAndPermission!.servicePackageEdit.getBoolInt());
  await rolesAndPermissionStore.setServicePackageDelete(data.roleAndPermission!.servicePackageDelete.getBoolInt());

  await rolesAndPermissionStore.setRefundAndCancellationPolicy(data.roleAndPermission!.refundAndCancellationPolicy.getBoolInt());

  await rolesAndPermissionStore.setBlog(data.roleAndPermission!.blog.getBoolInt());
  await rolesAndPermissionStore.setBlogList(data.roleAndPermission!.blogList.getBoolInt());
  await rolesAndPermissionStore.setBlogAdd(data.roleAndPermission!.blogAdd.getBoolInt());
  await rolesAndPermissionStore.setBlogEdit(data.roleAndPermission!.blogEdit.getBoolInt());
  await rolesAndPermissionStore.setBlogDelete(data.roleAndPermission!.blogDelete.getBoolInt());

  await rolesAndPermissionStore.setServiceAddOn(data.roleAndPermission!.serviceAddOn.getBoolInt());
  await rolesAndPermissionStore.setServiceAddOnList(data.roleAndPermission!.serviceAddOnList.getBoolInt());
  await rolesAndPermissionStore.setServiceAddOnAdd(data.roleAndPermission!.serviceAddOnAdd.getBoolInt());
  await rolesAndPermissionStore.setServiceAddOnEdit(data.roleAndPermission!.serviceAddOnEdit.getBoolInt());
  await rolesAndPermissionStore.setServiceAddOnDelete(data.roleAndPermission!.serviceAddOnDelete.getBoolInt());

  await rolesAndPermissionStore.setFrontendSetting(data.roleAndPermission!.frontendSetting.getBoolInt());
  await rolesAndPermissionStore.setFrontendSettingList(data.roleAndPermission!.frontendSettingList.getBoolInt());

  await rolesAndPermissionStore.setBank(data.roleAndPermission!.bank.getBoolInt());
  await rolesAndPermissionStore.setBankList(data.roleAndPermission!.bankList.getBoolInt());
  await rolesAndPermissionStore.setBankAdd(data.roleAndPermission!.bankAdd.getBoolInt());
  await rolesAndPermissionStore.setBankEdit(data.roleAndPermission!.bankEdit.getBoolInt());
  await rolesAndPermissionStore.setBankDelete(data.roleAndPermission!.bankDelete.getBoolInt());

  await rolesAndPermissionStore.setTax(data.roleAndPermission!.tax.getBoolInt());
  await rolesAndPermissionStore.setTaxAdd(data.roleAndPermission!.taxAdd.getBoolInt());
  await rolesAndPermissionStore.setTaxList(data.roleAndPermission!.taxList.getBoolInt());
  await rolesAndPermissionStore.setTaxEdit(data.roleAndPermission!.taxEdit.getBoolInt());
  await rolesAndPermissionStore.setTaxDelete(data.roleAndPermission!.taxDelete.getBoolInt());

  await rolesAndPermissionStore.setWallet(data.roleAndPermission!.wallet.getBoolInt());
  await rolesAndPermissionStore.setWalletList(data.roleAndPermission!.walletList.getBoolInt());
  await rolesAndPermissionStore.setWalletAdd(data.roleAndPermission!.walletAdd.getBoolInt());
  await rolesAndPermissionStore.setWalletEdit(data.roleAndPermission!.walletEdit.getBoolInt());
  await rolesAndPermissionStore.setWalletDelete(data.roleAndPermission!.walletDelete.getBoolInt());

  await rolesAndPermissionStore.setEarning(data.roleAndPermission!.earning.getBoolInt());
  await rolesAndPermissionStore.setEarningList(data.roleAndPermission!.earningList.getBoolInt());

  await rolesAndPermissionStore.setUserRating(data.roleAndPermission!.userRating.getBoolInt());
  await rolesAndPermissionStore.setUserRatingList(data.roleAndPermission!.userRatingList.getBoolInt());
  await rolesAndPermissionStore.setHandymanRating(data.roleAndPermission!.handymanRating.getBoolInt());
  await rolesAndPermissionStore.setHandymanRatingList(data.roleAndPermission!.handymanRatingList.getBoolInt());

  await rolesAndPermissionStore.setPlan(data.roleAndPermission!.plan.getBoolInt());
  await rolesAndPermissionStore.setPlanAdd(data.roleAndPermission!.planAdd.getBoolInt());
  await rolesAndPermissionStore.setPlanList(data.roleAndPermission!.planList.getBoolInt());
  await rolesAndPermissionStore.setPlanEdit(data.roleAndPermission!.planEdit.getBoolInt());
  await rolesAndPermissionStore.setPlanDelete(data.roleAndPermission!.planDelete.getBoolInt());

  await rolesAndPermissionStore.setUserServiceList(data.roleAndPermission!.userServiceList.getBoolInt());
  await rolesAndPermissionStore.setSystemSetting(data.roleAndPermission!.systemSetting.getBoolInt());
  await rolesAndPermissionStore.setProviderChangePassword(data.roleAndPermission!.providerChangePassword.getBoolInt());
  await rolesAndPermissionStore.setDataDeletionRequest(data.roleAndPermission!.dataDeletionRequest.getBoolInt());

  await rolesAndPermissionStore.setHelpDesk(data.roleAndPermission!.helpDesk.getBoolInt());
  await rolesAndPermissionStore.setHelpDeskAdd(data.roleAndPermission!.helpDeskAdd.getBoolInt());
  await rolesAndPermissionStore.setHelpDeskList(data.roleAndPermission!.helpDeskList.getBoolInt());
  await rolesAndPermissionStore.setHelpDeskEdit(data.roleAndPermission!.helpDeskEdit.getBoolInt());
  }

  /// Place ChatGPT Key Here
  if (data.chatGptKey.validate().isNotEmpty) {
    chatGPTAPIkey = data.chatGptKey!;

  }
  appConfigurationStore.setFirebaseKey(data.firebaseKey.validate());

  setValue(LAST_APP_CONFIGURATION_SYNCED_TIME, DateTime.timestamp().millisecondsSinceEpoch);
  await setValue(IS_APP_CONFIGURATION_SYNCED_AT_LEAST_ONCE, true);
}
//endregion

// region Shared Preference Keys
const AUTO_ASSIGN_STATUS = 'AUTO_ASSIGN_STATUS';
const DISTANCE_TYPE = 'DISTANCE_TYPE';
const TIMEZONE = 'TIMEZONE';
const PRIVACY_POLICY = 'PRIVACY_POLICY';
const TERM_CONDITIONS = 'TERM_CONDITIONS';
const HELP_AND_SUPPORT = 'HELP_AND_SUPPORT';
const REFUND_POLICY = 'REFUND_POLICY';
const INQUIRY_EMAIL = 'INQUIRY_EMAIL';
const HELPLINE_NUMBER = 'HELPLINE_NUMBER';
const IN_MAINTENANCE_MODE = 'IN_MAINTENANCE_MODE';
const CURRENCY_POSITION = 'CURRENCY_POSITION';
const PRICE_DECIMAL_POINTS = 'PRICE_DECIMAL_POINTS';
const ENABLE_USER_WALLET = 'ENABLE_USER_WALLET';
const CURRENCY_COUNTRY_SYMBOL = 'CURRENCY_COUNTRY_SYMBOL';
const CURRENCY_COUNTRY_CODE = 'CURRENCY_COUNTRY_CODE';

const SOCIAL_LOGIN_STATUS = 'SOCIAL_LOGIN';
const GOOGLE_LOGIN_STATUS = 'GOOGLE_LOGIN';
const APPLE_LOGIN_STATUS = 'APPLE_LOGIN';
const OTP_LOGIN_STATUS = 'OTP_LOGIN';
const ONLINE_PAYMENT_STATUS = 'ONLINE_PAYMENT_STATUS';
const BLOG_STATUS = 'BLOG';
const SLOT_SERVICE_STATUS = 'SLOT_SERVICE_STATUS';
const DIGITAL_SERVICE_STATUS = 'DIGITAL_SERVICE_STATUS';
const SERVICE_PACKAGE_STATUS = 'SERVICE_PACKAGE_STATUS';
const SERVICE_ADDON_STATUS = 'SERVICE_ADDON_STATUS';
const JOB_REQUEST_SERVICE_STATUS = 'JOB_REQUEST_SERVICE_STATUS';
const CHAT_GPT_STATUS = 'CHAT_GPT_STATUS';
const TEST_CHAT_GPT_WITHOUT_KEY = 'TEST_CHAT_GPT_WITHOUT_KEY';
const IS_ADVANCE_PAYMENT_ALLOWED = 'IS_ADVANCE_PAYMENT_ALLOWED';
const IS_USER_AUTHORIZED = 'IS_USER_AUTHORIZED';

const CUSTOMER_APP_STORE_URL = 'APPSTORE_URL';
const CUSTOMER_PLAY_STORE_URL = 'PLAY_STORE_URL';
const PROVIDER_PLAY_STORE_URL = 'PROVIDER_PLAY_STORE_URL';
const PROVIDER_APPSTORE_URL = 'PROVIDER_APPSTORE_URL';

const FORCE_UPDATE_PROVIDER_APP = 'FORCE_UPDATE_PROVIDER_APP';
const PROVIDER_APP_MINIMUM_VERSION = 'PROVIDER_APP_MINIMUM_VERSION';
const PROVIDER_APP_LATEST_VERSION = 'PROVIDER_APP_LATEST_VERSION';

const DATE_FORMAT = 'DATE_FORMAT';
const TIME_FORMAT = 'TIME_FORMAT';
const SITE_DESCRIPTION = 'SITE_DESCRIPTION';
const SITE_COPYRIGHT = 'SITE_COPYRIGHT';

const FACEBOOK_URL = 'FACEBOOK_URL';
const INSTAGRAM_URL = 'INSTAGRAM_URL';
const TWITTER_URL = 'TWITTER_URL';
const LINKEDIN_URL = 'LINKEDIN_URL';
const YOUTUBE_URL = 'YOUTUBE_URL';
const APPLE_KEY = 'APPLE_KEY';
const GOOGLE_KEY = 'GOOGLE_KEY';

//Roles And Permissions Keys

const ROLE = 'ROLE';
const ROLE_ADD = 'ROLE_ADD';
const ROLE_LIST = 'ROLE_LIST';

const PERMISSION = 'PERMISSION';
const PERMISSION_ADD = 'PERMISSION_ADD';
const PERMISSION_LIST = 'PERMISSION_LIST';

const CATEGORY = 'CATEGORY';
const CATEGORY_ADD = 'CATEGORY_ADD';
const CATEGORY_LIST = 'CATEGORY_LIST';
const CATEGORY_EDIT = 'CATEGORY_EDIT';
const CATEGORY_DELETE = 'CATEGORY_DELETE';

const SERVICE= 'SERVICE';
const SERVICE_ADD = 'SERVICE_ADD';
const SERVICE_LIST = 'SERVICE_LIST';
const SERVICE_EDIT = 'SERVICE_EDIT';
const SERVICE_DELETE = 'SERVICE_DELETE';

const PROVIDER= 'PROVIDER';
const PROVIDER_ADD = 'PROVIDER_ADD';
const PROVIDER_LIST= 'PROVIDER_LIST';
const PROVIDER_EDIT= 'PROVIDER_EDIT';
const PROVIDER_DELETE = 'PROVIDER_DELETE';
const PROVIDERTYPE = 'PROVIDERTYPE';
const PROVIDERTYPE_LIST = 'PROVIDERTYPE_LIST';
const PROVIDERTYPE_ADD = 'PROVIDERTYPE_ADD';
const PROVIDERTYPE_EDIT = 'PROVIDERTYPE_EDIT';
const PROVIDERTYPE_DELETE = 'PROVIDERTYPE_DELETE';
const PROVIDER_PAYOUT = 'PROVIDER_PAYOUT';
const PENDING_PROVIDER= 'PENDING_PROVIDER';

const HANDYMAN = 'HANDYMAN';
const HANDYMAN_LIST = 'HANDYMAN_LIST';
const HANDYMAN_ADD = 'HANDYMAN_ADD';
const HANDYMAN_EDIT= 'HANDYMAN_EDIT';
const HANDYMAN_DELETE = 'HANDYMAN_DELETE';
const HANDYMANTYPE = 'HANDYMANTYPE';
const HANDYMANTYPE_LIST = 'HANDYMANTYPE_LIST';
const HANDYMANTYPE_ADD = 'HANDYMANTYPE_ADD';
const HANDYMANTYPE_EDIT = 'HANDYMANTYPE_EDIT';
const HANDYMANTYPE_DELETE = 'HANDYMANTYPE_DELETE';
const HANDYMANRATING = 'HANDYMANRATING';
const HANDYMANRATING_LIST = 'HANDYMANRATING_LIST';
const HANDYMAN_PAYOUT = 'HANDYMAN_PAYOUT';
const PENDING_HANDYMAN = 'PENDING_HANDYMAN';

const BOOKING = 'BOOKING';
const BOOKING_LIST = 'BOOKING_LIST';
const BOOKING_EDIT = 'BOOKING_EDIT';
const BOOKING_DELETE = 'BOOKING_DELETE';
const BOOKING_VIEW = 'BOOKING_VIEW';

const PAYMENT = 'PAYMENT';
const PAYMENT_LIST = 'PAYMENT_LIST';

const USER = 'USER';
const USER_LIST = 'USER_LIST';
const USER_VIEW = 'USER_VIEW';
const USER_DELETE = 'USER_DELETE';
const USER_ADD = 'USER_ADD';
const USER_EDIT = 'USER_EDIT';

const COUPON = 'COUPON';
const COUPON_LIST = 'COUPON_LIST';
const COUPON_ADD = 'COUPON_ADD';
const COUPON_EDIT = 'COUPON_EDIT';
const COUPON_DELETE = 'COUPON_DELETE';

const SLIDER = 'SLIDER';
const SLIDER_LIST= 'SLIDER_LIST';
const SLIDER_ADD= 'SLIDER_ADD';
const SLIDER_EDIT= 'SLIDER_EDIT';
const SLIDER_DELETE = 'SLIDER_DELETE';

const PROVIDER_ADDRESS = 'PROVIDER_ADDRESS';
const PROVIDERADDRESS_LIST = 'PROVIDERADDRESS_LIST';
const PROVIDERADDRESS_ADD = 'PROVIDERADDRESS_ADD';
const PROVIDERADDRESS_EDIT = 'PROVIDERADDRESS_EDIT';
const PROVIDERADDRESS_DELETE = 'PROVIDERADDRESS_DELETE';

const DOCUMENT = 'DOCUMENT';
const DOCUMENT_LIST = 'DOCUMENT_LIST';
const DOCUMENT_ADD= 'DOCUMENT_ADD';
const DOCUMENT_EDIT = 'DOCUMENT_EDIT';
const DOCUMENT_DELETE = 'DOCUMENT_DELETE';

const PROVIDER_DOCUMENT = 'PROVIDER_DOCUMENT';
const PROVIDERDOCUMENT_LIST = 'PROVIDERDOCUMENT_LIST';
const PROVIDERDOCUMENT_ADD = 'PROVIDERDOCUMENT_ADD';
const PROVIDERDOCUMENT_EDIT = 'PROVIDERDOCUMENT_EDIT';
const PROVIDERDOCUMENT_DELETE = 'PROVIDERDOCUMENT_DELETE';

const SERVICEFAQ = 'SERVICEFAQ';
const SERVICEFAQ_ADD = 'SERVICEFAQ_ADD';
const SERVICEFAQ_EDIT = 'SERVICEFAQ_EDIT';
const SERVICEFAQ_DELETE = 'SERVICEFAQ_DELETE';
const SERVICEFAQ_LIST = 'SERVICEFAQ_LIST';

const SUBCATEGORY = 'SUBCATEGORY';
const SUBCATEGORY_ADD = 'SUBCATEGORY_ADD';
const SUBCATEGORY_EDIT = 'SUBCATEGORY_EDIT';
const SUBCATEGORY_DELETE = 'SUBCATEGORY_DELETE';
const SUBCATEGORY_LIST = 'SUBCATEGORY_LIST';

const POSTJOB = 'POSTJOB';
const POSTJOB_LIST = 'POSTJOB_LIST';

const SERVICEPACKAGE = 'SERVICEPACKAGE';
const SERVICEPACKAGE_ADD = 'SERVICEPACKAGE_ADD';
const SERVICEPACKAGE_EDIT = 'SERVICEPACKAGE_EDIT';
const SERVICEPACKAGE_DELETE = 'SERVICEPACKAGE_DELETE';
const SERVICEPACKAGE_LIST = 'SERVICEPACKAGE_LIST';

const BLOG = 'BLOG';
const BLOG_ADD = 'BLOG_ADD';
const BLOG_EDIT = 'BLOG_EDIT';
const BLOG_DELETE = 'BLOG_DELETE';
const BLOG_LIST = 'BLOG_LIST';

const SERVICE_ADD_ON = 'SERVICE_ADD_ON';
const SERVICE_ADD_ON_ADD = 'SERVICE_ADD_ON_ADD';
const SERVICE_ADD_ON_EDIT = 'SERVICE_ADD_ON_EDIT';
const SERVICE_ADD_ON_DELETE = 'SERVICE_ADD_ON_DELETE';
const SERVICE_ADD_ON_LIST = 'SERVICE_ADD_ON_LIST';

const FRONTEND_SETTING = 'FRONTEND_SETTING';
const FRONTENDSETTING_LIST = 'FRONTENDSETTING_LIST';

const BANK = 'BANK';
const BANK_ADD = 'BANK_ADD';
const BANK_EDIT = 'BANK_EDIT';
const BANK_DELETE = 'BANK_DELETE';
const BANK_LIST = 'BANK_LIST';

const TAX = 'TAX';
const TAX_ADD = 'TAX_ADD';
const TAX_EDIT = 'TAX_EDIT';
const TAX_DELETE = 'TAX_DELETE';
const TAX_LIST = 'TAX_LIST';

const EARNING = 'EARNING';
const EARNING_LIST = 'EARNING_LIST';

const WALLET = 'WALLET';
const WALLET_ADD = 'WALLET_ADD';
const WALLET_EDIT = 'WALLET_EDIT';
const WALLET_DELETE = 'WALLET_DELETE';
const WALLET_LIST = 'WALLET_LIST';

const USERRATING = 'USERRATING';
const USERRATING_LIST = 'USERRATING_LIST';

const PLAN = 'PLAN';
const PLAN_ADD = 'PLAN_ADD';
const PLAN_EDIT = 'PLAN_EDIT';
const PLAN_DELETE = 'PLAN_DELETE';
const PLAN_LIST = 'PLAN_LIST';

const PAGES= 'PAGES';
const PERMISSION_HELP_AND_SUPPORT= 'PERMISSION_HELP_AND_SUPPORT';
const PERMISSION_PRIVACY_POLICY= 'PERMISSION_PRIVACY_POLICY';
const PERMISSION_TERM_CONDITION= 'PERMISSION_TERM_CONDITION';
const REFUND_AND_CANCELLATION_POLICY = 'REFUND_AND_CANCELLATION_POLICY';
const USERSERVICE_LIST = 'USERSERVICE_LIST';
const SYSTEM_SETTING = 'SYSTEM_SETTING';
const PROVIDER_CHANGEPASSWORD = 'PROVIDER_CHANGEPASSWORD';
const DATA_DELETION_REQUEST = 'DATA_DELETION_REQUEST';

const HELP_DESK = 'HELPDESK';
const HELP_DESK_ADD = 'HELPDESK_ADD';
const HELP_DESK_EDIT = 'HELPDESK_EDIT';
const HELP_DESK_LIST = 'HELPDESK_LIST';

const PROMOTIONAL_BANNER = 'PROMOTIONAL_BANNER';
const PROMOTIONAL_BANNER_ADD = 'PROMOTIONAL_BANNER_ADD';
const PROMOTIONAL_BANNER_EDIT = 'PROMOTIONAL_BANNER_EDIT';
const PROMOTIONAL_BANNER_LIST = 'PROMOTIONAL_BANNER_LIST';
const ENABLE_CHAT = 'enable_chat';

//endregion

//region Models

class AppConfigurationModel {
  RolesAndPermissionModel? roleAndPermission;
  String? siteName;
  String? siteDescription;
  String? inquiryEmail;
  String? helplineNumber;
  String? website;
  String? zipcode;
  String? siteCopyright;
  String? dateFormat;
  String? timeFormat;
  String? timeZone;
  String? distanceType;
  String? radius;
  bool? isUserAuthorized;
  String? playStoreUrl;
  String? appstoreUrl;
  String? providerAppstoreUrl;
  String? providerPlayStoreUrl;
  String? currencyCode;
  String? currencyPosition;
  String? currencySymbol;
  String? decimalPoint;
  String? googleMapKey;
  int? advancePaymentStatus;
  int? slotServiceStatus;
  int? digitalServiceStatus;
  int? servicePackageStatus;
  int? serviceAddonStatus;
  int? jobRequestServiceStatus;
  int? socialLoginStatus;
  int? googleLoginStatus;
  int? appleLoginStatus;
  int? otpLoginStatus;
  int? onlinePaymentStatus;
  int? blogStatus;
  int? maintenanceMode;
  int? walletStatus;
  int? chatGptStatus;
  int? testChatGptWithoutKey;
  String? chatGptKey;
  int? forceUpdateProviderApp;
  int? providerAppMinimumVersion;
  int? providerAppLatestVersion;
  int? firebaseNotificationStatus;
  String? firebaseKey;
  String? facebookUrl;
  String? linkedinUrl;
  String? instagramUrl;
  String? youtubeUrl;
  String? twitterUrl;
  String? termsConditions;
  String? privacyPolicy;
  String? helpAndSupport;
  String? refundPolicy;
  String? earningType;
  int? autoAssignStatus;
  int isInAppPurchaseEnable;
  String revenueCatEntitlementIdentifier;
  String revenueCatGoogleAPIKey;
  String revenueCatAppleAPIKey;
  num providerBannerAmount;
  bool promotional_banner;
  int enable_chat;

  AppConfigurationModel.fromJsonMap(Map<String, dynamic> map)
      : siteName = map["site_name"],
        siteDescription = map["site_description"],
        inquiryEmail = map["inquiry_email"],
        helplineNumber = map["helpline_number"],
        website = map["website"],
        zipcode = map["zipcode"],
        siteCopyright = map["site_copyright"],
        dateFormat = map["date_format"],
        timeFormat = map["time_format"],
        timeZone = map["time_zone"],
        distanceType = map["distance_type"],
        radius = map["radius"],
        isUserAuthorized = map["is_user_authorized"],
        playStoreUrl = map["playstore_url"],
        appstoreUrl = map["appstore_url"],
        providerAppstoreUrl = map["provider_appstore_url"],
        providerPlayStoreUrl = map["provider_playstore_url"],
        currencyCode = map["currency_coden"],
        currencyPosition = map["currency_position"],
        currencySymbol = map["currency_symbol"],
        decimalPoint = map["decimal_point"],
        googleMapKey = map["google_map_key"],
        advancePaymentStatus = map["advance_payment_status"],
        slotServiceStatus = map["slot_service_status"],
        digitalServiceStatus = map["digital_service_status"],
        servicePackageStatus = map["service_package_status"],
        serviceAddonStatus = map["service_addon_status"],
        jobRequestServiceStatus = map["job_request_service_status"],
        socialLoginStatus = map["social_login_status"],
        googleLoginStatus = map["google_login_status"],
        appleLoginStatus = map["apple_login_status"],
        otpLoginStatus = map["otp_login_status"],
        onlinePaymentStatus = map["online_payment_status"],
        blogStatus = map["blog_status"],
        maintenanceMode = map["maintenance_mode"],
        walletStatus = map["wallet_status"],
        chatGptStatus = map["chat_gpt_status"],
        testChatGptWithoutKey = map["test_chat_gpt_without_key"],
        chatGptKey = map["chat_gpt_key"],
        forceUpdateProviderApp = map["force_update_provider_app"],
        providerAppMinimumVersion = map["provider_app_minimum_version"],
        providerAppLatestVersion = map["provider_app_latest_version"],
        firebaseNotificationStatus = map["firebase_notification_status"],
        firebaseKey = map["firebase_key"],
        facebookUrl = map["facebook_url"],
        linkedinUrl = map["linkedin_url"],
        instagramUrl = map["instagram_url"],
        youtubeUrl = map["youtube_url"],
        twitterUrl = map["twitter_url"],
        termsConditions = map["terms_conditions"],
        privacyPolicy = map["privacy_policy"],
        earningType = map["earning_type"],
        helpAndSupport = map["help_support"],
        refundPolicy = map["refund_policy"],
        autoAssignStatus = map["auto_assign_status"],
        promotional_banner = map["promotional_banner"],
        enable_chat = map["enable_chat"],
        isInAppPurchaseEnable = map["is_in_app_purchase_enable"] != null ?  map["is_in_app_purchase_enable"]: 0 ,
        revenueCatEntitlementIdentifier = map["entitlement_id"] is String ? map["entitlement_id"] : "",
        revenueCatGoogleAPIKey = map["google_public_api_key"] is String ? map["google_public_api_key"] : "",
        revenueCatAppleAPIKey = map["apple_public_api_key"] is String ? map["apple_public_api_key"] : "",
        providerBannerAmount = map["provider_banner_amount"] is num ? map["provider_banner_amount"] : 0,
        roleAndPermission = map["role_and_permission"] != null
            ? RolesAndPermissionModel.fromJsonMap(map["role_and_permission"])
            : null;


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['site_name'] = siteName;
    data['site_description'] = siteDescription;
    data['inquiry_email'] = inquiryEmail;
    data['helpline_number'] = helplineNumber;
    data['website'] = website;
    data['zipcode'] = zipcode;
    data['site_copyright'] = siteCopyright;
    data['date_format'] = dateFormat;
    data['time_format'] = timeFormat;
    data['time_zone'] = timeZone;
    data['distance_type'] = distanceType;
    data['radius'] = radius;
    data['is_user_authorized'] = isUserAuthorized;
    data['playstore_url'] = playStoreUrl;
    data['appstore_url'] = appstoreUrl;
    data['provider_appstore_url'] = providerAppstoreUrl;
    data['provider_playstore_url'] = providerPlayStoreUrl;
    data['currency_code'] = currencyCode;
    data['currency_position'] = currencyPosition;
    data['currency_symbol'] = currencySymbol;
    data['decimal_point'] = decimalPoint;
    data['google_map_key'] = googleMapKey;
    data['advance_payment_status'] = advancePaymentStatus;
    data['slot_service_status'] = slotServiceStatus;
    data['digital_service_status'] = digitalServiceStatus;
    data['service_package_status'] = servicePackageStatus;
    data['service_addon_status'] = serviceAddonStatus;
    data['job_request_service_status'] = jobRequestServiceStatus;
    data['social_login_status'] = socialLoginStatus;
    data['google_login_status'] = googleLoginStatus;
    data['apple_login_status'] = appleLoginStatus;
    data['otp_login_status'] = otpLoginStatus;
    data['online_payment_status'] = onlinePaymentStatus;
    data['blog_status'] = blogStatus;
    data['maintenance_mode'] = maintenanceMode;
    data['wallet_status'] = walletStatus;
    data['chat_gpt_status'] = chatGptStatus;
    data['test_chat_gpt_without_key'] = testChatGptWithoutKey;
    data['chat_gpt_key'] = chatGptKey;
    data['force_update_provider_app'] = forceUpdateProviderApp;
    data['provider_app_minimum_version'] = providerAppMinimumVersion;
    data['provider_app_latest_version'] = providerAppLatestVersion;
    data['firebase_notification_status'] = firebaseNotificationStatus;
    data['firebase_key'] = firebaseKey;
    data['facebook_url'] = facebookUrl;
    data['linkedin_url'] = linkedinUrl;
    data['instagram_url'] = instagramUrl;
    data['youtube_url'] = youtubeUrl;
    data['twitter_url'] = twitterUrl;
    data['terms_conditions'] = termsConditions;
    data['privacy_policy'] = privacyPolicy;
    data['earning_type'] = earningType;
    data['help_support'] = helpAndSupport;
    data['refund_policy'] = refundPolicy;
    data['auto_assign_status'] = autoAssignStatus;
    data["is_in_app_purchase_enable"] = isInAppPurchaseEnable;
    data["entitlement_id"] = revenueCatEntitlementIdentifier;
    data["google_public_api_key"] = revenueCatGoogleAPIKey;
    data["apple_public_api_key"] = revenueCatAppleAPIKey;
    data["provider_banner_amount"] = providerBannerAmount;
    data['promotional_banner'] = promotional_banner;
    data['enable_chat'] = enable_chat;
    if (roleAndPermission != null) {
      data['role_and_permission'] = roleAndPermission!.toJson();
    }
    return data;
  }
}

class PaymentSetting {
  int? id;
  String? title;
  String? type;
  int? status;
  int? isTest;
  LiveValue? testValue;
  LiveValue? liveValue;
  bool isSelected = false;

  PaymentSetting({this.id, this.isTest, this.liveValue, this.status, this.title, this.type, this.testValue});

  static String encode(List<PaymentSetting> paymentList) {
    return json.encode(paymentList.map<Map<String, dynamic>>((payment) => payment.toJson()).toList());
  }

  static List<PaymentSetting> decode(String musics) {
    return (json.decode(musics) as List<dynamic>).map<PaymentSetting>((item) => PaymentSetting.fromJson(item)).toList();
  }

  PaymentSetting.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        type = json["type"],
        status = json["status"],
        isTest = json["is_test"],
        testValue = json['value'] != null ? LiveValue.fromJson(json['value']) : LiveValue(),
        liveValue = json['live_value'] != null ? LiveValue.fromJson(json['live_value']) : LiveValue();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['status'] = status;
    data['is_test'] = isTest;
    if (this.liveValue != null) {
      data['live_value'] = this.liveValue?.toJson();
    }
    if (this.testValue != null) {
      data['value'] = this.testValue?.toJson();
    }
    return data;
  }
}

class LiveValue {
  /// For Stripe
  String? stripeUrl;
  String? stripeKey;
  String? stripePublickey;

  /// For Razor Pay
  String? razorUrl;
  String? razorKey;
  String? razorSecret;

  /// For Flutter Wave
  String? flutterwavePublic;
  String? flutterwaveSecret;
  String? flutterwaveEncryption;

  /// For Paypal
  String? payPalClientId;
  String? payPalSecretKey;

  /// For Sadad
  String? sadadId;
  String? sadadKey;
  String? sadadDomain;

  /// For CinetPay
  String? cinetId;
  String? cinetKey;
  String? cinetPublicKey;

  /// For AirtelMoney
  String? airtelClientId;
  String? airtelSecretKey;

  /// For Paystack
  String? paystackPublicKey;

  /// For PhonePe
  String? phonePeAppID;
  String? phonePeMerchantID;
  String? phonePeSaltKey;
  String? phonePeSaltIndex;

  /// For Midtrans
  String? midtransClientId;

  LiveValue({
    this.stripeUrl,
    this.stripeKey,
    this.stripePublickey,
    this.razorUrl,
    this.razorKey,
    this.razorSecret,
    this.flutterwavePublic,
    this.flutterwaveSecret,
    this.flutterwaveEncryption,
    this.payPalClientId,
    this.payPalSecretKey,
    this.sadadId,
    this.sadadKey,
    this.sadadDomain,
    this.cinetId,
    this.cinetKey,
    this.cinetPublicKey,
    this.airtelClientId,
    this.airtelSecretKey,
    this.phonePeAppID,
    this.phonePeMerchantID,
    this.phonePeSaltKey,
    this.phonePeSaltIndex,
    this.paystackPublicKey,
    this.midtransClientId,
  });

  factory LiveValue.fromJson(Map<String, dynamic> json) {
    return LiveValue(
      stripeUrl: json['stripe_url'],
      stripeKey: json['stripe_key'],
      stripePublickey: json['stripe_publickey'],
      razorUrl: json['razor_url'],
      razorKey: json['razor_key'],
      razorSecret: json['razor_secret'],
      flutterwavePublic: json['flutterwave_public'],
      flutterwaveSecret: json['flutterwave_secret'],
      flutterwaveEncryption: json['flutterwave_encryption'],
      payPalClientId: json['paypal_client_id'],
      payPalSecretKey: json['paypal_secret_key'],
      sadadId: json['sadad_id'],
      sadadKey: json['sadad_key'],
      sadadDomain: json['sadad_domain'],
      cinetId: json['cinet_id'],
      cinetKey: json['cinet_key'],
      cinetPublicKey: json['cinet_publickey'],
      airtelClientId: json['client_id'] is String ? json['client_id'] : "",
      airtelSecretKey: json['secret_key'] is String ? json['secret_key'] : "",
      phonePeAppID: json['app_id'] is String ? json['app_id'] : "",
      phonePeMerchantID: json['merchant_id'] is String ? json['merchant_id'] : "",
      phonePeSaltKey: json['salt_key'] is String ? json['salt_key'] : "",
      phonePeSaltIndex: json["salt_index"] is String ? json["salt_index"] : "1",
      paystackPublicKey: json['paystack_public'] is String ? json['paystack_public'] : "",
      midtransClientId: json['client_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stripe_url'] = this.stripeUrl;
    data['stripe_key'] = this.stripeKey;
    data['stripe_publickey'] = this.stripePublickey;
    data['razor_url'] = this.razorUrl;
    data['razor_key'] = this.razorKey;
    data['razor_secret'] = this.razorSecret;
    data['flutterwave_public'] = this.flutterwavePublic;
    data['flutterwave_secret'] = this.flutterwaveSecret;
    data['flutterwave_encryption'] = this.flutterwaveEncryption;
    data['paypal_client_id'] = this.payPalClientId;
    data['paypal_secret_key'] = this.payPalSecretKey;
    data['sadad_id'] = this.sadadId;
    data['sadad_key'] = this.sadadKey;
    data['sadad_domain'] = this.sadadDomain;
    data['cinet_id'] = this.cinetId;
    data['cinet_key'] = this.cinetKey;
    data['cinet_publickey'] = this.cinetPublicKey;
    data['client_id'] = this.airtelClientId;
    data['secret_key'] = this.airtelSecretKey;
    data['app_id'] = this.phonePeAppID;
    data['merchant_id'] = this.phonePeMerchantID;
    data['salt_key'] = this.phonePeSaltKey;
    data['salt_index'] = this.phonePeSaltIndex;
    data['paystack_public'] = this.paystackPublicKey;
    data['client_id'] = this.midtransClientId;

    return data;
  }
}

//Roles And permission Model
class RolesAndPermissionModel {
  int? role;
  int? roleAdd;
  int? roleList;

  // Permissions
  int? permission;
  int? permissionAdd;
  int? permissionList;

  // Categories
  int? category;
  int? categoryAdd;
  int? categoryList;
  int? categoryEdit;
  int? categoryDelete;

  // Sub-Categories
  int? subCategory;
  int? subCategoryAdd;
  int? subCategoryEdit;
  int? subCategoryDelete;
  int? subCategoryList;

  // Services
  int? service;
  int? serviceAdd;
  int? serviceList;
  int? serviceEdit;
  int? serviceDelete;
  int? serviceAddOn;
  int? serviceAddOnAdd;
  int? serviceAddOnEdit;
  int? serviceAddOnDelete;
  int? serviceAddOnList;
  int? servicePackage;
  int? servicePackageAdd;
  int? servicePackageEdit;
  int? servicePackageDelete;
  int? servicePackageList;
  int? serviceFAQ;
  int? serviceFAQAdd;
  int? serviceFAQEdit;
  int? serviceFAQDelete;
  int? serviceFAQList;

  // Providers
  int? provider;
  int? providerAdd;
  int? providerList;
  int? providerEdit;
  int? providerDelete;
  int? providerType;
  int? providerTypeList;
  int? providerTypeAdd;
  int? providerTypeEdit;
  int? providerTypeDelete;
  int? providerAddress;
  int? providerAddressList;
  int? providerAddressAdd;
  int? providerAddressEdit;
  int? providerAddressDelete;
  int? providerDocument;
  int? providerDocumentList;
  int? providerDocumentAdd;
  int? providerDocumentEdit;
  int? providerDocumentDelete;
  int? providerChangePassword;
  int? pendingProvider;
  int? providerPayout;

  // Handymen
  int? handyman;
  int? handymanList;
  int? handymanAdd;
  int? handymanEdit;
  int? handymanDelete;
  int? handymanType;
  int? handymanTypeList;
  int? handymanTypeAdd;
  int? handymanTypeEdit;
  int? handymanTypeDelete;
  int? handymanPayout;
  int? pendingHandyman;
  int? handymanRating;
  int? handymanRatingList;

  // Bookings
  int? booking;
  int? bookingList;
  int? bookingEdit;
  int? bookingDelete;
  int? bookingView;
  int? postJob;
  int? postJobList;

  // Payments
  int? payment;
  int? paymentList;

  // Users
  int? user;
  int? userList;
  int? userView;
  int? userDelete;
  int? userAdd;
  int? userEdit;
  int? userRating;
  int? userRatingList;
  int? userServiceList;

  // Coupons
  int? coupon;
  int? couponList;
  int? couponAdd;
  int? couponEdit;
  int? couponDelete;

  // Sliders
  int? slider;
  int? sliderList;
  int? sliderAdd;
  int? sliderEdit;
  int? sliderDelete;

  // Documents
  int? document;
  int? documentList;
  int? documentAdd;
  int? documentEdit;
  int? documentDelete;

  // Blogs
  int? blog;
  int? blogAdd;
  int? blogEdit;
  int? blogDelete;
  int? blogList;

  // Plans
  int? plan;
  int? planAdd;
  int? planEdit;
  int? planDelete;
  int? planList;

  // Wallet and Bank
  int? wallet;
  int? walletAdd;
  int? walletEdit;
  int? walletDelete;
  int? walletList;
  int? bank;
  int? bankAdd;
  int? bankEdit;
  int? bankDelete;
  int? bankList;

  // Taxes
  int? tax;
  int? taxAdd;
  int? taxEdit;
  int? taxDelete;
  int? taxList;

  // Earnings
  int? earning;
  int? earningList;

  // Frontend Settings
  int? frontendSetting;
  int? frontendSettingList;

  // Policies
  int? refundAndCancellationPolicy;

  // Others
  int? pages;
  int? privacyPolicy;
  int? termsAndcondition;
  int? helpAndSupport;
  int? helpDesk;
  int? helpDeskAdd;
  int? helpDeskEdit;
  int? helpDeskList;
  int? dataDeletionRequest;
  int? systemSetting;

  bool? promotional_banner;


  RolesAndPermissionModel.fromJsonMap(Map<String, dynamic> map)
      : role = map["role"] == null ? null : map["role"],
        roleAdd = map["role_add"] == null ? null : map["role_add"],
        roleList = map["role_list"] == null ? null : map["role_list"],
        permission = map["permission"] == null ? null : map["permission"],
        permissionAdd = map["permission_add"] == null ? null : map["permission_add"],
        permissionList = map["permission_list"] == null ? null : map["permission_list"],
        category = map["category"] == null ? null : map["category"],
        categoryAdd = map["category_add"] == null ? null : map["category_add"],
        categoryList = map["category_list"] == null ? null : map["category_list"],
        categoryEdit = map["category_edit"] == null ? null : map["category_edit"],
        categoryDelete = map["category_delete"] == null ? null : map["category_delete"],
        service = map["service"] == null ? null : map["service"],
        serviceAdd = map["service_add"] == null ? null : map["service_add"],
        serviceList = map["service_list"] == null ? null : map["service_list"],
        serviceEdit = map["service_edit"] == null ? null : map["service_edit"],
        serviceDelete = map["service_delete"] == null ? null : map["service_delete"],
        provider = map["provider"] == null ? null : map["provider"],
        providerAdd = map["provider_add"] == null ? null : map["provider_add"],
        providerList = map["provider_list"] == null ? null : map["provider_list"],
        providerEdit = map["provider_edit"] == null ? null : map["provider_edit"],
        providerDelete = map["provider_delete"] == null ? null : map["provider_delete"],
        handyman = map["handyman"] == null ? null : map["handyman"],
        handymanList = map["handyman_list"] == null ? null : map["handyman_list"],
        handymanAdd = map["handyman_add"] == null ? null : map["handyman_add"],
        handymanEdit = map["handyman_edit"] == null ? null : map["handyman_edit"],
        handymanDelete = map["handyman_delete"] == null ? null : map["handyman_delete"],
        booking = map["booking"] == null ? null : map["booking"],
        bookingList = map["booking_list"] == null ? null : map["booking_list"],
        bookingEdit = map["booking_edit"] == null ? null : map["booking_edit"],
        bookingDelete = map["booking_delete"] == null ? null : map["booking_delete"],
        bookingView = map["booking_view"] == null ? null : map["booking_view"],
        payment = map["payment"] == null ? null : map["payment"],
        paymentList = map["payment_list"] == null ? null : map["payment_list"],
        user = map["user"] == null ? null : map["user"],
        userList = map["user_list"] == null ? null : map["user_list"],
        userView = map["user_view"] == null ? null : map["user_view"],
        userDelete = map["user_delete"] == null ? null : map["user_delete"],
        userAdd = map["user_add"] == null ? null : map["user_add"],
        userEdit = map["user_edit"] == null ? null : map["user_edit"],
        providerType = map["providertype"] == null ? null : map["providertype"],
        providerTypeList = map["providertype_list"] == null ? null : map["providertype_list"],
        providerTypeAdd = map["providertype_add"] == null ? null : map["providertype_add"],
        providerTypeEdit = map["providertype_edit"] == null ? null : map["providertype_edit"],
        providerTypeDelete = map["providertype_delete"] == null ? null : map["providertype_delete"],
        coupon = map["coupon"] == null ? null : map["coupon"],
        couponList = map["coupon_list"] == null ? null : map["coupon_list"],
        couponAdd = map["coupon_add"] == null ? null : map["coupon_add"],
        couponEdit = map["coupon_edit"] == null ? null : map["coupon_edit"],
        couponDelete = map["coupon_delete"] == null ? null : map["coupon_delete"],
        slider = map["slider"] == null ? null : map["slider"],
        sliderList = map["slider_list"] == null ? null : map["slider_list"],
        sliderAdd = map["slider_add"] == null ? null : map["slider_add"],
        sliderEdit = map["slider_edit"] == null ? null : map["slider_edit"],
        sliderDelete = map["slider_delete"] == null ? null : map["slider_delete"],
        pendingProvider = map["pending_provider"] == null ? null : map["pending_provider"],
        pendingHandyman = map["pending_handyman"] == null ? null : map["pending_handyman"],
        pages = map["pages"] == null ? null : map["pages"],
        helpAndSupport = map["Help_and_support"] ?? 0,
        privacyPolicy = map["privacy_policy"] ?? 0,
        termsAndcondition = map["terms_condition"] ?? 0,
        providerAddress = map["provider_address"] == null ? null : map["provider_address"],
        providerAddressList = map["provideraddress_list"] == null ? null : map["provideraddress_list"],
        providerAddressAdd = map["provideraddress_add"] == null ? null : map["provideraddress_add"],
        providerAddressEdit = map["provideraddress_edit"] == null ? null : map["provideraddress_edit"],
        providerAddressDelete = map["provideraddress_delete"] == null ? null : map["provideraddress_delete"],
        document = map["document"] == null ? null : map["document"],
        documentList = map["document_list"] == null ? null : map["document_list"],
        documentAdd = map["document_add"] == null ? null : map["document_add"],
        documentEdit = map["document_edit"] == null ? null : map["document_edit"],
        documentDelete = map["document_delete"] == null ? null : map["document_delete"],
        providerDocument = map["provider_document"] == null ? null : map["provider_document"],
        providerDocumentList = map["providerdocument_list"] == null ? null : map["providerdocument_list"],
        providerDocumentAdd = map["providerdocument_add"] == null ? null : map["providerdocument_add"],
        providerDocumentEdit = map["providerdocument_edit"] == null ? null : map["providerdocument_edit"],
        providerDocumentDelete = map["providerdocument_delete"] == null ? null : map["providerdocument_delete"],
        handymanPayout = map["handyman_payout"] == null ? null : map["handyman_payout"],
        serviceFAQ = map["servicefaq"] == null ? null : map["servicefaq"],
        serviceFAQAdd = map["servicefaq_add"] == null ? null : map["servicefaq_add"],
        serviceFAQEdit = map["servicefaq_edit"] == null ? null : map["servicefaq_edit"],
        serviceFAQDelete = map["servicefaq_delete"] == null ? null : map["servicefaq_delete"],
        serviceFAQList = map["servicefaq_list"] == null ? null : map["servicefaq_list"],
        subCategory = map["subcategory"] == null ? null : map["subcategory"],
        subCategoryAdd = map["subcategory_add"] == null ? null : map["subcategory_add"],
        subCategoryEdit = map["subcategory_edit"] == null ? null : map["subcategory_edit"],
        subCategoryDelete = map["subcategory_delete"] == null ? null : map["subcategory_delete"],
        subCategoryList = map["subcategory_list"] == null ? null : map["subcategory_list"],
        handymanType = map["handymantype"] == null ? null : map["handymantype"],
        handymanTypeList = map["handymantype_list"] == null ? null : map["handymantype_list"],
        handymanTypeAdd = map["handymantype_add"] == null ? null : map["handymantype_add"],
        handymanTypeEdit = map["handymantype_edit"] == null ? null : map["handymantype_edit"],
        handymanTypeDelete = map["handymantype_delete"] == null ? null : map["handymantype_delete"],
        postJob = map["postjob"] == null ? null : map["postjob"],
        postJobList = map["postjob_list"] == null ? null : map["postjob_list"],
        servicePackage = map["servicepackage"] == null ? null : map["servicepackage"],
        servicePackageAdd = map["servicepackage_add"] == null ? null : map["servicepackage_add"],
        servicePackageEdit = map["servicepackage_edit"] == null ? null : map["servicepackage_edit"],
        servicePackageDelete = map["servicepackage_delete"] == null ? null : map["servicepackage_delete"],
        servicePackageList = map["servicepackage_list"] == null ? null : map["servicepackage_list"],
        refundAndCancellationPolicy = map["refund_and_cancellation_policy"] == null ? null : map["refund_and_cancellation_policy"],
        blog = map["blog"] == null ? null : map["blog"],
        blogAdd = map["blog_add"] == null ? null : map["blog_add"],
        blogEdit = map["blog_edit"] == null ? null : map["blog_edit"],
        blogDelete = map["blog_delete"] == null ? null : map["blog_delete"],
        blogList = map["blog_list"] == null ? null : map["blog_list"],
        serviceAddOn = map["service_add_on"] == null ? null : map["service_add_on"],
        serviceAddOnAdd = map["service_add_on_add"] == null ? null : map["service_add_on_add"],
        serviceAddOnEdit = map["service_add_on_edit"] == null ? null : map["service_add_on_edit"],
        serviceAddOnDelete = map["service_add_on_delete"] == null ? null : map["service_add_on_delete"],
        serviceAddOnList = map["service_add_on_list"] == null ? null : map["service_add_on_list"],
        frontendSetting = map["frontend_setting"] == null ? null : map["frontend_setting"],
        frontendSettingList = map["frontendsetting_list"] == null ? null : map["frontendsetting_list"],
        bank = map["bank"] == null ? null : map["bank"],
        bankAdd = map["bank_add"] == null ? null : map["bank_add"],
        bankEdit = map["bank_edit"] == null ? null : map["bank_edit"],
        bankDelete = map["bank_delete"] == null ? null : map["bank_delete"],
        bankList = map["bank_list"] == null ? null : map["bank_list"],
        tax = map["tax"] == null ? null : map["tax"],
        taxAdd = map["tax_add"] == null ? null : map["tax_add"],
        taxEdit = map["tax_edit"] == null ? null : map["tax_edit"],
        taxDelete = map["tax_delete"] == null ? null : map["tax_delete"],
        taxList = map["tax_list"] == null ? null : map["tax_list"],
        earning = map["earning"] == null ? null : map["earning"],
        earningList = map["earning_list"] == null ? null : map["earning_list"],
        wallet = map["wallet"] == null ? null : map["wallet"],
        walletAdd = map["wallet_add"] == null ? null : map["wallet_add"],
        walletEdit = map["wallet_edit"] == null ? null : map["wallet_edit"],
        walletDelete = map["wallet_delete"] == null ? null : map["wallet_delete"],
        walletList = map["wallet_list"] == null ? null : map["wallet_list"],
        userRating = map["userrating"] == null ? null : map["userrating"],
        userRatingList = map["userrating_list"] == null ? null : map["userrating_list"],
        handymanRating = map["handymanrating"] == null ? null : map["handymanrating"],
        handymanRatingList = map["handymanrating_list"] == null ? null : map["handymanrating_list"],
        providerPayout = map["provider_payout"] == null ? null : map["provider_payout"],
        plan = map["plan"] == null ? null : map["plan"],
        planAdd = map["plan_add"] == null ? null : map["plan_add"],
        planEdit = map["plan_edit"] == null ? null : map["plan_edit"],
        planDelete = map["plan_delete"] == null ? null : map["plan_delete"],
        planList = map["plan_list"] == null ? null : map["plan_list"],
        userServiceList = map["userservice_list"] == null ? null : map["userservice_list"],
        systemSetting = map["system_setting"] == null ? null : map["system_setting"],
        providerChangePassword = map["provider_changepassword"] == null ? null : map["provider_changepassword"],
        dataDeletionRequest = map["data_deletion_request"] == null ? null : map["data_deletion_request"],
        helpDesk = map["helpdesk"] == null ? null : map["helpdesk"],
        helpDeskAdd = map["helpdesk_add"] == null ? null : map["helpdesk_add"],
        helpDeskEdit = map["helpdesk_edit"] == null ? null : map["helpdesk_edit"],
        helpDeskList = map["helpdesk_list"] == null ? null : map["helpdesk_list"],
        promotional_banner = map["promotional_banner"] == null ? null : map["promotional_banner"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = role;
    data['role_add'] = roleAdd;
    data['role_list'] = roleList;
    data['permission'] = permission;
    data['permission_add'] = permissionAdd;
    data['permission_list'] = permissionList;
    data['category'] = category;
    data['category_add'] = categoryAdd;
    data['category_list'] = categoryList;
    data['category_edit'] = categoryEdit;
    data['category_delete'] = categoryDelete;
    data['sub_category'] = subCategory;
    data['sub_category_add'] = subCategoryAdd;
    data['sub_category_edit'] = subCategoryEdit;
    data['sub_category_delete'] = subCategoryDelete;
    data['sub_category_list'] = subCategoryList;
    data['service'] = service;
    data['service_add'] = serviceAdd;
    data['service_list'] = serviceList;
    data['service_edit'] = serviceEdit;
    data['service_delete'] = serviceDelete;
    data['service_add_on'] = serviceAddOn;
    data['service_add_on_add'] = serviceAddOnAdd;
    data['service_add_on_edit'] = serviceAddOnEdit;
    data['service_add_on_delete'] = serviceAddOnDelete;
    data['service_add_on_list'] = serviceAddOnList;
    data['service_package'] = servicePackage;
    data['service_package_add'] = servicePackageAdd;
    data['service_package_edit'] = servicePackageEdit;
    data['service_package_delete'] = servicePackageDelete;
    data['service_package_list'] = servicePackageList;
    data['service_faq'] = serviceFAQ;
    data['service_faq_add'] = serviceFAQAdd;
    data['service_faq_edit'] = serviceFAQEdit;
    data['service_faq_delete'] = serviceFAQDelete;
    data['service_faq_list'] = serviceFAQList;
    data['provider'] = provider;
    data['provider_add'] = providerAdd;
    data['provider_list'] = providerList;
    data['provider_edit'] = providerEdit;
    data['provider_delete'] = providerDelete;
    data['provider_type'] = providerType;
    data['provider_type_list'] = providerTypeList;
    data['provider_type_add'] = providerTypeAdd;
    data['provider_type_edit'] = providerTypeEdit;
    data['provider_type_delete'] = providerTypeDelete;
    data['provider_address'] = providerAddress;
    data['provider_address_list'] = providerAddressList;
    data['provider_address_add'] = providerAddressAdd;
    data['provider_address_edit'] = providerAddressEdit;
    data['provider_address_delete'] = providerAddressDelete;
    data['provider_document'] = providerDocument;
    data['provider_document_list'] = providerDocumentList;
    data['provider_document_add'] = providerDocumentAdd;
    data['provider_document_edit'] = providerDocumentEdit;
    data['provider_document_delete'] = providerDocumentDelete;
    data['provider_change_password'] = providerChangePassword;
    data['pending_provider'] = pendingProvider;
    data['provider_payout'] = providerPayout;
    data['handyman'] = handyman;
    data['handyman_list'] = handymanList;
    data['handyman_add'] = handymanAdd;
    data['handyman_edit'] = handymanEdit;
    data['handyman_delete'] = handymanDelete;
    data['handyman_type'] = handymanType;
    data['handyman_type_list'] = handymanTypeList;
    data['handyman_type_add'] = handymanTypeAdd;
    data['handyman_type_edit'] = handymanTypeEdit;
    data['handyman_type_delete'] = handymanTypeDelete;
    data['handyman_payout'] = handymanPayout;
    data['pending_handyman'] = pendingHandyman;
    data['handyman_rating'] = handymanRating;
    data['handyman_rating_list'] = handymanRatingList;
    data['booking'] = booking;
    data['booking_list'] = bookingList;
    data['booking_edit'] = bookingEdit;
    data['booking_delete'] = bookingDelete;
    data['booking_view'] = bookingView;
    data['post_job'] = postJob;
    data['post_job_list'] = postJobList;
    data['payment'] = payment;
    data['payment_list'] = paymentList;
    data['user'] = user;
    data['user_list'] = userList;
    data['user_view'] = userView;
    data['user_delete'] = userDelete;
    data['user_add'] = userAdd;
    data['user_edit'] = userEdit;
    data['user_rating'] = userRating;
    data['user_rating_list'] = userRatingList;
    data['user_service_list'] = userServiceList;
    data['coupon'] = coupon;
    data['coupon_list'] = couponList;
    data['coupon_add'] = couponAdd;
    data['coupon_edit'] = couponEdit;
    data['coupon_delete'] = couponDelete;
    data['slider'] = slider;
    data['slider_list'] = sliderList;
    data['slider_add'] = sliderAdd;
    data['slider_edit'] = sliderEdit;
    data['slider_delete'] = sliderDelete;
    data['document'] = document;
    data['document_list'] = documentList;
    data['document_add'] = documentAdd;
    data['document_edit'] = documentEdit;
    data['document_delete'] = documentDelete;
    data['blog'] = blog;
    data['blog_add'] = blogAdd;
    data['blog_edit'] = blogEdit;
    data['blog_delete'] = blogDelete;
    data['blog_list'] = blogList;
    data['plan'] = plan;
    data['plan_add'] = planAdd;
    data['plan_edit'] = planEdit;
    data['plan_delete'] = planDelete;
    data['plan_list'] = planList;
    data['wallet'] = wallet;
    data['wallet_add'] = walletAdd;
    data['wallet_edit'] = walletEdit;
    data['wallet_delete'] = walletDelete;
    data['wallet_list'] = walletList;
    data['bank'] = bank;
    data['bank_add'] = bankAdd;
    data['bank_edit'] = bankEdit;
    data['bank_delete'] = bankDelete;
    data['bank_list'] = bankList;
    data['tax'] = tax;
    data['tax_add'] = taxAdd;
    data['tax_edit'] = taxEdit;
    data['tax_delete'] = taxDelete;
    data['tax_list'] = taxList;
    data['earning'] = earning;
    data['earning_list'] = earningList;
    data['frontend_setting'] = frontendSetting;
    data['frontend_setting_list'] = frontendSettingList;
    data['refund_and_cancellation_policy'] = refundAndCancellationPolicy;
    data['pages'] = pages;
    data['Help_and_support'] = helpAndSupport;
    data['privacy_policy'] = privacyPolicy;
    data['terms_condition'] = termsAndcondition;
    data['help_desk'] = helpDesk;
    data['help_desk_add'] = helpDeskAdd;
    data['help_desk_edit'] = helpDeskEdit;
    data['help_desk_list'] = helpDeskList;
    data['data_deletion_request'] = dataDeletionRequest;
    data['system_setting'] = systemSetting;
    data['promotional_banner'] = promotional_banner;
    return data;
  }
}

//endregion