enum FilterByStatus {
  service,
  date_range,
  customer,
  provider,
  handyman,
  booking_status,
  payment_type,
  payment_status,
}

class FilterByStatusModel {
  FilterByStatus status;
  String name;

  FilterByStatusModel({
    this.status = FilterByStatus.service,
    this.name = "",
  });
}