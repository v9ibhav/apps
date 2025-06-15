class FirebaseDetailsModel {
  FirebaseDetailsModel({
      this.status, 
      this.data, 
      this.message,});

  FirebaseDetailsModel.fromJson(dynamic json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }
  bool? status;
  Data? data;
  String? message;
FirebaseDetailsModel copyWith({  bool? status,
  Data? data,
  String? message,
}) => FirebaseDetailsModel(  status: status ?? this.status,
  data: data ?? this.data,
  message: message ?? this.message,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['message'] = message;
    return map;
  }

}

class Data {
  Data({
      this.projectId,
      this.firebaseToken,});

  Data.fromJson(dynamic json) {
    projectId= json['project_id'];
    firebaseToken = json['firebase_token'];
  }
  String? projectId;
  String? firebaseToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['project_id'] = projectId;
    map['firebase_token'] = firebaseToken;
    return map;
  }

}