import 'package:chefaa/core/services/network_service.dart';
import 'package:chefaa/features/doctor/home/data/data_sources/clinic_data_source.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ClinicDataSource)
class ClinicDataSourceImp implements ClinicDataSource {
  NetworkService networkService;

  ClinicDataSourceImp(this.networkService);

  @override
  Future<Response<dynamic>> addClinics({
    required String? name,
    required String? address,
    required String? city,
    required num? price,
    required String? operatingLicense,
    required Map<String, dynamic>? location,
    required Map<String, dynamic>? schedule,
  }) {
    return networkService.dio.post(
      "/clinic/",
      data: {
        "name": name,
        "address": address,
        "city": city,
        "price": price,
        "operatingLicense": operatingLicense,
        "location": location,
        "schedule": schedule,
      },
    );
  }

  @override
  Future<Response<dynamic>> deleteClinics({required String clinicID}) {
    return networkService.dio.delete("/clinic/$clinicID");
  }

  @override
  Future<Response<dynamic>> getClinicByID({required String clinicID}) {
    return networkService.dio.get("/clinic/$clinicID");
  }

  @override
  Future<Response<dynamic>> getClinics({required String doctorID}) {
    return networkService.dio.get("/doctor/$doctorID/clinics");
  }

  @override
  Future<Response<dynamic>> updateClinics({
    required String clinicID,
    required String? name,
    required String? address,
    required String? city,
    required num? price,
    required String? operatingLicense,
    required Map<String, dynamic>? location,
    required Map<String, dynamic>? schedule,
  }) {
    return networkService.dio.put(
      "/clinic/$clinicID",
      data: {
        "name": name,
        "address": address,
        "city": city,
        "price": price,
        "operatingLicense": operatingLicense,
        "location": location,
        "schedule": schedule,
      },
    );
  }

  @override
  Future<Response<dynamic>> getMyAppointments() {
    return networkService.dio.get('/appointments/my');
  }
}
