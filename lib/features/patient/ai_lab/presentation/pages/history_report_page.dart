import 'package:chefaa/core/services/hive_service.dart';
import 'package:chefaa/features/patient/ai_lab/data/models/report_analysis.dart';
import 'package:chefaa/features/patient/ai_lab/presentation/manager/ai_report_cubit.dart';
import 'package:chefaa/features/patient/ai_lab/presentation/widgets/analysis_app_bar.dart';
import 'package:chefaa/features/patient/ai_lab/presentation/widgets/history_report_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../core/routes/app_routes_names.dart';

class ReportsHistoryPage extends StatelessWidget {
  const ReportsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box(HiveBoxes.reportsBox);
    final cubit = AiReportCubit.get(context);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AnalysisAppBar(title1: "AI Lab Report History"),
      ),

      body: ValueListenableBuilder(
        valueListenable: box.listenable(),

        builder: (context, Box box, _) {
          final reports = box.toMap().entries.toList().reversed.toList();

          if (reports.isEmpty) {
            return const Center(child: Text("No reports yet"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),

            itemBuilder: (context, index) {
              final item = reports[index];

              final report = ReportAnalysis.fromJson(
                Map<String, dynamic>.from(item.value),
              );

              return ReportCard(
                report: report,

                onTap: () {
                  context.push(AppRoutesNames.reportDetails, extra: report);
                },

                onDelete: () async {
                  await cubit.deleteReport(item.key);

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Deleted successfully")),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
