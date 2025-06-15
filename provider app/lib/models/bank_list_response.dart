class BankListResponse {
  Pagination pagination;
  List<BankHistory> data;

  BankListResponse({
    required this.pagination,
    this.data = const <BankHistory>[],
  });

  factory BankListResponse.fromJson(Map<String, dynamic> json) {
    return BankListResponse(
      pagination: json['pagination'] is Map ? Pagination.fromJson(json['pagination']) : Pagination(),
      data: json['data'] is List ? List<BankHistory>.from(json['data'].map((x) => BankHistory.fromJson(x))) : [],
    );
  }

  get id => null;

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

class BankHistory {
  int id;
  int providerId;
  String bankName;
  String branchName;
  String accountNo;
  String ifscNo;
  String mobileNo;
  String aadharNo;
  String panNo;
  List<dynamic> bankAttchments;
  int isDefault;

  BankHistory({
    this.id = -1,
    this.providerId = -1,
    this.bankName = "",
    this.branchName = "",
    this.accountNo = "",
    this.ifscNo = "",
    this.mobileNo = "",
    this.aadharNo = "",
    this.panNo = "",
    this.bankAttchments = const [],
    this.isDefault = -1,
  });

  factory BankHistory.fromJson(Map<String, dynamic> json) {
    return BankHistory(
      id: json['id'] is int ? json['id'] : -1,
      providerId: json['provider_id'] is int ? json['provider_id'] : -1,
      bankName: json['bank_name'] is String ? json['bank_name'] : "",
      branchName: json['branch_name'] is String ? json['branch_name'] : "",
      accountNo: json['account_no'] is String ? json['account_no'] : "",
      ifscNo: json['ifsc_no'] is String ? json['ifsc_no'] : "",
      mobileNo: json['mobile_no'] is String ? json['mobile_no'] : "",
      aadharNo: json['aadhar_no'] is String ? json['aadhar_no'] : "",
      panNo: json['pan_no'] is String ? json['pan_no'] : "",
      bankAttchments: json['bank_attchments'] is List ? json['bank_attchments'] : [],
      isDefault: json['is_default'] is int ? json['is_default'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider_id': providerId,
      'bank_name': bankName,
      'branch_name': branchName,
      'account_no': accountNo,
      'ifsc_no': ifscNo,
      'mobile_no': mobileNo,
      'aadhar_no': aadharNo,
      'pan_no': panNo,
      'bank_attchments': [],
      'is_default': isDefault,
    };
  }
}
