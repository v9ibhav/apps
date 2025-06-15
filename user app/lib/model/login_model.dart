import 'package:booking_system_flutter/model/user_data_model.dart';

class LoginResponse {
  UserData? userData;
  bool? isUserExist;
  bool? status;
  String? message;

  LoginResponse({this.userData, this.isUserExist, this.status, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userData: json['data'] != null ? UserData.fromJson(json['data']) : null,
      isUserExist: json['is_user_exist'],
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userData != null) {
      data['data'] = this.userData!.toJson();
    }
    data['is_user_exist'] = this.isUserExist;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class VerificationModel {
  bool? status;
  String? message;
  int? isEmailVerified;

  VerificationModel({this.status, this.message, this.isEmailVerified});

  factory VerificationModel.fromJson(Map<String, dynamic> json) {
    return VerificationModel(status: json['status'], message: json['message'], isEmailVerified: json['is_email_verified']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['status'] = this.status;
    data['message'] = this.message;
    data['is_email_verified'] = this.isEmailVerified;
    return data;
  }
}
