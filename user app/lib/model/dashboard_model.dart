import 'package:booking_system_flutter/model/category_model.dart';
import 'package:booking_system_flutter/model/user_data_model.dart';

import 'booking_data_model.dart';
import 'service_data_model.dart';

class DashboardResponse {
  List<SliderModel>? slider;
  List<PromotionalBannerModel>? promotionalBanner;
  List<CategoryData>? category;
  List<ServiceData>? service;
  List<ServiceData>? featuredServices;
  List<UserData>? provider;
  List<DashboardCustomerReview>? dashboardCustomerReview;
  BookingData? upcomingData;
  int? notificationUnreadCount;
  int? isEmailVerified;

  DashboardResponse({
    this.category,
    this.featuredServices,
    this.provider,
    this.service,
    this.slider,
    this.promotionalBanner,
    this.dashboardCustomerReview,
    this.upcomingData,
    this.notificationUnreadCount,
    this.isEmailVerified,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      category: json['category'] != null ? (json['category'] as List).map((i) => CategoryData.fromJson(i)).toList() : null,
      provider: json['provider'] != null ? (json['provider'] as List).map((i) => UserData.fromJson(i)).toList() : null,
      service: json['service'] != null ? (json['service'] as List).map((i) => ServiceData.fromJson(i)).toList() : null,
      featuredServices: json['featured_service'] != null ? (json['featured_service'] as List).map((i) => ServiceData.fromJson(i)).toList() : null,
      slider: json['slider'] != null ? (json['slider'] as List).map((i) => SliderModel.fromJson(i)).toList() : null,
      promotionalBanner: json['promotional_banner'] != null ? (json['promotional_banner'] as List).map((i) => PromotionalBannerModel.fromJson(i)).toList() : null,
      dashboardCustomerReview: json['customer_review'] != null ? (json['customer_review'] as List).map((i) => DashboardCustomerReview.fromJson(i)).toList() : null,
      upcomingData: json['upcomming_confirmed_booking'] != null ? BookingData.fromJson(json['upcomming_confirmed_booking']) : null,
      notificationUnreadCount: json['notification_unread_count'],
      isEmailVerified: json['is_email_verified'] != null ? json['is_email_verified'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_email_verified'] = this.isEmailVerified;
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.provider != null) {
      data['provider'] = this.provider!.map((v) => v.toJson()).toList();
    }
    if (this.service != null) {
      data['service'] = this.service!.map((v) => v.toJson()).toList();
    }
    if (this.featuredServices != null) {
      data['featured_service'] = this.service!.map((v) => v.toJson()).toList();
    }
    if (this.slider != null) {
      data['slider'] = this.slider!.map((v) => v.toJson()).toList();
    }
    if (this.promotionalBanner != null) {
      data['promotional_banner'] = this.promotionalBanner!.map((v) => v.toJson()).toList();
    }
    if (this.dashboardCustomerReview != null) {
      data['customer_review'] = this.dashboardCustomerReview!.map((v) => v.toJson()).toList();
    }
    if (this.upcomingData != null) {
      data['upcomming_confirmed_booking'] != null ? BookingData.fromJson(data['upcomming_confirmed_booking']) : null;
    }

    return data;
  }
}

class SliderModel {
  String? description;
  int? id;
  String? serviceName;
  String? sliderImage;
  int? status;
  String? title;
  String? type;
  int? typeId;

  SliderModel({
    this.description,
    this.id,
    this.serviceName,
    this.sliderImage,
    this.status,
    this.title,
    this.type,
    this.typeId,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      description: json['description'],
      id: json['id'],
      serviceName: json['service_name'],
      sliderImage: json['slider_image'],
      status: json['status'],
      title: json['title'],
      type: json['type'],
      typeId: json['type_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    data['service_name'] = this.serviceName;
    data['slider_image'] = this.sliderImage;
    data['status'] = this.status;
    data['title'] = this.title;
    data['type'] = this.type;
    data['type_id'] = this.typeId;
    return data;
  }
}

class PromotionalBannerModel {
  int? id;
  int? providerId;
  String? title;
  String? image;
  String? description;
  String? bannerType;
  String? bannerRedirectUrl;
  int? serviceId;
  String? serviceName;
  String? startDate;
  String? endDate;
  int? duration;
  String? charges;
  String? totalAmount;
  String? paymentStatus;
  String? paymentMethod;
  String? status;
  String? reason;

  PromotionalBannerModel({
    this.id,
    this.providerId,
    this.title,
    this.image,
    this.description,
    this.bannerType,
    this.bannerRedirectUrl,
    this.serviceId,
    this.serviceName,
    this.startDate,
    this.endDate,
    this.duration,
    this.charges,
    this.totalAmount,
    this.paymentStatus,
    this.status,
    this.reason,
  });

  PromotionalBannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    bannerType = json['banner_type'];
    bannerRedirectUrl = json['banner_redirect_url'];
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    duration = json['duration'];
    charges = json['charges'];
    totalAmount = json['total_amount'];
    paymentStatus = json['payment_status'];
    status = json['status'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider_id'] = this.providerId;
    data['title'] = this.title;
    data['image'] = this.image;
    data['description'] = this.description;
    data['banner_type'] = this.bannerType;
    data['banner_redirect_url'] = this.bannerRedirectUrl;
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['duration'] = this.duration;
    data['charges'] = this.charges;
    data['total_amount'] = this.totalAmount;
    data['payment_status'] = this.paymentStatus;
    data['status'] = this.status;
    data['reason'] = this.reason;
    return data;
  }
}

class DashboardCustomerReview {
  List<String>? attchments;
  int? bookingId;
  String? createdAt;
  int? customerId;
  String? customerName;
  int? id;
  String? profileImage;
  num? rating;
  String? review;
  int? serviceId;
  String? serviceName;

  DashboardCustomerReview({this.attchments, this.bookingId, this.createdAt, this.customerId, this.customerName, this.id, this.profileImage, this.rating, this.review, this.serviceId, this.serviceName});

  factory DashboardCustomerReview.fromJson(Map<String, dynamic> json) {
    return DashboardCustomerReview(
      attchments: json['attchments'] != null ? new List<String>.from(json['attchments']) : null,
      bookingId: json['booking_id'],
      createdAt: json['created_at'],
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      id: json['id'],
      profileImage: json['profile_image'],
      rating: json['rating'],
      review: json['review'],
      serviceId: json['service_id'],
      serviceName: json['service_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['created_at'] = this.createdAt;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['id'] = this.id;
    data['profile_image'] = this.profileImage;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    if (this.attchments != null) {
      data['attchments'] = this.attchments;
    }
    return data;
  }
}
