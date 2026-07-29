class LatencyCheckpoint {
  LatencyCheckpoint({
      this.engineTbtMs, 
      this.engineTtftMs, 
      this.engineTtltMs, 
      this.preInferenceMs, 
      this.serviceTbtMs, 
      this.serviceTtftMs, 
      this.serviceTtltMs, 
      this.totalDurationMs, 
      this.userVisibleTtftMs,});

  LatencyCheckpoint.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    engineTbtMs = json['engine_tbt_ms'];
    engineTtftMs = json['engine_ttft_ms'];
    engineTtltMs = json['engine_ttlt_ms'];
    preInferenceMs = json['pre_inference_ms'];
    serviceTbtMs = json['service_tbt_ms'];
    serviceTtftMs = json['service_ttft_ms'];
    serviceTtltMs = json['service_ttlt_ms'];
    totalDurationMs = json['total_duration_ms'];
    userVisibleTtftMs = json['user_visible_ttft_ms'];
  }
  num? engineTbtMs;
  num? engineTtftMs;
  num? engineTtltMs;
  num? preInferenceMs;
  num? serviceTbtMs;
  num? serviceTtftMs;
  num? serviceTtltMs;
  num? totalDurationMs;
  num? userVisibleTtftMs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['engine_tbt_ms'] = engineTbtMs;
    map['engine_ttft_ms'] = engineTtftMs;
    map['engine_ttlt_ms'] = engineTtltMs;
    map['pre_inference_ms'] = preInferenceMs;
    map['service_tbt_ms'] = serviceTbtMs;
    map['service_ttft_ms'] = serviceTtftMs;
    map['service_ttlt_ms'] = serviceTtltMs;
    map['total_duration_ms'] = totalDurationMs;
    map['user_visible_ttft_ms'] = userVisibleTtftMs;
    return map;
  }

}