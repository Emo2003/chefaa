import 'package:dio/dio.dart';

abstract class PatientsDataSource {
  Future<Response> getPatients();

  Future<Response> createPrescription({
    required String appointment,
    required String diagnosis,
    required List<Map<String, dynamic>> medicines,
    required List<String> labTests,
    required List<String> imaging,
    required String nextVisit,
    required String notes,
  });

  Future<Response> editPrescription({
    required String appointment,
    required String diagnosis,
    required List<Map<String, dynamic>> medicines,
    required List<String> labTests,
    required List<String> imaging,
    required String nextVisit,
    required String notes,
  });

  Future<Response> getPrescriptionByAppointment({
    required String appointmentId,
  });

  Future<Response> getPreviousPrescriptions({required String appointmentId});

  Future<Response> completeAppointment({required String appointmentId});
}
