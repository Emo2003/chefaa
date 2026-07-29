class Days {
  Days({
    this.day,
    this.isActive,
    this.open,
    this.close,
    this.breaks,
    this.slotDuration,
    this.dailyCapacity,
    this.patientsPerSlot,
    this.isDayLocked,
    this.isBookingLocked,
  });

  Days.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    day = json['day'];
    isActive = json['isActive'];
    open = json['open'];
    close = json['close'];
    if (json['breaks'] != null) {
      breaks = [];
      json['breaks'].forEach((v) {});
    }
    slotDuration = json['slotDuration'];
    dailyCapacity = json['dailyCapacity'];
    patientsPerSlot = json['patientsPerSlot'];
    isDayLocked = json['isDayLocked'];
    isBookingLocked = json['isBookingLocked'];
  }

  String? day;
  bool? isActive;
  num? open;
  num? close;
  List<dynamic>? breaks;
  dynamic slotDuration;
  dynamic dailyCapacity;
  dynamic patientsPerSlot;
  bool? isDayLocked;
  bool? isBookingLocked;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['day'] = day;
    map['isActive'] = isActive;
    map['open'] = open;
    map['close'] = close;
    if (breaks != null) {
      map['breaks'] = breaks;
    }
    map['slotDuration'] = slotDuration;
    map['dailyCapacity'] = dailyCapacity;
    map['patientsPerSlot'] = patientsPerSlot;
    map['isDayLocked'] = isDayLocked;
    map['isBookingLocked'] = isBookingLocked;
    return map;
  }
}
