import 'dart:convert';

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
      stripeUrl: json['stripe_url'] ?? '',
      stripeKey: json['stripe_key'] ?? '',
      stripePublickey: json['stripe_publickey'] ?? '',
      razorUrl: json['razor_url'] ?? '',
      razorKey: json['razor_key'] ?? '',
      razorSecret: json['razor_secret'] ?? '',
      flutterwavePublic: json['flutterwave_public'] ?? '',
      flutterwaveSecret: json['flutterwave_secret'] ?? '',
      flutterwaveEncryption: json['flutterwave_encryption'] ?? '',
      payPalClientId: json['paypal_client_id'] ?? '',
      payPalSecretKey: json['paypal_secret_key'] ?? '',
      sadadId: json['sadad_id'] ?? '',
      sadadKey: json['sadad_key'] ?? '',
      sadadDomain: json['sadad_domain'] ?? '',
      cinetId: json['cinet_id'] ?? '',
      cinetKey: json['cinet_key'] ?? '',
      cinetPublicKey: json['cinet_publickey'] ?? '',
      airtelClientId: json['client_id'] is String ? json['client_id'] : "",
      airtelSecretKey: json['secret_key'] is String ? json['secret_key'] : "",
      phonePeAppID: json['app_id'] is String ? json['app_id'] : "",
      phonePeMerchantID: json['merchant_id'] is String ? json['merchant_id'] : "",
      phonePeSaltKey: json['salt_key'] is String ? json['salt_key'] : "",
      phonePeSaltIndex: json["salt_index"] is String ? json["salt_index"] : "1",
      paystackPublicKey: json['paystack_public'] is String ? json['paystack_public'] : "",
      midtransClientId: json['client_id'] ?? '',
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
