import 'package:chefaa/core/error_handling/failure.dart';
import 'package:chefaa/features/doctor/home/data/data_sources/clinic_data_source.dart';
import 'package:chefaa/features/doctor/home/data/models/clinic_response.dart';
import 'package:chefaa/features/doctor/home/data/models/clinics_response.dart';
import 'package:chefaa/features/doctor/home/domain/repositories/clinic_repo.dart';
import 'package:chefaa/features/patient/appointment/data/models/appointment_model.dart';
import 'package:chefaa/features/patient/appointment/data/models/appointment_response_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ClinicRepo)
class ClinicRepoImp implements ClinicRepo {
  ClinicDataSource clinicDataSource;

  ClinicRepoImp(this.clinicDataSource);

  @override
  Future<ClinicResponse> addClinics({
    required String? name,
    required String? address,
    required String? city,
    required num? price,
    required String? operatingLicense,
    required Map<String, dynamic>? location,
    required Map<String, dynamic>? schedule,
  }) async {
    try {
      final response = await clinicDataSource.addClinics(
        name: name,
        address: address,
        city: city,
        price: price,
        operatingLicense: operatingLicense,
        location: location,
        schedule: schedule,
      );
      if (response.statusCode == 200) {
        return ClinicResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to add clinic");
      }
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e).message;
    } catch (e) {
      throw ServerFailure.unexpectedError;
    }
  }

  @override
  Future<ClinicResponse> deleteClinics({required String clinicID}) async {
    try {
      final response = await clinicDataSource.deleteClinics(clinicID: clinicID);
      if (response.statusCode == 200) {
        return ClinicResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to delete clinic");
      }
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e).message;
    } catch (e) {
      throw ServerFailure.unexpectedError;
    }
  }

  @override
  Future<ClinicResponse> getClinicByID({required String clinicID}) async {
    try {
      final response = await clinicDataSource.getClinicByID(clinicID: clinicID);
      if (response.statusCode == 200) {
        return ClinicResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to get clinic by ID");
      }
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e).message;
    } catch (e) {
      throw ServerFailure.unexpectedError;
    }
  }

  @override
  Future<ClinicsResponse> getClinics({required String doctorID}) async {
    try {
      final response = await clinicDataSource.getClinics(doctorID: doctorID);
      if (response.statusCode == 200) {
        return ClinicsResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to get clinics");
      }
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e).message;
    } catch (e) {
      throw ServerFailure.unexpectedError;
    }
  }

  @override
  Future<ClinicResponse> updateClinics({
    required String clinicID,
    required String? name,
    required String? address,
    required String? city,
    required num? price,
    required String? operatingLicense,
    required Map<String, dynamic>? location,
    required Map<String, dynamic>? schedule,
  }) async {
    try {
      final response = await clinicDataSource.updateClinics(
        clinicID: clinicID,
        name: name,
        address: address,
        city: city,
        price: price,
        operatingLicense: operatingLicense,
        location: location,
        schedule: schedule,
      );

      if (response.statusCode == 200) {
        return ClinicResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to update clinic');
      }
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e).message;
    } catch (e) {
      throw ServerFailure.unexpectedError;
    }
  }

  @override
  Future<List<AppointmentModel>> getMyAppointments() async {
    try {
      final response = await clinicDataSource.getMyAppointments();
      final model = AppointmentResponseModel.fromJsonList(response.data);
      return model.appointments ?? [];
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    } catch (_) {
      throw ServerFailure(ServerFailure.unexpectedError);
    }
  }
}
