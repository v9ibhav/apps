
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/app_configuration.dart';

part 'roles_and_permission_store.g.dart';

class RolesAndPermissionStore = _RolesAndPermissionStore with _$RolesAndPermissionStore;

abstract class _RolesAndPermissionStore with Store {

  @observable
  bool role = getBoolAsync(ROLE);

  @observable
  bool roleAdd = getBoolAsync(ROLE_ADD);

  @observable
  bool roleList = getBoolAsync(ROLE_LIST);

  @observable
  bool permission = getBoolAsync(PERMISSION);

  @observable
  bool permissionAdd = getBoolAsync(PERMISSION_ADD);

  @observable
  bool permissionList = getBoolAsync(PERMISSION_LIST);

  @observable
  bool category = getBoolAsync(CATEGORY);

  @observable
  bool categoryAdd = getBoolAsync(CATEGORY_ADD);

  @observable
  bool categoryList = getBoolAsync(CATEGORY_LIST);

  @observable
  bool categoryEdit = getBoolAsync(CATEGORY_EDIT);

  @observable
  bool categoryDelete = getBoolAsync(CATEGORY_DELETE);

  @observable
  bool service = getBoolAsync(SERVICE);

  @observable
  bool serviceAdd = getBoolAsync(SERVICE_ADD);

  @observable
  bool serviceList = getBoolAsync(SERVICE_LIST);

  @observable
  bool serviceEdit = getBoolAsync(SERVICE_EDIT);

  @observable
  bool serviceDelete = getBoolAsync(SERVICE_DELETE);

  @observable
  bool provider = getBoolAsync(PROVIDER);

  @observable
  bool providerAdd = getBoolAsync(PROVIDER_ADD);

  @observable
  bool providerList = getBoolAsync(PROVIDER_LIST);

  @observable
  bool providerEdit = getBoolAsync(PROVIDER_EDIT);

  @observable
  bool providerDelete = getBoolAsync(PROVIDER_DELETE);

  @observable
  bool handyman = getBoolAsync(HANDYMAN);

  @observable
  bool handymanList = getBoolAsync(HANDYMAN_LIST);

  @observable
  bool handymanAdd = getBoolAsync(HANDYMAN_ADD);

  @observable
  bool handymanEdit = getBoolAsync(HANDYMAN_EDIT);

  @observable
  bool handymanDelete = getBoolAsync(HANDYMAN_DELETE);

  @observable
  bool booking = getBoolAsync(BOOKING);

  @observable
  bool bookingList = getBoolAsync(BOOKING_LIST);

  @observable
  bool bookingEdit = getBoolAsync(BOOKING_EDIT);

  @observable
  bool bookingDelete = getBoolAsync(BOOKING_DELETE);

  @observable
  bool bookingView = getBoolAsync(BOOKING_VIEW);

  @observable
  bool payment = getBoolAsync(PAYMENT);

  @observable
  bool paymentList = getBoolAsync(PAYMENT_LIST);

  @observable
  bool user = getBoolAsync(USER);

  @observable
  bool userList = getBoolAsync(USER_LIST);

  @observable
  bool userView = getBoolAsync(USER_VIEW);

  @observable
  bool userDelete = getBoolAsync(USER_DELETE);

  @observable
  bool providerType = getBoolAsync(PROVIDERTYPE);

  @observable
  bool providerTypeList = getBoolAsync(PROVIDERTYPE_LIST);

  @observable
  bool providerTypeAdd = getBoolAsync(PROVIDERTYPE_ADD);

  @observable
  bool providerTypeEdit = getBoolAsync(PROVIDERTYPE_EDIT);

  @observable
  bool providerTypeDelete = getBoolAsync(PROVIDERTYPE_DELETE);

  @observable
  bool coupon = getBoolAsync(COUPON);

  @observable
  bool couponList = getBoolAsync(COUPON_LIST);

  @observable
  bool couponAdd = getBoolAsync(COUPON_ADD);

  @observable
  bool couponEdit = getBoolAsync(COUPON_EDIT);

  @observable
  bool couponDelete = getBoolAsync(COUPON_DELETE);

  @observable
  bool slider = getBoolAsync(SLIDER);

  @observable
  bool sliderList = getBoolAsync(SLIDER_LIST);

  @observable
  bool sliderAdd = getBoolAsync(SLIDER_ADD);

  @observable
  bool sliderEdit = getBoolAsync(SLIDER_EDIT);

  @observable
  bool sliderDelete = getBoolAsync(SLIDER_DELETE);

