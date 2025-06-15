import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

/// DO NOT CHANGE THIS PACKAGE NAME
const APP_PACKAGE_NAME = "com.homicon.provider";

//region Custom Headers
 class CustomHeader {
 static const LanguageCode = 'language-code';
 }
 //endregion

//region Configs
const DECIMAL_POINT = 2;
const PER_PAGE_ITEM = 25;
const PER_PAGE_ITEM_ALL = 'all';
const PLAN_REMAINING_DAYS = 15;
const LABEL_TEXT_SIZE = 14;
const APP_BAR_TEXT_SIZE = 18;
const List<String> RTL_LANGUAGES = ['ar', 'ur'];
const GET_LOCATION_API_TIMEOUT_SECOND = 15;

//endregion

// region Default values
const DISPLAY_DATE_FORMAT = 'MMMM d, y';
const DISPLAY_TIME_FORMAT = 'h:mm a';
//endregion

// region For Stripe Payment
const STRIPE_CURRENCY_CODE = 'INR';
//endregion

//region Commission Types
const COMMISSION_TYPE_PERCENT = 'percent';
const COMMISSION_TYPE_FIXED = 'fixed';
const COMMISSION_TYPE_PERCENTAGE = 'percentage';
//endregion

const TAX_TYPE_PERCENT = 'percent';

//region Discount Type
const DISCOUNT_TYPE_FIXED = 'fixed';
//endregion

//region LiveStream Keys
const LIVESTREAM_UPDATE_BOOKINGS = 'LiveStreamUpdateBookings';
const LIVESTREAM_HANDY_BOARD = 'HandyBoardStream';
const LIVESTREAM_HANDYMAN_ALL_BOOKING = "handymanAllBooking";
const LIVESTREAM_PROVIDER_ALL_BOOKING = "providerAllBooking";
const LIVESTREAM_START_TIMER = "startTimer";
const LIVESTREAM_PAUSE_TIMER = "pauseTimer";
const LIVESTREAM_UPDATE_NOTIFICATIONS = "LIVESTREAM_UPDATE_NOTIFICATIONS";
const LIVESTREAM_UPDATE_BOOKING_STATUS_WISE = "LIVESTREAM_UPDATE_BOOKING_STATUS_WISE";
const LIVESTREAM_CHANGE_HANDYMAN_TAB = "LIVESTREAM_CHANGE_HANDYMAN_TAB";
const LIVESTREAM_UPDATE_HELP_DESK_LIST = "LIVESTREAM_UPDATE_HELP_DESK_LIST";
//endregion

//region Theme Mode Type
const THEME_MODE_LIGHT = 0;
const THEME_MODE_DARK = 1;
const THEME_MODE_SYSTEM = 2;
//endregion

//region Tags for Firebase
const PROVIDER_APP_TAG = 'providerApp';
const HANDYMAN_APP_TAG = 'handymanApp';
//endregion

// region JOB REQUEST STATUS
const JOB_REQUEST_STATUS_REQUESTED = "requested";
const JOB_REQUEST_STATUS_ACCEPTED = "accepted";
const JOB_REQUEST_STATUS_ASSIGNED = "assigned";
// endregion

const BOOKING_TYPE_USER_POST_JOB = 'user_post_job';
const BOOKING_TYPE_SERVICE = 'service';

const BOOKING_SAVE_FORMAT = "yyyy-MM-dd kk:mm:ss";

