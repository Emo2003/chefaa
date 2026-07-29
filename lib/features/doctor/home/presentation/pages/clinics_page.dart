import 'package:chefaa/core/config/get_config.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/core/widgets/inside_app_bar.dart';
import 'package:chefaa/features/doctor/home/presentation/manager/clinic_cubit.dart';
import 'package:chefaa/features/doctor/home/presentation/widgets/clinic_bottom_sheet.dart';
import 'package:chefaa/features/doctor/home/presentation/widgets/clinic_card.dart';
import 'package:chefaa/features/doctor/home/presentation/widgets/custom_outline_button.dart';
import 'package:chefaa/features/doctor/home/presentation/widgets/empty_clinic_state.dart';
import 'package:chefaa/features/patient/home/presentation/manager/users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ClinicsPage extends StatelessWidget {
  const ClinicsPage({super.key});

  void _openAddSheet(BuildContext context) async {
    final cubit = context.read<ClinicCubit>();
    cubit.resetForm();

    await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorManager.lightGray,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const FractionallySizedBox(
          heightFactor: 0.92,
          child: ClinicBottomSheet(
            title: "Add Clinic",
            content: "Enter your clinic details for tracking.",
          ),
        ),
      ),
    );

    if (!context.mounted) return;
    cubit.getClinics(doctorID: cubit.doctorID ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final doctorID = context.select<UsersCubit, String>((cubit) {
      final state = cubit.state;
      return state is UserLoaded ? state.user.id : "";
    });

    return BlocProvider(
      create: (_) {
        final cubit = getIt<ClinicCubit>();
        cubit.doctorID = doctorID;
        cubit.getClinics(doctorID: doctorID);
        return cubit;
      },
      child: Builder(
        builder: (context) {
          final cubit = context.read<ClinicCubit>();

          return Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: InsideAppBar(title: "My Clinics"),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p28,
                vertical: AppPadding.p20,
              ),
              child: BlocBuilder<ClinicCubit, ClinicState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      if (state is ClinicsSuccessState &&
                          state.clinics.isNotEmpty)
                        CustomOutlineButton(
                          text: "Add Clinic",
                          onPressed: () => _openAddSheet(context),
                        ),

                      if (state is ClinicsSuccessState &&
                          state.clinics.isNotEmpty)
                        20.verticalSpace,

                      Expanded(child: _buildContent(context, state, cubit)),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ClinicState state,
    ClinicCubit cubit,
  ) {
    if (state is ClinicsLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ClinicsErrorState) {
      return Center(child: Text(state.message));
    }

    if (state is ClinicsSuccessState) {
      if (state.clinics.isEmpty) {
        return EmptyClinicsState(onAdd: () => _openAddSheet(context));
      }

      return ListView.separated(
        itemCount: state.clinics.length,
        separatorBuilder: (_, _) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final clinic = state.clinics[index];

          return ClinicCard(
            clinic: clinic,
            onPressed: () async {
              await context.push(
                AppRoutesNames.clinicsDetailsPage,
                extra: clinic,
              );
              if (!context.mounted) return;
            },
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}
