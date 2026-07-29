class Medicines {
  Medicines({
    this.name,
    this.dosage,
    this.frequency,
    this.duration,
    this.instructions,
  });

  Medicines.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    name = json['name'];
    dosage = json['dosage'];
    frequency = json['frequency'];
    duration = json['duration'];
    instructions = json['instructions'];
  }
  String? name;
  String? dosage;
  String? frequency;
  String? duration;
  String? instructions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['dosage'] = dosage;
    map['frequency'] = frequency;
    map['duration'] = duration;
    map['instructions'] = instructions;
    return map;
  }
}
