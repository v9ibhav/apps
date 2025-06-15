import 'dart:convert';

import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/attachment_model.dart';
import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/models/tax_list_response.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:nb_utils/nb_utils.dart';

import '../provider/jobRequest/models/post_job_data.dart';
import 'multi_language_request_model.dart';

class BookingDetailResponse {
  BookingData? bookingDetail;
  ServiceData? service;
  UserData? customer;
  List<BookingActivity>? bookingActivity;
  List<RatingData>? ratingData;
  UserData? providerData;
  List<UserData>? handymanData;
  CouponData? couponData;
  List<TaxData>? taxes;
  List<ServiceProof>? serviceProof;
  PostJobData? postRequestDetail;

  bool get isMe => handymanData.validate().isNotEmpty ? handymanData.validate().first.id.validate() == appStore.userId.validate() : false;

  BookingDetailResponse({
    this.bookingDetail,
    this.service,
    this.customer,
    this.bookingActivity,
    this.ratingData,
    this.providerData,
    this.handymanData,
    this.couponData,
    this.taxes,
    this.serviceProof,
    this.postRequestDetail,
  });

  BookingDetailResponse.fromJson(Map<String, dynamic> json) {
    bookingDetail = json['booking_detail'] != null ? new BookingData.fromJson(json['booking_detail']) : null;
    service = json['service'] != null ? new ServiceData.fromJson(json['service']) : null;
    customer = json['customer'] != null ? new UserData.fromJson(json['customer']) : null;
    if (json['booking_activity'] != null) {
      bookingActivity = [];
      json['booking_activity'].forEach((v) {
        bookingActivity!.add(new BookingActivity.fromJson(v));
      });
    }
    providerData = json['provider_data'] != null ? new UserData.fromJson(json['provider_data']) : null;
    if (json['rating_data'] != null) {
      ratingData = [];
      json['rating_data'].forEach((v) {
        ratingData!.add(new RatingData.fromJson(v));
      });
    }
    couponData = json['coupon_data'] != null ? new CouponData.fromJson(json['coupon_data']) : null;

    if (json['handyman_data'] != null) {
      handymanData = [];
      json['handyman_data'].forEach((v) {
        handymanData!.add(new UserData.fromJson(v));
      });
    }
    if (json['service_proof'] != null) {
      serviceProof = [];
      json['service_proof'].forEach((v) {
        serviceProof!.add(new ServiceProof.fromJson(v));
      });
    }
    postRequestDetail = json['post_request_detail'] != null ? PostJobData.fromJson(json['post_request_detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bookingDetail != null) {
      data['booking_detail'] = this.bookingDetail!.toJson();
    }
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.bookingActivity != null) {
      data['booking_activity'] = this.bookingActivity!.map((v) => v.toJson()).toList();
    }
    if (this.ratingData != null) {
      data['rating_data'] = this.ratingData!.map((v) => v.toJson()).toList();
    }
    if (this.couponData != null) {
      data['coupon_data'] = this.couponData!.toJson();
    }
    if (this.providerData != null) {
      data['provider_data'] = this.providerData!.toJson();
    }
    if (this.handymanData != null) {
      data['handyman_data'] = this.handymanData!.map((v) => v.toJson()).toList();
    }
    if (this.serviceProof != null) {
      data['service_proof'] = this.serviceProof!.map((v) => v.toJson()).toList();
    }
    if (postRequestDetail != null) {
      data['post_request_detail'] = postRequestDetail?.toJson();
    }
    return data;
  }
}

class CouponData {
  int? bookingId;
  String? code;
  String? createdAt;
  String? deletedAt;
  num? discount;
  String? discountType;
  int? id;
  String? updatedAt;
  num? totalCalculatedValue;

