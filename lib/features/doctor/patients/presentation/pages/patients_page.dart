import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/widgets/inside_app_bar.dart';
import 'package:chefaa/features/doctor/patients/presentation/manager/patients_cubit.dart';
import 'package:chefaa/features/doctor/patients/presentation/manager/patients_state.dart';
import 'package:chefaa/features/doctor/patients/presentation/widgets/custom_switch_tab.dart';
import 'package:chefaa/features/doctor/patients/presentation/widgets/patient_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/routes/app_routes_names.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PatientsCubit>().getPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: InsideAppBar(title: 'My Patients', isLayout: true),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: AppPadding.p32,
          left: AppPadding.p18,
          right: AppPadding.p18,
        ),
        child: BlocBuilder<PatientsCubit, PatientsState>(
          builder: (context, state) {
            if (state is PatientsFailureState) {
              return Center(child: Text(state.errorMessage));
            }

            if (state is PatientsSuccessState) {
              return Column(
                children: [
                  CustomSwitchTab(
                    items: const ['Upcoming', 'Completed'],
                    onChanged: (index) {
                      context.read<PatientsCubit>().changeTab(index);
                    },
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (state.selectedIndex == 0 &&
                            state.isUpcomingLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: ColorManager.primary,
                            ),
                          );
                        }

                        if (state.selectedIndex == 1 &&
                            state.isCompletedLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: ColorManager.primary,
                            ),
                          );
                        }

                        if (state.currentList.isEmpty) {
                          return Center(
                            child: Text(
                              state.selectedIndex == 0
                                  ? "No upcoming patients"
                                  : "No completed patients",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.only(top: AppPadding.p18),
                          separatorBuilder: (_, _) => 10.verticalSpace,
                          itemCount: state.currentList.length,
                          itemBuilder: (context, index) {
                            final patient = state.currentList[index];

                            return PatientCard(
                              onTap: () async {
                                final cubit = context.read<PatientsCubit>();

                                cubit.selectAppointment(patient);

                                await context.push(
                                  AppRoutesNames.patientDetailsPage,
                                  extra: cubit,
                                );

                                await cubit.refreshCurrentTab();
                              },
                              isFollowingUp: patient.isFollowUp,
                              name: patient.patient?.userId?.name ?? "",
                              status: patient.status ?? "upcoming",
                              lastVisit: patient.date != null
                                  ? DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(DateTime.parse(patient.date!))
                                  : "",
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                CustomSwitchTab(
                  items: const ['Upcoming', 'Completed'],
                  onChanged: (_) {},
                ),
                const SizedBox(height: 10),
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
