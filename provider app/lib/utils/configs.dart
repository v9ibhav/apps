import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

const APP_NAME = 'Homicon Provider';
const DEFAULT_LANGUAGE = 'en';

const primaryColor = Color(0xFF5F60B9);

/// Live Url
const DOMAIN_URL = "http://13.203.198.78";


const BASE_URL = "$DOMAIN_URL/api/";

/// You can specify in Admin Panel, These will be used if you don't specify in Admin Panel
const IOS_LINK_FOR_PARTNER = "https://apps.apple.com/";
const TERMS_CONDITION_URL = 'http://13.203.198.78/term-conditions/';
const PRIVACY_POLICY_URL = 'http://13.203.198.78/privacy-policy/';
const HELP_AND_SUPPORT_URL = 'http://13.203.198.78/help-support/';
const REFUND_POLICY_URL = 'http://13.203.198.78/refund-policy/';
const INQUIRY_SUPPORT_EMAIL = 'support@homicon.in';

/// You can add help line number here for contact. It's demo number
const HELP_LINE_NUMBER = '+917905801644';

//Airtel Money Payments
///It Supports ["UGX", "NGN", "TZS", "KES", "RWF", "ZMW", "CFA", "XOF", "XAF", "CDF", "USD", "XAF", "SCR", "MGA", "MWK"]
const AIRTEL_CURRENCY_CODE = "MWK";
const AIRTEL_COUNTRY_CODE = "MW";
const AIRTEL_TEST_BASE_URL = 'https://openapiuat.airtel.africa/'; //Test Url
const AIRTEL_LIVE_BASE_URL = 'https://openapi.airtel.africa/'; // Live Url

/// PAYSTACK PAYMENT DETAIL
const PAYSTACK_CURRENCY_CODE = 'NGN';

/// SADAD PAYMENT DETAIL
const SADAD_API_URL = 'https://api-s.sadad.qa';
const SADAD_PAY_URL = "https://d.sadad.qa";

/// RAZORPAY PAYMENT DETAIL
const RAZORPAY_CURRENCY_CODE = 'INR';

/// PAYPAL PAYMENT DETAIL
const PAYPAL_CURRENCY_CODE = 'USD';

/// STRIPE PAYMENT DETAIL
const STRIPE_MERCHANT_COUNTRY_CODE = 'IN';
const STRIPE_CURRENCY_CODE = 'INR';

Country defaultCountry() {
  return Country(
    phoneCode: '91',
    countryCode: 'IN',
    e164Sc: 91,
    geographic: true,
    level: 1,
    name: 'India',
    example: '9123456789',
    displayName: 'India (IN) [+91]',
    displayNameNoCountryCode: 'India (IN)',
    e164Key: '91-IN-0',
    fullExampleWithPlusSign: '+919123456789',
  );
}

//Chat Module File Upload Configs
const chatFilesAllowedExtensions = [
  'jpg', 'jpeg', 'png', 'gif', 'webp', // Images
  'pdf', 'txt', // Documents
  'mkv', 'mp4', // Video
  'mp3', // Audio
];
const max_acceptable_file_size = 5; //Size in Mb