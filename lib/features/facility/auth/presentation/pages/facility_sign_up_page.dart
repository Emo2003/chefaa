import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/get_config.dart';
import '../../../../../core/resources/constants_manager.dart';
import '../../../../../core/routes/app_routes_names.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/loading_dialog.dart';
import '../../../../../shared/file_handler/presentation/manager/file_handler_cubit.dart';
import '../manager/facility_auth_cubit.dart';
import '../widgets/facility_info_card.dart';
import '../widgets/medical_leadership_card.dart';
import '../widgets/terms_and_submit_section.dart';

class FacilitySignup extends StatefulWidget {
  const FacilitySignup({super.key});

  @override
  State<FacilitySignup> createState() => _FacilitySignupState();
}

class _FacilitySignupState extends State<FacilitySignup> {
  final _formKey = GlobalKey<FormState>();
  late final FacilityAuthCubit _cubit;
  late final FileHandlerCubit _fileHandlerCubit;
  bool _isCubitInitialized = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<FacilityAuthCubit>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isCubitInitialized) {
      _fileHandlerCubit = FileHandlerCubit.get(context);
      _fileHandlerCubit.clearFile();
      _isCubitInitialized = true;
    }
  }

  @override
  void dispose() {
    _cubit.close();
    _fileHandlerCubit.clearFile();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: ColorManager.input,
        appBar: CustomAppBar(
          preferredHeight: 175.h,
          child: Center(
            child: Image.asset("assets/images/chefaa.png", height: 50.h),
          ),
        ),
        body: BlocListener<FacilityAuthCubit, FacilityAuthState>(
          listener: (context, state) {
            if (state is SignUpLoading) {
              showDialog(
                context: context,
                builder: (context) => const LoadingDialog(),
              );
            } else if (state is SingUpFailure) {
              if (context.canPop()) {
                context.pop();
              }
              AnimatedSnackBar.rectangle(
                AppConstants.error,
                state.errorMessage,
                type: AnimatedSnackBarType.error,
                brightness: Brightness.dark,
              ).show(context);
            } else if (state is SingUpSuccess) {
              if (context.canPop()) {
                context.pop();
              }
              AnimatedSnackBar.rectangle(
                AppConstants.success,
                "Welcome  ${state.userName}!",
                type: AnimatedSnackBarType.success,
                brightness: Brightness.dark,
              ).show(context);
              context.go(AppRoutesNames.login);
            }
          },
          child: SafeArea(
            child: Builder(
              builder: (context) {
                var cubit = FacilityAuthCubit.get(context);
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 48),
                          FacilityInfoCard(cubit: cubit),
                          const SizedBox(height: 24),
                          MedicalLeadershipCard(cubit: cubit),
                          const SizedBox(height: 25),
                          TermsAndSubmitSection(
                            formKey: _formKey,
                            cubit: cubit,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