  CouponData({this.bookingId, this.code, this.createdAt, this.deletedAt, this.discount, this.discountType, this.id, this.updatedAt, this.totalCalculatedValue});

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      bookingId: json['booking_id'],
      code: json['code'],
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
      discount: json['discount'],
      discountType: json['discount_type'],
      id: json['id'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['code'] = this.code;
    data['created_at'] = this.createdAt;
    data['discount'] = this.discount;
    data['deleted_at'] = this.deletedAt;
    data['discount_type'] = this.discountType;
    data['id'] = this.id;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class BookingActivity {
  int? id;
  int? bookingId;
  String? datetime;
  String? activityType;
  String? activityMessage;
  String? activityData;
  String? createdAt;
  String? updatedAt;

  BookingActivity({this.id, this.bookingId, this.datetime, this.activityType, this.activityMessage, this.activityData, this.createdAt, this.updatedAt});

  BookingActivity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    datetime = json['datetime'];
    activityType = json['activity_type'];
    activityMessage = json['activity_message'];
    activityData = json['activity_data'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['datetime'] = this.datetime;
    data['activity_type'] = this.activityType;
    data['activity_message'] = this.activityMessage;
    data['activity_data'] = this.activityData;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class RatingData {
  num? id;
  num? rating;
  String? review;
  num? serviceId;
  num? bookingId;
  String? createdAt;
  String? customerName;
  String? profileImage;
  String? customerProfileImage;
  String? handymanProfileImage;

  String? serviceName;
  num? handymanId;
  num? customerId;
  String? handymanName;
  List<Attachments>? attachments;

  RatingData({
    this.id,
    this.rating,
    this.review,
    this.serviceId,
    this.bookingId,
    this.createdAt,
    this.customerName,
    this.profileImage,
    this.customerProfileImage,
    this.handymanProfileImage,
    this.serviceName,
    this.handymanId,
    this.customerId,
    this.handymanName,
    this.attachments,
  });

  RatingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    review = json['review'];
    serviceId = json['service_id'];
    bookingId = json['booking_id'];
    createdAt = json['created_at'];
    customerName = json['customer_name'];
    profileImage = json['profile_image'];
    customerProfileImage = json['customer_profile_image'];
    handymanProfileImage = json['handyman_profile_image'];
    serviceName = json['service_name'];
    handymanId = json['handyman_id'];
    customerId = json['customer_id'];
    handymanName = json['handyman_name'];
    attachments = json['attchments_array'] != null ? (json['attchments_array'] as List).map((i) => Attachments.fromJson(i)).toList() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['service_id'] = this.serviceId;
    data['booking_id'] = this.bookingId;
    data['created_at'] = this.createdAt;
    data['customer_name'] = this.customerName;
    data['profile_image'] = this.profileImage;
    data['customer_profile_image'] = this.customerProfileImage;
    data['handyman_profile_image'] = this.handymanProfileImage;
    data['service_name'] = this.serviceName;
    data['handyman_id'] = this.handymanId;
    data['customer_id'] = this.customerId;
    data['handyman_name'] = this.handymanName;
    if (this.attachments != null) {
      data['attchments_array'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceProof {
  int? id;
  String? title;
  String? description;
  int? serviceId;
  int? bookingId;
  int? userId;
  String? handymanName;
  String? serviceName;
  List<String>? attachments;

  ServiceProof({
    this.id,
    this.title,
    this.description,
    this.serviceId,
    this.bookingId,
    this.userId,
    this.handymanName,
    this.serviceName,
    this.attachments,
  });

  ServiceProof.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    serviceId = json['service_id'];
    bookingId = json['booking_id'];
    userId = json['user_id'];
    handymanName = json['handyman_name'];
    serviceName = json['service_name'];
    attachments = json['attachments'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['service_id'] = this.serviceId;
    data['booking_id'] = this.bookingId;
    data['user_id'] = this.userId;
    data['handyman_name'] = this.handymanName;
    data['service_name'] = this.serviceName;
    data['attachments'] = this.attachments;
    return data;
  }
}

class ServiceAddon {
  int id;
  String name;
  String serviceName;
  String serviceAddonImage;
  int serviceId;
  int serviceAddonId;
  num price;
  int status;
  String deletedAt;
  String createdAt;
  String updatedAt;
  bool isSelected = false;
  Map<String, MultiLanguageRequest>? translations;

  ServiceAddon({
    this.id = -1,
    this.name = "",
    this.serviceName = "",
    this.serviceAddonImage = "",
    this.serviceId = -1,
    this.serviceAddonId = -1,
    this.price = 0,
    this.status = -1,
    this.deletedAt = "",
    this.createdAt = "",
    this.updatedAt = "",
    this.translations
  });

  factory ServiceAddon.fromJson(Map<String, dynamic> json) {
    return ServiceAddon(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      serviceName: json['service_name'] is String ? json['service_name'] : "",
      serviceAddonImage: json['serviceaddon_image'] is String ? json['serviceaddon_image'] : "",
      serviceId: json['service_id'] is int ? json['service_id'] : -1,
      serviceAddonId: json['service_addon_id'] is int ? json['service_addon_id'] : -1,
      price: json['price'] is num ? json['price'] : 0,
      status: json['status'] is int ? json['status'] : -1,
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      translations:  json['translations'] != null
    ? (jsonDecode(json['translations']) as Map<String, dynamic>).map(
        (key, value) {
          if (value is Map<String, dynamic>) {
            return MapEntry(key, MultiLanguageRequest.fromJson(value));
          } else {
            print('Unexpected translation value for key $key: $value');
            return MapEntry(key, MultiLanguageRequest());
          }
        },
      )
    : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'service_name': serviceName,
      'serviceaddon_image': serviceAddonImage,
      if (serviceId > 0) 'service_id': serviceId,
      if (serviceAddonId > 0) 'service_addon_id': serviceAddonId,
      'price': price,
      'status': status,
      if (deletedAt.isNotEmpty) 'deleted_at': deletedAt,
      if (createdAt.isNotEmpty) 'created_at': createdAt,
      if (updatedAt.isNotEmpty) 'updated_at': updatedAt,
      if (translations != null) 
      'translations': translations!.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}
