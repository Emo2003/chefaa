class Doctor {
  Doctor({this.id, this.specialization});

  Doctor.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    id = json['_id'];
    specialization = json['specialization'];
  }
  String? id;
  String? specialization;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['specialization'] = specialization;
    return map;
  }
}
