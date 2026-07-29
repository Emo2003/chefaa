class Brief {
  Brief({
      this.generatedAt, 
      this.lang, 
      this.brief,});

  Brief.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    generatedAt = json['generatedAt'];
    lang = json['lang'];
    brief = json['brief'];
  }
  String? generatedAt;
  String? lang;
  String? brief;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['generatedAt'] = generatedAt;
    map['lang'] = lang;
    map['brief'] = brief;
    return map;
  }

}