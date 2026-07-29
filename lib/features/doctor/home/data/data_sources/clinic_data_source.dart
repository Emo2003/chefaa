import 'package:dio/dio.dart';

abstract class ClinicDataSource {
  Future<Response> getClinics({required String doctorID});

  Future<Response> addClinics({
    required String? name,
    required String? address,
    required String? city,
    required num? price,
    required String? operatingLicense,
    required Map<String, dynamic>? location,
    required Map<String, dynamic>? schedule,
  });

  Future<Response> deleteClinics({required String clinicID});

  Future<Response> updateClinics({
    required String clinicID,
    required String? name,
    required String? address,
    required String? city,
    required num? price,
    required String? operatingLicense,
    required Map<String, dynamic>? location,
    required Map<String, dynamic>? schedule,
  });

  Future<Response> getClinicByID({required String clinicID});
  Future<Response> getMyAppointments();
}
