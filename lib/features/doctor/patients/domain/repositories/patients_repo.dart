import 'package:chefaa/features/doctor/patients/data/models/complete/complete_appointment.dart';
import 'package:chefaa/features/doctor/patients/data/models/patients/prescription.dart';

import 'package:chefaa/features/doctor/patients/data/models/data.dart';

abstract class PatientsRepo {
  Future<List<Data>> getPatients();

  Future<Prescription> createPrescription({
    required String appointment,
    required String diagnosis,
    required List<Map<String, dynamic>> medicines,
    required List<String> labTests,
    required List<String> imaging,
    required String nextVisit,
    required String notes,
  });

  Future<Prescription> editPrescription({
    required String appointment,
    required String diagnosis,
    required List<Map<String, dynamic>> medicines,
    required List<String> labTests,
    required List<String> imaging,
    required String nextVisit,
    required String notes,
  });

  Future<Prescription> getPrescriptionByAppointment({
    required String appointmentId,
  });

  Future<List<Prescription>> getPreviousPrescriptions({
    required String appointmentId,
  });

  Future<CompleteAppointment> completeAppointment({
    required String appointmentId,
  });
}
