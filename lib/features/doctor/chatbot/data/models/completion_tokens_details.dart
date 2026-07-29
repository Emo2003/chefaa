class CompletionTokensDetails {
  CompletionTokensDetails({
      this.acceptedPredictionTokens, 
      this.audioTokens, 
      this.reasoningTokens, 
      this.rejectedPredictionTokens,});

  CompletionTokensDetails.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    acceptedPredictionTokens = json['accepted_prediction_tokens'];
    audioTokens = json['audio_tokens'];
    reasoningTokens = json['reasoning_tokens'];
    rejectedPredictionTokens = json['rejected_prediction_tokens'];
  }
  num? acceptedPredictionTokens;
  num? audioTokens;
  num? reasoningTokens;
  num? rejectedPredictionTokens;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['accepted_prediction_tokens'] = acceptedPredictionTokens;
    map['audio_tokens'] = audioTokens;
    map['reasoning_tokens'] = reasoningTokens;
    map['rejected_prediction_tokens'] = rejectedPredictionTokens;
    return map;
  }

}