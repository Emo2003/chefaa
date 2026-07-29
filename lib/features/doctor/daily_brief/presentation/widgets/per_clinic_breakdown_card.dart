import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/widgets/section_title.dart';

class PerClinicCard extends StatelessWidget {
  final List<Widget> clinics;

  const PerClinicCard({
    super.key,
    required this.clinics,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: "Per Clinic Breakdown",
        ),
        12.verticalSpace,
        ...clinics.map((clinic) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: clinic,
            )),
      ],
    );
  }
}
