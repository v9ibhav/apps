import 'dart:convert';

import 'package:handyman_provider_flutter/models/provider_subscription_model.dart';
import 'package:nb_utils/nb_utils.dart';

class UserData {
  int? id;
  String? uid;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? emailVerifiedAt;
  String? userType;
  String? contactNumber;
  int? countryId;
  int? stateId;
  int? cityId;
  String? address;
  int? providerId;
  String? playerId;
  int? status;
  int? providertypeId;
  int? isFeatured;
  String? displayName;
  String? timeZone;
  String? lastNotificationSeen;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? apiToken;
  String? profileImage;
  String? description;
  String? knownLanguages;
  String? whyChooseMe;
  String? skills;
  int? serviceAddressId;
  num? handymanRating;
  int? isSubscribe;
  String? designation;
  String? password;
  String? cityName;
  num? providerServiceRating;
  String? providerType;
  bool? isHandymanAvailable;
  String? loginType;
  int? handymanCommissionId;
  String? handymanType;
  String? handymanCommission;
  num? slotsForAllServices;
  int? isOnline;
  List<String>? userRole;
  ProviderSubscriptionModel? subscription;

  int? isEmailVerified;

  int? isVerifiedAccount;
  int? totalBooking;

  //Handyman Data
  String? handymanImage;
  int? isVerifiedHandyman;

  //Local
  bool isSelected = false;
  bool isActive = false;

  bool get isUserActive => status == 0;

  ///  This is to check if the provider's all services have time slot or not.
  bool get isSlotsForAllServices => slotsForAllServices == 1;

  List<String> get knownLanguagesArray => buildKnownLanguages();

  List<String> get skillsArray => buildSkills();

  List<String> buildKnownLanguages() {
    List<String> array = [];
    String tempLanguages = knownLanguages.validate();
    if (tempLanguages.isNotEmpty && tempLanguages.isJson()) {
      Iterable it1 = jsonDecode(knownLanguages.validate());
      array.addAll(it1.map((e) => e.toString()).toList());
    }

    return array;
  }

  List<String> buildSkills() {
    List<String> array = [];
    String tempSkills = skills.validate();
    if (tempSkills.isNotEmpty && tempSkills.isJson()) {
      Iterable it2 = jsonDecode(skills.validate());
      array.addAll(it2.map((e) => e.toString()).toList());
    }

    return array;
  }

  WhyChooseMe get whyChooseMeObj => buildWhyChooseMe();

  WhyChooseMe buildWhyChooseMe() {
    WhyChooseMe obj = WhyChooseMe();
    String tempWhyChooseMe = whyChooseMe.validate();
    if (tempWhyChooseMe.isNotEmpty && tempWhyChooseMe.isJson()) {
      obj = WhyChooseMe.fromJson(jsonDecode(tempWhyChooseMe));
    }

    return obj;
  }

