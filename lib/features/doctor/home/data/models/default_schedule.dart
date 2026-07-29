import 'days.dart';

class DefaultSchedule {
  DefaultSchedule({
    this.days,
    this.slotDuration,
    this.dailyCapacity,
    this.patientsPerSlot,
  });

  DefaultSchedule.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    if (json['days'] != null) {
      days = [];
      json['days'].forEach((v) {
        days?.add(Days.fromJson(v));
      });
    }
    slotDuration = json['slotDuration'];
    dailyCapacity = json['dailyCapacity'];
    patientsPerSlot = json['patientsPerSlot'];
  }

  List<Days>? days;
  num? slotDuration;
  num? dailyCapacity;
  num? patientsPerSlot;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (days != null) {
      map['days'] = days?.map((v) => v.toJson()).toList();
    }
    map['slotDuration'] = slotDuration;
    map['dailyCapacity'] = dailyCapacity;
    map['patientsPerSlot'] = patientsPerSlot;
    return map;
  }
}
