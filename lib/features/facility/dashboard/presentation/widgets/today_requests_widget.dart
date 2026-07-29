import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/widgets/custom_text_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/features/facility/dashboard/data/models/get_dashboard_response.dart';
import 'request_item_widget.dart';
import 'empty_state_card_widget.dart';
import 'package:go_router/go_router.dart';

class TodayRequestsWidget extends StatelessWidget {
  final List<DashboardRequestItem>? pendingUploads;

  const TodayRequestsWidget({super.key, this.pendingUploads});

  String _formatTime(String? createdAt) {
    if (createdAt == null) return '';
    final parsed = DateTime.tryParse(createdAt);
    if (parsed == null) return createdAt;
    return DateFormat('hh:mm a').format(parsed.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final list = pendingUploads ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "TODAY'S REQUESTS",
              style: getBoldStyle(
                color: ColorManager.gray.withValues(alpha: 0.8),
                fontSize: 12.sp,
              ).copyWith(letterSpacing: 0.5),
            ),
            CustomTextBtn(
              text: "View All",
              onPressed: () {
                context.push(AppRoutesNames.facilityResults);
              },
            ),
          ],
        ),
        SizedBox(height: 14.h),
        if (list.isEmpty)
          const EmptyStateCardWidget(
            message: "No pending requests at the moment.",
          )
        else
          ...list.map(
            (item) => RequestItemWidget(
              name: item.patientName ?? "Unknown Patient",
              scanType: item.services != null && item.services!.isNotEmpty
                  ? item.services!.join(', ')
                  : "General Scan",
              time: _formatTime(item.createdAt),
              status: item.status ?? "Pending",
              aiMatchedText: "AI MATCHED",
              aiMatchedIcon: Icons.auto_awesome_rounded,
            ),
          ),
      ],
    );
  }
}