//region SharedPreferences Keys
const IS_FIRST_TIME = 'IsFirstTime';
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const IS_TESTER = 'IS_TESTER';
const USER_ID = 'USER_ID';
const USER_TYPE = 'USER_TYPE';
const FIRST_NAME = 'FIRST_NAME';
const LAST_NAME = 'LAST_NAME';
const USER_EMAIL = 'USER_EMAIL';
const USER_PASSWORD = 'USER_PASSWORD';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const HOUR_FORMAT_STATUS = 'HOUR_FORMAT_STATUS';
const IS_REMEMBERED = "IS_REMEMBERED";
const TOKEN = 'TOKEN';
const USERNAME = 'USERNAME';
const CONTACT_NUMBER = 'CONTACT_NUMBER';
const COUNTRY_ID = 'COUNTRY_ID';
const STATE_ID = 'STATE_ID';
const CITY_ID = 'CITY_ID';
const ADDRESS = 'ADDRESS';
const UID = 'UID';
const SERVICE_ADDRESS_ID = 'SERVICE_ADDRESS_ID';
const PROVIDER_ID = 'PROVIDER_ID';
const TOTAL_BOOKING = 'total_booking';
const COMPLETED_BOOKING = 'total_booking';
const CREATED_AT = 'created_at';
const IS_PLAN_SUBSCRIBE = 'IS_PLAN_SUBSCRIBE';
const PLAN_TITLE = 'PLAN_TITLE';
const PLAN_END_DATE = 'PLAN_END_DATE';
const PLAN_IDENTIFIER = 'PLAN_IDENTIFIER';
const HAS_IN_APP_STORE_REVIEW = 'hasInAppStoreReview1';
const HAS_IN_PLAY_STORE_REVIEW = 'hasInPlayStoreReview1';
const HAS_IN_REVIEW = 'hasInReview';
const HANDYMAN_AVAILABLE_STATUS = 'HANDYMAN_AVAILABLE_STATUS';
const DESIGNATION = 'DESIGNATION';
const UPDATE_NOTIFY = 'UPDATE_NOTIFY';
const FOR_ALL_SERVICES = 'FOR_ALL_SERVICES';
const SADAD_PAYMENT_ACCESS_TOKEN = 'SADAD_PAYMENT_ACCESS_TOKEN';
const DASHBOARD_COMMISSION = 'DASHBOARD_COMMISSION';
const IS_EMAIL_VERIFIED = 'IS_EMAIL_VERIFIED';
const LAST_APP_CONFIGURATION_SYNCED_TIME = 'LAST_APP_CONFIGURATION_SYNCED_TIME';
const CATEGORY_BASED_SELECT_PACKAGE_SERVICE = 'CATEGORY_BASED_SELECT_PACKAGE_SERVICE';
const IS_APP_CONFIGURATION_SYNCED_AT_LEAST_ONCE = 'IS_APP_CONFIGURATION_SYNCED_AT_LEAST_ONCE';
const IS_SUBSCRIBED_FOR_PUSH_NOTIFICATION = 'IS_SUBSCRIBED_FOR_PUSH_NOTIFICATION';
const PERMISSION_STATUS = 'permissionStatus';
const BANK_IMAGE = 'BANK_IMAGE';
const IS_HELP_DESK_FIRST_TIME = 'IS_HELP_DESK_FIRST_TIME';

///IN APP PURCHASE
const IS_IN_APP_PURCHASE_ENABLE = 'IS_IN_APP_PURCHASE_ENABLE';
const HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE = 'HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE';
const HAS_IN_REVENUE_CAT_LOGIN_DONE_LEASE_ONCE = 'HAS_IN_REVENUE_CAT_LOGIN_DONE_LEASE_ONCE';
const IN_APP_PURCHASE_GOOGLE_API_KEY = 'IN_APP_PURCHASE_GOOGLE_API_KEY';
const IN_APP_PURCHASE_APPLE_API_KEY = 'IN_APP_PURCHASE_APPLE_API_KEY';
const IN_APP_PURCHASE_ENTITLEMENT_IDENTIFIER = 'IN_APP_PURCHASE_ENTITLEMENT_IDENTIFIER';
const ACTIVE_IN_APP_PURCHASE_IDENTIFIER = 'ACTIVE_IN_APP_PURCHASE_IDENTIFIER';
const ACTIVE_SUBSCRIPTION_PLAN = 'ACTIVE_SUBSCRIPTION_PLAN';
const IS_RESTORE_PURCHASE_REQUIRED = 'IS_RESTORE_PURCHASE_REQUIRED';
const HAS_PURCHASE_STORED = 'HAS_PURCHASE_STORED';
const PURCHASE_REQUEST = 'PURCHASE_REQUEST';
const PROMOTIONAL_BANNER_STATUS = 'promotional_banner';

