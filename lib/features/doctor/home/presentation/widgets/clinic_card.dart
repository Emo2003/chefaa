import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/features/doctor/home/presentation/widgets/clinic_days_avaliable.dart';
import 'package:chefaa/features/doctor/home/presentation/widgets/clinic_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/features/doctor/home/data/models/clinics.dart';

class ClinicCard extends StatelessWidget {
  final Clinics clinic;
  final VoidCallback onPressed;

  const ClinicCard({super.key, required this.onPressed, required this.clinic});

  @override
  Widget build(BuildContext context) {
    final availableDays = clinic.defaultSchedule?.days ?? [];

    return InkWell(
      splashColor: ColorManager.transparent,
      highlightColor: ColorManager.transparent,

      onTap: onPressed,

      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.lightGray,

          borderRadius: BorderRadius.circular(25.r),

          boxShadow: [
            BoxShadow(
              color: ColorManager.gray.withAlpha(100),

              blurRadius: 10,

              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p18,
            vertical: AppPadding.p20,
          ),

          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          clinic.name ?? "Clinic Name",

                          style: getBoldStyle(
                            color: ColorManager.primary,

                            fontSize: 18,
                          ),
                        ),

                        5.verticalSpace,

                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: ColorManager.gray,
                              size: 16,
                            ),

                            Expanded(
                              child: Text(
                                clinic.address ?? "Clinic Address",

                                overflow: TextOverflow.ellipsis,

                                style: getMediumStyle(
                                  color: ColorManager.gray,

                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  12.horizontalSpace,

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p12,

                      vertical: AppPadding.p6,
                    ),

                    decoration: BoxDecoration(
                      color: ColorManager.lawAnalysis,

                      borderRadius: BorderRadius.circular(15.r),
                    ),

                    child: Text(
                      clinic.status ?? "Pending",

                      style: getMediumStyle(
                        color: ColorManager.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              15.verticalSpace,

              Align(
                alignment: Alignment.centerRight,

                child: SizedBox(
                  height: 30.h,

                  child: ListView.separated(
                    shrinkWrap: true,

                    scrollDirection: Axis.horizontal,

                    itemCount: availableDays.length,
                    separatorBuilder: (_, _) => 7.horizontalSpace,

                    itemBuilder: (_, index) {
                      final scheduleDay = availableDays[index];

                      if (scheduleDay.isActive != true) {
                        return const SizedBox.shrink();
                      }
                      return ClinicDaysAvailable(
                        day: scheduleDay.day?.substring(0, 3) ?? "",
                        isAvailable: true,
                      );
                    },
                  ),
                ),
              ),
              15.verticalSpace,
              ClinicStatus(days: clinic.defaultSchedule?.days ?? []),
            ],
          ),
        ),
      ),
    );
  }
}
