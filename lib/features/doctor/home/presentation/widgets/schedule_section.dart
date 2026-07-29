import 'package:chefaa/core/widgets/bottom_sheet_text_field_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/features/patient/profile/presentation/widgets/item_container.dart';

class ScheduleSection extends StatelessWidget {
  final TextEditingController slotDurationController;

  final TextEditingController maxPatientsController;

  final TextEditingController patientPerSlotController;

  const ScheduleSection({
    super.key,
    required this.slotDurationController,
    required this.maxPatientsController,
    required this.patientPerSlotController,
  });

  @override
  Widget build(BuildContext context) {
    return ItemContainer(
      isMedication: true,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Schedule",
              style: getBoldStyle(color: ColorManager.black, fontSize: 18),
            ),

            20.verticalSpace,

            Row(
              children: [
                Expanded(
                  child: BottomSheetTextFieldItem(
                    title: "Slot Duration (MIN)",
                    controller: slotDurationController,
                    hint: "e.g. 30 minutes",
                  ),
                ),

                12.horizontalSpace,

                Expanded(
                  child: BottomSheetTextFieldItem(
                    title: "Max Patients/Day",
                    controller: maxPatientsController,
                    hint: "e.g. 3 patients",
                  ),
                ),
              ],
            ),

            16.verticalSpace,

            BottomSheetTextFieldItem(
              title: "Patient Per Slots",
              controller: patientPerSlotController,
              hint: "e.g. 2 patients per slot",
            ),
          ],
        ),
      ),
    );
  }
}
