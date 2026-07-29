import 'completion_tokens_details.dart';
import 'latency_checkpoint.dart';
import 'prompt_tokens_details.dart';

class Usage {
  Usage({
      this.completionTokens, 
      this.completionTokensDetails, 
      this.latencyCheckpoint, 
      this.promptTokens, 
      this.promptTokensDetails, 
      this.totalTokens,});

  Usage.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    completionTokens = json['completion_tokens'];
    completionTokensDetails = json['completion_tokens_details'] != null ? CompletionTokensDetails.fromJson(json['completion_tokens_details']) : null;
    latencyCheckpoint = json['latency_checkpoint'] != null ? LatencyCheckpoint.fromJson(json['latency_checkpoint']) : null;
    promptTokens = json['prompt_tokens'];
    promptTokensDetails = json['prompt_tokens_details'] != null ? PromptTokensDetails.fromJson(json['prompt_tokens_details']) : null;
    totalTokens = json['total_tokens'];
  }
  num? completionTokens;
  CompletionTokensDetails? completionTokensDetails;
  LatencyCheckpoint? latencyCheckpoint;
  num? promptTokens;
  PromptTokensDetails? promptTokensDetails;
  num? totalTokens;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['completion_tokens'] = completionTokens;
    if (completionTokensDetails != null) {
      map['completion_tokens_details'] = completionTokensDetails?.toJson();
    }
    if (latencyCheckpoint != null) {
      map['latency_checkpoint'] = latencyCheckpoint?.toJson();
    }
    map['prompt_tokens'] = promptTokens;
    if (promptTokensDetails != null) {
      map['prompt_tokens_details'] = promptTokensDetails?.toJson();
    }
    map['total_tokens'] = totalTokens;
    return map;
  }

}
