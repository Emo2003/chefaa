class PromptTokensDetails {
  PromptTokensDetails({
      this.audioTokens, 
      this.cachedTokens,});

  PromptTokensDetails.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    audioTokens = json['audio_tokens'];
    cachedTokens = json['cached_tokens'];
  }
  num? audioTokens;
  num? cachedTokens;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['audio_tokens'] = audioTokens;
    map['cached_tokens'] = cachedTokens;
    return map;
  }

}