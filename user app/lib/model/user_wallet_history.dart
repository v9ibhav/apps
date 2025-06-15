

class UserWalletHistoryResponse {
  Pagination pagination;
  List<WalletDataElement> data;
    num? availableBalance;

  UserWalletHistoryResponse({
    required this.pagination,
    this.data = const <WalletDataElement>[],
    this.availableBalance
  });

  factory UserWalletHistoryResponse.fromJson(Map<String, dynamic> json) {
    return UserWalletHistoryResponse(
      pagination: json['pagination'] is Map ? Pagination.fromJson(json['pagination']) : Pagination(),
      data: json['data'] is List ? List<WalletDataElement>.from(json['data'].map((x) => WalletDataElement.fromJson(x))) : [],
    availableBalance:
            json['available_balance'] != null ? json['available_balance'] : 0,
      
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
      data['pagination'] = this.pagination.toJson();
      data['available_balance'] = this.availableBalance;
    return data;
  }
}

class Pagination {
  int totalItems;
  int perPage;
  int currentPage;
  int totalPages;
  int from;
  int to;
  String nextPage;
  dynamic previousPage;

  Pagination({
    this.totalItems = -1,
    this.perPage = -1,
    this.currentPage = -1,
    this.totalPages = -1,
    this.from = -1,
    this.to = -1,
    this.nextPage = "",
    this.previousPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalItems: json['total_items'] is int ? json['total_items'] : -1,
      perPage: json['per_page'] is int ? json['per_page'] : -1,
      currentPage: json['currentPage'] is int ? json['currentPage'] : -1,
      totalPages: json['totalPages'] is int ? json['totalPages'] : -1,
      from: json['from'] is int ? json['from'] : -1,
      to: json['to'] is int ? json['to'] : -1,
      nextPage: json['next_page'] is String ? json['next_page'] : "",
      previousPage: json['previous_page'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_items': totalItems,
      'per_page': perPage,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'from': from,
      'to': to,
      'next_page': nextPage,
      'previous_page': previousPage,
    };
  }
}

class WalletDataElement {
  int id;
  String datetime;
  String activityType;
  String activityMessage;
  ActivityData? activityData;

  WalletDataElement({
    this.id = -1,
    this.datetime = "",
    this.activityType = "",
    this.activityMessage = "",
    this.activityData,
  });

  factory WalletDataElement.fromJson(Map<String, dynamic> json) {
    return WalletDataElement(
      id: json['id'] is int ? json['id'] : -1,
      datetime: json['datetime'] is String ? json['datetime'] : "",
      activityType: json['activity_type'] is String ? json['activity_type'] : "",
      activityMessage: json['activity_message'] is String ? json['activity_message'] : "",
      activityData: json['activity_data'] != null ? ActivityData.fromJson(json['activity_data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'datetime': datetime,
      'activity_type': activityType,
      'activity_message': activityMessage,
      if (activityData != null) 'activity_data': activityData!.toJson(),
    };
  }
}

class ActivityData {
  String title;
  int userId;
  String providerName;
  num amount;
  num creditDebitAmount;
  dynamic transactionId;
  String transactionType;

  ActivityData({
    this.title = "",
    this.userId = -1,
    this.providerName = "",
    this.amount = 0,
    this.creditDebitAmount = 0,
    this.transactionId,
    this.transactionType = "",
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(
      title: json['title'] is String ? json['title'] : "",
      userId: json['user_id'] is int ? json['user_id'] : -1,
      providerName: json['provider_name'] is String ? json['provider_name'] : "",
      amount: json['amount'] is num ? json['amount'] : 0,
      creditDebitAmount: json['credit_debit_amount'] is num ? json['credit_debit_amount'] : 0,
      transactionId: json['transaction_id'],
      transactionType: json['transaction_type'] is String ? json['transaction_type'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'user_id': userId,
      'provider_name': providerName,
      'amount': amount,
      'credit_debit_amount': creditDebitAmount,
      'transaction_id': transactionId,
      'transaction_type': transactionType,
    };
  }
}