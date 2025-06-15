enum HelpDeskStatus {
  all,
  open,
  closed,
}

class HelpDeskStatusModel {
  HelpDeskStatus status;
  String name;

  HelpDeskStatusModel({
    this.status = HelpDeskStatus.all,
    this.name = "",
  });
}