import 'package:chefaa/core/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/features/doctor/patients/presentation/manager/patients_cubit.dart';

class MedicationAdditionCard extends StatelessWidget {
  final MedicationItem medicine;
  final int index;
  final VoidCallback onDelete;
  final bool showDelete;

  const MedicationAdditionCard({
    super.key,
    required this.medicine,
    required this.index,
    required this.onDelete,
    required this.showDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: ColorManager.input),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Medicine ${index + 1}",
                style: getBoldStyle(color: ColorManager.black, fontSize: 18.sp),
              ),

              const Spacer(),

              if (showDelete)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
            ],
          ),

          12.verticalSpace,

          CustomTextField(
            controller: medicine.nameController,
            text: "Enter medication name",
          ),

          10.verticalSpace,

          CustomTextField(
            controller: medicine.instructionsController,
            text: "Instructions (e.g., take with food)",
          ),

          10.verticalSpace,

          CustomTextField(
            controller: medicine.dosageController,
            text: "Dosage (e.g., 500mg)",
          ),

          10.verticalSpace,

          CustomTextField(
            controller: medicine.frequencyController,
            text: "Frequency (e.g., twice a day)",
          ),

          10.verticalSpace,

          CustomTextField(
            controller: medicine.durationController,
            text: "Duration (e.g., 7 days)",
          ),
        ],
      ),
    );
  }
}
