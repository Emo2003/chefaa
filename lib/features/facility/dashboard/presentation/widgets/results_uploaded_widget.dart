import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/features/facility/dashboard/data/models/get_dashboard_response.dart';
import 'uploaded_result_item_widget.dart';
import 'empty_state_card_widget.dart';
import 'package:go_router/go_router.dart';

class ResultsUploadedWidget extends StatelessWidget {
  final List<DashboardRequestItem>? uploadedResults;

  const ResultsUploadedWidget({super.key, this.uploadedResults});

  String _formatTime(String? createdAt) {
    if (createdAt == null) return '';
    final parsed = DateTime.tryParse(createdAt);
    if (parsed == null) return createdAt;
    return DateFormat('hh:mm a').format(parsed.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final list = uploadedResults ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "RESULTS UPLOADED",
              style: getBoldStyle(
                color: ColorManager.gray.withValues(alpha: 0.8),
                fontSize: 12.sp,
              ).copyWith(letterSpacing: 0.5),
            ),
            GestureDetector(
              onTap: () {
                context.push(AppRoutesNames.facilityResults);
              },
              child: Text(
                "History",
                style: getBoldStyle(
                  color: ColorManager.primary,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        if (list.isEmpty)
          const EmptyStateCardWidget(message: "No results uploaded today.")
        else
          ...list.map(
            (item) => UploadedResultItemWidget(
              name: item.patientName ?? "Unknown Patient",
              scanType: item.services != null && item.services!.isNotEmpty
                  ? item.services!.join(', ')
                  : "General Scan",
              time: _formatTime(item.createdAt),
            ),
          ),
      ],
    );
  }
}
