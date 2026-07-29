import 'package:chefaa/core/config/get_config.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/inside_app_bar.dart';
import 'package:chefaa/core/widgets/loading.dart';
import 'package:chefaa/features/patient/appointment/data/models/appointment_model.dart';
import 'package:chefaa/features/patient/appointment/presentation/manager/appointment_cubit.dart';
import 'package:chefaa/features/patient/appointment/presentation/manager/appointment_state.dart';
import 'package:chefaa/features/patient/appointment/presentation/widgets/appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AppointmentCubit>()..getMyAppointments(),
      child: const _AppointmentView(),
    );
  }
}

class _AppointmentView extends StatelessWidget {
  const _AppointmentView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: InsideAppBar(title: 'My Appointments'),
      ),
      body: BlocConsumer<AppointmentCubit, AppointmentState>(
        buildWhen: (previous, current) =>
            current is GetAppointmentsLoadingState ||
            current is GetAppointmentsErrorState ||
            current is GetAppointmentsSuccessState ||
            current is RescheduleSuccessState ||
            current is CancelAppointmentSuccessState,
        listenWhen: (previous, current) =>
            current is RescheduleSuccessState ||
            current is RescheduleErrorState ||
            current is CancelAppointmentLoadingState ||
            current is CancelAppointmentSuccessState ||
            current is CancelAppointmentErrorState,
        listener: (context, state) {
          if (state is RescheduleSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Appointment rescheduled successfully.'),
                backgroundColor: ColorManager.lightGreen,
              ),
            );
          } else if (state is RescheduleErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: ColorManager.error,
              ),
            );
          } else if (state is CancelAppointmentLoadingState) {
            Loading.show(context);
          } else if (state is CancelAppointmentSuccessState) {
            Loading.hide(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Appointment cancelled successfully.'),
                backgroundColor: ColorManager.lightGreen,
              ),
            );
          } else if (state is CancelAppointmentErrorState) {
            Loading.hide(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: ColorManager.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = AppointmentCubit.get(context);

          if (state is GetAppointmentsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: ColorManager.primary),
            );
          }

          if (state is GetAppointmentsErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64.sp,
                      color: ColorManager.error,
                    ),
                    16.verticalSpace,
                    Text(
                      state.error,
                      textAlign: TextAlign.center,
                      style: getMediumStyle(
                        color: ColorManager.gray,
                        fontSize: 16,
                      ),
                    ),
                    24.verticalSpace,
                    CustomBtn(
                      text: 'Try Again',
                      onPressed: () =>
                          cubit.getMyAppointments(forceRefresh: true),
                    ),
                  ],
                ),
              ),
            );
          }

          final appointments = cubit.appointments;

          if (appointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 64.sp,
                    color: ColorManager.gray,
                  ),
                  16.verticalSpace,
                  Text(
                    'No appointments yet.',
                    style: getMediumStyle(
                      color: ColorManager.gray,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: ColorManager.primary,
            onRefresh: () => cubit.getMyAppointments(forceRefresh: true),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p20,
                vertical: AppPadding.p18,
              ),
              child: ListView.separated(
                itemCount: appointments.length,
                separatorBuilder: (_, _) => const SizedBox(height: 20),
                itemBuilder: (_, index) {
                  final appointment = appointments[index];
                  return DoctorCard(
                    isAppointments: true,
                    appointment: appointment,
                    onReschedule: () =>
                        _showRescheduleSheet(context, cubit, appointment),
                    onCancel: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          title: Text(
                            'Cancel Appointment',
                            style: getBoldStyle(
                              color: ColorManager.error,
                              fontSize: 18,
                            ),
                          ),
                          content: Text(
                            'Are you sure you want to cancel this appointment?',
                            style: getRegularStyle(
                              color: ColorManager.black,
                              fontSize: 14,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => context.pop(),
                              child: Text(
                                'No',
                                style: getMediumStyle(
                                  color: ColorManager.gray,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.pop();
                                cubit.cancelAppointment(
                                  appointmentId: appointment.id ?? '',
                                );
                              },
                              child: Text(
                                'Yes, Cancel',
                                style: getMediumStyle(
                                  color: ColorManager.error,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showRescheduleSheet(
    BuildContext pageContext,
    AppointmentCubit cubit,
    AppointmentModel appointment,
  ) {
    showModalBottomSheet(
      context: pageContext,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),

      builder: (_) => _RescheduleSheet(cubit: cubit, appointment: appointment),
    );
  }
}

class _RescheduleSheet extends StatefulWidget {
  final AppointmentCubit cubit;
  final AppointmentModel appointment;

  const _RescheduleSheet({required this.cubit, required this.appointment});

  @override
  State<_RescheduleSheet> createState() => _RescheduleSheetState();
}

class _RescheduleSheetState extends State<_RescheduleSheet> {
  late DateTime _pickedDate;

  late TimeOfDay _slotStart;
  late TimeOfDay _slotEnd;
  late TimeOfDay _timeChosed;

  @override
  void initState() {
    super.initState();
    _pickedDate = _parseDateOrNow(widget.appointment.date);
    _slotStart = _parseTimeOrDefault(
      widget.appointment.slotStart,
      const TimeOfDay(hour: 9, minute: 0),
    );
    _slotEnd = _parseTimeOrDefault(
      widget.appointment.slotEnd,
      const TimeOfDay(hour: 9, minute: 30),
    );
    _timeChosed = _parseTimeOrDefault(
      widget.appointment.timeChosed,
      const TimeOfDay(hour: 9, minute: 0),
    );
  }

  DateTime _parseDateOrNow(String? iso) {
    if (iso == null) return DateTime.now();
    try {
      return DateTime.parse(iso);
    } catch (_) {
      return DateTime.now();
    }
  }

  TimeOfDay _parseTimeOrDefault(String? hhmm, TimeOfDay fallback) {
    if (hhmm == null) return fallback;
    try {
      final parts = hhmm.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (_) {
      return fallback;
    }
  }

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String get _displayDate => DateFormat('dd MMM yyyy').format(_pickedDate);

  String get _apiDate => DateFormat('yyyy-MM-dd').format(_pickedDate);

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _pickedDate.isAfter(now) ? _pickedDate : now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: ColorManager.primary,
            onPrimary: ColorManager.white,
            onSurface: ColorManager.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _pickedDate = picked);
  }

  Future<void> _pickTime({
    required TimeOfDay initial,
    required void Function(TimeOfDay) onPicked,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: ColorManager.primary,
            onPrimary: ColorManager.white,
            onSurface: ColorManager.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => onPicked(picked));
  }

  void _submit() {
    widget.cubit.rescheduleAppointment(
      appointmentId: widget.appointment.id ?? '',
      date: _apiDate,
      slotStart: _fmt(_slotStart),
      slotEnd: _fmt(_slotEnd),
      timeChosed: _fmt(_timeChosed),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      bloc: widget.cubit,
      builder: (_, state) {
        final isLoading = state is RescheduleLoadingState;

        return Padding(
          padding: EdgeInsets.only(
            left: AppPadding.p20,
            right: AppPadding.p20,
            top: AppPadding.p24,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppPadding.p24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reschedule Appointment',
                style: getBoldStyle(color: ColorManager.black, fontSize: 20),
              ),
              4.verticalSpace,
              Text(
                'Tap each row to pick a new date or time.',
                style: getRegularStyle(color: ColorManager.gray, fontSize: 13),
              ),
              20.verticalSpace,

              _PickerRow(
                icon: Icons.calendar_today_outlined,
                label: 'Date',
                value: _displayDate,
                onTap: isLoading ? null : _pickDate,
              ),
              12.verticalSpace,

              _PickerRow(
                icon: Icons.access_time_outlined,
                label: 'Slot Start',
                value: _fmt(_slotStart),
                onTap: isLoading
                    ? null
                    : () => _pickTime(
                        initial: _slotStart,
                        onPicked: (t) => _slotStart = t,
                      ),
              ),
              12.verticalSpace,

              _PickerRow(
                icon: Icons.access_time_filled_outlined,
                label: 'Slot End',
                value: _fmt(_slotEnd),
                onTap: isLoading
                    ? null
                    : () => _pickTime(
                        initial: _slotEnd,
                        onPicked: (t) => _slotEnd = t,
                      ),
              ),
              12.verticalSpace,

              _PickerRow(
                icon: Icons.schedule_outlined,
                label: 'Time Chosen',
                value: _fmt(_timeChosed),
                onTap: isLoading
                    ? null
                    : () => _pickTime(
                        initial: _timeChosed,
                        onPicked: (t) => _timeChosed = t,
                      ),
              ),
              24.verticalSpace,

              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.primary,
                      ),
                    )
                  : CustomBtn(text: 'Confirm Reschedule', onPressed: _submit),
            ],
          ),
        );
      },
    );
  }
}

class _PickerRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _PickerRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap == null ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p16,
            vertical: AppPadding.p14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: ColorManager.input),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: ColorManager.black.withAlpha(10),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorManager.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: ColorManager.primary, size: 18),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: getRegularStyle(
                        color: ColorManager.gray,
                        fontSize: 12,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      value,
                      style: getSemiBoldStyle(
                        color: ColorManager.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: ColorManager.gray),
            ],
          ),
        ),
      ),
    );
  }
}