//endregion

const INACTIVE = 'Inactive';
const ACTIVE = 'Active';
const ONLINE = 'Online';
const OFFLINE = 'Offline';
const CATEGORY_TYPE_ALL = 'all';

const BLOG_ATTACHMENT = 'blog_attachment';

const ACCEPTED = 'ACCEPTED';
const REFUSED = 'REFUSED';

//region CURRENCY POSITION
const CURRENCY_POSITION_LEFT = 'left';
const CURRENCY_POSITION_RIGHT = 'right';
//endregion

//region  Login Type
const USER_TYPE_PROVIDER = 'provider';
const USER_TYPE_HANDYMAN = 'handyman';
const IS_USER = 'user';
const USER_STATUS_CODE = 1;
//endregion

// region Package Type
const PACKAGE_TYPE_SINGLE = 'single';
const PACKAGE_TYPE_MULTIPLE = 'multiple';
//endregion

//region Notification
const MARK_AS_READ = 'markas_read';
const NOTIFICATION_TYPE_BOOKING = 'booking';
const NOTIFICATION_TYPE_POST_JOB = 'post_job';

const ADD_BOOKING = 'add_booking';
const ASSIGNED_BOOKING = 'assigned_booking';
const TRANSFER_BOOKING = 'transfer_booking';
const UPDATE_BOOKING_STATUS = 'update_booking_status';
const CANCEL_BOOKING = 'cancel_booking';
const PAID_FOR_BOOKING = 'paid_for_booking';
const PROVIDER_PAYOUT = 'provider_payout';
const HANDYMAN_PAYOUT = 'handyman_payout';

const PAYMENT_MESSAGE_STATUS = 'payment_message_status';
const JOB_REQUESTED = 'job_requested';
const USER_ACCEPT_BID = 'user_accept_bid';
const PROVIDER_SEND_BID = 'provider_send_bid';
const SUBSCRIPTION_ADD = 'subscription_add';
const RESGISTER = 'resgister';

//endregion

// region navigationType

const WALLET = 'wallet';
const PAYOUT = 'payout';
const BOOKING = 'booking';
const POSTJOB = 'postjob';
const USER_DETAIL = 'register';
const SERVICE_REQUEST_APPROVE = 'service_request_approved';
const SERVICE_REQUEST_REJECT = 'service_request_reject';

//endregion

//region SERVICE TYPE

const SERVICE_TYPE_HOURLY = 'hourly';
const SERVICE_TYPE_FIXED = 'fixed';
const SERVICE_TYPE_FREE = 'free';
//endregion

enum GalleryFileTypes { CANCEL, CAMERA, GALLERY }

//region Errors
const USER_NOT_CREATED = "User not created";
const USER_CANNOT_LOGIN = "User can't login";
const USER_NOT_FOUND = "User Not Found";
//endregion

//region service payment status
const PAID = 'paid';
const PENDING = 'pending';
const PENDING_BY_ADMINS = 'pending_by_admin';

const SERVICE_PAYMENT_STATUS_PAID = 'paid';
const SERVICE_PAYMENT_STATUS_ADVANCE_PAID = 'advanced_paid';
//endregion

//region ProviderStore
const RESTORE = "restore";
const FORCE_DELETE = "forcedelete";
//endregion

//region default handyman login
const DEFAULT_PROVIDER_EMAIL = 'demo@provider.com';
const DEFAULT_HANDYMAN_EMAIL = 'demo@handyman.com';
const DEFAULT_PASS = '12345678';
const DEFAULT_PASSWORD_FOR_FIREBASE = '12345678';
//endregion

//region Mail And Tel URL
const MAIL_TO = 'mailto:';
const TEL = 'tel:';
//endregion

