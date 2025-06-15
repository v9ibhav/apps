import 'package:handyman_provider_flutter/models/user_data.dart';

class LoginResponse {
  UserData? data;

  LoginResponse({this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class VerificationModel {
  bool? status;
  String? message;
  int? isEmailVerified;

  VerificationModel({this.status, this.message, this.isEmailVerified});

  factory VerificationModel.fromJson(Map<String, dynamic> json) {
    return VerificationModel(
      status: json['status'],
      message: json['message'],
      isEmailVerified: json['is_email_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['status'] = this.status;
    data['message'] = this.message;
    data['is_email_verified'] = this.isEmailVerified;
    return data;
  }
}
