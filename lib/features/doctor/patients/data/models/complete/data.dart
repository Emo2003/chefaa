class Data {
  Data({
    this.id,
    this.patient,
    this.doctor,
    this.clinic,
    this.prescription,
    this.date,
    this.timeChosed,
    this.slotStart,
    this.slotEnd,
    this.isFollowUp,
    this.paymentStatus,
    this.paymentOption,
    this.status,
    this.paidAt,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Data.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    id = json['_id'];
    patient = json['patient'];
    doctor = json['doctor'];
    clinic = json['clinic'];
    prescription = json['prescription'];
    date = json['date'];
    timeChosed = json['timeChosed'];
    slotStart = json['slotStart'];
    slotEnd = json['slotEnd'];
    isFollowUp = json['isFollowUp'];
    paymentStatus = json['paymentStatus'];
    paymentOption = json['paymentOption'];
    status = json['status'];
    paidAt = json['paidAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
  String? patient;
  String? doctor;
  String? clinic;
  String? prescription;
  String? date;
  String? timeChosed;
  String? slotStart;
  String? slotEnd;
  bool? isFollowUp;
  String? paymentStatus;
  String? paymentOption;
  String? status;
  dynamic paidAt;
  String? createdAt;
  String? updatedAt;
  num? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['patient'] = patient;
    map['doctor'] = doctor;
    map['clinic'] = clinic;
    map['prescription'] = prescription;
    map['date'] = date;
    map['timeChosed'] = timeChosed;
    map['slotStart'] = slotStart;
    map['slotEnd'] = slotEnd;
    map['isFollowUp'] = isFollowUp;
    map['paymentStatus'] = paymentStatus;
    map['paymentOption'] = paymentOption;
    map['status'] = status;
    map['paidAt'] = paidAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}