  UserData({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerifiedAt,
    this.userType,
    this.contactNumber,
    this.countryId,
    this.providerServiceRating,
    this.stateId,
    this.cityId,
    this.address,
    this.providerId,
    this.playerId,
    this.slotsForAllServices,
    this.status,
    this.providertypeId,
    this.isFeatured,
    this.displayName,
    this.timeZone,
    this.lastNotificationSeen,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.userRole,
    this.apiToken,
    this.profileImage,
    this.description,
    this.knownLanguages,
    this.whyChooseMe,
    this.skills,
    this.serviceAddressId,
    this.handymanRating,
    this.subscription,
    this.isSubscribe,
    this.uid,
    this.designation,
    this.cityName,
    this.providerType,
    this.handymanType,
    this.handymanCommissionId,
    this.handymanCommission,
    this.isHandymanAvailable,
    this.loginType,
    this.isEmailVerified,
    this.isVerifiedAccount = 0,
    this.totalBooking,
    this.handymanImage,
    this.isVerifiedHandyman = 0,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString().toInt();
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    slotsForAllServices = json['slots_for_all_services'] != null ? json['slots_for_all_services'] : 0;
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    providerServiceRating = json['providers_service_rating'];
    isOnline = json['isOnline'];
    userType = json['user_type'];
    contactNumber = json['contact_number'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    address = json['address'];
    providerId = json['provider_id'];
    playerId = json['player_id'];
    status = json['status'];
    isActive = status == 1;
    serviceAddressId = json['service_address_id'];
    handymanRating = json['handyman_rating'];
    isFeatured = json['is_featured'];
    displayName = json['display_name'];
    timeZone = json['time_zone'];
    lastNotificationSeen = json['last_notification_seen'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    apiToken = json['api_token'];
    profileImage = json['profile_image'];
    description = json['description'];
    knownLanguages = json['known_languages'];
    whyChooseMe = json['why_choose_me'];
    skills = json['skills'];
    uid = json['uid'];
    subscription = json['subscription'] != null ? ProviderSubscriptionModel.fromJson(json['subscription']) : null;
    isSubscribe = json['is_subscribe'];
    designation = json['designation'];
    cityName = json['city_name'];
    providerType = json['providertype'];
    handymanCommissionId = json['handymantype_id'];
    handymanType = json['handyman_type'];
    handymanCommission = json['handyman_commission'];
    isHandymanAvailable = json['isHandymanAvailable'] != null ? json['isHandymanAvailable'] == 1 : false;
    loginType = json['login_type'];
    isEmailVerified = json['is_email_verified'];
    isVerifiedAccount = json['is_verify_provider'] is int ? json['is_verify_provider'] : 0;
    totalBooking= json['total_services_booked'];
    handymanImage = json['handyman_image'];
    isVerifiedHandyman = json['is_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) data['id'] = this.id;
    if (this.slotsForAllServices != null) data['slots_for_all_services'] = this.slotsForAllServices;
    if (this.username != null) data['username'] = this.username;
    if (this.firstName != null) data['first_name'] = this.firstName;
    if (this.lastName != null) data['last_name'] = this.lastName;
    if (this.email != null) data['email'] = this.email;
    if (this.providerServiceRating != null) data['providers_service_rating'] = this.providerServiceRating;
    if (this.serviceAddressId != null) data['service_address_id'] = this.serviceAddressId;
    if (this.handymanRating != null) data['handyman_rating'] = this.handymanRating;
    if (this.emailVerifiedAt != null) data['email_verified_at'] = this.emailVerifiedAt;
    if (this.userType != null) data['user_type'] = this.userType;
    if (this.contactNumber != null) data['contact_number'] = this.contactNumber;
    if (this.countryId != null) data['country_id'] = this.countryId;
    if (this.isOnline != null) data['isOnline'] = this.isOnline;
    if (this.handymanType != null) data['handyman_type'] = this.handymanType;
    if (this.handymanCommission != null) data['handyman_commission'] = this.handymanCommission;
    if (this.stateId != null) data['state_id'] = this.stateId;
    if (this.cityId != null) data['city_id'] = this.cityId;
    if (this.address != null) data['address'] = this.address;
    if (this.providerId != null) data['provider_id'] = this.providerId;
    if (this.playerId != null) data['player_id'] = this.playerId;
    if (this.status != null) data['status'] = this.status;
    if (this.providertypeId != null) data['providertype_id'] = this.providertypeId;
    if (this.isFeatured != null) data['is_featured'] = this.isFeatured;
    if (this.displayName != null) data['display_name'] = this.displayName;
    if (this.timeZone != null) data['time_zone'] = this.timeZone;
    if (this.lastNotificationSeen != null) data['last_notification_seen'] = this.lastNotificationSeen;
    if (this.createdAt != null) data['created_at'] = this.createdAt;
    if (this.updatedAt != null) data['updated_at'] = this.updatedAt;
    if (this.deletedAt != null) data['deleted_at'] = this.deletedAt;
    if (this.userRole != null) data['user_role'] = this.userRole;
    if (this.apiToken != null) data['api_token'] = this.apiToken;
    if (this.profileImage != null) data['profile_image'] = this.profileImage;
    if (this.description != null) data['description'] = this.description;
    if (this.knownLanguages != null) data['known_languages'] = this.knownLanguages;
    if (this.whyChooseMe != null) data['why_choose_me'] = this.whyChooseMe;
    if (this.skills != null) data['skills'] = this.skills;
    if (this.uid != null) data['uid'] = this.uid;
    if (this.isSubscribe != null) data['is_subscribe'] = this.isSubscribe;
    if (this.cityName != null) data['city_name'] = this.cityName;
    if (this.handymanCommissionId != null) data['handymantype_id'] = this.handymanCommissionId;
    if (this.providerType != null) data['providertype'] = this.providerType;
    if (this.isHandymanAvailable != null) data['isHandymanAvailable'] = this.isHandymanAvailable;
    if (this.loginType != null) data['login_type'] = this.loginType;
    if (this.isEmailVerified != null) data['is_email_verified'] = this.isEmailVerified;
    if (this.isVerifiedAccount != null) data['is_verify_provider'] = this.isVerifiedAccount;
    if (this.totalBooking != null) data['total_services_booked'] = this.totalBooking;
    if (this.handymanImage != null) data['handyman_image'] = this.handymanImage;
    if (this.isVerifiedHandyman != null) data['is_verified'] = this.isVerifiedHandyman;

    if (this.subscription != null) {
      data['subscription'] = this.subscription!.toJson();
    }
    if (this.designation != null) data['designation'] = this.designation;
    return data;
  }

  Map<String, dynamic> toFirebaseJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) data['id'] = this.id;
    if (this.uid != null) data['uid'] = this.uid;
    if (this.firstName != null) data['first_name'] = this.firstName;
    if (this.lastName != null) data['last_name'] = this.lastName;
    if (this.email != null) data['email'] = this.email;
    if (this.profileImage != null) data['profile_image'] = this.profileImage;
    if (this.isOnline != null) data['isOnline'] = this.isOnline;
    if (this.updatedAt != null) data['updated_at'] = this.updatedAt;
    if (this.createdAt != null) data['created_at'] = this.createdAt;
    return data;
  }
}

class WhyChooseMe {
  String title;
  List<String> reason;

  WhyChooseMe({
    this.title = "",
    this.reason = const <String>[],
  });

  factory WhyChooseMe.fromJson(Map<String, dynamic> json) {
    return WhyChooseMe(
      title: json['why_choose_me_title'] is String ? json['why_choose_me_title'] : "",
      reason: json['reason'] is List ? List<String>.from(json['reason'].map((x) => x)) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'why_choose_me_title': title,
      'why_choose_me_reason': reason.map((e) => e).toList(),
    };
  }
}