  @observable
  bool providerAddress = getBoolAsync(PROVIDER_ADDRESS);

  @observable
  bool providerAddressList = getBoolAsync(PROVIDER);

  @observable
  bool providerAddressAdd = getBoolAsync(PROVIDERADDRESS_ADD);

  @observable
  bool providerAddressEdit = getBoolAsync(PROVIDERADDRESS_EDIT);

  @observable
  bool providerAddressDelete = getBoolAsync(PROVIDERADDRESS_DELETE);

  @observable
  bool document = getBoolAsync(DOCUMENT);

  @observable
  bool documentList =getBoolAsync(DOCUMENT_LIST);

  @observable
  bool documentAdd = getBoolAsync(DOCUMENT_ADD);

  @observable
  bool documentEdit = getBoolAsync(DOCUMENT_EDIT);

  @observable
  bool documentDelete = getBoolAsync(DOCUMENT_DELETE);

  @observable
  bool handymanPayout = getBoolAsync(HANDYMAN_PAYOUT);

  @observable
  bool serviceFAQ = getBoolAsync(SERVICEFAQ);

  @observable
  bool serviceFAQAdd = getBoolAsync(SERVICEFAQ_ADD);

  @observable
  bool serviceFAQEdit = getBoolAsync(SERVICEFAQ_EDIT);

  @observable
  bool serviceFAQDelete = getBoolAsync(SERVICEFAQ_DELETE);

  @observable
  bool serviceFAQList = getBoolAsync(SERVICEFAQ_LIST);

  @observable
  bool userAdd = getBoolAsync(USER_ADD);

  @observable
  bool userEdit = getBoolAsync(USER_EDIT);

  @observable
  bool subCategory = getBoolAsync(SUBCATEGORY);

  @observable
  bool subCategoryAdd = getBoolAsync(SERVICE_ADD) ;

  @observable
  bool subCategoryEdit = getBoolAsync(SUBCATEGORY_EDIT);

  @observable
  bool subCategoryDelete = getBoolAsync(SUBCATEGORY_DELETE);

  @observable
  bool subCategoryList =getBoolAsync(SUBCATEGORY_LIST) ;

  // HANDYMAN TYPE-RELATED KEYS
  @observable
  bool handymanType = getBoolAsync(HANDYMANTYPE);

  @observable
  bool handymanTypeList = getBoolAsync(HANDYMAN_LIST);

  @observable
  bool handymanTypeAdd = getBoolAsync(HANDYMANTYPE_ADD);

  @observable
  bool handymanTypeEdit = getBoolAsync(HANDYMAN_EDIT);

  @observable
  bool handymanTypeDelete = getBoolAsync(HANDYMANTYPE_DELETE);

  // POST JOB-RELATED KEYS
  @observable
  bool postJob = getBoolAsync(POSTJOB);

  @observable
  bool postJobList = getBoolAsync(POSTJOB_LIST);

  // SERVICE PACKAGE-RELATED KEYS
  @observable
  bool servicePackage = getBoolAsync(SERVICEPACKAGE);

  @observable
  bool servicePackageAdd = getBoolAsync(SERVICEPACKAGE_ADD);

  @observable
  bool servicePackageEdit = getBoolAsync(SERVICEPACKAGE_EDIT);

  @observable
  bool servicePackageDelete = getBoolAsync(SERVICEPACKAGE_DELETE);

  @observable
  bool servicePackageList = getBoolAsync(SERVICEPACKAGE_LIST);

  @observable
  bool refundAndCancellationPolicy = getBoolAsync(REFUND_AND_CANCELLATION_POLICY);

  @observable
  bool blog = getBoolAsync(BLOG);

  @observable
  bool blogAdd = getBoolAsync(BLOG_ADD);

  @observable
  bool blogEdit = getBoolAsync(BLOG_EDIT);

  @observable
  bool blogDelete = getBoolAsync(BLOG_DELETE);

  @observable
  bool blogList = getBoolAsync(BLOG_LIST);

  @observable
  bool serviceAddOn = getBoolAsync(SERVICE_ADD_ON);

  @observable
  bool serviceAddOnAdd = getBoolAsync(SERVICE_ADD_ON_ADD);

  @observable
  bool serviceAddOnEdit = getBoolAsync(SERVICE_ADD_ON_EDIT);

  @observable
  bool serviceAddOnDelete = getBoolAsync(SERVICE_ADD_ON_DELETE);

  @observable
  bool serviceAddOnList = getBoolAsync(SERVICE_ADD_ON_LIST);

