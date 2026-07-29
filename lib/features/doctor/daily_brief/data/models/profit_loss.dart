class ProfitLoss {
  ProfitLoss({
      this.status, 
      this.amount, 
      this.note,});

  ProfitLoss.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    status = json['status'];
    amount = json['amount'];
    note = json['note'];
  }
  String? status;
  num? amount;
  String? note;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['amount'] = amount;
    map['note'] = note;
    return map;
  }

}