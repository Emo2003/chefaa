import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/core/widgets/layout_app_bar.dart';
import 'package:chefaa/features/doctor/home/presentation/manager/clinic_cubit.dart';
import 'package:chefaa/features/doctor/home/presentation/widgets/clinic_card.dart';
import 'package:chefaa/features/doctor/home/presentation/widgets/empty_clinic_state.dart';
import 'package:chefaa/features/patient/home/presentation/manager/users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  @override
  void initState() {
    super.initState();
    final userState = context.read<UsersCubit>().state;
    if (userState is UserLoaded) {
      context.read<ClinicCubit>().getClinics(doctorID: userState.user.id);
    }
  }

  void _refreshClinics() {
    if (!mounted) return;
    final userState = context.read<UsersCubit>().state;
    if (userState is UserLoaded) {
      context.read<ClinicCubit>().getClinics(doctorID: userState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersCubit, UsersState>(
      listenWhen: (previous, current) => current is UserLoaded,
      listener: (context, state) {
        if (state is UserLoaded) {
          context.read<ClinicCubit>().getClinics(doctorID: state.user.id);
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(170),
          child: BlocBuilder<UsersCubit, UsersState>(
            builder: (context, state) {
              String doctorName = "Doctor";
              if (state is UserLoaded) doctorName = state.user.name;
              return CustomAppBarLayout(title1: "Hello", title2: doctorName);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p20,
              vertical: AppPadding.p32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.verticalSpace,

                BlocBuilder<ClinicCubit, ClinicState>(
                  builder: (context, state) {
                    final isEmpty =
                        state is ClinicsSuccessState && state.clinics.isEmpty;

                    return Row(
                      children: [
                        Text(
                          "My Clinics",
                          style: getBoldStyle(
                            color: ColorManager.black,
                            fontSize: 22,
                          ),
                        ),
                        const Spacer(),
                        if (state is ClinicsSuccessState && !isEmpty)
                          TextButton(
                            style: TextButton.styleFrom(
                              overlayColor: ColorManager.transparent,
                            ),
                            onPressed: () async {
                              await context.push(AppRoutesNames.clinicsPage);
                              if (mounted) _refreshClinics();
                            },
                            child: Row(
                              children: [
                                Text(
                                  "View All",
                                  style: getBoldStyle(
                                    color: ColorManager.primary,
                                    fontSize: 18,
                                  ),
                                ),
                                7.horizontalSpace,
                                const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: ColorManager.primary,
                                  size: 17,
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),

                10.verticalSpace,

                BlocBuilder<ClinicCubit, ClinicState>(
                  builder: (context, state) {
                    if (state is ClinicsLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primary,
                        ),
                      );
                    }

                    if (state is ClinicsErrorState) {
                      return Center(child: Text(state.message));
                    }

                    if (state is ClinicsSuccessState) {
                      final clinics = state.clinics;

                      if (clinics.isEmpty) {
                        return EmptyClinicsState(
                          onAdd: () async {
                            await context.push(AppRoutesNames.clinicsPage);
                            if (mounted) _refreshClinics();
                          },
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: clinics.length > 2 ? 2 : clinics.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 15),
                        itemBuilder: (context, index) {
                          final clinic = clinics[index];
                          return ClinicCard(
                            clinic: clinic,
                            onPressed: () async {
                              await context.push(
                                AppRoutesNames.clinicsDetailsPage,
                                extra: clinic,
                              );
                              if (mounted) _refreshClinics();
                            },
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
