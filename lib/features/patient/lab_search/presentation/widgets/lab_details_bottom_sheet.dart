import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/features/patient/lab_search/data/models/search_centers_response.dart';
import 'package:go_router/go_router.dart';

class LabDetailsBottomSheet extends StatelessWidget {
  final CenterModel centerData;

  const LabDetailsBottomSheet({super.key, required this.centerData});

  String get _centerImage {
    if (centerData.facilityType?.toLowerCase() == 'lab') {
      return ImageAssets.labBackground;
    } else if (centerData.facilityType?.toLowerCase() == 'both') {
      return ImageAssets.mri;
    } else {
      return ImageAssets.xRay;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.lightGray,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
                width: 50.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: ColorManager.input,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),

            // Header Image & Info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Image.asset(
                      _centerImage,
                      width: 90.w,
                      height: 90.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          centerData.name ?? "Lab Name",
                          style: getBoldStyle(
                            color: ColorManager.black,
                            fontSize: 18.sp,
                          ),
                        ),
                        6.verticalSpace,
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 16.sp,
                              color: ColorManager.primary,
                            ),
                            4.horizontalSpace,
                            Text(
                              centerData.distance ?? "Unknown distance",
                              style: getMediumStyle(
                                color: ColorManager.gray,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                        8.verticalSpace,
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 18.sp,
                              color: ColorManager.gold,
                            ),
                            4.horizontalSpace,
                            Text(
                              (centerData.rating ?? 0.0).toString(),
                              style: getBoldStyle(
                                color: ColorManager.black,
                                fontSize: 14.sp,
                              ),
                            ),
                            8.horizontalSpace,
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorManager.lightBlue.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                centerData.facilityType?.toUpperCase() ?? "LAB",
                                style: getBoldStyle(
                                  color: ColorManager.primary,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            20.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Divider(color: ColorManager.input, thickness: 1.h),
            ),
            16.verticalSpace,

            // Details Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About Center",
                    style: getBoldStyle(color: ColorManager.black, fontSize: 16.sp),
                  ),
                  12.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(
                        icon: Icons.payments_rounded,
                        title: "Starting from",
                        subtitle: "EGP ${centerData.minPrice ?? 0}",
                        iconColor: ColorManager.green600,
                      ),
                      _buildInfoItem(
                        icon: Icons.access_time_rounded,
                        title: "Next Slot",
                        subtitle: centerData.nextSlot ?? "Available Now",
                        iconColor: ColorManager.blue600,
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(
                        icon: Icons.home_repair_service_rounded,
                        title: "Home Visit",
                        subtitle: (centerData.homeServiceAvailable == true) 
                            ? "Available" 
                            : "Not Available",
                        iconColor: ColorManager.purple600,
                      ),
                      _buildInfoItem(
                        icon: Icons.health_and_safety_rounded,
                        title: "Insurance",
                        subtitle: (centerData.insuranceAccepted == true) 
                            ? "Accepted" 
                            : "Not Accepted",
                        iconColor: ColorManager.mint600,
                      ),
                    ],
                  ),
                  
                  if (centerData.availableTags != null && centerData.availableTags!.isNotEmpty) ...[
                    20.verticalSpace,
                    Text(
                      "Available Services",
                      style: getBoldStyle(color: ColorManager.black, fontSize: 16.sp),
                    ),
                    12.verticalSpace,
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: centerData.availableTags!.map((tag) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: ColorManager.white,
                            border: Border.all(color: ColorManager.input),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            tag.name ?? "",
                            style: getMediumStyle(
                              color: ColorManager.darkGray,
                              fontSize: 12.sp,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            
            32.verticalSpace,
            // Action Button
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: MediaQuery.of(context).padding.bottom + 20.h),
              child: SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to booking or handle action
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Book Appointment",
                    style: getBoldStyle(
                      color: ColorManager.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20.sp),
        ),
        12.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: getMediumStyle(color: ColorManager.gray, fontSize: 12.sp),
            ),
            2.verticalSpace,
            Text(
              subtitle,
              style: getBoldStyle(color: ColorManager.black, fontSize: 13.sp),
            ),
          ],
        ),
      ],
    );
  }
}