//region FireBase Collection Name
const MESSAGES_COLLECTION = "messages";
const USER_COLLECTION = "users";
const CONTACT_COLLECTION = "contact";
const CHAT_FILES = "chat_files";

const IS_ENTER_KEY = "IS_ENTER_KEY";
const SELECTED_WALLPAPER = "SELECTED_WALLPAPER";
const SELECT_SUBCATEGORY = "SELECT_SUBCATEGORY";
const SELECT_USER_TYPE = "SELECT_USER_TYPE";
const PER_PAGE_CHAT_COUNT = 50;
const PER_PAGE_CHAT_LIST_COUNT = 10;

const TEXT = "TEXT";
const IMAGE = "IMAGE";

const VIDEO = "VIDEO";
const AUDIO = "AUDIO";
//endregion

//region MessageType
enum MessageType {
  TEXT,
  IMAGE,
  VIDEO,
  AUDIO,
  Files,
}
//endregion

//region BOOKING STATUS
const BOOKING_PAYMENT_STATUS_ALL = 'all';
const BOOKING_STATUS_PENDING = 'pending';
const BOOKING_STATUS_ACCEPT = 'accept';
const BOOKING_STATUS_ON_GOING = 'on_going';
const BOOKING_STATUS_IN_PROGRESS = 'in_progress';
const BOOKING_STATUS_HOLD = 'hold';
const BOOKING_STATUS_CANCELLED = 'cancelled';
const BOOKING_STATUS_REJECTED = 'rejected';
const BOOKING_STATUS_FAILED = 'failed';
const BOOKING_STATUS_COMPLETED = 'completed';
const BOOKING_STATUS_PENDING_APPROVAL = 'pending_approval';
const BOOKING_STATUS_WAITING_ADVANCED_PAYMENT = 'waiting';
const BOOKING_STATUS_PAID = 'paid';
const PAYMENT_STATUS_ADVANCE = 'advanced_paid';
const SERVICE_PAYMENT_STATUS_ADVANCE_REFUND = 'Advanced Refund';
//endregion

//region PAYMENT METHOD
const PAYMENT_METHOD_COD = 'cash';
const PAYMENT_METHOD_STRIPE = 'stripe';
const PAYMENT_METHOD_RAZOR = 'razorPay';
const PAYMENT_METHOD_FLUTTER_WAVE = 'flutterwave';
const PAYMENT_METHOD_CINETPAY = 'cinet';
const PAYMENT_METHOD_SADAD_PAYMENT = 'sadad';
const PAYMENT_METHOD_FROM_WALLET = 'wallet';
const PAYMENT_METHOD_PAYPAL = 'paypal';
const PAYMENT_METHOD_PAYSTACK = 'paystack';
const PAYMENT_METHOD_AIRTEL = 'airtel';
const PAYMENT_METHOD_PHONEPE = 'phonepe';
const PAYMENT_METHOD_PIX = 'PIX';
const PAYMENT_METHOD_MIDTRANS = 'midtrans';
const PAYMENT_METHOD_IN_APP_PURCHASE = 'PAYMENT_IN_APP_PURCHASE';
const PAYMENT_METHOD_BANK = 'bank';

const List<String> onlinePaymentGateways = [
  PAYMENT_METHOD_STRIPE,
  PAYMENT_METHOD_RAZOR,
  PAYMENT_METHOD_FLUTTER_WAVE,
  PAYMENT_METHOD_CINETPAY,
  PAYMENT_METHOD_SADAD_PAYMENT,
  PAYMENT_METHOD_PAYPAL,
  PAYMENT_METHOD_PAYSTACK,
  PAYMENT_METHOD_AIRTEL,
  PAYMENT_METHOD_PHONEPE,
  PAYMENT_METHOD_PIX,
  PAYMENT_METHOD_MIDTRANS,
];
//endregion

