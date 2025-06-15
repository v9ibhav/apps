import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/models/pagination_model.dart';

class AddonsServiceResponse {
  List<ServiceAddon>? addonsServiceList;
  Pagination? pagination;

  AddonsServiceResponse({this.addonsServiceList, this.pagination});

  AddonsServiceResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      addonsServiceList = [];
      json['data'].forEach((v) {
        addonsServiceList!.add(ServiceAddon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addonsServiceList != null) {
      data['data'] = this.addonsServiceList!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}
