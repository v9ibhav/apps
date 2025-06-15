import 'package:handyman_provider_flutter/models/user_data.dart';

class UserInfoResponse {
  UserData? data;

  UserInfoResponse({this.data});

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) {
    return UserInfoResponse(
      data: UserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
