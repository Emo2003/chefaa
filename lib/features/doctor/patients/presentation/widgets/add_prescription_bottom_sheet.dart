import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/core/widgets/inspector_bottom_sheet_container.dart';
import 'package:chefaa/features/doctor/home/presentation/widgets/custom_outline_button.dart';
import 'package:chefaa/features/patient/medication/presentation/widgets/medication_calender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/features/doctor/patients/data/models/patients/prescription.dart';
import 'package:chefaa/features/doctor/patients/presentation/manager/patients_cubit.dart';
import 'package:chefaa/features/doctor/patients/presentation/manager/patients_state.dart';
import 'medicine_addition_card.dart';
import 'package:go_router/go_router.dart';

class AddPrescriptionBottomSheet extends StatefulWidget {
  final bool isEdit;
  final Prescription? prescription;

  const AddPrescriptionBottomSheet({
    super.key,
    this.isEdit = false,
    this.prescription,
  });

  @override
  State<AddPrescriptionBottomSheet> createState() =>
      _AddPrescriptionBottomSheetState();
}

class _AddPrescriptionBottomSheetState
    extends State<AddPrescriptionBottomSheet> {
  Widget sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: getBoldStyle(color: ColorManager.black, fontSize: 20.sp),
      ),
    );
  }

  Widget textField({
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: ColorManager.input.withAlpha(60),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: const BorderSide(color: ColorManager.gray),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    final cubit = context.read<PatientsCubit>();

    if (widget.isEdit && widget.prescription != null) {
      final p = widget.prescription!;

      cubit.diagnosisController.text = p.data?.diagnosis ?? '';
      cubit.notesController.text = p.data?.notes ?? '';
      cubit.nextVisitController.text = p.data?.nextVisit ?? '';
      cubit.labTestController.text = (p.data?.labTests ?? []).join('\n');
      cubit.imagingController.text = (p.data?.imaging ?? []).join('\n');

      for (final medicine in cubit.medications) {
        medicine.dispose();
      }
      cubit.medications.clear();

      final medicines = p.data?.medicines ?? [];

      for (final med in medicines) {
        final item = MedicationItem();

        item.nameController.text = med.name ?? '';
        item.dosageController.text = med.dosage ?? '';
        item.frequencyController.text = med.frequency ?? '';
        item.durationController.text = med.duration ?? '';
        item.instructionsController.text = med.instructions ?? '';

        cubit.medications.add(item);
      }

      if (cubit.medications.isEmpty) {
        cubit.medications.add(MedicationItem());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientsCubit, PatientsState>(
      buildWhen: (previous, current) {
        final prevLoading =
            previous is PrescriptionCreatingLoadingState ||
            previous is PrescriptionEditingLoadingState;
        final currLoading =
            current is PrescriptionCreatingLoadingState ||
            current is PrescriptionEditingLoadingState;
        return prevLoading != currLoading;
      },
      listenWhen: (previous, current) =>
          current is PrescriptionCreatingSuccessState ||
          current is PrescriptionEditingSuccessState ||
          current is PrescriptionCreatingErrorState ||
          current is PrescriptionEditingErrorState,
      listener: (context, state) async {
        final cubit = context.read<PatientsCubit>();

        if (state is PrescriptionCreatingSuccessState ||
            state is PrescriptionEditingSuccessState) {
          final appointment = cubit.selectedAppointment;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state is PrescriptionEditingSuccessState
                    ? "Prescription updated successfully"
                    : "Prescription added successfully",
              ),
            ),
          );
          context.pop();

          if (appointment?.id != null) {
            await cubit.getPrescriptionByAppointment(
              appointmentId: appointment.id!,
            );
          }
        }

        if (!context.mounted) return;

        if (state is PrescriptionCreatingErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }

        if (state is PrescriptionEditingErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        final cubit = context.read<PatientsCubit>();

        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .8,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p20,
                  vertical: AppPadding.p16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const InspectorBottomSheetContainer(),

                    Text(
                      widget.isEdit ? "Edit Prescription" : "Add Prescription",
                      style: getBoldStyle(
                        color: ColorManager.black,
                        fontSize: 24.sp,
                      ),
                    ),

                    6.verticalSpace,

                    Text(
                      widget.isEdit
                          ? "Update patient prescription details"
                          : "Add patient prescription details",
                      style: getMediumStyle(
                        color: ColorManager.gray,
                        fontSize: 14.sp,
                      ),
                    ),

                    24.verticalSpace,

                    sectionTitle("Diagnosis"),

                    CustomTextField(
                      controller: cubit.diagnosisController,
                      text: "Enter diagnosis details",
                    ),

                    10.verticalSpace,

                    sectionTitle("Medications"),

                    BlocBuilder<PatientsCubit, PatientsState>(
                      buildWhen: (previous, current) =>
                          current is AddMedicineState ||
                          current is RemoveMedicineState,
                      builder: (context, state) {
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cubit.medications.length,
                              itemBuilder: (context, index) {
                                return MedicationAdditionCard(
                                  medicine: cubit.medications[index],
                                  index: index,
                                  showDelete: cubit.medications.length > 1,
                                  onDelete: () {
                                    cubit.removeMedicine(index);
                                  },
                                );
                              },
                            ),

                            10.verticalSpace,

                            CustomOutlineButton(
                              text: "Add Another Medicine",
                              onPressed: () {
                                cubit.addMedicine();
                              },
                            ),
                          ],
                        );
                      },
                    ),

                    10.verticalSpace,

                    sectionTitle("Lab Tests"),

                    textField(
                      hint: "Enter lab tests",
                      controller: cubit.labTestController,
                      maxLines: 3,
                    ),

                    sectionTitle("Imaging / Radiology Tests"),

                    textField(
                      hint: "Enter imaging tests",
                      controller: cubit.imagingController,
                      maxLines: 3,
                    ),

                    10.verticalSpace,

                    sectionTitle("Next Visit"),

                    MedicationCalender(
                      hintText: "Next Visit Date",
                      controller: cubit.nextVisitController,
                      onDateSelected: (date) {
                        cubit.nextVisitController.text =
                            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                      },
                    ),

                    20.verticalSpace,

                    sectionTitle("Doctor Notes"),

                    textField(
                      hint: "Write notes...",
                      controller: cubit.notesController,
                      maxLines: 5,
                    ),

                    20.verticalSpace,

                    (state is PrescriptionCreatingLoadingState ||
                            state is PrescriptionEditingLoadingState)
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: ColorManager.primary,
                            ),
                          )
                        : CustomBtn(
                            text: widget.isEdit
                                ? "Update Prescription"
                                : "Add Prescription",
                            onPressed: () {
                              final appointment = cubit.selectedAppointment;

                              if (appointment?.id == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Appointment ID not found"),
                                  ),
                                );
                                return;
                              }

                              if (widget.isEdit) {
                                cubit.updatePrescription(
                                  appointmentId: appointment.id!,
                                );
                              } else {
                                cubit.createPrescription(
                                  appointmentId: appointment.id!,
                                );
                              }
                            },
                          ),

                    20.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
