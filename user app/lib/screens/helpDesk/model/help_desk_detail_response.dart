import '../../../model/bank_list_response.dart';
import '../../../model/package_data_model.dart';

class HelpDeskDetailResponse {
  Pagination? pagination;
  String? status;
  List<HelpDeskActivityData>? data;

  HelpDeskDetailResponse({this.pagination, this.data, this.status});

  factory HelpDeskDetailResponse.fromJson(Map<String, dynamic> json) {
    return HelpDeskDetailResponse(
      data: json['activity'] != null ? (json['activity'] as List).map((i) => HelpDeskActivityData.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['activity'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class HelpDeskActivityData {
  int? id;
  int? helpdeskId;
  int? senderId;
  String? senderName;
  String? senderImage;
  int? receiverId;
  String? recevierName;
  String? recevierImage;
  String? messages;
  String? activityType;
  String? createdAt;
  String? updatedAt;
  List<String>? attachments;
  List<Attachments>? attachmentsArray;
  List<String>? helDeskAttachments;
  List<Attachments>? helpDeskAttachmentsArray;

  HelpDeskActivityData({
    this.id,
    this.helpdeskId,
    this.senderId,
    this.senderName,
    this.senderImage,
    this.receiverId,
    this.recevierName,
    this.recevierImage,
    this.messages,
    this.activityType,
    this.createdAt,
    this.updatedAt,
    this.attachments,
    this.attachmentsArray,
    this.helDeskAttachments,
    this.helpDeskAttachmentsArray,
  });

  factory HelpDeskActivityData.fromJson(Map<String, dynamic> json) {
    return HelpDeskActivityData(
      id: json['id'],
      helpdeskId: json['helpdesk_id'],
      senderId: json['sender_id'],
      senderName: json['sender_name'],
      senderImage: json['sender_image'],
      receiverId: json['receiver_id'],
      recevierName: json['recevier_name'],
      recevierImage: json['recevier_image'],
      messages: json['messages'],
      activityType: json['activity_type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      attachments: json['attachments'] != null ? new List<String>.from(json['attachments']) : null,
      attachmentsArray: json['attachments_array'] != null ? (json['attachments_array'] as List).map((i) => Attachments.fromJson(i)).toList() : null,
      helDeskAttachments: json['helpdesk_attachments'] != null ? new List<String>.from(json['helpdesk_attachments']) : null,
      helpDeskAttachmentsArray: json['helpdesk_attachments_array'] != null ? (json['helpdesk_attachments_array'] as List).map((i) => Attachments.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['helpdesk_id'] = this.helpdeskId;
    data['sender_id'] = this.senderId;
    data['sender_name'] = this.senderName;
    data['sender_image'] = this.senderImage;
    data['receiver_id'] = this.receiverId;
    data['recevier_name'] = this.recevierName;
    data['recevier_image'] = this.recevierImage;
    data['messages'] = this.messages;
    data['activity_type'] = this.activityType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.attachments != null) {
      data['attachments'] = this.attachments;
    }
    if (this.attachmentsArray != null) {
      data['attachments_array'] = this.attachmentsArray!.map((v) => v.toJson()).toList();
    }
    if (this.helDeskAttachments != null) {
      data['helpdesk_attachments'] = this.helDeskAttachments;
    }
    if (this.helpDeskAttachmentsArray != null) {
      data['helpdesk_attachments_array'] = this.helpDeskAttachmentsArray!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
