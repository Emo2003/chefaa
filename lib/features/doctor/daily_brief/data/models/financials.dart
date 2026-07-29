import 'analysis.dart';

class Financials {
  Financials({
      this.generatedAt, 
      this.lang, 
      this.analysis,});

  Financials.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    generatedAt = json['generatedAt'];
    lang = json['lang'];
    analysis = json['analysis'] != null ? Analysis.fromJson(json['analysis']) : null;
  }
  String? generatedAt;
  String? lang;
  Analysis? analysis;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['generatedAt'] = generatedAt;
    map['lang'] = lang;
    if (analysis != null) {
      map['analysis'] = analysis?.toJson();
    }
    return map;
  }

}
