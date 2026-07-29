import 'package:chefaa/shared/file_handler/presentation/manager/file_handler_cubit.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/widgets/upload_dialog.dart';
import 'package:chefaa/features/patient/ai_lab/presentation/manager/ai_report_cubit.dart';
import 'package:chefaa/features/patient/ai_lab/presentation/manager/ai_report_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/features/patient/ai_lab/presentation/widgets/ai_app_bar.dart';
import 'package:go_router/go_router.dart';

class AiLabPage extends StatefulWidget {
  const AiLabPage({super.key});

  @override
  State<AiLabPage> createState() => _AiLabPageState();
}

class _AiLabPageState extends State<AiLabPage> {
  late FileHandlerCubit _fileHandlerCubit;

  @override
  void initState() {
    super.initState();
    _fileHandlerCubit = context.read<FileHandlerCubit>();
    _fileHandlerCubit.clearFile();
  }

  @override
  void dispose() {
    _fileHandlerCubit.clearFile();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AiAppBar(
          title1: "AI Lab Report",
          onPressed: () {
            context.push(AppRoutesNames.historyReportPage);
          },
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<FileHandlerCubit, FileHandlerState>(
            listener: (context, state) {
              if (state is FilePickedSuccess) {
                AiReportCubit.get(context).reportAnalysis(state.file);
              }
            },
          ),

          BlocListener<AiReportCubit, AiReportState>(
            listener: (context, state) {
              if (state is LoadingState) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.lightGray,
                    ),
                  ),
                );
              }

              if (state is SuccessState) {
                context.pop();

                context.push(AppRoutesNames.aiLabAnalysis, extra: state.report,
                );
              }

              if (state is ErrorState) {
                context.pop();

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
        ],
        child: const Padding(
          padding: EdgeInsets.only(top: AppPadding.p28),
          child: Column(
            children: [UploadDialog(isReport: true, text: "Upload Lab Report")],
          ),
        ),
      ),
    );
  }
}
