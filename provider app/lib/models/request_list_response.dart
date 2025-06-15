class RequestListResponse {
  Pagination pagination;
  List<RequestListModel> data;

  RequestListResponse({
    required this.pagination,
    this.data = const <RequestListModel>[],
  });

  factory RequestListResponse.fromJson(Map<String, dynamic> json) {
    return RequestListResponse(
      pagination: json['pagination'] is Map
          ? Pagination.fromJson(json['pagination'])
          : Pagination(),
      data: json['data'] is List
          ? List<RequestListModel>.from(
              json['data'].map((x) => RequestListModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pagination': pagination.toJson(),
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Pagination {
  int totalItems;
  int perPage;
  int currentPage;
  int totalPages;
  int from;
  int to;
  dynamic nextPage;
  dynamic previousPage;

  Pagination({
    this.totalItems = -1,
    this.perPage = -1,
    this.currentPage = -1,
    this.totalPages = -1,
    this.from = -1,
    this.to = -1,
    this.nextPage,
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
      nextPage: json['next_page'],
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

class RequestListModel {
  int id;
  String paymentMethod;
  dynamic description;
  int amount;
  String createdAt;

  RequestListModel({
    this.id = -1,
    this.paymentMethod = "",
    this.description,
    this.amount = -1,
    this.createdAt = "",
  });

  factory RequestListModel.fromJson(Map<String, dynamic> json) {
    return RequestListModel(
      id: json['id'] is int ? json['id'] : -1,
      paymentMethod:
          json['payment_method'] is String ? json['payment_method'] : "",
      description: json['description'],
      amount: json['amount'] is int ? json['amount'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_method': paymentMethod,
      'description': description,
      'amount': amount,
      'created_at': createdAt,
    };
  }
}
