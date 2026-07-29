import 'clinics.dart';

class ClinicsResponse {
  ClinicsResponse({this.doctorId, this.totalClinics, this.clinics});

  ClinicsResponse.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    doctorId = json['doctorId'];
    totalClinics = json['totalClinics'];
    if (json['clinics'] != null) {
      clinics = [];
      json['clinics'].forEach((v) {
        clinics?.add(Clinics.fromJson(v));
      });
    }
  }

  String? doctorId;
  num? totalClinics;
  List<Clinics>? clinics;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['doctorId'] = doctorId;
    map['totalClinics'] = totalClinics;
    if (clinics != null) {
      map['clinics'] = clinics?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
