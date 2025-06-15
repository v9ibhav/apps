enum ServiceListApprovalStatus {
  all,
  pending,
  approved,
  reject,
}

class ServiceListApprovalStatusModel {
  ServiceListApprovalStatus status;
  String name;

  ServiceListApprovalStatusModel({
    this.status = ServiceListApprovalStatus.all,
    this.name = "",
  });
}