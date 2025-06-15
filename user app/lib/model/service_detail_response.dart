import 'package:booking_system_flutter/model/service_data_model.dart';
import 'package:booking_system_flutter/model/user_data_model.dart';

class ServiceDetailResponse {
  List<CouponData>? couponData;
  UserData? provider;
  List<RatingData>? ratingData;
  ServiceData? serviceDetail;
  List<TaxData>? taxes;
  List<ServiceData>? relatedService;
  List<ServiceFaq>? serviceFaq;
  List<Serviceaddon>? serviceaddon;

  ServiceDetailResponse({
    this.couponData,
    this.provider,
    this.ratingData,
    this.serviceDetail,
    this.taxes,
    this.relatedService,
    this.serviceFaq,
    this.serviceaddon,
  });

  factory ServiceDetailResponse.fromJson(Map<String, dynamic> json) {
    return ServiceDetailResponse(
      couponData: json['coupon_data'] != null ? (json['coupon_data'] as List).map((i) => CouponData.fromJson(i)).toList() : null,
      provider: json['provider'] != null ? UserData.fromJson(json['provider']) : null,
      ratingData: json['rating_data'] != null ? (json['rating_data'] as List).map((i) => RatingData.fromJson(i)).toList() : null,
      serviceDetail: json['service_detail'] != null ? ServiceData.fromJson(json['service_detail']) : null,
      taxes: json['taxes'] != null ? (json['taxes'] as List).map((i) => TaxData.fromJson(i)).toList() : null,
      relatedService: json['related_service'] != null ? (json['related_service'] as List).map((i) => ServiceData.fromJson(i)).toList() : null,
      serviceFaq: json['service_faq'] != null ? (json['service_faq'] as List).map((i) => ServiceFaq.fromJson(i)).toList() : null,
      serviceaddon: json['serviceaddon'] != null ? (json['serviceaddon'] as List).map((i) => Serviceaddon.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.couponData != null) {
      data['coupon_data'] = this.couponData!.map((v) => v.toJson()).toList();
    }
    if (this.provider != null) {
      data['provider'] = this.provider!.toJson();
    }
    if (this.ratingData != null) {
      data['rating_data'] = this.ratingData!.map((v) => v.toJson()).toList();
    }
    if (this.serviceDetail != null) {
      data['service_detail'] = this.serviceDetail!.toJson();
    }
    if (this.taxes != null) {
      data['taxes'] = this.taxes!.map((v) => v.toJson()).toList();
    }
    if (this.relatedService != null) {
      data['related_service'] = this.relatedService!.map((v) => v.toJson()).toList();
    }
    if (this.serviceFaq != null) {
      data['service_faq'] = this.serviceFaq!.map((v) => v.toJson()).toList();
    }
    if (this.serviceaddon != null) {
      data['serviceaddon'] = this.serviceaddon!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaxData {
  int? id;
  int? providerId;
  String? title;
  String? type;
  num? value;
  num? totalCalculatedValue;

  TaxData({this.id, this.providerId, this.title, this.type, this.value, this.totalCalculatedValue});

  factory TaxData.fromJson(Map<String, dynamic> json) {
    return TaxData(
      id: json['id'],
      providerId: json['provider_id'],
      title: json['title'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider_id'] = this.providerId;
    data['title'] = this.title;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}

class CouponData {
  String? code;
  num? discount;
  String? discountType;
  String? expireDate;
  int? id;
  int? status;
  bool isApplied;

  CouponData({this.code, this.discount, this.discountType, this.expireDate, this.id, this.status, this.isApplied = false});

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      code: json['code'],
      discount: json['discount'],
      discountType: json['discount_type'],
      expireDate: json['expire_date'],
      id: json['id'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['expire_date'] = this.expireDate;
    data['id'] = this.id;
    data['status'] = this.status;
    return data;
  }
}

class RatingData {
  int? bookingId;
  String? createdAt;
  int? id;
  String? profileImage;
  num? rating;
  int? customerId;
  String? review;
  int? serviceId;
  String? updatedAt;

  int? handymanId;
  String? handymanName;
  String? handymanProfileImage;
  String? customerName;
  String? customerProfileImage;
  String? serviceName;
  List<String>? attachments;

  RatingData({
    this.bookingId,
    this.createdAt,
    this.id,
    this.profileImage,
    this.rating,
    this.customerId,
    this.review,
    this.serviceId,
    this.updatedAt,
    this.handymanId,
    this.handymanName,
    this.handymanProfileImage,
    this.customerName,
    this.customerProfileImage,
    this.serviceName,
    this.attachments,
  });

  factory RatingData.fromJson(Map<String, dynamic> json) {
    return RatingData(
      updatedAt: json['updated_at'],
      bookingId: json['booking_id'],
      createdAt: json['created_at'],
      id: json['id'],
      profileImage: json['profile_image'],
      rating: json['rating'],
      customerId: json['customer_id'],
      review: json['review'],
      serviceId: json['service_id'],
      handymanId: json['handyman_id'],
      handymanName: json['handyman_name'],
      handymanProfileImage: json['handyman_profile_image'],
      customerName: json['customer_name'],
      customerProfileImage: json['customer_profile_image'],
      serviceName: json['service_name'],
      attachments: json['attchments'] != null ? List<String>.from(json['attchments']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['updated_at'] = this.updatedAt;
    data['booking_id'] = this.bookingId;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['profile_image'] = this.profileImage;
    data['customer_id'] = this.customerId;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['service_id'] = this.serviceId;
    data['handyman_id'] = this.handymanId;
    data['handyman_name'] = this.handymanName;
    data['handyman_profile_image'] = this.handymanProfileImage;
    data['customer_name'] = this.customerName;
    data['customer_profile_image'] = this.customerProfileImage;
    data['service_name'] = this.serviceName;
    if (this.attachments != null) {
      data['attchments'] = this.attachments;
    }
    return data;
  }
}

class ServiceFaq {
  String? createdAt;
  String? description;
  int? id;
  int? serviceId;
  int? status;
  String? title;
  String? updatedAt;

  ServiceFaq({this.createdAt, this.description, this.id, this.serviceId, this.status, this.title, this.updatedAt});

  factory ServiceFaq.fromJson(Map<String, dynamic> json) {
    return ServiceFaq(
      createdAt: json['created_at'],
      description: json['description'],
      id: json['id'],
      serviceId: json['service_id'],
      status: json['status'],
      title: json['title'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['description'] = this.description;
    data['id'] = this.id;
    data['service_id'] = this.serviceId;
    data['status'] = this.status;
    data['title'] = this.title;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Serviceaddon {
  int id;
  String name;
  String serviceAddonImage;
  int serviceId;
  num price;
  int status;
  String deletedAt;
  String createdAt;
  String updatedAt;
  bool isSelected = false;

  Serviceaddon({
    this.id = -1,
    this.name = "",
    this.serviceAddonImage = "",
    this.serviceId = -1,
    this.price = 0,
    this.status = -1,
    this.deletedAt = "",
    this.createdAt = "",
    this.updatedAt = "",
  });

  factory Serviceaddon.fromJson(Map<String, dynamic> json) {
    return Serviceaddon(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      serviceAddonImage: json['serviceaddon_image'] is String ? json['serviceaddon_image'] : "",
      serviceId: json['service_id'] is int ? json['service_id'] : -1,
      price: json['price'] is num ? json['price'] : 0,
      status: json['status'] is int ? json['status'] : -1,
      deletedAt: json['deleted_at'] is String ? json['created_at'] : "",
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'serviceaddon_image': serviceAddonImage,
      'service_id': serviceId,
      'price': price,
      'status': status,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
