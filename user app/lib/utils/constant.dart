import 'package:nb_utils/nb_utils.dart';

/// DO NOT CHANGE THIS PACKAGE NAME
var appPackageName = isAndroid ? 'com.homicon.user' : 'com.iqonic.user';

//region Custom Headers
 class CustomHeader {
 static const LanguageCode = 'language-code';
 }
 //endregion

//region Common Configs
const DEFAULT_FIREBASE_PASSWORD = '12345678';
const DECIMAL_POINT = 2;
const PER_PAGE_ITEM = 20;
const PER_PAGE_CATEGORY_ITEM = 50;
const LABEL_TEXT_SIZE = 14;
const double SETTING_ICON_SIZE = 18;
const double CATEGORY_ICON_SIZE = 70;
const double SUBCATEGORY_ICON_SIZE = 45;
const APP_BAR_TEXT_SIZE = 18;
const MARK_AS_READ = 'markas_read';
const IS_CURRENT_LOCATION = 'CURRENT_LOCATION';
const GET_LOCATION_API_TIMEOUT_SECOND = 15;

//region Dashboard Type
const DEFAULT_USER_DASHBOARD = 'dashboard';
const DASHBOARD_1 = 'dashboard_1';
const DASHBOARD_2 = 'dashboard_2';
const DASHBOARD_3 = 'dashboard_3';
const DASHBOARD_4 = 'dashboard_4';
//end region

// region Default values
const DISPLAY_DATE_FORMAT = 'MMMM d, y';
const DISPLAY_TIME_FORMAT = 'h:mm a';
//endregion

const USER_APP_TAG = 'userApp';
const PER_PAGE_CHAT_LIST_COUNT = 50;

const USER_NOT_CREATED = "User not created";
const USER_CANNOT_LOGIN = "User can't login";
const USER_NOT_FOUND = "User not found";

const BOOKING_TYPE_ALL = 'all';
const CATEGORY_LIST_ALL = "all";

const BOOKING_TYPE_USER_POST_JOB = 'user_post_job';
const BOOKING_TYPE_SERVICE = 'service';

const DONE = 'Done';
const SERVICE = 'service';
const PROMOTIONAL_TYPE_LINK = 'link';

const PAYMENT_STATUS_PAID = 'paid';
const PAYMENT_STATUS_DEBIT = 'debit';

const NOTIFICATION_TYPE_BOOKING = 'booking';
const NOTIFICATION_TYPE_POST_JOB = 'post_Job';
const NOTIFICATION_TYPE_WALLET = 'update_wallet';
const SERVICE_ATTACHMENT = 'service_attachment';
const IS_EMAIL_VERIFIED = 'IS_EMAIL_VERIFIED';

// Types for user list API
const FILTER_PROVIDER = 'filter_provider';
//

// region navigationType

const WALLET = 'wallet';
const BOOKING = 'booking';
const PROVIDER_SEND_BID = 'provider_send_bid';

//endregion

//region LIVESTREAM KEYS
const LIVESTREAM_UPDATE_BOOKING_LIST = "UpdateBookingList";
const LIVESTREAM_UPDATE_SERVICE_LIST = "LIVESTREAM_UPDATE_SERVICE_LIST";
const LIVESTREAM_UPDATE_DASHBOARD = "streamUpdateDashboard";
const LIVESTREAM_START_TIMER = "startTimer";
const LIVESTREAM_PAUSE_TIMER = "pauseTimer";
const LIVESTREAM_UPDATE_BIDER = 'updateBiderData';
const LIVESTREAM_FIREBASE = "LIVESTREAM_FIREBASE";
const LIVESTREAM_UPDATE_HELP_DESK_LIST = "LIVESTREAM_UPDATE_HELP_DESK_LIST";
//endregion

//region default USER login
const DEFAULT_EMAIL = 'demo@user.com';
const DEFAULT_PASS = '12345678';
//endregion

//region THEME MODE TYPE
const THEME_MODE_LIGHT = 0;
const THEME_MODE_DARK = 1;
const THEME_MODE_SYSTEM = 2;
//endregion

