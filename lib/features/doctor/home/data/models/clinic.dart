import 'default_schedule.dart';
import 'location.dart';

class Clinic {
  Clinic({
    this.id,
    this.doctorId,
    this.name,
    this.city,
    this.address,
    this.location,
    this.color,
    this.defaultSchedule,
    this.price,
    this.operatingLicense,
    this.status,
    this.activatedAt,
    this.activatedBy,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Clinic.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    id = json['_id'];
    doctorId = json['doctorId'];
    name = json['name'];
    city = json['city'];
    address = json['address'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    color = json['color'];
    defaultSchedule = json['defaultSchedule'] != null
        ? DefaultSchedule.fromJson(json['defaultSchedule'])
        : null;
    price = json['price'];
    operatingLicense = json['operatingLicense'];
    status = json['status'];
    activatedAt = json['activatedAt'];
    activatedBy = json['activatedBy'];
    rejectionReason = json['rejectionReason'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  String? id;
  String? doctorId;
  String? name;
  String? city;
  String? address;
  Location? location;
  String? color;
  DefaultSchedule? defaultSchedule;
  num? price;
  String? operatingLicense;
  String? status;
  dynamic activatedAt;
  dynamic activatedBy;
  String? rejectionReason;
  String? createdAt;
  String? updatedAt;
  num? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['doctorId'] = doctorId;
    map['name'] = name;
    map['city'] = city;
    map['address'] = address;
    if (location != null) {
      map['location'] = location?.toJson();
    }
    map['color'] = color;
    if (defaultSchedule != null) {
      map['defaultSchedule'] = defaultSchedule?.toJson();
    }
    map['price'] = price;
    map['operatingLicense'] = operatingLicense;
    map['status'] = status;
    map['activatedAt'] = activatedAt;
    map['activatedBy'] = activatedBy;
    map['rejectionReason'] = rejectionReason;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}

