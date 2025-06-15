class Attachments {
  int? id;
  String? url;
  String? name;

  Attachments({this.id, this.url, this.name});

  factory Attachments.fromJson(Map<String, dynamic> json) {
    return Attachments(
      id: json['id'],
      url: json['url'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['name'] = this.name;
    return data;
  }
}
