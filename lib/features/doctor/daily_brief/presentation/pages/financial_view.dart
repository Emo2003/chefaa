import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/manager/brief_cubit.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/manager/brief_state.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/widgets/ai_narrative_card.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/widgets/clinic_performance_card.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/widgets/next_estimate_card.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/widgets/per_clinic_breakdown_card.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/widgets/profit_loss_card.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/widgets/recommendation_card.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/widgets/revenue_split_card.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/widgets/risk_flag_card.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/widgets/summary_card.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/widgets/trend_card.dart';
import 'package:chefaa/features/patient/pharmacy/pharmacies/presentation/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FinancialsView extends StatelessWidget {
  const FinancialsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BriefCubit, BriefState>(
      builder: (context, state) {
        if (state.financialsLoading) {
          return const Center(
            child: CircularProgressIndicator(color: ColorManager.primary),
          );
        }

        if (state.financialsError != null) {
          return Center(child: Text(state.financialsError!));
        }

        if (state.financials == null || state.financials!.analysis == null) {
          return const SizedBox.shrink();
        }

        final analysis = state.financials!.analysis!;
        final summary = analysis.summary!;
        final trends = analysis.trends!;
        final prediction = analysis.predictions!;
        final profitLoss = analysis.profitLoss!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppPadding.p4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Financial Analysis",
                        style: getBoldStyle(
                          color: ColorManager.black,
                          fontSize: 18.sp,
                        ),
                      ),
                      Text(
                        "AI-powered profit & loss analysis",
                        style: getRegularStyle(
                          color: ColorManager.gray,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              20.verticalSpace,

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 5.h,
                crossAxisSpacing: 5.w,
                childAspectRatio: 0.97,
                children: [
                  SummaryCard(
                    title: "CONFIRMED REVENUE",
                    value: "${summary.confirmedRevenue} ${summary.currency}",
                    subtitle: "Completed transactions",
                    color: ColorManager.lightGreen,
                  ),
                  SummaryCard(
                    title: "PLATFORM FEE",
                    value: "${summary.platformFee} ${summary.currency}",
                    subtitle: "Platform fees",
                    color: ColorManager.error,
                  ),
                  SummaryCard(
                    title: "NET REVENUE",
                    value: "${summary.netRevenue} ${summary.currency}",
                    subtitle: "After fees",
                    color: ColorManager.primary,
                  ),
                  SummaryCard(
                    title: "EXPECTED",
                    value:
                        "${summary.expectedFromUpcoming} ${summary.currency}",
                    subtitle: "Upcoming sessions",
                    color: ColorManager.primary,
                  ),
                ],
              ),

              15.verticalSpace,

              ProfitLossCard(
                netProfit: (profitLoss.amount ?? 0).toDouble(),
                description: profitLoss.note ?? '',
              ),

              15.verticalSpace,

              AiNarrativeCard(narrative: analysis.aiNarrative ?? ''),

              15.verticalSpace,

              NextEstimateCard(
                estimate:
                    "${prediction.next30DaysEstimate} ${summary.currency}",
                confidence: prediction.confidence ?? '',
                description: prediction.basis ?? '',
              ),

              25.verticalSpace,

              const SectionTitle(title: "Performance Trends"),

              15.verticalSpace,

              Row(
                children: [
                  Expanded(
                    child: TrendCard(
                      value: "${trends.completionRate}%",
                      title: "Completion Rate",
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: TrendCard(
                      value: "${trends.cancellationRate}%",
                      title: "Cancellation Rate",
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: TrendCard(
                      value:
                          "${trends.avgRevenuePerSession} ${summary.currency}",
                      title: "Avg / Session",
                    ),
                  ),
                ],
              ),

              15.verticalSpace,

              Text(
                trends.assessment ?? '',
                style: getRegularStyle(
                  color: ColorManager.black,
                  fontSize: 12.sp,
                ),
              ),

              25.verticalSpace,

              Column(
                children: [
                  PerClinicCard(
                    clinics: analysis.perClinicBreakdown!
                        .map(
                          (clinic) => ClinicPerformanceCard(
                            clinicName: clinic.clinicName ?? '',
                            completed: clinic.completed ?? 0,
                            upcoming: clinic.upcoming ?? 0,
                            revenue: (clinic.estimatedRevenue ?? 0).toDouble(),
                            percentage:
                                double.tryParse(
                                  (clinic.shareOfTotal ?? '0').replaceAll(
                                    '%',
                                    '',
                                  ),
                                ) ??
                                0,
                          ),
                        )
                        .toList(),
                  ),

                  12.verticalSpace,

                  RevenueSplitCard(
                    shares: analysis.perClinicBreakdown!
                        .asMap()
                        .entries
                        .map(
                          (entry) => ClinicRevenueShare(
                            label: entry.value.clinicName ?? '',
                            percentage:
                                double.tryParse(
                                  (entry.value.shareOfTotal ?? '0').replaceAll(
                                    '%',
                                    '',
                                  ),
                                ) ??
                                0,
                            color: ColorManager.primary.withAlpha(
                              255 - (entry.key * 40),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),

              25.verticalSpace,

              const SectionTitle(title: "AI Recommendations"),

              12.verticalSpace,

              RecommendationsCard(
                recommendations: analysis.recommendations ?? [],
              ),

              25.verticalSpace,

              const SectionTitle(title: "Risk Flags"),

              12.verticalSpace,

              RiskFlagsCard(risks: analysis.riskFlags ?? []),
            ],
          ),
        );
      },
    );
  }
}
