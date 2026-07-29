import 'package:chefaa/core/config/get_config.dart';
import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/core/widgets/layout_app_bar.dart';
import 'package:chefaa/features/patient/appointment/data/models/appointment_model.dart';
import 'package:chefaa/features/patient/appointment/presentation/manager/appointment_cubit.dart';
import 'package:chefaa/features/patient/appointment/presentation/manager/appointment_state.dart';
import 'package:chefaa/features/patient/home/presentation/manager/users_cubit.dart';
import 'package:chefaa/features/patient/home/presentation/widgets/quick_actions.dart';
import 'package:chefaa/features/patient/lab_results/presentation/manager/lab_results_cubit.dart';
import 'package:chefaa/features/patient/lab_results/presentation/manager/lab_results_state.dart';
import 'package:chefaa/features/patient/medication/presentation/manager/medication_cubit.dart';
import 'package:chefaa/features/patient/medication/presentation/manager/medication_state.dart';
import 'package:chefaa/features/patient/medication/presentation/widgets/medicine_card.dart';
import 'package:chefaa/features/patient/notification/presentation/manager/patient_notification_cubit.dart';
import 'package:chefaa/features/patient/notification/presentation/manager/patient_notification_state.dart';
import 'package:chefaa/features/patient/search/presentation/manager/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../appointment/presentation/widgets/appointment_card.dart';
import '../../../medication/presentation/widgets/empty_medication_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<MedicineCardState> _medicineCardKey =
      GlobalKey<MedicineCardState>();

  @override
  void initState() {
    super.initState();
    context.read<MedicationCubit>().getMedicationList();
    context.read<PatientNotificationCubit>().getNotification();
  }

  void _openSearchPage() {
    context.push(
      AppRoutesNames.patientSearch,
      extra: context.read<SearchCubit>(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LabResultsCubit>()..getLabResults()),
        BlocProvider(
          create: (_) => getIt<AppointmentCubit>()..getMyAppointments(),
        ),
      ],
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(175),
          child: Builder(
            builder: (context) {
              final userName = context.select<UsersCubit, String>((cubit) {
                final state = cubit.state;
                if (state is UserLoaded) return state.user.name;
                if (state is UsersLoading) return "...";
                return "Patient";
              });

              final hasUnread = context.select<PatientNotificationCubit, bool>((
                cubit,
              ) {
                final state = cubit.state;
                if (state is PatientNotificationSuccessState) {
                  return state.notification.any((e) => e.isRead != true);
                }
                return false;
              });

              return CustomAppBarLayout(
                title1: "Hello",
                title2: userName,
                hasUnreadNotifications: hasUnread,
                onPressed: () {
                  context.push(AppRoutesNames.patientNotification);
                },
              );
            },
          ),
        ),
        body: BlocListener<MedicationCubit, MedicationState>(
          listenWhen: (previous, current) =>
              current is MedicationConfirmSuccessState ||
              current is MedicationListErrorState,
          listener: (context, state) {
            if (state is MedicationConfirmSuccessState) {
              _medicineCardKey.currentState?.updateConfirmed(
                state.confirmMedication,
              );
            }

            if (state is MedicationListErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: ColorManager.error,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.p32,
                    horizontal: AppPadding.p20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _openSearchPage,
                          child: IgnorePointer(
                            child: CustomTextField(
                              isSearch: true,
                              rec: true,
                              controller: _searchController,
                              text: "Search Doctor or specialty ",
                              prefixIcon: "assets/icons/search-normal.svg",
                            ),
                          ),
                        ),
                      ),

                      40.verticalSpace,

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Today's Medication",
                              style: getBoldStyle(
                                color: ColorManager.black,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                          BlocBuilder<MedicationCubit, MedicationState>(
                            buildWhen: (previous, current) =>
                                current is MedicationListLoadingState ||
                                current is MedicationListSuccessState ||
                                current is MedicationListErrorState,
                            builder: (context, state) {
                              final medications =
                                  state is MedicationListSuccessState
                                  ? (state.medications.medications ?? [])
                                  : <dynamic>[];

                              if (medications.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return TextButton(
                                onPressed: () =>
                                    context.push(AppRoutesNames.medicationPage),
                                child: Row(
                                  children: [
                                    Text(
                                      "Manage",
                                      style:
                                          getMediumStyle(
                                            color: ColorManager.primary,
                                            fontSize: 16.sp,
                                          ).copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                ColorManager.primary,
                                            decorationThickness: 2,
                                          ),
                                    ),
                                    SvgPicture.asset("assets/icons/drug.svg"),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      15.verticalSpace,
                      BlocBuilder<MedicationCubit, MedicationState>(
                        buildWhen: (previous, current) =>
                            current is MedicationListLoadingState ||
                            current is MedicationListSuccessState ||
                            current is MedicationListErrorState,
                        builder: (context, state) {
                          if (state is MedicationListLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: ColorManager.primary,
                              ),
                            );
                          }

                          if (state is MedicationListErrorState) {
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 24.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorManager.lightGray,
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: ColorManager.error,
                                    size: 40.sp,
                                  ),
                                  12.verticalSpace,
                                  Text(
                                    state.errorMessage,
                                    textAlign: TextAlign.center,
                                    style: getMediumStyle(
                                      color: ColorManager.gray,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  12.verticalSpace,
                                  ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<MedicationCubit>()
                                          .getMedicationList();
                                    },
                                    child: const Text("Retry"),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (state is MedicationListSuccessState) {
                            final medications =
                                state.medications.medications ?? [];

                            if (medications.isEmpty) {
                              return const EmptyMedicationState();
                            }

                            return MedicineCard(
                              key: _medicineCardKey,
                              medications: medications,
                              onPressed: (med) {
                                context
                                    .read<MedicationCubit>()
                                    .confirmMedication(med.id ?? '');
                              },
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                      45.verticalSpace,

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Latest Lab Results",
                              style: getBoldStyle(
                                color: ColorManager.black,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                context.push(AppRoutesNames.labResultsPage),
                            child: Row(
                              children: [
                                Text(
                                  "ViewAll",
                                  style:
                                      getMediumStyle(
                                        color: ColorManager.primary,
                                        fontSize: 16.sp,
                                      ).copyWith(
                                        decoration: TextDecoration.underline,
                                        decorationColor: ColorManager.primary,
                                      ),
                                ),
                                6.horizontalSpace,
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: ColorManager.primary,
                                  size: 14.sp,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      15.verticalSpace,
                      BlocBuilder<LabResultsCubit, LabResultsState>(
                        builder: (context, state) {
                          if (state is LabResultsLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: ColorManager.primary,
                              ),
                            );
                          }
                          if (state is LabResultsErrorState) {
                            return const SizedBox.shrink();
                          }
                          if (state is LabResultsSuccessState) {
                            final results = state.results;
                            if (results.isEmpty) {
                              return Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 24.h,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorManager.lightGray,
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                child: Center(
                                  child: Text(
                                    "No uploaded results yet",
                                    style: getMediumStyle(
                                      color: ColorManager.gray,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              );
                            }
                            final latest = results.first;
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: ColorManager.white,
                                borderRadius: BorderRadius.circular(25.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorManager.black.withValues(
                                      alpha: 0.04,
                                    ),
                                    blurRadius: 10.r,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                border: Border.all(
                                  color: ColorManager.input.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12.r),
                                    decoration: BoxDecoration(
                                      color: ColorManager.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      latest.fileName?.toLowerCase().contains(
                                                'blood',
                                              ) ==
                                              true
                                          ? Icons.bloodtype_outlined
                                          : latest.fileName
                                                    ?.toLowerCase()
                                                    .contains('urine') ==
                                                true
                                          ? Icons.opacity_outlined
                                          : Icons.science_outlined,
                                      color: ColorManager.primary,
                                      size: 24.sp,
                                    ),
                                  ),
                                  12.horizontalSpace,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          latest.fileName ?? 'Lab Report',
                                          style: getBoldStyle(
                                            color: ColorManager.black,
                                            fontSize: 15.sp,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        4.verticalSpace,
                                        Text(
                                          latest.labName ?? 'Laboratory',
                                          style: getMediumStyle(
                                            color: ColorManager.gray,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: ColorManager.primary,
                                      size: 16.sp,
                                    ),
                                    onPressed: () {
                                      context.push(
                                        AppRoutesNames.labResultsPage,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      40.verticalSpace,

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Upcoming Appointment",
                              style: getBoldStyle(
                                color: ColorManager.black,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                context.push(AppRoutesNames.appointmentPage),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "All Appointments",
                                  style: getBoldStyle(
                                    color: ColorManager.primary,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: ColorManager.primary,
                                  size: 12.sp,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      20.verticalSpace,
                      BlocBuilder<AppointmentCubit, AppointmentState>(
                        builder: (context, state) {
                          if (state is GetAppointmentsLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: ColorManager.primary,
                              ),
                            );
                          }

                          final cubit = AppointmentCubit.get(context);
                          final upcoming = cubit.appointments
                              .cast<AppointmentModel?>()
                              .firstWhere(
                                (a) =>
                                    (a?.status ?? '').toLowerCase() ==
                                    'upcoming',
                                orElse: () => null,
                              );

                          if (upcoming == null) {
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 30.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorManager.white,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: ColorManager.input.withValues(
                                    alpha: 0.6,
                                  ),
                                  width: 1.w,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorManager.black.withValues(
                                      alpha: 0.02,
                                    ),
                                    blurRadius: 10.r,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12.r),
                                    decoration: BoxDecoration(
                                      color: ColorManager.primary.withValues(
                                        alpha: 0.08,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.calendar_month_outlined,
                                      color: ColorManager.primary,
                                      size: 32.sp,
                                    ),
                                  ),
                                  16.verticalSpace,
                                  Text(
                                    "No upcoming appointments",
                                    textAlign: TextAlign.center,
                                    style: getBoldStyle(
                                      color: ColorManager.black,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return DoctorCard(
                            appointment: upcoming,
                            onReschedule: () {
                              context.push(AppRoutesNames.appointmentPage);
                            },
                            onCancel: () {
                              context.push(AppRoutesNames.appointmentPage);
                            },
                          );
                        },
                      ),
                      50.verticalSpace,
                      Text(
                        "Quick Actions ",
                        style: getSemiBoldStyle(
                          color: ColorManager.black,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: QuickActions(
                          title: "Emergency",
                          image: SvgAssets.phone,
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: QuickActions(
                          title: "Order Pharmacy",
                          image: SvgAssets.orderPharmacy,
                          onTap: () {
                            context.push(AppRoutesNames.searchPharmacy);
                          },
                        ),
                      ),
                      Expanded(
                        child: QuickActions(
                          title: "Find Lab",
                          image: SvgAssets.findLab,
                          onTap: () => context.push(AppRoutesNames.findLabPage),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
