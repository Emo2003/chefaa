class Predictions {
  Predictions({
      this.next30DaysEstimate, 
      this.basis, 
      this.confidence,});

  Predictions.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    next30DaysEstimate = json['next30DaysEstimate'];
    basis = json['basis'];
    confidence = json['confidence'];
  }
  num? next30DaysEstimate;
  String? basis;
  String? confidence;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['next30DaysEstimate'] = next30DaysEstimate;
    map['basis'] = basis;
    map['confidence'] = confidence;
    return map;
  }

}