  @observable
  bool frontendSetting = getBoolAsync(FRONTEND_SETTING);

  @observable
  bool frontendSettingList = getBoolAsync(FRONTENDSETTING_LIST);

  @observable
  bool bank = getBoolAsync(BANK);

  @observable
  bool bankAdd = getBoolAsync(BANK_LIST);

  @observable
  bool bankEdit = getBoolAsync(BANK_EDIT);

  @observable
  bool bankDelete = getBoolAsync(BANK_DELETE);

  @observable
  bool bankList = getBoolAsync(BANK_LIST);

  @observable
  bool tax = getBoolAsync(TAX);

  @observable
  bool taxAdd = getBoolAsync(TAX_ADD);

  @observable
  bool taxEdit = getBoolAsync(TAX_EDIT);

  @observable
  bool taxDelete = getBoolAsync(TAX_DELETE);

  @observable
  bool taxList = getBoolAsync(TAX_LIST);

  @observable
  bool earning = getBoolAsync(EARNING);

  @observable
  bool earningList = getBoolAsync(EARNING_LIST);

  @observable
  bool wallet = getBoolAsync(WALLET);

  @observable
  bool walletAdd = getBoolAsync(WALLET_ADD);

  @observable
  bool walletEdit = getBoolAsync(WALLET_EDIT);

  @observable
  bool walletDelete = getBoolAsync(WALLET_DELETE);

  @observable
  bool walletList = getBoolAsync(WALLET_LIST);

  @observable
  bool userRating = getBoolAsync(USERRATING);

  @observable
  bool userRatingList = getBoolAsync(USERRATING_LIST);

  @observable
  bool handymanRating = getBoolAsync(HANDYMANRATING);

  @observable
  bool handymanRatingList = getBoolAsync(HANDYMANRATING_LIST);

  @observable
  bool providerPayout = getBoolAsync(PROVIDER_PAYOUT);

  @observable
  bool plan = getBoolAsync(PLAN);

  @observable
  bool planAdd = getBoolAsync(PLAN_ADD);

  @observable
  bool planEdit = getBoolAsync(PLAN_EDIT);

  @observable
  bool planDelete = getBoolAsync(PLAN_DELETE);

  @observable
  bool planList = getBoolAsync(PLAN_LIST);

  @observable
  bool userServiceList = getBoolAsync(USERSERVICE_LIST);

  @observable
  bool systemSetting = getBoolAsync(SYSTEM_SETTING);

  @observable
  bool providerChangePassword = getBoolAsync(PROVIDER_CHANGEPASSWORD);

  @observable
  bool dataDeletionRequest = getBoolAsync(DATA_DELETION_REQUEST);

  @observable
  bool helpDesk = getBoolAsync(HELP_DESK);

  @observable
  bool helpDeskAdd = getBoolAsync(HELP_DESK_ADD);

  @observable
  bool helpDeskEdit = getBoolAsync(HELP_DESK_EDIT);

  @observable
  bool helpDeskList = getBoolAsync(HELP_DESK_LIST);

  @observable
  bool pendingProvider = getBoolAsync(PENDING_PROVIDER);

  @observable
  bool pendingHandyman = getBoolAsync(PENDING_HANDYMAN);

  @observable
  bool pages = getBoolAsync(PAGES);

  @observable
  bool helpAndSupport = getBoolAsync(PERMISSION_HELP_AND_SUPPORT);

  @observable
  bool termCondition = getBoolAsync(PERMISSION_TERM_CONDITION);

  @observable
  bool privacyPolicy = getBoolAsync(PERMISSION_PRIVACY_POLICY);

  @observable
  bool providerDocument = getBoolAsync(PROVIDER_DOCUMENT);

  @observable
  bool providerDocumentList = getBoolAsync(PROVIDERDOCUMENT_LIST);

  @observable
  bool providerDocumentAdd = getBoolAsync(PROVIDERDOCUMENT_ADD);

  @observable
  bool providerDocumentEdit = getBoolAsync(PROVIDERDOCUMENT_EDIT);

  @observable
  bool providerDocumentDelete = getBoolAsync(PROVIDERDOCUMENT_DELETE);

  @observable
  bool promotionalBanner = getBoolAsync(PROMOTIONAL_BANNER);

  @observable
  bool promotionalBannerAdd = getBoolAsync(PROMOTIONAL_BANNER_ADD);

  @observable
  bool promotionalBannerEdit = getBoolAsync(PROMOTIONAL_BANNER_EDIT);

