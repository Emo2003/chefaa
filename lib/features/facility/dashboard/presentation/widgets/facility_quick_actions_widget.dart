import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class FacilityQuickActionsWidget extends StatelessWidget {
  final VoidCallback? onServicesPressed;

  const FacilityQuickActionsWidget({super.key, this.onServicesPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "QUICK ACTIONS",
          style: getBoldStyle(color: ColorManager.gray, fontSize: 12.sp),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _QuickActionItemWidget(
              icon: Icons.local_hospital_outlined,
              label: "Services",
              onTap: onServicesPressed ?? () {},
            ),
            _QuickActionItemWidget(
              icon: Icons.note_add_outlined,
              label: "Upload result",
              onTap: () {
                context.push(AppRoutesNames.facilityResults);
              },
            ),
            _QuickActionItemWidget(
              icon: Icons.add_circle_outline_rounded,
              label: "New Request",
              onTap: () {
                context.push(AppRoutesNames.createPatientRequest);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionItemWidget({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: ColorManager.input, width: 1.w),
            boxShadow: [
              BoxShadow(
                color: ColorManager.black.withValues(alpha: 0.01),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: ColorManager.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: ColorManager.primary, size: 20.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                style: getBoldStyle(color: ColorManager.black, fontSize: 12.sp),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