//region SHARED PREFERENCES KEYS
const IS_FIRST_TIME = 'IsFirstTime';
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const USER_ID = 'USER_ID';
const FIRST_NAME = 'FIRST_NAME';
const LAST_NAME = 'LAST_NAME';
const USER_EMAIL = 'USER_EMAIL';
const USER_PASSWORD = 'USER_PASSWORD';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const IS_REMEMBERED = "IS_REMEMBERED";
const TOKEN = 'TOKEN';
const USERNAME = 'USERNAME';
const DISPLAY_NAME = 'DISPLAY_NAME';
const CONTACT_NUMBER = 'CONTACT_NUMBER';
const COUNTRY_ID = 'COUNTRY_ID';
const STATE_ID = 'STATE_ID';
const CITY_ID = 'CITY_ID';
const ADDRESS = 'ADDRESS';
const UID = 'UID';
const LATITUDE = 'LATITUDE';
const LONGITUDE = 'LONGITUDE';
const CURRENT_ADDRESS = 'CURRENT_ADDRESS';
const CITY_NAME = 'CITY_NAME';
const LOGIN_TYPE = 'LOGIN_TYPE';
const USER_TYPE = 'USER_TYPE';
const HOUR_FORMAT_STATUS = 'HOUR_FORMAT_STATUS';
const USER_CHANGE_LOG = 'userChangeLog';
const PERMISSION_STATUS = 'permissionStatus';

const USE_MATERIAL_YOU_THEME = 'USE_MATERIAL_YOU_THEME';
const HAS_IN_APP_STORE_REVIEW = 'hasInAppStoreReview1';
const HAS_IN_PLAY_STORE_REVIEW = 'hasInPlayStoreReview1';
const HAS_IN_REVIEW = 'hasInReview';
const AUTO_SLIDER_STATUS = 'AUTO_SLIDER_STATUS';
const UPDATE_NOTIFY = 'UPDATE_NOTIFY';

const APPLE_EMAIL = 'APPLE_EMAIL';
const APPLE_UID = 'APPLE_UID';
const APPLE_GIVE_NAME = 'APPLE_GIVE_NAME';
const APPLE_FAMILY_NAME = 'APPLE_FAMILY_NAME';

const BOOKING_ID_CLOSED_ = 'BOOKING_ID_CLOSED_';
const LAST_APP_CONFIGURATION_SYNCED_TIME = 'LAST_APP_CONFIGURATION_SYNCED_TIME';
const IS_APP_CONFIGURATION_SYNCED_AT_LEAST_ONCE = 'IS_APP_CONFIGURATION_SYNCED_AT_LEAST_ONCE';
const LAST_USER_DETAILS_SYNCED_TIME = 'LAST_USER_DETAILS_SYNCED_TIME';
const IS_SUBSCRIBED_FOR_PUSH_NOTIFICATION = 'IS_SUBSCRIBED_FOR_PUSH_NOTIFICATION';
const IS_HELP_DESK_FIRST_TIME = 'IS_HELP_DESK_FIRST_TIME';
//endregion

const ADD_BOOKING = 'add_booking';
const ASSIGNED_BOOKING = 'assigned_booking';
const TRANSFER_BOOKING = 'transfer_booking';
const UPDATE_BOOKING_STATUS = 'update_booking_status';
const CANCEL_BOOKING = 'cancel_booking';
const PAYMENT_MESSAGE_STATUS = 'payment_message_status';
const PROMOTIONAL_BANNER_STATUS = 'promotional_banner';

//region CURRENCY POSITION
const CURRENCY_POSITION_LEFT = 'left';
const CURRENCY_POSITION_RIGHT = 'right';
//endregion

//region User Types
const USER_TYPE_PROVIDER = 'provider';
const USER_TYPE_HANDYMAN = 'handyman';
const USER_TYPE_USER = 'user';
//endregion

//region LOGIN TYPE
const LOGIN_TYPE_USER = 'user';
const LOGIN_TYPE_GOOGLE = 'google';
const LOGIN_TYPE_OTP = 'mobile';
const LOGIN_TYPE_APPLE = 'apple';
//endregion

//region SERVICE TYPE
const SERVICE_TYPE_FIXED = 'fixed';
const SERVICE_TYPE_PERCENT = 'percent';
const SERVICE_TYPE_HOURLY = 'hourly';
const SERVICE_TYPE_FREE = 'free';
//endregion

//region TAX TYPE
const TAX_TYPE_FIXED = 'fixed';
const TAX_TYPE_PERCENT = 'percent';
//endregion

//region COUPON TYPE
const COUPON_TYPE_FIXED = 'fixed';
const COUPON_TYPE_PERCENT = 'percentage';
//endregion

//region Visit Type
const VISIT_OPTION_ON_SITE = 'on_site';
const VISIT_OPTION_ONLINE = 'online';
// endregion