  @observable
  bool promotionalBannerList = getBoolAsync(PROMOTIONAL_BANNER_LIST);

  @action
  Future<void> setRole(bool val) async {
    role = val;
    await setValue(ROLE, val);
  }

  @action
  Future<void> setRoleAdd(bool val) async {
    roleAdd = val;
    await setValue(ROLE_ADD, val);
  }

  @action
  Future<void> setRoleList(bool val) async {
    roleList = val;
    await setValue(ROLE_LIST, val);
  }

  @action
  Future<void> setPermission(bool val) async {
    permission = val;
    await setValue(PERMISSION, val);
  }

  @action
  Future<void> setPermissionAdd(bool val) async {
    permissionAdd = val;
    await setValue(PERMISSION_ADD, val);
  }

  @action
  Future<void> setPermissionList(bool val) async {
    permissionList = val;
    await setValue(PERMISSION_LIST, val);
  }

  @action
  Future<void> setCategory(bool val) async {
    category = val;
    await setValue(CATEGORY, val);
  }

  @action
  Future<void> setCategoryAdd(bool val) async {
    categoryAdd = val;
    await setValue(CATEGORY_ADD, val);
  }

  @action
  Future<void> setCategoryList(bool val) async {
    categoryList = val;
    await setValue(CATEGORY_LIST, val);
  }

  @action
  Future<void> setCategoryEdit(bool val) async {
    categoryEdit = val;
    await setValue(CATEGORY_EDIT, val);
  }

  @action
  Future<void> setCategoryDelete(bool val) async {
    categoryDelete = val;
    await setValue(CATEGORY_DELETE, val);
  }

  @action
  Future<void> setService(bool val) async {
    service = val;
    await setValue(SERVICE, val);
  }

  @action
  Future<void> setServiceAdd(bool val) async {
    serviceAdd = val;
    await setValue(SERVICE_ADD, val);
  }

  @action
  Future<void> setServiceList(bool val) async {
    serviceList = val;
    await setValue(SERVICE_LIST, val);
  }

  @action
  Future<void> setServiceEdit(bool val) async {
    serviceEdit = val;
    await setValue(SERVICE_EDIT, val);
  }

  @action
  Future<void> setServiceDelete(bool val) async {
    serviceDelete = val;
    await setValue(SERVICE_DELETE, val);
  }

  @action
  Future<void> setProvider(bool val) async {
    provider = val;
    await setValue(PROVIDER, val);
  }

  @action
  Future<void> setProviderAdd(bool val) async {
    providerAdd = val;
    await setValue(PROVIDER_ADD, val);
  }

  @action
  Future<void> setProviderList(bool val) async {
    providerList = val;
    await setValue(PROVIDER_LIST, val);
  }

  @action
  Future<void> setProviderEdit(bool val) async {
    providerEdit = val;
    await setValue(PROVIDER_EDIT, val);
  }

  @action
  Future<void> setProviderDelete(bool val) async {
    providerDelete = val;
    await setValue(PROVIDER_DELETE, val);
  }

  @action
  Future<void> setHandyman(bool val) async {
    handyman = val;
    await setValue(HANDYMAN, val);
  }

  @action
  Future<void> setHandymanList(bool val) async {
    handymanList = val;
    await setValue(HANDYMAN_LIST, val);
  }

  @action
  Future<void> setHandymanAdd(bool val) async {
    handymanAdd = val;
    await setValue(HANDYMAN_ADD, val);
  }

  @action
  Future<void> setHandymanEdit(bool val) async {
    handymanEdit = val;
    await setValue(HANDYMAN_EDIT, val);
  }

  @action
  Future<void> setHandymanDelete(bool val) async {
    handymanDelete = val;
    await setValue(HANDYMAN_DELETE, val);
  }

  @action
  Future<void> setBooking(bool val) async {
    booking = val;
    await setValue(BOOKING, val);
  }

  @action
  Future<void> setBookingList(bool val) async {
    bookingList = val;
    await setValue(BOOKING_LIST, val);
  }

  @action
  Future<void> setBookingEdit(bool val) async {
    bookingEdit = val;
    await setValue(BOOKING_EDIT, val);
  }

  @action
  Future<void> setBookingDelete(bool val) async {
    bookingDelete = val;
    await setValue(BOOKING_DELETE, val);
  }

  @action
  Future<void> setBookingView(bool val) async {
    bookingView = val;
    await setValue(BOOKING_VIEW, val);
  }

