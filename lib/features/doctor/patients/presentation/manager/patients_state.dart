import 'package:chefaa/features/doctor/patients/data/models/complete/complete_appointment.dart';
import 'package:chefaa/features/doctor/patients/data/models/patients/prescription.dart';

import 'package:chefaa/features/doctor/patients/data/models/data.dart';

sealed class PatientsState {}

class PatientsInitialState extends PatientsState {}

class PatientsLoadingState extends PatientsState {}

class PatientsSuccessState extends PatientsState {
  final List<Data> upcoming;
  final List<Data> completed;

  final bool isUpcomingLoading;
  final bool isCompletedLoading;

  final int selectedIndex;

  PatientsSuccessState({
    required this.upcoming,
    required this.completed,
    this.selectedIndex = 0,
    this.isUpcomingLoading = false,
    this.isCompletedLoading = false,
  });

  List<Data> get currentList => selectedIndex == 0 ? upcoming : completed;

  PatientsSuccessState copyWith({
    List<Data>? upcoming,
    List<Data>? completed,
    int? selectedIndex,
    bool? isUpcomingLoading,
    bool? isCompletedLoading,
  }) {
    return PatientsSuccessState(
      upcoming: upcoming ?? this.upcoming,
      completed: completed ?? this.completed,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isUpcomingLoading: isUpcomingLoading ?? this.isUpcomingLoading,
      isCompletedLoading: isCompletedLoading ?? this.isCompletedLoading,
    );
  }
}

class PatientsFailureState extends PatientsState {
  final String errorMessage;

  PatientsFailureState(this.errorMessage);
}

class PrescriptionCreatingLoadingState extends PatientsState {}

class PrescriptionCreatingSuccessState extends PatientsState {
  final Prescription prescription;

  PrescriptionCreatingSuccessState({required this.prescription});
}

class PrescriptionCreatingErrorState extends PatientsState {
  final String errorMessage;

  PrescriptionCreatingErrorState(this.errorMessage);
}

class PrescriptionEditingLoadingState extends PatientsState {}

class PrescriptionEditingSuccessState extends PatientsState {
  final Prescription prescription;

  PrescriptionEditingSuccessState({required this.prescription});
}

class PrescriptionEditingErrorState extends PatientsState {
  final String errorMessage;

  PrescriptionEditingErrorState(this.errorMessage);
}

class PrescriptionPreviousLoadingState extends PatientsState {}

class PrescriptionPreviousSuccessState extends PatientsState {
  final List<Prescription> prescriptions;

  PrescriptionPreviousSuccessState({required this.prescriptions});
}

class PrescriptionPreviousErrorState extends PatientsState {
  final String errorMessage;

  PrescriptionPreviousErrorState(this.errorMessage);
}

class PrescriptionByAppointmentLoadingState extends PatientsState {}

class PrescriptionByAppointmentSuccessState extends PatientsState {
  final Prescription prescription;

  PrescriptionByAppointmentSuccessState({required this.prescription});
}

class PrescriptionByAppointmentErrorState extends PatientsState {
  final String errorMessage;

  PrescriptionByAppointmentErrorState(this.errorMessage);
}

class CompleteAppointmentLoadingState extends PatientsState {}

class CompleteAppointmentSuccessState extends PatientsState {
  final CompleteAppointment appointment;

  CompleteAppointmentSuccessState({required this.appointment});
}

class CompleteAppointmentErrorState extends PatientsState {
  final String errorMessage;

  CompleteAppointmentErrorState(this.errorMessage);
}

class PatientDetailsLoadingState extends PatientsState {}

class PatientDetailsSuccessState extends PatientsState {
  final Prescription? currentPrescription;
  final List<Prescription> previousPrescriptions;

  PatientDetailsSuccessState({
    required this.currentPrescription,
    required this.previousPrescriptions,
  });
}

class PatientDetailsErrorState extends PatientsState {
  final String errorMessage;

  PatientDetailsErrorState(this.errorMessage);
}

class AddMedicineState extends PatientsState {}

class RemoveMedicineState extends PatientsState {}

class PrescriptionFormResetState extends PatientsState {}
