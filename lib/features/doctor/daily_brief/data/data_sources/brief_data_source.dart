import 'package:dio/dio.dart';

abstract class BriefDataSource {
  Future<Response> getDailyBrief({required String language});
  Future<Response>getFinancialsReport({required String language});
}