  @action
  Future<void> setPayment(bool val) async {
    payment = val;
    await setValue(PAYMENT, val);
  }

  @action
  Future<void> setPaymentList(bool val) async {
    paymentList = val;
    await setValue(PAYMENT_LIST, val);
  }

  @action
  Future<void> setUser(bool val) async {
    user = val;
    await setValue(USER, val);
  }

  @action
  Future<void> setUserList(bool val) async {
    userList = val;
    await setValue(USER_LIST, val);
  }

  @action
  Future<void> setUserView(bool val) async {
    userView = val;
    await setValue(USER_VIEW, val);
  }

  @action
  Future<void> setUserDelete(bool val) async {
    userDelete = val;
    await setValue(USER_DELETE, val);
  }

  @action
  Future<void> setProviderType(bool val) async {
    providerType = val;
    await setValue(PROVIDERTYPE, val);
  }

  @action
  Future<void> setProviderTypeList(bool val) async {
    providerTypeList = val;
    await setValue(PROVIDERTYPE_LIST, val);
  }

  @action
  Future<void> setProviderTypeAdd(bool val) async {
    providerTypeAdd = val;
    await setValue(PROVIDERTYPE_ADD, val);
  }

  @action
  Future<void> setProviderTypeEdit(bool val) async {
    providerTypeEdit = val;
    await setValue(PROVIDERTYPE_EDIT, val);
  }

  @action
  Future<void> setProviderTypeDelete(bool val) async {
    providerTypeDelete = val;
    await setValue(PROVIDERTYPE_DELETE, val);
  }

  @action
  Future<void> setCoupon(bool val) async {
    coupon = val;
    await setValue(COUPON, val);
  }

  @action
  Future<void> setCouponList(bool val) async {
    couponList = val;
    await setValue(COUPON_LIST, val);
  }

  @action
  Future<void> setCouponAdd(bool val) async {
    couponAdd = val;
    await setValue(COUPON_ADD, val);
  }

  @action
  Future<void> setCouponEdit(bool val) async {
    couponEdit = val;
    await setValue(COUPON_EDIT, val);
  }

  @action
  Future<void> setCouponDelete(bool val) async {
    couponDelete = val;
    await setValue(COUPON_DELETE, val);
  }

  @action
  Future<void> setSlider(bool val) async {
    slider = val;
    await setValue(SLIDER, val);
  }

  @action
  Future<void> setSliderList(bool val) async {
    sliderList = val;
    await setValue(SLIDER_LIST, val);
  }

  @action
  Future<void> setSliderAdd(bool val) async {
    sliderAdd = val;
    await setValue(SLIDER_ADD, val);
  }

  @action
  Future<void> setSliderEdit(bool val) async {
    sliderEdit = val;
    await setValue(SLIDER_EDIT, val);
  }

  @action
  Future<void> setSliderDelete(bool val) async {
    sliderDelete = val;
    await setValue(SLIDER_DELETE, val);
  }

  @action
  Future<void> setProviderAddress(bool val) async {
    providerAddress = val;
    await setValue(PROVIDER_ADDRESS, val);
  }

  @action
  Future<void> setProviderAddressList(bool val) async {
    providerAddressList = val;
    await setValue(PROVIDERADDRESS_LIST, val);
  }

  @action
  Future<void> setProviderAddressAdd(bool val) async {
    providerAddressAdd = val;
    await setValue(PROVIDERADDRESS_ADD, val);
  }

  @action
  Future<void> setProviderAddressEdit(bool val) async {
    providerAddressEdit = val;
    await setValue(PROVIDERADDRESS_EDIT, val);
  }

  @action
  Future<void> setProviderAddressDelete(bool val) async {
    providerAddressDelete = val;
    await setValue(PROVIDERADDRESS_DELETE, val);
  }

  @action
  Future<void> setDocument(bool val) async {
    document = val;
    await setValue(DOCUMENT, val);
  }

  @action
  Future<void> setDocumentList(bool val) async {
    documentList = val;
    await setValue(DOCUMENT_LIST, val);
  }

  @action
  Future<void> setDocumentAdd(bool val) async {
    documentAdd = val;
    await setValue(DOCUMENT_ADD, val);
  }

  @action
  Future<void> setDocumentEdit(bool val) async {
    documentEdit = val;
    await setValue(DOCUMENT_EDIT, val);
  }

  @action
  Future<void> setDocumentDelete(bool val) async {
    documentDelete = val;
    await setValue(DOCUMENT_DELETE, val);
  }