//region PAYMENT METHOD
const PAYMENT_METHOD_COD = 'cash';
const PAYMENT_METHOD_FROM_WALLET = 'wallet';
const PAYMENT_METHOD_STRIPE = 'stripe';
const PAYMENT_METHOD_RAZOR = 'razorPay';
const PAYMENT_METHOD_FLUTTER_WAVE = 'flutterwave';
const PAYMENT_METHOD_CINETPAY = 'cinet';
const PAYMENT_METHOD_SADAD_PAYMENT = 'sadad';
const PAYMENT_METHOD_PAYPAL = 'paypal';
const PAYMENT_METHOD_PAYSTACK = 'paystack';
const PAYMENT_METHOD_AIRTEL = 'airtel';
const PAYMENT_METHOD_PHONEPE = 'phonepe';
const PAYMENT_METHOD_PIX = 'PIX';
const PAYMENT_METHOD_MIDTRANS = 'midtrans';
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

//region SERVICE PAYMENT STATUS
const SERVICE_PAYMENT_STATUS_PAID = 'paid';
const PENDING_BY_ADMIN = 'pending_by_admin';
const SERVICE_PAYMENT_STATUS_ADVANCE_PAID = 'advanced_paid';
const SERVICE_PAYMENT_STATUS_PENDING = 'pending';
const SERVICE_PAYMENT_STATUS_ADVANCE_REFUND = 'Advanced Refund';
//endregion

//region FireBase Collection Name
const MESSAGES_COLLECTION = "messages";
const USER_COLLECTION = "users";
const CONTACT_COLLECTION = "contact";
const CHAT_FILES = "chat_files";

const IS_ENTER_KEY = "IS_ENTER_KEY";
const SELECTED_WALLPAPER = "SELECTED_WALLPAPER";
const PER_PAGE_CHAT_COUNT = 50;
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
//endregion

//region FILE TYPE
const TEXT = "TEXT";
const IMAGE = "IMAGE";

const VIDEO = "VIDEO";
const AUDIO = "AUDIO";
//endregion

//region CHAT LANGUAGE
const List<String> RTL_LanguageS = ['ar', 'ur'];
//endregion

//region Gallery File Types
enum GalleryFileTypes { CANCEL, CAMERA, GALLERY }
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

//region DateFormat
const DATE_FORMAT_1 = 'dd-MMM-yyyy hh:mm a';
const DATE_FORMAT_2 = 'd MMM, yyyy';
const DATE_FORMAT_3 = 'dd-MMM-yyyy';
const HOUR_12_FORMAT = 'hh:mm a';
const DATE_FORMAT_4 = 'dd MMM';
const DATE_FORMAT_7 = 'yyyy-MM-dd';
const DATE_FORMAT_8 = 'd MMM, yyyy hh:mm a';
const YEAR = 'yyyy';
const BOOKING_SAVE_FORMAT = "yyyy-MM-dd kk:mm:ss";
const DATE_FORMAT_9 = "dd/MM/yyyy";
const DATE_FORMAT_10 = "dd/MM/yyyy, hh:mm a";
//endregion

//region Mail And Tel URL
const MAIL_TO = 'mailto:';
const TEL = 'tel:';
const GOOGLE_MAP_PREFIX = 'https://www.google.com/maps/search/?api=1&query=';

//endregion

SlideConfiguration sliderConfigurationGlobal = SlideConfiguration(duration: 400.milliseconds, delay: 50.milliseconds);

// region JOB REQUEST STATUS
const JOB_REQUEST_STATUS_REQUESTED = "requested";
const JOB_REQUEST_STATUS_ACCEPTED = "accepted";
const JOB_REQUEST_STATUS_ASSIGNED = "assigned";
// endregion

const INACTIVE = 'Inactive';
const ACTIVE = 'Active';

// region Help Desk Status
const OPEN = 'open';
const CLOSED = 'closed';
const ADD_HELP_DESK = 'add_helpdesk';
const REPLIED_HELP_DESK = 'replied_helpdesk';
const CLOSED_HELP_DESK = 'closed_helpdesk';

// region Booking Filter Section Type
const DATE_RANGE = 'date_range';
const PROVIDER = 'provider';
const HANDYMAN = 'handyman';
const BOOKING_STATUS = 'booking_status';
const PAYMENT_TYPE = 'payment_type';
const PAYMENT_STATUS = 'payment_status';