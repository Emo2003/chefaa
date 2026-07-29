import 'usage.dart';

class ChatbotDoc {
  ChatbotDoc({
      this.reply, 
      this.usage,});

  ChatbotDoc.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    reply = json['reply'];
    usage = json['usage'] != null ? Usage.fromJson(json['usage']) : null;
  }
  String? reply;
  Usage? usage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reply'] = reply;
    if (usage != null) {
      map['usage'] = usage?.toJson();
    }
    return map;
  }

}
