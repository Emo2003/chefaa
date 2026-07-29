import 'package:chefaa/core/services/network_service.dart';
import 'package:chefaa/features/doctor/patients/data/data_sources/patients_data_source.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PatientsDataSource)
class PatientsDataSourceImp implements PatientsDataSource {
  NetworkService networkService;

  PatientsDataSourceImp(this.networkService);

  @override
  Future<Response<dynamic>> getPatients() {
    return networkService.dio.get('/appointments/my');
  }

  @override
  Future<Response<dynamic>> completeAppointment({
    required String appointmentId,
  }) {
    return networkService.dio.patch('/appointments/$appointmentId/complete');
  }

  @override
  Future<Response<dynamic>> createPrescription({
    required String appointment,
    required String diagnosis,
    required List<Map<String, dynamic>> medicines,
    required List<String> labTests,
    required List<String> imaging,
    required String nextVisit,
    required String notes,
  }) {
    return networkService.dio.post(
      '/appointments/prescription',
      data: {
        'appointment': appointment,
        'diagnosis': diagnosis,
        'medicines': medicines,
        'labTests': labTests,
        'imaging': imaging,
        'nextVisit': nextVisit,
        'notes': notes,
      },
    );
  }

  @override
  Future<Response<dynamic>> editPrescription({
    required String appointment,
    required String diagnosis,
    required List<Map<String, dynamic>> medicines,
    required List<String> labTests,
    required List<String> imaging,
    required String nextVisit,
    required String notes,
  }) {
    return networkService.dio.patch(
      '/appointments/$appointment/updatePrescription',
      data: {
        'appointment': appointment,
        'diagnosis': diagnosis,
        'medicines': medicines,
        'labTests': labTests,
        'imaging': imaging,
        'nextVisit': nextVisit,
        'notes': notes,
      },
    );
  }

  @override
  Future<Response<dynamic>> getPrescriptionByAppointment({
    required String appointmentId,
  }) {
    return networkService.dio.get(
      '/appointments/$appointmentId/getPrescription',
    );
  }

  @override
  Future<Response<dynamic>> getPreviousPrescriptions({
    required String appointmentId,
  }) {
    return networkService.dio.get(
      '/appointments/$appointmentId/getPreviousPrescription',
    );
  }
}
