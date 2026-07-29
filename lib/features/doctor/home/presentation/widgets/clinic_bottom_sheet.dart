import 'package:chefaa/core/widgets/inspector_bottom_sheet_container.dart';
import 'package:chefaa/features/doctor/home/presentation/widgets/basic_info_section.dart';
import 'package:chefaa/features/doctor/home/presentation/widgets/schedule_section.dart';
import 'package:chefaa/features/doctor/home/presentation/widgets/working_days_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/delete_confirmation_dialog.dart';
import 'package:chefaa/features/patient/medication/presentation/widgets/outline_button.dart';
import 'package:chefaa/features/doctor/home/presentation/manager/clinic_cubit.dart';
import 'package:go_router/go_router.dart';

class ClinicBottomSheet extends StatefulWidget {
  final String title;
  final String content;
  final bool isEdit;
  final String? clinicID;

  const ClinicBottomSheet({
    super.key,
    required this.title,
    required this.content,
    this.isEdit = false,
    this.clinicID,
  });

  @override
  State<ClinicBottomSheet> createState() => _ClinicBottomSheetState();
}

class _ClinicBottomSheetState extends State<ClinicBottomSheet> {
  late ClinicCubit cubit;

  final weekDays = const [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  @override
  void initState() {
    super.initState();
    cubit = context.read<ClinicCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClinicCubit, ClinicState>(
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);

        if (state is ClinicAddedSuccessState) {
          messenger.showSnackBar(
            const SnackBar(content: Text("Medication added successfully!")),
          );
          context.pop();
        }

        if (state is ClinicEditSuccessState) {
          messenger.showSnackBar(
            const SnackBar(content: Text("Medication updated successfully!")),
          );
          context.pop();
        }

        if (state is ClinicDeleteSuccessState) {
          messenger.showSnackBar(
            const SnackBar(content: Text("Medication deleted successfully!")),
          );
          context.pop();
        }

        if (state is ClinicErrorState ||
            state is ClinicAddedErrorState ||
            state is ClinicEditErrorState ||
            state is ClinicDeleteErrorState) {
          final msg = (state as dynamic).message;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
        }
      },
      builder: (context, state) {
        final loading =
            state is ClinicAddedLoadingState || state is ClinicEditLoadingState;

        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.92,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const InspectorBottomSheetContainer(),

                        Text(
                          widget.title,
                          style: getBoldStyle(
                            color: ColorManager.black,
                            fontSize: 24,
                          ),
                        ),

                        6.verticalSpace,
                        Text(widget.content),

                        20.verticalSpace,

                        BasicInfoSection(
                          clinicNameController: cubit.nameController,
                          cityController: cubit.cityController,
                          consultationPriceController: cubit.priceController,
                          addressController: cubit.addressController,
                          latitudeController: cubit.latitudeController,
                          longitudeController: cubit.longitudeController,
                          licenseController: cubit.operatingLicenseController,
                        ),

                        20.verticalSpace,

                        ScheduleSection(
                          slotDurationController: cubit.slotDurationController,
                          maxPatientsController: cubit.dailyCapacityController,
                          patientPerSlotController:
                              cubit.patientsPerSlotController,
                        ),

                        20.verticalSpace,

                        WorkingDaysSection(
                          activeDay: cubit.activeDay,
                          weekDays: weekDays,
                          selectedDays: cubit.selectedDays,
                          openTimes: cubit.openTimes,
                          closeTimes: cubit.closeTimes,
                          onDayTap: cubit.onDayTap,
                          pickTime: ({required day, required isOpen}) =>
                              cubit.pickTime(
                                context: context,
                                day: day,
                                isOpen: isOpen,
                              ),
                        ),

                        20.verticalSpace,

                        CustomBtn(
                          text: widget.isEdit ? "Save" : "Add",
                          onPressed: () {
                            if (widget.isEdit) {
                              cubit.updateClinic(clinicID: widget.clinicID!);
                            } else {
                              cubit.addClinic();
                            }
                          },
                        ),

                        if (widget.isEdit) ...[
                          10.verticalSpace,
                          OutlineButton(
                            title: "Delete",
                            color: ColorManager.error,
                            onPressed: () {
                              final id = widget.clinicID;
                              if (id == null) return;

                              DeleteConfirmationDialog.show(
                                context: context,
                                title: "Delete Clinic",
                                message: "Are you sure?",
                                onConfirm: () =>
                                    cubit.deleteClinic(clinicID: id),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                if (loading)
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
