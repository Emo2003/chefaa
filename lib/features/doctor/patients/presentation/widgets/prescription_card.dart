import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/features/doctor/home/presentation/widgets/custom_outline_button.dart';
import 'package:chefaa/features/doctor/patients/presentation/manager/patients_cubit.dart';
import 'package:chefaa/features/doctor/patients/presentation/widgets/empty_prescription_card.dart';
import 'package:chefaa/features/doctor/patients/presentation/widgets/lab_tests.dart';
import 'package:chefaa/features/doctor/patients/presentation/widgets/medication_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/features/doctor/patients/data/models/patients/prescription.dart';
import 'package:chefaa/features/doctor/patients/presentation/manager/patients_state.dart';
import 'add_prescription_bottom_sheet.dart';

class PrescriptionCard extends StatefulWidget {
  final List<Map<String, String>> medications;
  final bool showAddButton;
  final bool showEditButton;
  final Prescription? prescriptionOverride;

  const PrescriptionCard({
    super.key,
    required this.medications,
    required this.showAddButton,
    this.showEditButton = true,
    this.prescriptionOverride,
  });

  @override
  State<PrescriptionCard> createState() => _PrescriptionCardState();
}

class _PrescriptionCardState extends State<PrescriptionCard> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientsCubit, PatientsState>(
      buildWhen: (previous, current) {
        final prevLoading =
            previous is PrescriptionByAppointmentLoadingState ||
            previous is CompleteAppointmentLoadingState;
        final currLoading =
            current is PrescriptionByAppointmentLoadingState ||
            current is CompleteAppointmentLoadingState;
        return prevLoading != currLoading ||
            current is PrescriptionByAppointmentSuccessState;
      },
      listenWhen: (previous, current) =>
          current is CompleteAppointmentSuccessState ||
          current is CompleteAppointmentErrorState,
      listener: (context, state) {
        if (state is CompleteAppointmentSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Appointment marked as completed successfully"),
            ),
          );
        }

        if (state is CompleteAppointmentErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        final cubit = context.read<PatientsCubit>();
        final appointment = cubit.selectedAppointment;

        final prescription =
            widget.prescriptionOverride ?? cubit.currentPrescription;
        if (prescription == null) {
          return const EmptyPrescriptionCard();
        }

        if (state is PrescriptionByAppointmentLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        final bool isUpcoming =
            appointment?.status?.toLowerCase() == "upcoming";
        final bool shouldShowEditButton = widget.showEditButton;

        final bool showMarkAsCompleteButton =
            widget.showEditButton && isUpcoming;
        final bool isCompleting = state is CompleteAppointmentLoadingState;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
              top: AppPadding.p20,
              left: AppPadding.p4,
              right: AppPadding.p4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorManager.lightGray,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: ColorManager.primary.withAlpha(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.black.withAlpha(50),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: ColorManager.primary.withAlpha(30),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.event,
                          color: ColorManager.primary,
                          size: 22.sp,
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Next Visit",
                              style: getBoldStyle(
                                color: ColorManager.primary,
                                fontSize: 17.sp,
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              prescription.data?.nextVisit ?? "Soon",
                              style: getBoldStyle(
                                color: ColorManager.black,
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorManager.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          appointment?.status ?? "upcoming",
                          style: getMediumStyle(
                            color: ColorManager.primary,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                30.verticalSpace,

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Medication Items",
                        style: getBoldStyle(
                          color: ColorManager.black,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p12,
                        vertical: AppPadding.p4,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManager.primary.withAlpha(50),
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: Text(
                        "${widget.medications.length} items",
                        style: getMediumStyle(
                          color: ColorManager.primary,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                15.verticalSpace,
                if (widget.medications.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ColorManager.lightGray,
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: const Center(child: Text("No medications added")),
                  )
                else
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 80.h,
                      maxHeight: 250.h,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppPadding.p16),
                      decoration: BoxDecoration(
                        color: ColorManager.lightGray,
                        borderRadius: BorderRadius.circular(25.r),
                        boxShadow: [
                          BoxShadow(
                            color: ColorManager.black.withAlpha(80),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: RawScrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        trackColor: ColorManager.input.withAlpha(85),
                        thickness: 5,
                        radius: const Radius.circular(25),
                        interactive: true,
                        child: ListView.separated(
                          shrinkWrap: true,
                          primary: false,
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(right: AppPadding.p16),
                          itemCount: widget.medications.length,
                          separatorBuilder: (_, _) => const Divider(
                            color: ColorManager.input,
                            thickness: 1,
                          ),
                          itemBuilder: (context, index) {
                            final item = widget.medications[index];
                            return MedicationItems(
                              medicationName: item['name'] ?? "",
                              dosage: item['dosage'] ?? "",
                              frequency: item['frequency'] ?? "",
                              duration: item['duration'] ?? "",
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                30.verticalSpace,
                Text(
                  "Lab Tests",
                  style: getBoldStyle(
                    color: ColorManager.black,
                    fontSize: 20.sp,
                  ),
                ),
                15.verticalSpace,
                LabTests(
                  tests: (prescription.data?.labTests?.isNotEmpty ?? false)
                      ? prescription.data!.labTests!
                      : ["No lab tests added"],
                ),
                30.verticalSpace,
                Text(
                  "Imaging / Radiology Tests",
                  style: getBoldStyle(
                    color: ColorManager.black,
                    fontSize: 20.sp,
                  ),
                ),
                15.verticalSpace,
                LabTests(
                  tests: (prescription.data?.imaging?.isNotEmpty ?? false)
                      ? prescription.data!.imaging!
                      : ["No imaging tests added"],
                ),
                30.verticalSpace,
                Text(
                  "Doctor Notes",
                  style: getBoldStyle(
                    color: ColorManager.black,
                    fontSize: 20.sp,
                  ),
                ),
                15.verticalSpace,
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppPadding.p20),
                    decoration: BoxDecoration(
                      color: ColorManager.lightGray,
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(color: ColorManager.gold),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.black.withAlpha(50),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Text(
                      prescription.data?.notes ?? "No notes added",
                      style: getMediumStyle(
                        color: ColorManager.black,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),

                30.verticalSpace,
                if (shouldShowEditButton)
                  Column(
                    children: [
                      30.verticalSpace,
                      CustomBtn(
                        text: "Edit Prescription",
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: ColorManager.lightGray,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            builder: (_) => BlocProvider.value(
                              value: context.read<PatientsCubit>(),
                              child: AddPrescriptionBottomSheet(
                                isEdit: true,
                                prescription: prescription,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                if (showMarkAsCompleteButton)
                  Column(
                    children: [
                      20.verticalSpace,

                      isCompleting
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: ColorManager.primary,
                              ),
                            )
                          : CustomOutlineButton(
                              text: "Mark As Complete",
                              onPressed: () async {
                                await context
                                    .read<PatientsCubit>()
                                    .completeAppointment(
                                      appointmentId: appointment!.id!,
                                    );
                              },
                            ),
                    ],
                  ),
                50.verticalSpace,
              ],
            ),
          ),
        );
      },
    );
  }
}
