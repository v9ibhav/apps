class UpiApps {
  String? name;
  String? imagePath;
  String? packageName;

  UpiApps({this.name, this.imagePath, this.packageName});

  List<Map<String, String>> upiAppList = [
    {"name": "PhonePe", "image": "assets/icons/upi_payment/phonepe-icon.webp", "packageName": "com.phonepe.app"},
    {"name": "Freecharge", "image": "assets/icons/upi_payment/freecharge.png", "packageName": "com.freecharge.android"},
    {"name": "Paytm", "image": "assets/icons/upi_payment/paytm.png", "packageName": "net.one97.paytm"},
    {"name": "BHIM", "image": "assets/icons/upi_payment/bhmin.webp", "packageName": "in.org.npci.upiapp"},
    {"name": "MobiKwik", "image": "assets/icons/upi_payment/mobikwik.webp", "packageName": "com.mobikwik_new"},
    {"name": "Google Pay", "image": "assets/icons/upi_payment/gpay.webp", "packageName": "com.google.android.apps.nbu.paisa.user"},
    {"name": "Axis Pay", "image": "assets/icons/upi_payment/axis_pay.webp", "packageName": "com.upi.axispay"},
    {"name": "BOB UPI", "image": "assets/icons/upi_payment/bob_upi.webp", "packageName": "com.bankofbaroda.upi"},
    {"name": "Amazon Pay", "image": "assets/icons/upi_payment/Amazon_pay.png", "packageName": "com.amazon.in.payments.merchant.app.android"},
    {"name": "Cred", "image": "assets/icons/upi_payment/cred.webp", "packageName": "com.dreamplug.androidapp"},
  ];
}

class UpiResponse {
  String? packageName;
  String? applicationName;
  String? version;

  UpiResponse({this.packageName, this.applicationName, this.version});

  UpiResponse.fromJson(Map<String, dynamic> json) {
    packageName = json['packageName'];
    applicationName = json['applicationName'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['packageName'] = this.packageName;
    data['applicationName'] = this.applicationName;
    data['version'] = this.version;
    return data;
  }
}
