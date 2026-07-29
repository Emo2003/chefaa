class Location {
  Location({this.type, this.coordinates});

  Location.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    type = json['type'];
    coordinates = json['coordinates'] != null
        ? json['coordinates'].cast<num>()
        : [];
  }

  String? type;
  List<num>? coordinates;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['coordinates'] = coordinates;
    return map;
  }
}
