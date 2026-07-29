import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/features/doctor/patients/presentation/manager/patients_cubit.dart';
import 'add_prescription_bottom_sheet.dart';

class EmptyPrescriptionCard extends StatelessWidget {
  const EmptyPrescriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PatientsCubit>();

    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppPadding.p24),
        decoration: BoxDecoration(
          color: ColorManager.lightGray,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black.withAlpha(30),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.description_outlined,
              size: 60.sp,
              color: ColorManager.gray,
            ),

            16.verticalSpace,

            Text(
              "No Prescription Yet",
              style: getSemiBoldStyle(
                color: ColorManager.black,
                fontSize: 18.sp,
              ),
            ),

            8.verticalSpace,

            Text(
              "This appointment doesn't have a prescription yet.\nYou can add one now.",
              textAlign: TextAlign.center,
              style: getRegularStyle(color: ColorManager.gray, fontSize: 14.sp),
            ),

            20.verticalSpace,

            SizedBox(
              width: double.infinity,
              child: CustomBtn(
                text: "Create Prescription",
                onPressed: () {
                  cubit.clearPrescriptionForm();

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
                      value: cubit,
                      child: const AddPrescriptionBottomSheet(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