//region DateFormat
const DATE_FORMAT_1 = 'M/d/yyyy';
const DATE_FORMAT_2 = 'd MMM, yyyy';
const DATE_FORMAT_3 = 'hh:mm a';
const DATE_FORMAT_4 = 'dd MMM';
const DATE_FORMAT_5 = 'yyyy';
const DATE_FORMAT_6 = 'd MMMM, yyyy';
const DATE_FORMAT_7 = 'yyyy-MM-dd';
const DATE_FORMAT_8 = 'HH:mm';
const DATE_FORMAT_9 = 'd MMM, yyyy hh:mm a';
const DATE_FORMAT_10 = "dd/MM/yyyy";
const DATE_FORMAT_11 = "dd/MM/yyyy, hh:mm a";
//endregion

//region SUBSCRIPTION PAYMENT STATUS
const SUBSCRIPTION_STATUS_ACTIVE = 'active';
const SUBSCRIPTION_STATUS_INACTIVE = 'inactive';
//endregion

//region EARNING TYPE
const EARNING_TYPE = 'EARNING_TYPE';
const EARNING_TYPE_COMMISSION = 'commission';
const EARNING_TYPE_SUBSCRIPTION = 'subscription';
const FREE = 'free';
//endregion

//region WALLET TYPE
const ADD_WALLET = 'add_wallet';
const UPDATE_WALLET = 'update_wallet';
const WALLET_PAYOUT_TRANSFER = 'wallet_payout_transfer';
const WALLET_TOP_UP = 'wallet_top_up';
const WALLET_REFUND = 'wallet_refund';

//endregion

//region Visit Type
const VISIT_OPTION_ON_SITE = 'on_site';
const VISIT_OPTION_ONLINE = 'online';
// endregion

const GOOGLE_MAP_PREFIX = 'https://www.google.com/maps/search/?api=1&query=';

List<String> daysList = [
  languages.mon,
  languages.tue,
  languages.wed,
  languages.thu,
  languages.fri,
  languages.sat,
  languages.sun,
];

List<String> months = [
  languages.jan,
  languages.feb,
  languages.mar,
  languages.apr,
  languages.may,
  languages.jun,
  languages.july,
  languages.aug,
  languages.sept,
  languages.oct,
  languages.nov,
  languages.dec,
];

Map<String, String> dayListMap = {
  languages.mon: "mon",
  languages.tue: "tue",
  languages.wed: "wed",
  languages.thu: "thu",
  languages.fri: "fri",
  languages.sat: "sat",
  languages.sun: "sun",
};

const PAYMENT_STATUS_PAID = 'paid';
const PAYMENT_STATUS_PENDING = 'pending';
const PAYMENT_STATUS_DEBIT = 'debit';

// region Help Desk Status
const OPEN = 'open';
const CLOSED = 'closed';
const ADD_HELP_DESK = 'add_helpdesk';
const REPLIED_HELP_DESK = 'replied_helpdesk';
const CLOSED_HELP_DESK = 'closed_helpdesk';

// region Promotional Banner Status
const PROMOTIONAL_BANNER_ALL = 'all';
const PROMOTIONAL_BANNER_ACCEPTED = 'accepted';
const PROMOTIONAL_BANNER_PENDING = 'pending';
const PROMOTIONAL_BANNER_REJECT = 'rejected';

//region PROMOTIONAL TYPE
const PROMOTIONAL_TYPE_SERVICE = 'service';
const PROMOTIONAL_TYPE_LINK = 'link';
//endregion

// region Service Approval Status
const SERVICE_ALL = 'all';
const SERVICE_PENDING = 'pending';
const SERVICE_REJECT = 'reject';
const SERVICE_APPROVE = 'approve';

// region Booking Filter Section Type
const SERVICE_FILTER = 'service';
const DATE_RANGE = 'date_range';
const CUSTOMER = 'customer';
// const PROVIDER = 'provider';
// const HANDYMAN = 'handyman';
const BOOKING_STATUS = 'booking_status';
const PAYMENT_TYPE = 'payment_type';
const PAYMENT_STATUS = 'payment_status';

SlideConfiguration sliderConfigurationGlobal = SlideConfiguration(duration: 400.milliseconds, delay: 50.milliseconds);