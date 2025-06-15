import 'constant.dart';

class CommonKeys {
  static String id = 'id';
  static String address = 'address';
  static String serviceId = 'service_id';
  static String customerId = 'customer_id';
  static String providerId = 'provider_id';
  static String bookingId = 'booking_id';
  static String handymanId = 'handyman_id';
  static String userId = 'user_id';
  static String type = 'type';
}

class UserKeys {
  static String firstName = 'first_name';
  static String lastName = 'last_name';
  static String userName = 'username';
  static String email = 'email';
  static String password = 'password';
  static String id = 'id';
  static String userType = 'user_type';
  static String providerTypeId = 'providertype_id';
  static String handymanTypeId = 'handymantype_id';
  static String status = 'status';
  static String providerId = 'provider_id';
  static String contactNumber = 'contact_number';
  static String address = 'address';
  static String countryId = 'country_id';
  static String stateId = 'state_id';
  static String cityId = 'city_id';
  static String oldPassword = 'old_password';
  static String newPassword = 'new_password';
  static String profileImage = 'profile_image';
  static String playerId = 'player_id';
  static String serviceAddressId = 'service_address_id';
  static String uid = 'uid';
  static String designation = 'designation';
  static String knownLanguages = 'known_languages';
  static String skills = 'skills';
  static String description = 'description';
  static String displayName = 'display_name';
  static String whyChooseReason = 'reason';
  static String whyChooseTitle = 'title';
  static String isDefault = 'is_default';
}

class BookingServiceKeys {
  static String description = 'description';
  static String couponId = 'coupon_id';
  static String date = 'date';
  static String totalAmount = 'total_amount';
  static String extraCharges = 'extra_charges';
}

class BookingStatusKeys {
  static String pending = BOOKING_STATUS_PENDING;
  static String accept = BOOKING_STATUS_ACCEPT;
  static String onGoing = BOOKING_STATUS_ON_GOING;
  static String inProgress = BOOKING_STATUS_IN_PROGRESS;
  static String hold = BOOKING_STATUS_HOLD;
  static String rejected = BOOKING_STATUS_REJECTED;
  static String failed = BOOKING_STATUS_FAILED;
  static String complete = BOOKING_STATUS_COMPLETED;
  static String cancelled = BOOKING_STATUS_CANCELLED;
  static String all = BOOKING_PAYMENT_STATUS_ALL;
  static String paid = BOOKING_STATUS_PAID;
  static String pendingApproval = BOOKING_STATUS_PENDING_APPROVAL;
  static String waitingAdvancedPayment = BOOKING_STATUS_WAITING_ADVANCED_PAYMENT;
}

class BookingUpdateKeys {
  static String date = 'date';
  static String description = 'description';
  static String startDate = 'start_date';
  static String endDate = 'end_date';
  static String reason = 'reason';
  static String status = 'status';
  static String startAt = 'start_at';
  static String endAt = 'end_at';
  static String durationDiff = 'duration_diff';
  static String paymentStatus = 'payment_status';
}

class NotificationKey {
  static String type = 'type';
  static String page = 'page';
}

class AddServiceKey {
  static String id = 'id';
  static String serviceId = 'service_id';
  static String name = 'name';
  static String providerId = 'provider_id';
  static String categoryId = 'category_id';
  static String subCategoryId = 'subcategory_id';
  static String type = 'type';
  static String price = 'price';
  static String discountPrice = 'discount';
  static String description = 'description';
  static String isFeatured = 'is_featured';
  static String isSlot = 'is_slot';
  static String status = 'status';
  static String duration = 'duration';
  static String attachmentCount = 'attachment_count';
  static String serviceAttachment = 'service_attachment_';
  static String providerAddressId = ' provider_address_id';
  static String attchments = 'attchments';
  static String visitType = 'visit_type';
  static String translations = 'translations';
  static String isServiceRequest = 'is_service_request';
}

class AddAddressKey {
  static String id = 'id';
  static String providerId = 'provider_id';
  static String latitude = 'latitude';
  static String longitude = 'longitude';
  static String status = 'status';
  static String address = 'address';
}

class AddDocument {
  static String documentId = 'document_id';
  static String isVerified = 'is_verified';
  static String providerDocument = 'provider_document';
}

