import 'package:chefaa/core/widgets/inside_app_bar.dart';
import 'package:chefaa/features/doctor/patients/presentation/manager/patients_cubit.dart';
import 'package:chefaa/features/doctor/patients/presentation/widgets/patient_data_card.dart';
import 'package:chefaa/features/doctor/patients/presentation/widgets/prescription_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/features/doctor/patients/presentation/manager/patients_state.dart';
import 'package:chefaa/features/doctor/patients/presentation/widgets/custom_switch_tab.dart';
import 'package:chefaa/features/doctor/patients/presentation/widgets/empty_prescription_card.dart';
import 'package:chefaa/features/doctor/patients/presentation/widgets/prescription_history_bottom_sheet.dart';
import 'package:chefaa/features/doctor/patients/presentation/widgets/prescription_mini_card.dart';

class PatientDetailsPage extends StatefulWidget {
  const PatientDetailsPage({super.key});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  int selectedIndex = 0;

  @override
  @override
  void initState() {
    super.initState();

    final cubit = context.read<PatientsCubit>();
    final appointment = cubit.selectedAppointment;

    if (appointment?.id != null) {
      cubit.getPrescriptionByAppointment(appointmentId: appointment.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: InsideAppBar(title: 'Patient Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: AppPadding.p32,
          left: AppPadding.p12,
          right: AppPadding.p12,
        ),
        child: Column(
          children: [
            CustomSwitchTab(
              items: const ['Prescription', 'Patient Data', 'History'],
              onChanged: (index) {
                setState(() => selectedIndex = index);

                final cubit = context.read<PatientsCubit>();
                final appointment = cubit.selectedAppointment;

                if (appointment?.id == null) return;

                if (index == 0) {
                  cubit.getPrescriptionByAppointment(
                    appointmentId: appointment.id!,
                  );
                }

                if (index == 2 && cubit.previousPrescriptions.isEmpty) {
                  cubit.getPreviousPrescriptions(
                    appointmentId: appointment.id!,
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedIndex) {
      case 0:
        return _buildPrescriptionTab();

      case 1:
        final appointment = context.read<PatientsCubit>().selectedAppointment;

        return PatientDataCard(data: appointment);

      case 2:
        return _buildHistoryTab();

      default:
        return const SizedBox();
    }
  }

  Widget _buildPrescriptionTab() {
    return BlocBuilder<PatientsCubit, PatientsState>(
      buildWhen: (prev, curr) =>
          curr is PrescriptionByAppointmentLoadingState ||
          curr is PrescriptionByAppointmentSuccessState ||
          curr is PrescriptionByAppointmentErrorState,
      builder: (context, state) {
        if (state is PrescriptionByAppointmentLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        final cubit = context.read<PatientsCubit>();
        final prescription = cubit.currentPrescription;

        final medications = (prescription?.data?.medicines ?? [])
            .map<Map<String, String>>(
              (m) => {
                "name": m.name ?? "",
                "dosage": m.dosage ?? "",
                "frequency": m.frequency ?? "",
                "duration": m.duration ?? "",
              },
            )
            .toList();
        if (medications.isEmpty) {
          return const EmptyPrescriptionCard();
        }

        return PrescriptionCard(medications: medications, showAddButton: true);
      },
    );
  }

  Widget _buildHistoryTab() {
    return BlocBuilder<PatientsCubit, PatientsState>(
      buildWhen: (prev, curr) =>
          curr is PrescriptionPreviousLoadingState ||
          curr is PrescriptionPreviousSuccessState ||
          curr is PrescriptionPreviousErrorState,
      builder: (context, state) {
        final cubit = context.read<PatientsCubit>();
        final list = cubit.previousPrescriptions;

        if (state is PrescriptionPreviousLoadingState && list.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (list.isEmpty) {
          return const Center(child: Text("No prescriptions"));
        }

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: list.length,
          separatorBuilder: (_, _) => 10.verticalSpace,
          itemBuilder: (context, index) {
            final p = list[index];
            final meds = (p.data?.medicines ?? [])
                .map<Map<String, String>>(
                  (m) => {
                    "name": m.name ?? "",
                    "dosage": m.dosage ?? "",
                    "frequency": m.frequency ?? "",
                    "duration": m.duration ?? "",
                  },
                )
                .toList();

            return PrescriptionMiniCard(
              prescriptionName: p.data?.diagnosis ?? "Prescription",
              date: p.data?.createdAt ?? "",
              medsCount: meds.length,
              status: "Completed",
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: ColorManager.lightGray,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (_) => BlocProvider.value(
                    value: context.read<PatientsCubit>(),
                    child: PrescriptionHistoryBottomSheet(
                      prescription: p,
                      medications: meds,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
