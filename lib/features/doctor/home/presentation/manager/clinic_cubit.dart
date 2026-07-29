import 'package:chefaa/core/error_handling/failure.dart';
import 'package:chefaa/features/doctor/home/data/models/clinic.dart';
import 'package:chefaa/features/doctor/home/domain/repositories/clinic_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:chefaa/features/doctor/home/data/models/clinics.dart';
import 'package:chefaa/features/patient/appointment/data/models/appointment_model.dart';

part 'clinic_state.dart';

@injectable
class ClinicCubit extends Cubit<ClinicState> {
  final ClinicRepo clinicRepo;

  ClinicCubit(this.clinicRepo) : super(ClinicInitialState());

  static ClinicCubit get(BuildContext context) => BlocProvider.of(context);

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final priceController = TextEditingController();
  final operatingLicenseController = TextEditingController();

  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  final slotDurationController = TextEditingController();
  final dailyCapacityController = TextEditingController();
  final patientsPerSlotController = TextEditingController();

  String? doctorID;
  Clinic? currentClinic;

  String? activeDay;

  final Map<String, bool> selectedDays = {
    "Monday": false,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
    "Friday": false,
    "Saturday": false,
    "Sunday": false,
  };

  final Map<String, TimeOfDay?> openTimes = {};
  final Map<String, TimeOfDay?> closeTimes = {};

  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  Map<String, dynamic> _buildLocation() {
    return {
      "type": "Point",
      "coordinates": [
        double.tryParse(longitudeController.text) ?? 0.0,
        double.tryParse(latitudeController.text) ?? 0.0,
      ],
    };
  }

  List<Map<String, dynamic>> _buildDays() {
    return selectedDays.entries.where((e) => e.value).map((e) {
      final open = openTimes[e.key];
      final close = closeTimes[e.key];

      return {
        "day": e.key,
        "isActive": true,
        "open": open != null ? _toMinutes(open) : 0,
        "close": close != null ? _toMinutes(close) : 0,
      };
    }).toList();
  }

  Map<String, dynamic> _buildSchedule() {
    return {
      "days": _buildDays(),
      "slotDuration": int.tryParse(slotDurationController.text) ?? 30,
      "dailyCapacity": int.tryParse(dailyCapacityController.text) ?? 10,
      "patientsPerSlot": int.tryParse(patientsPerSlotController.text) ?? 1,
    };
  }

  void onDayTap(String day) {
    selectedDays[day] = !(selectedDays[day] ?? false);
    activeDay = selectedDays[day] == true ? day : null;
    if (!isClosed) emit(ClinicInitialState());
  }

  Future<void> pickTime({
    required BuildContext context,
    required String day,
    required bool isOpen,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      if (isOpen) {
        openTimes[day] = picked;
      } else {
        closeTimes[day] = picked;
      }
      if (!isClosed) emit(ClinicInitialState());
    }
  }

  Future<void> addClinic() async {
    if (nameController.text.trim().isEmpty) {
      if (!isClosed) {
        emit(ClinicAddedErrorState(message: "Clinic name cannot be empty"));
      }
      return;
    }
    if (addressController.text.trim().isEmpty ||
        latitudeController.text.trim().isEmpty ||
        longitudeController.text.trim().isEmpty) {
      if (!isClosed) {
        emit(
          ClinicAddedErrorState(
            message: "Please select a clinic location on the map",
          ),
        );
      }
      return;
    }

    if (!isClosed) emit(ClinicAddedLoadingState());

    try {
      await clinicRepo.addClinics(
        name: nameController.text.trim(),
        city: cityController.text.trim(),
        address: addressController.text.trim(),
        price: num.tryParse(priceController.text),
        operatingLicense: operatingLicenseController.text.trim(),
        location: _buildLocation(),
        schedule: _buildSchedule(),
      );
      if (!isClosed) emit(ClinicAddedSuccessState());
    } catch (e) {
      if (!isClosed) emit(ClinicAddedErrorState(message: e.toString()));
    }
  }

  Future<void> getClinicByID({required String clinicID}) async {
    if (!isClosed) emit(ClinicLoadingState());
    try {
      final response = await clinicRepo.getClinicByID(clinicID: clinicID);

      if (response.clinic == null) {
        if (!isClosed) emit(ClinicErrorState(message: "Clinic not found"));
        return;
      }
      if (!isClosed) emit(ClinicSuccessState(clinic: response.clinic!));
    } catch (e) {
      if (!isClosed) emit(ClinicErrorState(message: e.toString()));
    }
  }

