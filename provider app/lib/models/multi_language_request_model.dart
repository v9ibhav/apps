class MultiLanguageRequest {
  final String? name;
  final String? description;

  MultiLanguageRequest({this.name, this.description});

  // Add this copyWith method
  MultiLanguageRequest copyWith({String? name, String? description}) {
    return MultiLanguageRequest(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }


// Handle missing keys in fromJson
  factory MultiLanguageRequest.fromJson(Map<String, dynamic> json) {
    return MultiLanguageRequest(
      name: json['name']?.toString(), // Safely parse `name` if present
      description: json['description']?.toString(), // Safely parse `description` if present
    );
  }

  // Modified toJson to remove null or empty values
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null && name!.isNotEmpty) {
      data['name'] = name;
    }
    if (description != null && description!.isNotEmpty) {
      data['description'] = description;
    }
    return data;
  }
  
}

