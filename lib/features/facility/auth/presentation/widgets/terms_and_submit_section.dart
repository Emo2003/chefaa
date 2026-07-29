import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/constants_manager.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/terms_of_service.dart';
import 'package:chefaa/core/widgets/already_have_account.dart';
import 'package:chefaa/shared/file_handler/presentation/manager/file_handler_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/features/facility/auth/presentation/manager/facility_auth_cubit.dart';

class TermsAndSubmitSection extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final FacilityAuthCubit cubit;

  const TermsAndSubmitSection({
    super.key,
    required this.formKey,
    required this.cubit,
  });

  @override
  State<TermsAndSubmitSection> createState() => _TermsAndSubmitSectionState();
}

class _TermsAndSubmitSectionState extends State<TermsAndSubmitSection> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                child: isChecked
                    ? SvgPicture.asset(IconsAssets.checkIconActive)
                    : SvgPicture.asset(IconsAssets.checkIconInactive),
              ),
              const SizedBox(width: 12),
              const Expanded(child: TermsOfService()),
            ],
          ),
        ),
        const SizedBox(height: 16),
        BlocSelector<FacilityAuthCubit, FacilityAuthState, bool>(
          selector: (state) => state is SignUpLoading,
          builder: (context, isLoading) {
            return CustomBtn(
              isDisabled: !isChecked || isLoading,
              text: AppConstants.submitForVerification,
              onPressed: () {
                if (widget.formKey.currentState!.validate()) {
                  final file = context.read<FileHandlerCubit>().pickedFile;
                  widget.cubit.signUp(medicalLicence: file);
                }
              },
            );
          },
        ),
        const SizedBox(height: 15),
        AlreadyHaveAccount(
          onPressed: () {
            context.go(AppRoutesNames.login);
          },
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}

