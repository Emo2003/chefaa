import 'package:chefaa/features/facility/dashboard/data/models/create_patient_request_response.dart';
import 'package:chefaa/features/facility/dashboard/data/models/get_dashboard_response.dart';
import 'package:chefaa/features/facility/dashboard/data/models/upload_result_response.dart';
import 'package:chefaa/features/facility/dashboard/domain/repositories/dashboard_repository.dart' show DashboardRepository;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';


part 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _dashboardRepository;

  GetDashboardResponse? dashboardResponse;

  DashboardCubit(this._dashboardRepository) : super(DashboardInitial());

  static DashboardCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> getDashboard() async {
      if (!isClosed) emit(GetDashboardLoading());
    try {
      final response = await _dashboardRepository.getDashboard();
      dashboardResponse = response;
      if (!isClosed) emit(GetDashboardSuccess(response));
    } catch (e) {
      if (!isClosed) emit(GetDashboardFailure(e.toString()));
    }
  }

  Future<void> uploadResult({
    required String requestId,
    required String filePath,
  }) async {
      debugPrint("Cubit upload requestId = $requestId");
      if (!isClosed) emit(UploadResultLoading(requestId: requestId));
    try {
      final response = await _dashboardRepository.uploadResult(
        requestId: requestId,
        filePath: filePath,
      );
      if (!isClosed) emit(UploadResultSuccess(response));
    } catch (e) {
      if (!isClosed) emit(UploadResultFailure(e.toString()));
    }
  }

  Future<void> createPatientRequest({
    required String patientPhone,
    required List<String> serviceIds,
    required bool viaAI,
  }) async {
      if (!isClosed) emit(CreatePatientRequestLoading());
    try {
      final response = await _dashboardRepository.createPatientRequest(
        patientPhone: patientPhone,
        serviceIds: serviceIds,
        viaAI: viaAI,
      );
      if (!isClosed) emit(CreatePatientRequestSuccess(response));
    } catch (e) {
      if (!isClosed) emit(CreatePatientRequestFailure(e.toString()));
    }
  }
}

