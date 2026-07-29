class Appointment {
  Appointment({this.id, this.clinic, this.date, this.slotStart, this.slotEnd});

  Appointment.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    id = json['_id'];
    clinic = json['clinic'];
    date = json['date'];
    slotStart = json['slotStart'];
    slotEnd = json['slotEnd'];
  }
  String? id;
  String? clinic;
  String? date;
  String? slotStart;
  String? slotEnd;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['clinic'] = clinic;
    map['date'] = date;
    map['slotStart'] = slotStart;
    map['slotEnd'] = slotEnd;
    return map;
  }
}
