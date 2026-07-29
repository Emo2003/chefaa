import 'default_schedule.dart';
import 'location.dart';

class Clinics {
  Clinics({
    this.location,
    this.defaultSchedule,
    this.id,
    this.doctorId,
    this.name,
    this.city,
    this.address,
    this.color,
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

  Clinics.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    defaultSchedule = json['defaultSchedule'] != null
        ? DefaultSchedule.fromJson(json['defaultSchedule'])
        : null;
    id = json['_id'];
    doctorId = json['doctorId'];
    name = json['name'];
    city = json['city'];
    address = json['address'];
    color = json['color'];
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

  Location? location;
  DefaultSchedule? defaultSchedule;
  String? id;
  String? doctorId;
  String? name;
  String? city;
  String? address;
  String? color;
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
    if (location != null) {
      map['location'] = location?.toJson();
    }
    if (defaultSchedule != null) {
      map['defaultSchedule'] = defaultSchedule?.toJson();
    }
    map['_id'] = id;
    map['doctorId'] = doctorId;
    map['name'] = name;
    map['city'] = city;
    map['address'] = address;
    map['color'] = color;
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

