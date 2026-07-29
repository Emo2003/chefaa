import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../doctor/home/presentation/widgets/custom_outline_button.dart';

class EmptyMedicationState extends StatelessWidget {
  const EmptyMedicationState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p18),
      decoration: BoxDecoration(
        color: ColorManager.lightGray,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medication_outlined,
            size: 30.sp,
            color: ColorManager.primary.withAlpha(80),
          ),
          12.verticalSpace,
          Text(
            "No Medications Yet",
            style: getBoldStyle(color: ColorManager.black, fontSize: 16.sp),
          ),
          5.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              "Add your medications to track them daily",
              style: getMediumStyle(color: ColorManager.gray, fontSize: 12.sp),
              textAlign: TextAlign.center,
            ),
          ),
          5.verticalSpace,
          CustomOutlineButton(
            text: "Add Medication",
            onPressed: () {
              context.push(AppRoutesNames.medicationPage);
            },
          ),
        ],
      ),
    );
  }
}
