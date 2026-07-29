import 'package:chefaa/features/doctor/patients/domain/repositories/patients_repo.dart';
import 'package:chefaa/features/doctor/patients/presentation/manager/patients_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:chefaa/features/doctor/patients/data/models/data.dart';
import 'package:chefaa/features/doctor/patients/data/models/patients/prescription.dart';

@injectable
class PatientsCubit extends Cubit<PatientsState> {
  final PatientsRepo patientsRepo;

  PatientsCubit(this.patientsRepo) : super(PatientsInitialState());

  static PatientsCubit get(BuildContext context) => BlocProvider.of(context);
  Prescription? currentPrescription;
  List<Prescription> previousPrescriptions = [];
  dynamic selectedAppointment;

  void selectAppointment(dynamic appointment) {
    selectedAppointment = appointment;
  }

  TextEditingController diagnosisController = TextEditingController();
  TextEditingController nextVisitController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController labTestController = TextEditingController();
  TextEditingController imagingController = TextEditingController();

  List<MedicationItem> medications = [MedicationItem()];
  int selectedTab = 0;

  void addMedicine() {
    medications.add(MedicationItem());
    if (!isClosed) emit(AddMedicineState());
  }

  void removeMedicine(int index) {
    medications[index].dispose();
    medications.removeAt(index);
    if (!isClosed) emit(RemoveMedicineState());
  }

  List<Data> allPatients = [];
  List<Data> filteredPatients = [];

  Future<void> getPatients() async {
    if (!isClosed) {
      emit(
        PatientsSuccessState(
          upcoming: [],
          completed: [],
          selectedIndex: 0,
          isUpcomingLoading: true,
          isCompletedLoading: false,
        ),
      );
    }

    try {
      final patients = await patientsRepo.getPatients();

      final upcoming = patients
          .where((e) => e.status == "upcoming" && e.paymentStatus == "paid")
          .toList();

      final completed = patients
          .where((e) => e.status == "completed" && e.paymentStatus == "paid")
          .toList();
      if (!isClosed) {
        emit(
          PatientsSuccessState(
            upcoming: upcoming,
            completed: completed,
            selectedIndex: 0,
            isUpcomingLoading: false,
            isCompletedLoading: false,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) emit(PatientsFailureState(e.toString()));
    }
  }

  Future<void> refreshCurrentTab() async {
    try {
      final patients = await patientsRepo.getPatients();

      final upcoming = patients.where((e) => e.status == "upcoming").toList();

      final completed = patients.where((e) => e.status == "completed").toList();
      if (!isClosed) {
        emit(
          PatientsSuccessState(
            upcoming: upcoming,
            completed: completed,
            selectedIndex: selectedTab,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) emit(PatientsFailureState(e.toString()));
    }
  }

  void changeTab(int index) {
    selectedTab = index;

    final currentState = state;

    if (currentState is PatientsSuccessState) {
      if (!isClosed) emit(currentState.copyWith(selectedIndex: index));
    }
  }

  Future<void> createPrescription({required String appointmentId}) async {
    if (!isClosed) emit(PrescriptionCreatingLoadingState());

    try {
      final prescription = await patientsRepo.createPrescription(
        appointment: appointmentId,

        diagnosis: diagnosisController.text,

        medicines: medications
            .map(
              (medicine) => {
                "name": medicine.nameController.text,
                "dosage": medicine.dosageController.text,
                "frequency": medicine.frequencyController.text,
                "duration": medicine.durationController.text,
                "instructions": medicine.instructionsController.text,
              },
            )
            .toList(),

        labTests: labTestController.text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),

        imaging: imagingController.text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),

        nextVisit: nextVisitController.text,

        notes: notesController.text,
      );

      currentPrescription = prescription;
      if (!isClosed) {
        emit(PrescriptionCreatingSuccessState(prescription: prescription));
      }
    } catch (e) {
      if (!isClosed) emit(PrescriptionCreatingErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    diagnosisController.dispose();
    nextVisitController.dispose();
    notesController.dispose();
    labTestController.dispose();
    imagingController.dispose();

    for (final medicine in medications) {
      medicine.dispose();
    }

    return super.close();
  }

  Future<void> updatePrescription({required String appointmentId}) async {
    if (!isClosed) emit(PrescriptionEditingLoadingState());

    try {
      final prescription = await patientsRepo.editPrescription(
        appointment: appointmentId,
        diagnosis: diagnosisController.text,

        medicines: medications
            .map(
              (medicine) => {
                "name": medicine.nameController.text,
                "dosage": medicine.dosageController.text,
                "frequency": medicine.frequencyController.text,
                "duration": medicine.durationController.text,
                "instructions": medicine.instructionsController.text,
              },
            )
            .toList(),

        labTests: labTestController.text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),

        imaging: imagingController.text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),

        nextVisit: nextVisitController.text,

        notes: notesController.text,
      );

      currentPrescription = prescription;
      if (!isClosed) {
        emit(PrescriptionEditingSuccessState(prescription: prescription));
      }
    } catch (e) {
      if (!isClosed) emit(PrescriptionEditingErrorState(e.toString()));
    }
  }

  Future<void> getPrescriptionByAppointment({
    required String appointmentId,
  }) async {
    currentPrescription = null;
    if (!isClosed) emit(PrescriptionByAppointmentLoadingState());

    try {
      currentPrescription = await patientsRepo.getPrescriptionByAppointment(
        appointmentId: appointmentId,
      );
      if (!isClosed) {
        emit(
          PrescriptionByAppointmentSuccessState(
            prescription: currentPrescription!,
          ),
        );
      }
    } catch (e) {
      currentPrescription = null;
      if (!isClosed) emit(PrescriptionByAppointmentErrorState(e.toString()));
    }
  }

  Future<void> getPreviousPrescriptions({required String appointmentId}) async {
    if (!isClosed) emit(PrescriptionPreviousLoadingState());

    try {
      final prescriptions = await patientsRepo.getPreviousPrescriptions(
        appointmentId: appointmentId,
      );
      previousPrescriptions = prescriptions;
      if (!isClosed) {
        emit(PrescriptionPreviousSuccessState(prescriptions: prescriptions));
      }
    } catch (e) {
      if (!isClosed) emit(PrescriptionPreviousErrorState(e.toString()));
    }
  }

  Future<void> completeAppointment({required String appointmentId}) async {
    if (!isClosed) emit(CompleteAppointmentLoadingState());

    try {
      final complete = await patientsRepo.completeAppointment(
        appointmentId: appointmentId,
      );
      if (!isClosed) {
        emit(CompleteAppointmentSuccessState(appointment: complete));
      }

      await refreshCurrentTab();
    } catch (e) {
      if (!isClosed) emit(CompleteAppointmentErrorState(e.toString()));
    }
  }

  void clearPrescriptionForm() {
    diagnosisController.clear();
    nextVisitController.clear();
    notesController.clear();
    labTestController.clear();
    imagingController.clear();

    for (final medicine in medications) {
      medicine.dispose();
    }

    medications = [MedicationItem()];
  }
}

class MedicationItem {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController dosageController = TextEditingController();

  final TextEditingController frequencyController = TextEditingController();

  final TextEditingController durationController = TextEditingController();

  final TextEditingController instructionsController = TextEditingController();

  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    frequencyController.dispose();
    durationController.dispose();
    instructionsController.dispose();
  }
}
