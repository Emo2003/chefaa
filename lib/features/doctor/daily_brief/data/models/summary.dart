class Summary {
  Summary({
      this.confirmedRevenue, 
      this.platformFee, 
      this.netRevenue, 
      this.expectedFromUpcoming, 
      this.totalProjected, 
      this.currency,});

  Summary.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    confirmedRevenue = json['confirmedRevenue'];
    platformFee = json['platformFee'];
    netRevenue = json['netRevenue'];
    expectedFromUpcoming = json['expectedFromUpcoming'];
    totalProjected = json['totalProjected'];
    currency = json['currency'];
  }
  num? confirmedRevenue;
  num? platformFee;
  num? netRevenue;
  num? expectedFromUpcoming;
  num? totalProjected;
  String? currency;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['confirmedRevenue'] = confirmedRevenue;
    map['platformFee'] = platformFee;
    map['netRevenue'] = netRevenue;
    map['expectedFromUpcoming'] = expectedFromUpcoming;
    map['totalProjected'] = totalProjected;
    map['currency'] = currency;
    return map;
  }

}