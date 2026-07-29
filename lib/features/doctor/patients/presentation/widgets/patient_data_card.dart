import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/features/doctor/patients/presentation/widgets/details_card.dart';
import 'package:chefaa/features/doctor/patients/presentation/widgets/medical_history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/features/doctor/patients/data/models/data.dart';

class PatientDataCard extends StatelessWidget {
  final Data? data;

  const PatientDataCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            Text(
              "Contact Information",
              style: getBoldStyle(color: ColorManager.black, fontSize: 20.sp),
            ),
            15.verticalSpace,
            DetailsCard(
              items: [
                DetailItem(
                  title: 'Full Name',
                  value: data?.patient?.userId!.name ?? "",
                ),
                DetailItem(
                  title: 'Phone',
                  value: data?.patient?.userId?.phoneNumber ?? "",
                ),
                DetailItem(
                  title: 'Email',
                  value: data?.patient?.userId?.email ?? "",
                ),
                DetailItem(
                  title: 'Address',
                  value: data?.patient?.address ?? "",
                ),
              ],
            ),
            30.verticalSpace,
            Text(
              "Personal Information",
              style: getBoldStyle(color: ColorManager.black, fontSize: 20.sp),
            ),
            15.verticalSpace,
            DetailsCard(
              items: [
                DetailItem(
                  title: 'Age',
                  value: data?.patient?.age.toString() ?? "",
                ),
                DetailItem(title: 'Gender', value: data?.patient?.gender ?? ""),
                DetailItem(
                  title: 'Blood Type',
                  value: data?.patient?.bloodType ?? "",
                ),
                DetailItem(
                  title: 'Weight',
                  value: data?.patient?.weight.toString() ?? "",
                ),
              ],
            ),
            30.verticalSpace,
            Text(
              "Medical History",
              style: getBoldStyle(color: ColorManager.black, fontSize: 20.sp),
            ),
            15.verticalSpace,
            const MedicalHistoryCard(),
            30.verticalSpace,
            Text(
              "Appointment History",
              style: getBoldStyle(color: ColorManager.black, fontSize: 20.sp),
            ),
            15.verticalSpace,

            DetailsCard(
              items: [
                DetailItem(
                  title: 'Date',
                  value: data?.date?.toFormattedDate() ?? "",
                ),
                DetailItem(title: 'Time', value: data?.slotStart ?? ""),
                DetailItem(title: 'Clinic', value: data?.clinic?.name ?? ""),
                DetailItem(title: 'Payment', value: data?.paymentOption ?? ""),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension DateFormatting on String {
  String toFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(this));
  }
}
