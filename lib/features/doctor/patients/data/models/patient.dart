import 'user_id.dart';

class Patient {
  Patient({
    this.address,
    this.isBlocked,
    this.id,
    this.userId,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.bloodType,
    this.allergies,
    this.chronicConditions,
  });

  Patient.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    final addr = json['address'];

    if (addr is String) {
      address = addr;
    } else if (addr is Map<String, dynamic>) {
      address = addr['location']?['coordinates']?.toString();
    } else {
      address = null;
    }

    isBlocked = json['isBlocked'];
    id = json['_id'];
    userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    age = json['age'];
    gender = json['gender'];
    height = json['height'];
    weight = json['weight'];
    bloodType = json['bloodType'];
    allergies = json['allergies'] != null
        ? json['allergies'].cast<String>()
        : [];
    chronicConditions = json['chronicConditions'] != null
        ? json['chronicConditions'].cast<String>()
        : [];
  }

  String? address;
  bool? isBlocked;
  String? id;
  UserId? userId;
  num? age;
  String? gender;
  num? height;
  num? weight;
  String? bloodType;
  List<String>? allergies;
  List<String>? chronicConditions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = address;
    map['isBlocked'] = isBlocked;
    map['_id'] = id;
    if (userId != null) {
      map['userId'] = userId?.toJson();
    }
    map['age'] = age;
    map['gender'] = gender;
    map['height'] = height;
    map['weight'] = weight;
    map['bloodType'] = bloodType;
    map['allergies'] = allergies;
    map['chronicConditions'] = chronicConditions;
    return map;
  }
}
