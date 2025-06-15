import 'dart:convert';

import 'package:handyman_provider_flutter/models/attachment_model.dart';
import 'package:handyman_provider_flutter/models/pagination_model.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';

import 'multi_language_request_model.dart';

class PackageResponse {
  Pagination? pagination;
  List<PackageData>? packageList;

  PackageResponse(this.pagination, this.packageList);

  PackageResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      packageList = [];
      json['data'].forEach((v) {
        packageList!.add(PackageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.packageList != null) {
      data['data'] = this.packageList!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class PackageData {
  int? id;
  String? name;
  String? description;
  num? price;
  String? startDate;
  String? endDate;
  List<ServiceData>? serviceList;
  var isFeatured;
  int? categoryId;
  int? subCategoryId;
  List<Attachments>? attchments;
  List<String>? imageAttachments;
  int? status;
  String? categoryName;
  String? subCategoryName;
  String? packageType;
  Map<String, MultiLanguageRequest>? translations;

  PackageData({
    this.id,
    this.name,
    this.description,
    this.price,
    this.startDate,
    this.endDate,
    this.serviceList,
    this.isFeatured,
    this.categoryId,
    this.attchments,
    this.imageAttachments,
    this.status,
    this.categoryName,
    this.packageType,
    this.translations
  });

  PackageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryName = json['category_name'];
    subCategoryName = json['subcategory_name'];
    description = json['description'];
    price = json['price'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    packageType = json['package_type'];
    serviceList = json['services'] != null ? (json['services'] as List).map((i) => ServiceData.fromJson(i)).toList() : null;
    attchments = json['attchments_array'] != null ? (json['attchments_array'] as List).map((i) => Attachments.fromJson(i)).toList() : null;
    imageAttachments = json['attchments'] != null ? List<String>.from(json['attchments']) : null;
    categoryId = json['category_id'];
    subCategoryId = json['subcategory_id'];
    isFeatured = json['is_featured'];
    translations =  json['translations'] != null
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
    : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['status'] = this.status;
    data['category_name'] = this.categoryName;
    data['subcategory_name'] = this.subCategoryName;
    data['status'] = this.status;
    data['package_type'] = this.packageType;
    if (translations != null) {
      data['translations'] = translations!.map((key, value) => MapEntry(key, value.toJson()));
    }
    if (this.serviceList != null) {
      data['services'] = this.serviceList!.map((v) => v.toJson()).toList();
    }
    data['category_id'] = this.categoryId;
    data['subcategory_id'] = this.subCategoryId;
    data['is_featured'] = this.isFeatured;
    if (this.attchments != null) {
      data['attchments_array'] = this.attchments!.map((v) => v.toJson()).toList();
    }
    if (this.imageAttachments != null) {
      data['attchments'] = this.imageAttachments;
    }
    return data;
  }
}
