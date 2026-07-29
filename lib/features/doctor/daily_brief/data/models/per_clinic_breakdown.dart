class PerClinicBreakdown {
  PerClinicBreakdown({
      this.clinicName, 
      this.completed, 
      this.upcoming, 
      this.estimatedRevenue, 
      this.shareOfTotal,});

  PerClinicBreakdown.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    clinicName = json['clinicName'];
    completed = json['completed'];
    upcoming = json['upcoming'];
    estimatedRevenue = json['estimatedRevenue'];
    shareOfTotal = json['shareOfTotal'];
  }
  String? clinicName;
  num? completed;
  num? upcoming;
  num? estimatedRevenue;
  String? shareOfTotal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['clinicName'] = clinicName;
    map['completed'] = completed;
    map['upcoming'] = upcoming;
    map['estimatedRevenue'] = estimatedRevenue;
    map['shareOfTotal'] = shareOfTotal;
    return map;
  }

}