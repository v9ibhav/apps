import '../../../models/bank_list_response.dart';

class PayoutHistoryResponse {
  List<PayoutData>? payoutData;
  Pagination? pagination;

  PayoutHistoryResponse({this.payoutData, this.pagination});

  factory PayoutHistoryResponse.fromJson(Map<String, dynamic> json) {
    return PayoutHistoryResponse(
      payoutData: json['data'] != null ? (json['data'] as List).map((i) => PayoutData.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.payoutData != null) {
      data['data'] = this.payoutData!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class PayoutData {
  num? amount;
  String? createdAt;
  String? description;
  int? id;
  String? paymentMethod;

  PayoutData({this.amount, this.createdAt, this.description, this.id, this.paymentMethod});

  factory PayoutData.fromJson(Map<String, dynamic> json) {
    return PayoutData(
      amount: json['amount'],
      createdAt: json['created_at'],
      description: json['description'],
      id: json['id'],
      paymentMethod: json['payment_method'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['payment_method'] = this.paymentMethod;
    data['description'] = this.description;
    return data;
  }
}