  @action
  Future<void> setHandymanPayout(bool val) async {
    handymanPayout = val;
    await setValue(HANDYMAN_PAYOUT, val);
  }

  @action
  Future<void> setServiceFAQ(bool val) async {
    serviceFAQ = val;
    await setValue(SERVICEFAQ, val);
  }

  @action
  Future<void> setServiceFAQAdd(bool val) async {
    serviceFAQAdd = val;
    await setValue(SERVICEFAQ_ADD, val);
  }

  @action
  Future<void> setServiceFAQEdit(bool val) async {
    serviceFAQEdit = val;
    await setValue(SERVICEFAQ_EDIT, val);
  }

  @action
  Future<void> setServiceFAQDelete(bool val) async {
    serviceFAQDelete = val;
    await setValue(SERVICEFAQ_DELETE, val);
  }

  @action
  Future<void> setServiceFAQList(bool val) async {
    serviceFAQList = val;
    await setValue(SERVICEFAQ_LIST, val);
  }

  @action
  Future<void> setUserAdd(bool val) async {
    userAdd = val;
    await setValue(USER_ADD, val);
  }

  @action
  Future<void> setUserEdit(bool val) async {
    userEdit = val;
    await setValue(USER_EDIT, val);
  }

  @action
  Future<void> setSubcategory(bool val) async {
    subCategory = val;
    await setValue(SUBCATEGORY, val);
  }

  @action
  Future<void> setSubcategoryAdd(bool val) async {
    subCategoryAdd = val;
    await setValue(SUBCATEGORY_ADD, val);
  }

  @action
  Future<void> setSubcategoryEdit(bool val) async {
    subCategoryEdit = val;
    await setValue(SUBCATEGORY_EDIT, val);
  }

  @action
  Future<void> setSubcategoryDelete(bool val) async {
    subCategoryDelete = val;
    await setValue(SUBCATEGORY_DELETE, val);
  }

  @action
  Future<void> setSubcategoryList(bool val) async {
    subCategoryList = val;
    await setValue(SUBCATEGORY_LIST, val);
  }

  @action
  Future<void> setHandymanType(bool val) async {
    handymanType = val;
    await setValue(HANDYMANTYPE, val);
  }

  @action
  Future<void> setHandymanTypeList(bool val) async {
    handymanTypeList = val;
    await setValue(HANDYMANTYPE_LIST, val);
  }

  @action
  Future<void> setHandymanTypeAdd(bool val) async {
    handymanTypeAdd = val;
    await setValue(HANDYMANTYPE_ADD, val);
  }

  @action
  Future<void> setHandymanTypeEdit(bool val) async {
    handymanTypeEdit = val;
    await setValue(HANDYMANTYPE_EDIT, val);
  }

  @action
  Future<void> setHandymanTypeDelete(bool val) async {
    handymanTypeDelete = val;
    await setValue(HANDYMANTYPE_DELETE, val);
  }

  @action
  Future<void> setPostJob(bool val) async {
    postJob = val;
    await setValue(POSTJOB, val);
  }

  @action
  Future<void> setPostJobList(bool val) async {
    postJobList = val;
    await setValue(POSTJOB_LIST, val);
  }

  @action
  Future<void> setServicePackage(bool val) async {
    servicePackage = val;
    await setValue(SERVICEPACKAGE, val);
  }

  @action
  Future<void> setServicePackageAdd(bool val) async {
    servicePackageAdd = val;
    await setValue(SERVICEPACKAGE_ADD, val);
  }

  @action
  Future<void> setServicePackageEdit(bool val) async {
    servicePackageEdit = val;
    await setValue(SERVICEPACKAGE_EDIT, val);
  }

  @action
  Future<void> setServicePackageDelete(bool val) async {
    servicePackageDelete = val;
    await setValue(SERVICEPACKAGE_DELETE, val);
  }

  @action
  Future<void> setServicePackageList(bool val) async {
    servicePackageList = val;
    await setValue(SERVICEPACKAGE_LIST, val);
  }

  @action
  Future<void> setRefundAndCancellationPolicy(bool val) async {
    refundAndCancellationPolicy = val;
    await setValue(REFUND_AND_CANCELLATION_POLICY, val);
  }

  @action
  Future<void> setBlog(bool val) async {
    blog = val;
    await setValue(BLOG, val);
  }

  @action
  Future<void> setBlogAdd(bool val) async {
    blogAdd = val;
    await setValue(BLOG_ADD, val);
  }

  @action
  Future<void> setBlogEdit(bool val) async {
    blogEdit = val;
    await setValue(BLOG_EDIT, val);
  }

