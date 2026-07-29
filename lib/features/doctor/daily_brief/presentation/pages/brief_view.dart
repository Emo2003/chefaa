import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/features/doctor/daily_brief/data/models/split_brief_response.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/manager/brief_cubit.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/manager/brief_state.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/widgets/action_item_card.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/widgets/finance_mini_card.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/widgets/motivation_card.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/widgets/section_card.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/widgets/state_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BriefView extends StatelessWidget {
  const BriefView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BriefCubit, BriefState>(
      builder: (context, state) {
        if (state.briefLoading) {
          return const Center(
            child: CircularProgressIndicator(color: ColorManager.primary),
          );
        }

        if (state.briefError != null) {
          return Center(child: Text(state.briefError!));
        }

        if (state.brief == null) {
          return const SizedBox.shrink();
        }

        final parsed = ParsedBrief.fromText(state.brief!.brief ?? '');

        return ListView(
          padding: const EdgeInsets.all(AppPadding.p4),
          children: [
            Row(
              children: [
                Column(
                  spacing: 5.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Good Morning",
                      style: getBoldStyle(
                        color: ColorManager.black,
                        fontSize: 18.sp,
                      ),
                    ),
                    Text(
                      parsed.intro,
                      style: getMediumStyle(
                        color: ColorManager.darkGray,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            15.verticalSpace,

            SectionCard(
              title: "Today's Schedule",
              accentColor: ColorManager.primary,
              child: Text(
                parsed.schedule,
                style: getMediumStyle(
                  color: ColorManager.darkGray,
                  fontSize: 13.sp,
                ),
              ),
            ),

            15.verticalSpace,

            SectionCard(
              title: "This Week at a Glance",
              accentColor: ColorManager.primary,
              child: Row(
                spacing: 3.w,
                children: [
                  Expanded(
                    child: StatCard(
                      title: "Appointments",
                      value: parsed.appointments,
                      color: ColorManager.primary,
                    ),
                  ),
                  Expanded(
                    child: StatCard(
                      title: "Completed",
                      value: parsed.completed,
                      color: ColorManager.lightGreen,
                    ),
                  ),
                  Expanded(
                    child: StatCard(
                      title: "Rate",
                      value: parsed.rate,
                      color: ColorManager.primary,
                    ),
                  ),
                ],
              ),
            ),

            15.verticalSpace,

            SectionCard(
              title: "Clinic Status",
              accentColor: ColorManager.error,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 7.w,
                    height: 7.w,
                    margin: EdgeInsets.only(top: 5.h),
                    decoration: const BoxDecoration(
                      color: ColorManager.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  8.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parsed.clinicName,
                          style: getBoldStyle(
                            color: ColorManager.gray,
                            fontSize: 13.sp,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          parsed.workingHours,
                          style: getMediumStyle(
                            color: ColorManager.primary,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            15.verticalSpace,

            SectionCard(
              title: "Financial Snapshot",
              accentColor: ColorManager.lightGreen,
              child: Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: FinanceMiniCard(
                      title: "Revenue",
                      value: parsed.revenue,
                      color: ColorManager.lightGreen,
                    ),
                  ),
                  Expanded(
                    child: FinanceMiniCard(
                      title: "Expected",
                      value: parsed.expectedRevenue,
                      color: ColorManager.primary,
                    ),
                  ),
                  Expanded(
                    child: FinanceMiniCard(
                      title: "Fee",
                      value: parsed.fee,
                      color: ColorManager.error,
                    ),
                  ),
                ],
              ),
            ),

            15.verticalSpace,

            ActionItemCard(
              clinicName: "Elhayaa Clinic",
              message: parsed.actionItem,
            ),

            15.verticalSpace,

            MotivationCard(message: parsed.motivation),
          ],
        );
      },
    );
  }
}
