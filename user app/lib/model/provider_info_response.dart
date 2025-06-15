import 'package:booking_system_flutter/model/service_detail_response.dart';
import 'package:booking_system_flutter/model/user_data_model.dart';

import 'service_data_model.dart';

class ProviderInfoResponse {
  UserData? userData;
  List<ServiceData>? serviceList;
  List<RatingData>? handymanRatingReviewList;
  List<String>? handymanImageList;
  List<UserData>? handymanStaffList;

  ProviderInfoResponse({this.userData, this.serviceList, this.handymanRatingReviewList, this.handymanImageList});

  ProviderInfoResponse.fromJson(Map<String, dynamic> json) {
    userData = json['data'] != null ? new UserData.fromJson(json['data']) : null;
    if (json['service'] != null) {
      serviceList = [];
      json['service'].forEach((v) {
        serviceList!.add(ServiceData.fromJson(v));
      });
    }
    if (json['handyman_rating_review'] != null) {
      handymanRatingReviewList = [];
      json['handyman_rating_review'].forEach((v) {
        handymanRatingReviewList!.add(new RatingData.fromJson(v));
      });
    }
    handymanImageList = json['handyman_image'] != null ? json['handyman_image'].cast<String>() : null;
    if (json['handyman_staff'] != null) {
      handymanStaffList = json['handyman_staff'] != null ? (json['handyman_staff'] as List).map((i) => UserData.fromJson(i)).toList() : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userData != null) {
      data['data'] = this.userData!.toJson();
    }
    if (this.serviceList != null) {
      data['service'] = this.serviceList!.map((v) => v.toJson()).toList();
    }
    if (this.handymanRatingReviewList != null) {
      data['handyman_rating_review'] = this.handymanRatingReviewList!.map((v) => v.toJson()).toList();
    }
    data['handyman_image'] = this.handymanImageList;
    if (this.handymanStaffList != null) {
      data['handyman_staff'] = this.handymanStaffList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
