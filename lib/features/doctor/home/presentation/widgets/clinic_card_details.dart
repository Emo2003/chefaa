import 'package:chefaa/features/doctor/home/data/models/clinic.dart';
import 'package:chefaa/features/doctor/home/presentation/widgets/schedule_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/features/doctor/home/presentation/manager/clinic_cubit.dart';
import 'appointment_status_cart.dart';
import 'clinic_bottom_sheet.dart';
import 'clinic_days_avaliable.dart';
import 'clinic_info_card.dart';
import 'clinic_status.dart';
import 'custom_outline_button.dart';

class ClinicCardDetails extends StatefulWidget {
  final Clinic clinic;

  const ClinicCardDetails({super.key, required this.clinic});

  @override
  State<ClinicCardDetails> createState() => _ClinicCardDetailsState();
}

class _ClinicCardDetailsState extends State<ClinicCardDetails> {
  late Clinic clinic;

  @override
  void initState() {
    super.initState();
    clinic = widget.clinic;
  }

  Future<void> _openEditSheet(BuildContext context) async {
    final cubit = context.read<ClinicCubit>();

    cubit.fillFromClinic(clinic);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorManager.lightGray,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: ClinicBottomSheet(
          title: "Edit Clinic",
          content: "Update your clinic details.",
          isEdit: true,
          clinicID: clinic.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableDays = clinic.defaultSchedule?.days ?? [];

    final activeDays = availableDays
        .where((day) => day.isActive == true)
        .toList();

    return Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          fontSize: 18.sp,
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
                              clinic.address ?? "Address",
                              overflow: TextOverflow.ellipsis,
                              style: getMediumStyle(
                                color: ColorManager.gray,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                10.horizontalSpace,
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
                  itemCount: activeDays.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 7),
                  itemBuilder: (_, index) {
                    final scheduleDay = activeDays[index];
                    return ClinicDaysAvailable(
                      day: scheduleDay.day?.substring(0, 3) ?? "",
                      isAvailable: true,
                    );
                  },
                ),
              ),
            ),

            10.verticalSpace,
            ClinicStatus(days: clinic.defaultSchedule?.days ?? []),
            15.verticalSpace,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClinicInfoCard(
                  title: "Consultation",
                  value: "${clinic.price ?? 0} EGP",
                ),
                ClinicInfoCard(
                  title: "Slot Duration",
                  value: "${clinic.defaultSchedule?.slotDuration ?? 0} Min",
                ),
              ],
            ),

            10.verticalSpace,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClinicInfoCard(
                  title: "Max Cases",
                  value:
                      "${clinic.defaultSchedule?.dailyCapacity ?? "—"} Patients",
                ),
                ClinicInfoCard(
                  title: "Per Slot",
                  value:
                      "${clinic.defaultSchedule?.patientsPerSlot ?? "—"} Patient",
                ),
              ],
            ),

            10.verticalSpace,

            ClinicInfoCard(
              title: "License",
              value: clinic.operatingLicense ?? "—",
              isInfinity: true,
            ),

            20.verticalSpace,

            Text(
              "Schedule",
              style: getBoldStyle(color: ColorManager.gray, fontSize: 18),
            ),

            15.verticalSpace,

            if (activeDays.isNotEmpty)
              SizedBox(
                height: 155.h,
                child: ListView.separated(
                  itemCount: activeDays.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 7),
                  itemBuilder: (_, index) {
                    final schedule = activeDays[index];

                    return ScheduleCard(
                      day: schedule.day ?? "—",
                      time:
                          "${_formatTime(schedule.open as int?)} - ${_formatTime(schedule.close as int?)}",
                    );
                  },
                ),
              ),

            20.verticalSpace,
            const AppointmentStatusCart(),
            30.verticalSpace,

            CustomOutlineButton(
              isAdd: false,
              text: "Edit",
              onPressed: () => _openEditSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int? minutes) {
    if (minutes == null) return "--";

    final hour = minutes ~/ 60;
    final minute = minutes % 60;
    final period = hour >= 12 ? "PM" : "AM";
    final formattedHour = hour > 12 ? hour - 12 : hour;
    final formattedMinute = minute.toString().padLeft(2, '0');

    return "$formattedHour:$formattedMinute $period";
  }
}
