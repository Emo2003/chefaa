class Patient {
  Patient({this.id, this.userId, this.age, this.gender});

  Patient.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    id = json['_id'];
    userId = json['userId'];
    age = json['age'];
    gender = json['gender'];
  }
  String? id;
  String? userId;
  num? age;
  String? gender;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['userId'] = userId;
    map['age'] = age;
    map['gender'] = gender;
    return map;
  }
}
