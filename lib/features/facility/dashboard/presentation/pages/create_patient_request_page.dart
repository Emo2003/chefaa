import 'package:chefaa/core/config/get_config.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/font_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/core/widgets/validators.dart';
import 'package:chefaa/features/facility/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:chefaa/features/facility/services/data/models/service_model.dart';
import 'package:chefaa/features/facility/services/presentation/manager/services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CreatePatientRequestPage extends StatelessWidget {
  const CreatePatientRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<DashboardCubit>()),
        BlocProvider(create: (_) => getIt<ServicesCubit>()..getMyServices()),
      ],
      child: const _CreatePatientRequestPageBody(),
    );
  }
}

class _CreatePatientRequestPageBody extends StatefulWidget {
  const _CreatePatientRequestPageBody();

  @override
  State<_CreatePatientRequestPageBody> createState() =>
      _CreatePatientRequestPageBodyState();
}

class _CreatePatientRequestPageBodyState
    extends State<_CreatePatientRequestPageBody> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _searchController = TextEditingController();

  final List<ServiceModel> _selectedServices = [];
  bool _viaAI = false;
  String _searchQuery = "";

  @override
  void dispose() {
    _phoneController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleService(ServiceModel service) {
    setState(() {
      if (_selectedServices.any((s) => s.id == service.id)) {
        _selectedServices.removeWhere((s) => s.id == service.id);
      } else {
        _selectedServices.add(service);
      }
    });
  }

  void _clearSelected() {
    setState(() {
      _selectedServices.clear();
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select at least one service',
            style: getMediumStyle(color: ColorManager.white, fontSize: 13.sp),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final serviceIds = _selectedServices.map((s) => s.id!).toList();
    context.read<DashboardCubit>().createPatientRequest(
      patientPhone: _phoneController.text.trim(),
      serviceIds: serviceIds,
      viaAI: _viaAI,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is CreatePatientRequestSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.response.message ?? "Request added successfully",
                style: getMediumStyle(
                  color: ColorManager.white,
                  fontSize: 13.sp,
                ),
              ),
              backgroundColor: ColorManager.lightGreen,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop();
        } else if (state is CreatePatientRequestFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage,
                style: getMediumStyle(
                  color: ColorManager.white,
                  fontSize: 13.sp,
                ),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorManager.lightGray,
        appBar: AppBar(
          backgroundColor: ColorManager.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: ColorManager.primary,
              size: FontSize.s24.sp,
            ),
            onPressed: () => context.pop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Patient Request",
                style: getBoldStyle(
                  color: ColorManager.slate900,
                  fontSize: FontSize.s18.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "Enter patient details and select services",
                style: getRegularStyle(
                  color: ColorManager.gray,
                  fontSize: FontSize.s11.sp,
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(AppSize.s1.h),
            child: Container(
              color: ColorManager.input.withValues(alpha: 0.5),
              height: AppSize.s1.h,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient Info Section
                    Text(
                      "PATIENT INFORMATION",
                      style: getBoldStyle(
                        color: ColorManager.gray,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: _phoneController,
                      text: "Patient Phone (e.g. 01225408571)",
                      keyboardType: TextInputType.phone,
                      validator: Validators.validatePhone,
                    ),
                    SizedBox(height: 24.h),

                    // Services Section Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "SELECT SERVICES",
                          style: getBoldStyle(
                            color: ColorManager.gray,
                            fontSize: 12.sp,
                          ),
                        ),
                        if (_selectedServices.isNotEmpty)
                          GestureDetector(
                            onTap: _clearSelected,
                            child: Text(
                              "Clear selected (${_selectedServices.length})",
                              style: getBoldStyle(
                                color: ColorManager.primary,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Chip list of selected services
                    if (_selectedServices.isNotEmpty) ...[
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: _selectedServices.map((service) {
                          return Chip(
                            label: Text(
                              service.name ?? '',
                              style: getMediumStyle(
                                color: ColorManager.primary,
                                fontSize: 11.sp,
                              ),
                            ),
                            backgroundColor: ColorManager.primary.withValues(
                              alpha: 0.08,
                            ),
                            deleteIcon: Icon(
                              Icons.close,
                              size: 14.sp,
                              color: ColorManager.primary,
                            ),
                            onDeleted: () => _toggleService(service),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              side: BorderSide(
                                color: ColorManager.primary.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // Services search bar and list
                    BlocBuilder<ServicesCubit, ServicesState>(
                      builder: (context, servicesState) {
                        final servicesCubit = context.read<ServicesCubit>();
                        final allServices = [
                          ...servicesCubit.labTests,
                          ...servicesCubit.radiologyScans,
                        ];
                        final availableServices = allServices
                            .where((s) => s.isActive ?? true)
                            .toList();

                        if (servicesState is GetServicesLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: CircularProgressIndicator(
                                color: ColorManager.primary,
                              ),
                            ),
                          );
                        }

                        if (servicesState is GetServicesFailure) {
                          return Center(
                            child: Text(
                              servicesState.errorMessage,
                              style: getRegularStyle(
                                color: Colors.red,
                                fontSize: 13.sp,
                              ),
                            ),
                          );
                        }

                        if (availableServices.isEmpty) {
                          return Center(
                            child: Text(
                              "No services available in the system.",
                              style: getRegularStyle(
                                color: ColorManager.gray,
                                fontSize: 13.sp,
                              ),
                            ),
                          );
                        }

                        final filteredServices = availableServices
                            .where(
                              (s) => (s.name ?? '').toLowerCase().contains(
                                _searchQuery.toLowerCase(),
                              ),
                            )
                            .toList();

                        return Column(
                          children: [
                            // Search field
                            TextFormField(
                              controller: _searchController,
                              style: getRegularStyle(
                                color: ColorManager.black,
                                fontSize: 14.sp,
                              ),
                              decoration: InputDecoration(
                                hintText: "Search services...",
                                hintStyle: getRegularStyle(
                                  color: ColorManager.gray,
                                  fontSize: 14.sp,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: ColorManager.gray,
                                  size: 20.sp,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                fillColor: ColorManager.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.r),
                                  borderSide: const BorderSide(
                                    color: ColorManager.input,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.r),
                                  borderSide: const BorderSide(
                                    color: ColorManager.input,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.r),
                                  borderSide: BorderSide(
                                    color: ColorManager.primary,
                                    width: 1.5.w,
                                  ),
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _searchQuery = val.trim();
                                });
                              },
                            ),
                            SizedBox(height: 14.h),

                            if (filteredServices.isEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Text(
                                  "No matching services found",
                                  style: getRegularStyle(
                                    color: ColorManager.gray,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredServices.length,
                                itemBuilder: (context, index) {
                                  final service = filteredServices[index];
                                  final isSelected = _selectedServices.any(
                                    (s) => s.id == service.id,
                                  );
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 10.h),
                                    decoration: BoxDecoration(
                                      color: ColorManager.white,
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                        color: isSelected
                                            ? ColorManager.primary
                                            : ColorManager.input,
                                        width: isSelected ? 1.5.w : 1.w,
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: Container(
                                        padding: EdgeInsets.all(8.r),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? ColorManager.primary.withValues(
                                                  alpha: 0.1,
                                                )
                                              : ColorManager.lightGray,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          service.category?.toLowerCase() ==
                                                  'scan'
                                              ? Icons
                                                    .radio_button_checked_outlined
                                              : Icons.science_outlined,
                                          color: isSelected
                                              ? ColorManager.primary
                                              : ColorManager.gray,
                                          size: 20.sp,
                                        ),
                                      ),
                                      title: Text(
                                        service.name ?? '',
                                        style: getBoldStyle(
                                          color: ColorManager.black,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Price: \$${service.price ?? 0} | ${service.estimatedTime ?? "N/A"}',
                                        style: getRegularStyle(
                                          color: ColorManager.gray,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                      trailing: Icon(
                                        isSelected
                                            ? Icons.check_circle_rounded
                                            : Icons.radio_button_off_rounded,
                                        color: isSelected
                                            ? ColorManager.primary
                                            : ColorManager.gray,
                                        size: 20.sp,
                                      ),
                                      onTap: () => _toggleService(service),
                                    ),
                                  );
                                },
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 24.h),

                    // Request Type Section
                    Text(
                      "REQUEST TYPE",
                      style: getBoldStyle(
                        color: ColorManager.gray,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManager.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: ColorManager.input,
                          width: 1.w,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Via AI Analysis",
                                style: getBoldStyle(
                                  color: ColorManager.black,
                                  fontSize: 13.sp,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "Enable automated AI smart mapping diagnostics",
                                style: getRegularStyle(
                                  color: ColorManager.gray,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: _viaAI,
                            onChanged: (val) {
                              setState(() {
                                _viaAI = val;
                              });
                            },
                            activeThumbColor: ColorManager.primary,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // Submit Button
                    BlocBuilder<DashboardCubit, DashboardState>(
                      builder: (context, dashboardState) {
                        final isLoading =
                            dashboardState is CreatePatientRequestLoading;
                        return CustomBtn(
                          text: "Create Request",
                          isDisabled: isLoading,
                          onPressed: _submit,
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

