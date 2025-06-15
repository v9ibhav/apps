class EarningListModel {
  int? handymanId;
  String? handymanName;
  num? commission;
  String? commissionType;
  num? totalBookings;
  num? totalEarning;
  num? taxes;
  num? adminEarning;
  num? handymanPaidEarningFormate;
  String? handymanImage;
  String? email;
  String? taxesFormate;
  num? handymanDueAmount;
  num? handymanPaidEarning;
  num? handymanTotalAmount;
  num? providerTotalAmount;

  EarningListModel({
    this.adminEarning,
    this.commission,
    this.commissionType,
    this.handymanPaidEarningFormate,
    this.handymanId,
    this.handymanName,
    this.taxes,
    this.totalBookings,
    this.totalEarning,
    this.handymanImage,
    this.email,
    this.taxesFormate,
    this.handymanDueAmount,
    this.handymanPaidEarning,
    this.handymanTotalAmount,
    this.providerTotalAmount,
  });

  factory EarningListModel.fromJson(Map<String, dynamic> json) {
    return EarningListModel(
      commission: json['commission'],
      handymanPaidEarningFormate: json['handyman_paid_earning_formate'],
      handymanId: json['handyman_id'],
      commissionType: json['commission_type'],
      handymanName: json['handyman_name'],
      taxes: json['taxes'],
      adminEarning: json['admin_earning'],
      totalBookings: json['total_bookings'],
      totalEarning: json['total_earning'],
      handymanImage: json['handyman_image'],
      email: json['email'],
      taxesFormate: json['taxes_formate'],
      handymanDueAmount: json['handyman_due_amount'],
      handymanPaidEarning: json['handyman_paid_earning'],
      handymanTotalAmount: json['handyman_total_amount'],
      providerTotalAmount: json['provider_total_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admin_earning'] = this.adminEarning;
    data['commission'] = this.commission;
    data['handyman_paid_earning_formate'] = this.handymanPaidEarningFormate;
    data['commission_type'] = this.commissionType;
    data['handyman_id'] = this.handymanId;
    data['handyman_name'] = this.handymanName;
    data['taxes'] = this.taxes;
    data['total_bookings'] = this.totalBookings;
    data['total_earning'] = this.totalEarning;
    data['handyman_image'] = this.handymanImage;
    data['email'] = this.email;
    data['taxes_formate'] = this.taxesFormate;
    data['handyman_due_amount'] = this.handymanDueAmount;
    data['handyman_paid_earning'] = this.handymanPaidEarning;
    data['handyman_total_amount'] = this.handymanTotalAmount;
    data['provider_total_amount'] = this.providerTotalAmount;
    return data;
  }
}
