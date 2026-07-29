import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

import 'package:chefaa/core/error_handling/failure.dart';
import 'package:chefaa/core/services/hive_service.dart';
import 'package:chefaa/features/facility/dashboard/data/models/get_dashboard_response.dart';
import 'package:chefaa/features/facility/dashboard/data/models/create_patient_request_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:chefaa/features/facility/dashboard/data/data_sources/dashboard_remote_source.dart';
import 'package:chefaa/features/facility/dashboard/data/models/upload_result_response.dart';
import '../../domain/repositories/dashboard_repository.dart';

@Injectable(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteSource _dashboardRemoteSource;
  static const String _cacheKey = 'facility_dashboard_cache';

  DashboardRepositoryImpl(this._dashboardRemoteSource);

  @override
  Future<UploadResultResponse> uploadResult({
    required String requestId,
    required String filePath,
  }) async {
    debugPrint("Repository upload requestId = $requestId");
    try {
      final response = await _dashboardRemoteSource.uploadResult(
        requestId: requestId,
        filePath: filePath,
      );
      final body = response.data;
      final UploadResultResponse data = body is String
          ? UploadResultResponse.fromJson(
              await Isolate.run(() => jsonDecode(body)),
            )
          : UploadResultResponse.fromJson(body);
      return data;
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e).message;
    } catch (e) {
      throw ServerFailure.unexpectedError;
    }
  }

  @override
  Future<GetDashboardResponse> getDashboard() async {
    try {
      final response = await _dashboardRemoteSource.getDashboard();
      final body = response.data;
      final GetDashboardResponse data = body is String
          ? GetDashboardResponse.fromJson(
              await Isolate.run(() => jsonDecode(body)),
            )
          : GetDashboardResponse.fromJson(body);

      await HiveService.put(HiveBoxes.facilityBox, _cacheKey, body);
      return data;
    } on DioException catch (e) {
      final cachedBody = await HiveService.get<dynamic>(
        HiveBoxes.facilityBox,
        _cacheKey,
      );
      if (cachedBody != null) {
        try {
          final decoded = cachedBody is String
              ? await Isolate.run(() => jsonDecode(cachedBody))
              : cachedBody;
          return GetDashboardResponse.fromJson(decoded);
        } catch (_) {}
      }
      throw ServerFailure.fromDioError(e).message;
    } catch (e) {
      final cachedBody = await HiveService.get<dynamic>(
        HiveBoxes.facilityBox,
        _cacheKey,
      );
      if (cachedBody != null) {
        try {
          final decoded = cachedBody is String
              ? await Isolate.run(() => jsonDecode(cachedBody))
              : cachedBody;
          return GetDashboardResponse.fromJson(decoded);
        } catch (_) {}
      }
      throw ServerFailure.unexpectedError;
    }
  }

  @override
  Future<CreatePatientRequestResponse> createPatientRequest({
    required String patientPhone,
    required List<String> serviceIds,
    required bool viaAI,
  }) async {
    try {
      final response = await _dashboardRemoteSource.createPatientRequest(
        patientPhone: patientPhone,
        serviceIds: serviceIds,
        viaAI: viaAI,
      );
      final body = response.data;
      final CreatePatientRequestResponse data = body is String
          ? CreatePatientRequestResponse.fromJson(
              await Isolate.run(() => jsonDecode(body)),
            )
          : CreatePatientRequestResponse.fromJson(body);
      return data;
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e).message;
    } catch (e) {
      throw ServerFailure.unexpectedError;
    }
  }
}