  Future<void> updateClinic({required String clinicID}) async {
    if (nameController.text.trim().isEmpty) {
      if (!isClosed) {
        emit(ClinicEditErrorState(message: "Clinic name cannot be empty"));
      }
      return;
    }
    if (addressController.text.trim().isEmpty ||
        latitudeController.text.trim().isEmpty ||
        longitudeController.text.trim().isEmpty) {
      if (!isClosed) {
        emit(
          ClinicEditErrorState(
            message: "Please select a clinic location on the map",
          ),
        );
      }
      return;
    }

    if (!isClosed) emit(ClinicEditLoadingState());

    try {
      final response = await clinicRepo.updateClinics(
        clinicID: clinicID,
        name: nameController.text.trim(),
        city: cityController.text.trim(),
        address: addressController.text.trim(),
        price: num.tryParse(priceController.text),
        operatingLicense: operatingLicenseController.text.trim(),
        location: _buildLocation(),
        schedule: _buildSchedule(),
      );

      if (response.clinic == null) {
        if (!isClosed) emit(ClinicEditErrorState(message: "Update failed"));
        return;
      }
      if (!isClosed) emit(ClinicEditSuccessState(clinic: response.clinic!));
      if (!isClosed) emit(ClinicSuccessState(clinic: response.clinic!));
    } catch (e) {
      if (!isClosed) emit(ClinicEditErrorState(message: e.toString()));
    }
  }

  Future<void> deleteClinic({required String clinicID}) async {
    if (!isClosed) emit(ClinicDeleteLoadingState());

    try {
      await clinicRepo.deleteClinics(clinicID: clinicID);
      if (!isClosed) emit(ClinicDeleteSuccessState(clinicID: clinicID));
    } catch (e) {
      if (!isClosed) emit(ClinicDeleteErrorState(message: e.toString()));
    }
  }

  Future<void> getClinics({required String doctorID}) async {
    if (!isClosed) emit(ClinicsLoadingState());

    try {
      final clinics = await clinicRepo.getClinics(doctorID: doctorID);
      if (!isClosed) emit(ClinicsSuccessState(clinics: clinics.clinics ?? []));
    } catch (e) {
      if (!isClosed) emit(ClinicsErrorState(message: e.toString()));
    }
  }

  void fillFromClinic(Clinic clinic) {
    currentClinic = clinic;

    nameController.text = clinic.name ?? '';
    addressController.text = clinic.address ?? '';
    cityController.text = clinic.city ?? '';
    priceController.text = clinic.price?.toString() ?? '';
    operatingLicenseController.text = clinic.operatingLicense ?? '';

    final coords = clinic.location?.coordinates;
    if (coords != null && coords.length >= 2) {
      longitudeController.text = coords[0].toString();
      latitudeController.text = coords[1].toString();
    }

    final schedule = clinic.defaultSchedule;
    if (schedule != null) {
      slotDurationController.text = schedule.slotDuration?.toString() ?? '';
      dailyCapacityController.text = schedule.dailyCapacity?.toString() ?? '';
      patientsPerSlotController.text =
          schedule.patientsPerSlot?.toString() ?? '';

      resetDays();

      for (final d in schedule.days ?? []) {
        if (d.day == null) continue;

        selectedDays[d.day!] = true;

        if (d.open != null) {
          openTimes[d.day!] = TimeOfDay(
            hour: (d.open as int) ~/ 60,
            minute: (d.open as int) % 60,
          );
        }

        if (d.close != null) {
          closeTimes[d.day!] = TimeOfDay(
            hour: (d.close as int) ~/ 60,
            minute: (d.close as int) % 60,
          );
        }
      }
    }
    if (!isClosed) emit(ClinicInitialState());
  }

  Future<void> getMyAppointments() async {
    if (!isClosed) emit(ClinicAppointmentStatusLoadingState());

    try {
      final appointments = await clinicRepo.getMyAppointments();
      if (!isClosed) {
        emit(ClinicAppointmentStatusSuccessState(appointments: appointments));
      }
    } catch (e) {
      if (e is ServerFailure) {
        if (!isClosed) {
          emit(ClinicAppointmentStatusErrorState(message: e.message));
        }
      } else {
        if (!isClosed) {
          emit(
            ClinicAppointmentStatusErrorState(
              message: ServerFailure.unexpectedError,
            ),
          );
        }
      }
    }
  }

  void resetDays() {
    for (final k in selectedDays.keys) {
      selectedDays[k] = false;
    }
    openTimes.clear();
    closeTimes.clear();
  }

  void resetForm() {
    nameController.clear();
    addressController.clear();
    cityController.clear();
    priceController.clear();
    operatingLicenseController.clear();
    latitudeController.clear();
    longitudeController.clear();
    slotDurationController.clear();
    dailyCapacityController.clear();
    patientsPerSlotController.clear();

    resetDays();
  }

  @override
  Future<void> close() {
    nameController.dispose();
    addressController.dispose();
    cityController.dispose();
    priceController.dispose();
    operatingLicenseController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    return super.close();
  }
}
