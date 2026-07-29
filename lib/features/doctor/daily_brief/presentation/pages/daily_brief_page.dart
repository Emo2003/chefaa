import 'package:chefaa/core/widgets/inside_app_bar.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/manager/brief_cubit.dart';
import 'package:chefaa/features/doctor/patients/presentation/widgets/custom_switch_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'brief_view.dart';
import 'financial_view.dart';

class DailyBriefPage extends StatefulWidget {
  const DailyBriefPage({super.key});

  @override
  State<DailyBriefPage> createState() => _DailyBriefPageState();
}

class _DailyBriefPageState extends State<DailyBriefPage> {
  int selectedTab = 0;
  bool briefLoaded = false;
  bool financialsLoaded = false;

  @override
  void initState() {
    super.initState();

    context.read<BriefCubit>().getDailyBrief(language: 'en');
    briefLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: InsideAppBar(title: 'Daily Brief', isLayout: true),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            CustomSwitchTab(
              items: const ['Brief', 'Financials'],
              onChanged: (index) {
                setState(() {
                  selectedTab = index;
                });

                if (index == 0) {
                  context.read<BriefCubit>().getDailyBrief(language: 'en');
                } else {
                  context.read<BriefCubit>().getFinancialsReport(
                    language: 'en',
                  );
                }
              },
            ),

            24.verticalSpace,
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: selectedTab == 0
                    ? const BriefView()
                    : const FinancialsView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