class Subscription {
  static String planId = "plan_id";
  static String title = "title";
  static String identifier = "identifier";
  static String amount = "amount";
  static String type = "type";
  static String paymentType = "payment_type";
  static String txnId = "txn_id";
  static String paymentStatus = "payment_status";
  static String otherTransactionDetail = "other_transaction_detail";
}

class SaveBookingAttachment {
  static String title = 'title';
  static String description = 'description';
  static String bookingAttachment = 'booking_attachment_';
}

class SaveBidding {
  static String postRequestId = 'post_request_id';
  static String providerId = 'provider_id';
  static String price = 'price';
}

class PostJob {
  static String postRequestId = 'post_request_id';
  static String postTitle = 'title';
  static String description = 'description';
  static String serviceId = 'service_id';
  static String price = 'price';
  static String status = 'status';
  static String providerId = 'provider_id';
}

class PackageKey {
  static String packageId = "id";
  static String categoryId = 'category_id';
  static String subCategoryId = 'subcategory_id';
  static String name = "name";
  static String description = 'description';
  static String price = 'price';
  static String serviceId = 'service_id';
  static String startDate = "start_at";
  static String endDate = "end_at";
  static String status = 'status';
  static String isFeatured = 'is_featured';
  static String packageAttachment = 'package_attachment_';
  static String attachmentCount = 'attachment_count';
  static String packageType = 'package_type';
  static String removePackageAttachment = 'package_attachment';
}

class AddonServiceKey {
  static String addonId = "id";
  static String name = "name";
  static String serviceId = 'service_id';
  static String price = 'price';
  static String status = 'status';
  static String serviceAddonImage = 'serviceaddon_image';
}

class AddBlogKey {
  static String attachmentCount = 'attachment_count';
  static String blogAttachment = 'blog_attachment_';
  static String id = 'id';
  static String title = 'title';
  static String description = 'description';
  static String isFeatured = 'is_featured';
  static String status = 'status';
  static String providerId = 'provider_id';
  static String authorId = 'author_id';
  static String blogId = 'blog_id';
}

class AdvancePaymentKey {
  static String advancePaymentAmount = "advance_payment_amount"; // double value
  static String isEnableAdvancePayment = 'is_enable_advance_payment'; // 0/1
  static String advancePaymentSetting = 'advance_payment_setting'; // 0/1
  static String advancePaidAmount = 'advance_paid_amount'; // double value
}

class BankServiceKey {
  static String bankName = 'bank_name';
  static String branchName = 'branch_name';
  static String accountNo = 'account_no';
  static String ifscNo = 'ifsc_no';
  static String mobileNo = 'mobile_no';
  static String aadharNo = 'aadhar_no';
  static String panNo = 'pan_no';
  static String bankAttachment = 'bank_attachment';
  static String bankProfile = 'bank_profile';
}

class HelpDeskKey {
  static String helpDeskId = 'id';
  static String subject = 'subject';
  static String description = 'description';
  static String mode = 'mode';
  static String helpdeskAttachment = 'helpdesk_attachment_';
  static String helpdeskActivityAttachment = 'helpdesk_activity_attachment_';
  static String attachmentCount = 'attachment_count';
}


class CommissionKey {
  static String id = "id";
  static String name = "name";
  static String commission = "commission";
  static String type = "type";
  static String status = "status";
}

class PromotionalBannerKey {
  static String bannerId = 'banner_id';
  static String title = 'title';
  static String description = 'description';
  static String bannerType = 'banner_type';
  static String serviceId = 'service_id';
  static String bannerRedirectUrl = 'banner_redirect_url';
  static String startDate = 'start_date';
  static String endDate = 'end_date';
  static String totalAmount = 'total_amount';
  static String txnId = 'txn_id';
  static String paymentStatus = 'payment_status';
  static String paymentType = "payment_type";
  static String bannerAttachment = 'banner_attachment_';
  static String attachmentCount = 'attachment_count';
}


class ServiceRequestKey {
  static String serviceId = 'id';
  static String requestStatus = 'request_status';
  static String rejectReason = 'reject_reason';
  static String permanentlyDelete = 'permanently_delete';
  static String restore = 'restore';
  static String delete = 'delete';
  static String approve = 'approve';
  static String pending = 'pending';
  static String all = 'all';
  static String reject = 'reject';
}