import 'appointment.dart';
import 'doctor.dart';
import 'patient.dart';
import 'medicines.dart';

class Data {
  Data({
    this.id,
    this.appointment,
    this.doctor,
    this.patient,
    this.diagnosis,
    this.medicines,
    this.labTests,
    this.imaging,
    this.nextVisit,
    this.notes,
    this.suggestedPharmacies,
    this.attachedFiles,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Data.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    id = json['_id'];
    appointment = json['appointment'] != null
        ? Appointment.fromJson(json['appointment'])
        : null;
    doctor = json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
    patient = json['patient'] != null
        ? Patient.fromJson(json['patient'])
        : null;
    diagnosis = json['diagnosis'];
    if (json['medicines'] != null) {
      medicines = [];
      json['medicines'].forEach((v) {
        medicines?.add(Medicines.fromJson(v));
      });
    }
    labTests = json['labTests'] != null ? json['labTests'].cast<String>() : [];
    imaging = json['imaging'] != null ? json['imaging'].cast<String>() : [];
    nextVisit = json['nextVisit'];
    notes = json['notes'];
    if (json['suggestedPharmacies'] != null) {
      suggestedPharmacies = [];
      if (json['suggestedPharmacies'] != null) {
        suggestedPharmacies = List<dynamic>.from(json['suggestedPharmacies']);
      }
    }
    if (json['attachedFiles'] != null) {
      attachedFiles = [];
      if (json['attachedFiles'] != null) {
        attachedFiles = List<dynamic>.from(json['attachedFiles']);
      }
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  String? id;
  Appointment? appointment;
  Doctor? doctor;
  Patient? patient;
  String? diagnosis;
  List<Medicines>? medicines;
  List<String>? labTests;
  List<String>? imaging;
  String? nextVisit;
  String? notes;
  List<dynamic>? suggestedPharmacies;
  List<dynamic>? attachedFiles;
  String? createdAt;
  String? updatedAt;
  num? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    if (appointment != null) {
      map['appointment'] = appointment?.toJson();
    }
    if (doctor != null) {
      map['doctor'] = doctor?.toJson();
    }
    if (patient != null) {
      map['patient'] = patient?.toJson();
    }
    map['diagnosis'] = diagnosis;
    if (medicines != null) {
      map['medicines'] = medicines?.map((v) => v.toJson()).toList();
    }
    map['labTests'] = labTests;
    map['imaging'] = imaging;
    map['nextVisit'] = nextVisit;
    map['notes'] = notes;
    if (suggestedPharmacies != null) {
      map['suggestedPharmacies'] = suggestedPharmacies
          ?.map((v) => v.toJson())
          .toList();
    }
    if (attachedFiles != null) {
      map['attachedFiles'] = attachedFiles?.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}

