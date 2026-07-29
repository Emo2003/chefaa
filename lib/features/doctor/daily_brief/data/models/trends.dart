class Trends {
  Trends({
      this.completionRate, 
      this.cancellationRate, 
      this.avgRevenuePerSession, 
      this.assessment,});

  Trends.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    completionRate = json['completionRate'];
    cancellationRate = json['cancellationRate'];
    avgRevenuePerSession = json['avgRevenuePerSession'];
    assessment = json['assessment'];
  }
  num? completionRate;
  num? cancellationRate;
  num? avgRevenuePerSession;
  String? assessment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['completionRate'] = completionRate;
    map['cancellationRate'] = cancellationRate;
    map['avgRevenuePerSession'] = avgRevenuePerSession;
    map['assessment'] = assessment;
    return map;
  }

}