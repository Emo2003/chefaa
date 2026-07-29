import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class PrescriptionMiniCard extends StatelessWidget {
  final String prescriptionName;
  final void Function() onTap;
  final String date;
  final int medsCount;
  final String status;

  const PrescriptionMiniCard({
    super.key,
    required this.prescriptionName,
    required this.onTap,
    required this.date,
    required this.medsCount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      prescriptionName,
                      maxLines: 2,
                      style: getBoldStyle(
                        color: ColorManager.black,
                        fontSize: 16.sp,
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      formatDate(date),
                      style: getSemiBoldStyle(
                        color: ColorManager.gray,
                        fontSize: 14.sp,
                      ),
                    ),
                    7.verticalSpace,
                    Text(
                      "$medsCount medications",
                      style: getSemiBoldStyle(
                        color: ColorManager.primary,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p6,
                  vertical: AppPadding.p4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(50),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: getSemiBoldStyle(color: Colors.green, fontSize: 12.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatDate(String isoDate) {
  final dateTime = DateTime.parse(isoDate);
  return DateFormat('dd MMM, yyyy • hh:mm a').format(dateTime);
}