  @action
  Future<void> setBlogDelete(bool val) async {
    blogDelete = val;
    await setValue(BLOG_DELETE, val);
  }

  @action
  Future<void> setBlogList(bool val) async {
    blogList = val;
    await setValue(BLOG_LIST, val);
  }

  @action
  Future<void> setServiceAddOn(bool val) async {
    serviceAddOn = val;
    await setValue(SERVICE_ADD_ON, val);
  }

  @action
  Future<void> setServiceAddOnAdd(bool val) async {
    serviceAddOnAdd = val;
    await setValue(SERVICE_ADD_ON_ADD, val);
  }

  @action
  Future<void> setServiceAddOnEdit(bool val) async {
    serviceAddOnEdit = val;
    await setValue(SERVICE_ADD_ON_EDIT, val);
  }

  @action
  Future<void> setServiceAddOnDelete(bool val) async {
    serviceAddOnDelete = val;
    await setValue(SERVICE_ADD_ON_DELETE, val);
  }

  @action
  Future<void> setServiceAddOnList(bool val) async {
    serviceAddOnList = val;
    await setValue(SERVICE_ADD_ON_LIST, val);
  }

  @action
  Future<void> setFrontendSetting(bool val) async {
    frontendSetting = val;
    await setValue(FRONTEND_SETTING, val);
  }

  @action
  Future<void> setFrontendSettingList(bool val) async {
    frontendSettingList = val;
    await setValue(FRONTENDSETTING_LIST, val);
  }

  @action
  Future<void> setBank(bool val) async {
    bank = val;
    await setValue(BANK, val);
  }

  @action
  Future<void> setBankAdd(bool  val) async {
    bankAdd = val;
    await setValue(BANK_ADD, val);
  }

  @action
  Future<void> setBankEdit(bool val) async {
    bankEdit = val;
    await setValue(BANK_EDIT, val);
  }

  @action
  Future<void> setBankDelete(bool val) async {
    bankDelete = val;
    await setValue(BANK_DELETE, val);
  }

  @action
  Future<void> setBankList(bool val) async {
    bankList = val;
    await setValue(BANK_LIST, val);
  }

  @action
  Future<void> setTax(bool val) async {
    tax = val;
    await setValue(TAX, val);
  }

  @action
  Future<void> setTaxAdd(bool val) async {
    taxAdd = val;
    await setValue(TAX_ADD, val);
  }

  @action
  Future<void> setTaxEdit(bool val) async {
    taxEdit = val;
    await setValue(TAX_EDIT, val);
  }

  @action
  Future<void> setTaxDelete(bool val) async {
    taxDelete = val;
    await setValue(TAX_DELETE, val);
  }

  @action
  Future<void> setTaxList(bool val) async {
    taxList = val;
    await setValue(TAX_LIST, val);
  }

  @action
  Future<void> setEarning(bool val) async {
    earning = val;
    await setValue(EARNING, val);
  }

  @action
  Future<void> setEarningList(bool val) async {
    earningList = val;
    await setValue(EARNING_LIST, val);
  }

  @action
  Future<void> setWallet(bool val) async {
    wallet = val;
    await setValue(WALLET, val);
  }

  @action
  Future<void> setWalletAdd(bool val) async {
    walletAdd = val;
    await setValue(WALLET_ADD, val);
  }

  @action
  Future<void> setWalletEdit(bool val) async {
    walletEdit = val;
    await setValue(WALLET_EDIT, val);
  }

  @action
  Future<void> setWalletDelete(bool val) async {
    walletDelete = val;
    await setValue(WALLET_DELETE, val);
  }

  @action
  Future<void> setWalletList(bool val) async {
    walletList = val;
    await setValue(WALLET_LIST, val);
  }

  @action
  Future<void> setUserRating(bool val) async {
    userRating = val;
    await setValue(USERRATING, val);
  }

  @action
  Future<void> setUserRatingList(bool val) async {
    userRatingList = val;
    await setValue(USERRATING_LIST, val);
  }

  @action
  Future<void> setHandymanRating(bool val) async {
    handymanRating = val;
    await setValue(HANDYMANRATING, val);
  }

  @action
  Future<void> setHandymanRatingList(bool val) async {
    handymanRatingList = val;
    await setValue(HANDYMANRATING_LIST, val);
  }

  @action
  Future<void> setProviderPayout(bool val) async {
    providerPayout = val;
    await setValue(PROVIDER_PAYOUT, val);
  }

