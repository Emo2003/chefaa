import 'package:chefaa/features/patient/medication/presentation/widgets/basic_info_section.dart';
import 'package:chefaa/features/patient/medication/presentation/widgets/medication_schedule_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/constants_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/delete_confirmation_dialog.dart';
import 'package:chefaa/core/widgets/inspector_bottom_sheet_container.dart';
import 'package:chefaa/features/patient/medication/data/models/medications.dart';
import 'package:chefaa/features/patient/medication/presentation/manager/medication_cubit.dart';
import 'package:chefaa/features/patient/medication/presentation/manager/medication_state.dart';
import 'outline_button.dart';
import 'package:go_router/go_router.dart';

class MedicationBottomSheet extends StatefulWidget {
  final String title;
  final String content;
  final Medications? medication;
  final bool isEdit;

  const MedicationBottomSheet({
    super.key,
    required this.title,
    required this.content,
    this.medication,
    this.isEdit = false,
  });

  @override
  State<MedicationBottomSheet> createState() => _MedicationBottomSheetState();
}

class _MedicationBottomSheetState extends State<MedicationBottomSheet> {
  List<TimeOfDay?> selectedTimes = [];

  late MedicationCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = MedicationCubit.get(context);

    if (widget.isEdit && widget.medication != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadExistingMedication();
      });
    }
  }

  void _loadExistingMedication() {
    final med = widget.medication!;
    cubit.clearControllers();

    setState(() {
      cubit.nameController.text = med.name ?? '';
      cubit.dosageController.text = med.dosage ?? '';
      cubit.formController.text = med.form ?? '';
      cubit.startDateController.text = med.startDate ?? '';
      cubit.endDateController.text = med.endDate ?? '';
      cubit.isActive = med.isActive ?? false;

      selectedTimes = (med.schedule ?? []).map((timeStr) {
        try {
          final dt = DateFormat('hh:mm a').parseLoose(timeStr);
          return TimeOfDay.fromDateTime(dt);
        } catch (_) {
          return null;
        }
      }).toList();

      if (med.timesPerDay != null) {
        final label = AppConstants.timesPerDayToLabel(med.timesPerDay);
        cubit.setTimesPerDay(label);
      }
    });
  }

  void _generateDoses(String? value) {
    if (value == null) return;

    setState(() {
      switch (value) {
        case "Once a day (1)":
          selectedTimes = [null];
          break;
        case "Every 12 hours":
          selectedTimes = [null, null];
          break;
        case "Every 8 hours":
          selectedTimes = [null, null, null];
          break;
        default:
          selectedTimes = [];
      }
    });
  }

  void _pickTime(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTimes[index] ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => selectedTimes[index] = picked);
    }
  }

  void _deleteDose(int index) {
    if (index < selectedTimes.length) {
      setState(() => selectedTimes.removeAt(index));
    }
  }

  void _syncScheduleToCubit() {
    cubit.scheduleController.text = selectedTimes
        .whereType<TimeOfDay>()
        .map((t) => _formatTime(t))
        .join(', ');
  }

  String _formatTime(TimeOfDay t) {
    final period = t.hour < 12 ? 'AM' : 'PM';
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicationCubit, MedicationState>(
      buildWhen: (previous, current) {
        final prevLoading = previous is MedicationAdditionLoadingState || previous is MedicationUpdateLoadingState;
        final currLoading = current is MedicationAdditionLoadingState || current is MedicationUpdateLoadingState;
        return prevLoading != currLoading;
      },
      listenWhen: (previous, current) =>
          current is MedicationAdditionSuccessState ||
          current is MedicationUpdateSuccessState ||
          current is MedicationDeleteSuccessState ||
          current is MedicationAdditionErrorState ||
          current is MedicationUpdateErrorState,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);

        if (state is MedicationAdditionSuccessState) {
          messenger.showSnackBar(
            const SnackBar(content: Text("Medication added successfully!")),
          );
        }

        if (state is MedicationUpdateSuccessState) {
          context.pop();
          messenger.showSnackBar(
            const SnackBar(content: Text("Medication updated successfully!")),
          );
        }

        if (state is MedicationDeleteSuccessState) {
          context.pop();
          messenger.showSnackBar(
            const SnackBar(content: Text("Medication deleted successfully!")),
          );
        }

        if (state is MedicationAdditionErrorState) {
          messenger.showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }

        if (state is MedicationUpdateErrorState) {
          messenger.showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        final isLoading =
            state is MedicationAdditionLoadingState ||
            state is MedicationUpdateLoadingState;

        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.92,
            child: Stack(
              children: [
                SingleChildScrollView(
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
                          widget.title,
                          style: getBoldStyle(
                            fontSize: 24.sp,
                            color: ColorManager.black,
                          ),
                        ),
                        6.verticalSpace,
                        Text(
                          widget.content,
                          style: getSemiBoldStyle(
                            color: ColorManager.gray,
                            fontSize: 14.sp,
                          ),
                        ),

                        24.verticalSpace,

                        BasicInfoSection(
                          hintText: cubit.formController.text.isEmpty
                              ? "Select form"
                              : cubit.formController.text,
                          onChanged: (value) => setState(
                            () => cubit.formController.text = value!,
                          ),
                          values: cubit.formController.text.isEmpty
                              ? null
                              : cubit.formController.text,
                          nameController: cubit.nameController,
                          dosageController: cubit.dosageController,
                          formController: cubit.formController,
                        ),

                        20.verticalSpace,

                        MedicationScheduleSection(
                          selectedTimes: selectedTimes,
                          deleteDose: _deleteDose,
                          onPickTime: _pickTime,
                          hintText: cubit.timesPerDayController.text.isEmpty
                              ? "Select times per day"
                              : cubit.timesPerDayController.text,
                          value: cubit.timesPerDayController.text.isEmpty
                              ? null
                              : cubit.timesPerDayController.text,
                          onChanged: (value) {
                            if (value != null) {
                              cubit.setTimesPerDay(value);
                              _generateDoses(value);
                            }
                          },
                          startDateController: cubit.startDateController,
                          endDateController: cubit.endDateController,
                          onDateSelected: (date) {
                            cubit.startDateController.text = DateFormat(
                              'yyyy-MM-dd',
                            ).format(date);
                          },
                          onTap: () =>
                              setState(() => cubit.isActive = !cubit.isActive),
                          color: cubit.isActive
                              ? ColorManager.primary
                              : ColorManager.input,
                          alignment: cubit.isActive
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                        ),

                        20.verticalSpace,

                        CustomBtn(
                          text: widget.isEdit
                              ? "Update Medication"
                              : "Add Medication",
                          onPressed: () {
                            _syncScheduleToCubit();
                            if (widget.isEdit) {
                              cubit.updateMedication(
                                medicationId: widget.medication!.id!,
                              );
                            } else {
                              cubit.addMedication();
                            }
                          },
                        ),

                        if (widget.isEdit) ...[
                          16.verticalSpace,
                          OutlineButton(
                            isEditSheet: true,
                            color: ColorManager.error,
                            title: "Delete Medication",
                            onPressed: () {
                              final id = widget.medication?.id;
                              if (id != null) {
                                DeleteConfirmationDialog.show(
                                  context: context,
                                  title: "Delete Medication",
                                  message:
                                      "Are you sure you want to delete this medication?",
                                  onConfirm: () => cubit.deleteMedication(id),
                                );
                              }
                            },
                          ),
                        ],

                        30.verticalSpace,
                      ],
                    ),
                  ),
                ),

                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
