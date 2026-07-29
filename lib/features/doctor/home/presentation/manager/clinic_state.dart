part of 'clinic_cubit.dart';

sealed class ClinicState {}

final class ClinicInitialState extends ClinicState {}

final class ClinicAddedLoadingState extends ClinicState {}

final class ClinicAddedSuccessState extends ClinicState {
  ClinicAddedSuccessState();
}

final class ClinicAddedErrorState extends ClinicState {
  final String message;

  ClinicAddedErrorState({required this.message});
}

final class ClinicsLoadingState extends ClinicState {}

final class ClinicsErrorState extends ClinicState {
  final String message;

  ClinicsErrorState({required this.message});
}

final class ClinicsSuccessState extends ClinicState {
  final List<Clinics> clinics;

  ClinicsSuccessState({required this.clinics});
}

final class ClinicEditLoadingState extends ClinicState {}

final class ClinicEditSuccessState extends ClinicState {
  final Clinic clinic;

  ClinicEditSuccessState({required this.clinic});
}

final class ClinicEditErrorState extends ClinicState {
  final String message;

  ClinicEditErrorState({required this.message});
}

final class ClinicDeleteLoadingState extends ClinicState {}

final class ClinicDeleteSuccessState extends ClinicState {
  final String clinicID;

  ClinicDeleteSuccessState({required this.clinicID});
}

final class ClinicDeleteErrorState extends ClinicState {
  final String message;

  ClinicDeleteErrorState({required this.message});
}

final class ClinicLoadingState extends ClinicState {}

final class ClinicSuccessState extends ClinicState {
  final Clinic clinic;

  ClinicSuccessState({required this.clinic});
}

final class ClinicErrorState extends ClinicState {
  final String message;

  ClinicErrorState({required this.message});
}

final class ClinicAppointmentStatusLoadingState extends ClinicState {}

final class ClinicAppointmentStatusSuccessState extends ClinicState {
  List<AppointmentModel> appointments;

  ClinicAppointmentStatusSuccessState({required this.appointments});
}

final class ClinicAppointmentStatusErrorState extends ClinicState {
  final String message;

  ClinicAppointmentStatusErrorState({required this.message});
}