  @action
  Future<void> setPlan(bool val) async {
    plan = val;
    await setValue(PLAN, val);
  }

  @action
  Future<void> setPlanAdd(bool val) async {
    planAdd = val;
    await setValue(PLAN_ADD, val);
  }

  @action
  Future<void> setPlanEdit(bool val) async {
    planEdit = val;
    await setValue(PLAN_EDIT, val);
  }

  @action
  Future<void> setPlanDelete(bool val) async {
    planDelete = val;
    await setValue(PLAN_DELETE, val);
  }

  @action
  Future<void> setPlanList(bool val) async {
    planList = val;
    await setValue(PLAN_LIST, val);
  }

  @action
  Future<void> setUserServiceList(bool val) async {
    userServiceList = val;
    await setValue(USERSERVICE_LIST, val);
  }

  @action
  Future<void> setSystemSetting(bool val) async {
    systemSetting = val;
    await setValue(SYSTEM_SETTING, val);
  }

  @action
  Future<void> setProviderChangePassword(bool val) async {
    providerChangePassword = val;
    await setValue(PROVIDER_CHANGEPASSWORD, val);
  }

  @action
  Future<void> setDataDeletionRequest(bool val) async {
    dataDeletionRequest = val;
    await setValue(DATA_DELETION_REQUEST, val);
  }

  @action
  Future<void> setHelpDesk(bool val) async {
    helpDesk = val;
    await setValue(HELP_DESK, val);
  }

  @action
  Future<void> setHelpDeskAdd(bool val) async {
    helpDeskAdd = val;
    await setValue(HELP_DESK_ADD, val);
  }

  @action
  Future<void> setHelpDeskEdit(bool val) async {
    helpDeskEdit = val;
    await setValue(HELP_DESK_EDIT, val);
  }

  @action
  Future<void> setHelpDeskList(bool val) async {
    helpDeskList = val;
    await setValue(HELP_DESK_LIST, val);
  }

  @action
  Future<void> setPendingProvider(bool val) async {
    pendingProvider = val;
    await setValue(PENDING_PROVIDER, val);
  }

  @action
  Future<void> setPendingHandyman(bool val) async {
    pendingHandyman = val;
    await setValue(PENDING_HANDYMAN, val);
  }

  @action
  Future<void> setPages(bool val) async {
    pages = val;
    await setValue(PAGES, val);
  }

  @action
  Future<void> setHelpAndSupport(bool val) async {
    helpAndSupport = val;
    await setValue(PERMISSION_HELP_AND_SUPPORT, val);
  }

  @action
  Future<void> setPrivacyPolicy(bool val) async {
    privacyPolicy = val;
    await setValue(PERMISSION_PRIVACY_POLICY, val);
  }

  @action
  Future<void> setTermCondition(bool val) async {
    termCondition = val;
    await setValue(PERMISSION_TERM_CONDITION, val);
  }

  @action
  Future<void> setProviderDocument(bool val) async {
    providerDocument = val;
    await setValue(PROVIDER_DOCUMENT, val);
  }

  @action
  Future<void> setProviderDocumentList(bool val) async {
    providerDocumentList = val;
    await setValue(PROVIDERDOCUMENT_LIST, val);
  }

  @action
  Future<void> setProviderDocumentAdd(bool val) async {
    providerDocumentAdd = val;
    await setValue(PROVIDERDOCUMENT_ADD, val);
  }

  @action
  Future<void> setProviderDocumentEdit(bool val) async {
    providerDocumentEdit = val;
    await setValue(PROVIDERDOCUMENT_EDIT, val);
  }

  @action
  Future<void> setProviderDocumentDelete(bool val) async {
    providerDocumentDelete = val;
    await setValue(PROVIDERDOCUMENT_DELETE, val);
  }

  @action
  Future<void> setPromotionalBanner(bool val) async {
    promotionalBanner = val;
    await setValue(PROMOTIONAL_BANNER, val);
  }

  @action
  Future<void> setPromotionalBannerAdd(bool val) async {
    promotionalBannerAdd = val;
    await setValue(PROMOTIONAL_BANNER_ADD, val);
  }

  @action
  Future<void> setPromotionalBannerEdit(bool val) async {
    promotionalBannerEdit = val;
    await setValue(PROMOTIONAL_BANNER_EDIT, val);
  }

  @action
  Future<void> setPromotionalBannerList(bool val) async {
    promotionalBannerList = val;
    await setValue(PROMOTIONAL_BANNER_LIST, val);
  }
}