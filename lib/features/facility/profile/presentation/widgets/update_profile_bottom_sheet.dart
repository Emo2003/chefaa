import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/font_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/services/storage_service.dart';
import 'package:chefaa/features/facility/profile/presentation/manager/facility_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

void showUpdateProfileBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<FacilityProfileCubit>(),
      child: const _UpdateProfileBottomSheet(),
    ),
  );
}

class _UpdateProfileBottomSheet extends StatefulWidget {
  const _UpdateProfileBottomSheet();

  @override
  State<_UpdateProfileBottomSheet> createState() =>
      _UpdateProfileBottomSheetState();
}

class _UpdateProfileBottomSheetState extends State<_UpdateProfileBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  late bool _homeSampleCollection;
  late bool _aiRecommendations;
  late bool _insuranceAccepted;
  int? _openHour;
  int? _closeHour;
  late bool _cashEnabled;
  late bool _visaEnabled;
  late bool _insuranceEnabled;

  @override
  void initState() {
    super.initState();
    final profileData = context.read<FacilityProfileCubit>().profileData;
    _nameController.text = profileData?.name ?? StorageService.user?.name ?? '';
    _phoneController.text = profileData?.phoneNumber ?? '';
    _addressController.text = profileData?.addresses?.isNotEmpty == true
        ? (profileData!.addresses!.first.addressText ?? '')
        : '';
    _homeSampleCollection =
        profileData?.settings?.homeSampleCollection ?? false;
    _aiRecommendations = profileData?.settings?.aiRecommendations ?? false;
    _insuranceAccepted = profileData?.settings?.insuranceAccepted ?? false;

    final workingHours = profileData?.workingHours;
    _openHour = workingHours?.open?.toInt() ?? 9;
    _closeHour = workingHours?.close?.toInt() ?? 23;

    final paymentMethods = profileData?.paymentmethod ?? [];
    _cashEnabled = paymentMethods.any((e) => e.toLowerCase() == 'cash');
    _visaEnabled = paymentMethods.any((e) => e.toLowerCase() == 'visa');
    _insuranceEnabled = paymentMethods.any(
      (e) => e.toLowerCase() == 'insurance',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final body = <String, dynamic>{
      'homeSampleCollection': _homeSampleCollection,
      'aiRecommendations': _aiRecommendations,
      'insuranceAccepted': _insuranceAccepted,
      'workingHours': {
        if (_openHour != null) 'open': _openHour,
        if (_closeHour != null) 'close': _closeHour,
      },
      'paymentmethod': [
        if (_cashEnabled) 'Cash',
        if (_visaEnabled) 'Visa',
        if (_insuranceEnabled) 'Insurance',
      ],
      'paymentMethod': [
        if (_cashEnabled) 'Cash',
        if (_visaEnabled) 'Visa',
        if (_insuranceEnabled) 'Insurance',
      ],
      'paymentMethods': [
        if (_cashEnabled) 'Cash',
        if (_visaEnabled) 'Visa',
        if (_insuranceEnabled) 'Insurance',
      ],
    };

    if (_nameController.text.trim().isNotEmpty) {
      body['name'] = _nameController.text.trim();
    }
    if (_phoneController.text.trim().isNotEmpty) {
      body['phoneNumber'] = _phoneController.text.trim();
    }

    final profileData = context.read<FacilityProfileCubit>().profileData;
    final originalAddressText = profileData?.addresses?.isNotEmpty == true
        ? (profileData!.addresses!.first.addressText ?? '')
        : '';
    final originalLocation = profileData?.addresses?.isNotEmpty == true
        ? profileData!.addresses!.first.location
        : null;

    final hasAddressChanged =
        _addressController.text.trim() != originalAddressText;

    if (_addressController.text.trim().isNotEmpty && hasAddressChanged) {
      final coords = (originalLocation?.coordinates?.isNotEmpty == true)
          ? originalLocation!.coordinates!
          : <double>[31.2357, 30.0444];

      body['addresses'] = [
        {
          'addressText': _addressController.text.trim(),
          'location': {'type': 'Point', 'coordinates': coords},
        },
      ];
    }

    context.read<FacilityProfileCubit>().updateProfile(body);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.r24.r),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: ColorManager.input,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Edit Profile',
                  style: getBoldStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s16.sp,
                  ),
                ),
                SizedBox(height: 20.h),

                // Name
                _buildTextField(
                  controller: _nameController,
                  label: 'Name',
                  hint: 'Enter facility name',
                ),
                SizedBox(height: 14.h),

                // Phone
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: 'Enter phone number',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 14.h),

                // Address
                _buildTextField(
                  controller: _addressController,
                  label: 'Address',
                  hint: 'Enter address',
                ),
                SizedBox(height: 14.h),

                // Working Hours Row
                Row(
                  children: [
                    Expanded(
                      child: _buildHourDropdown(
                        label: 'Open Hour',
                        value: _openHour,
                        onChanged: (v) => setState(() => _openHour = v),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildHourDropdown(
                        label: 'Close Hour',
                        value: _closeHour,
                        onChanged: (v) => setState(() => _closeHour = v),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Toggles
                _buildSwitch(
                  label: 'Home Sample Collection',
                  value: _homeSampleCollection,
                  onChanged: (v) => setState(() => _homeSampleCollection = v),
                ),
                _buildSwitch(
                  label: 'AI Recommendations',
                  value: _aiRecommendations,
                  onChanged: (v) => setState(() => _aiRecommendations = v),
                ),
                _buildSwitch(
                  label: 'Insurance Accepted',
                  value: _insuranceAccepted,
                  onChanged: (v) => setState(() => _insuranceAccepted = v),
                ),
                _buildSwitch(
                  label: 'Cash Payment',
                  value: _cashEnabled,
                  onChanged: (v) => setState(() => _cashEnabled = v),
                ),
                _buildSwitch(
                  label: 'Visa Payment',
                  value: _visaEnabled,
                  onChanged: (v) => setState(() => _visaEnabled = v),
                ),
                _buildSwitch(
                  label: 'Insurance Payment',
                  value: _insuranceEnabled,
                  onChanged: (v) => setState(() => _insuranceEnabled = v),
                ),
                SizedBox(height: 20.h),

                // Save button
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary,
                    foregroundColor: ColorManager.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r16.r),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: getBoldStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s14.sp,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getMediumStyle(
            color: ColorManager.darkGray,
            fontSize: FontSize.s12.sp,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: getRegularStyle(
            color: ColorManager.black,
            fontSize: FontSize.s13.sp,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: getRegularStyle(
              color: ColorManager.gray,
              fontSize: FontSize.s13.sp,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              borderSide: const BorderSide(color: ColorManager.input),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              borderSide: const BorderSide(color: ColorManager.input),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              borderSide: BorderSide(color: ColorManager.primary, width: 1.5.w),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHourDropdown({
    required String label,
    required int? value,
    required ValueChanged<int?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getMediumStyle(
            color: ColorManager.darkGray,
            fontSize: FontSize.s12.sp,
          ),
        ),
        SizedBox(height: 6.h),
        DropdownButtonFormField<int>(
          initialValue: value,
          onChanged: onChanged,
          style: getRegularStyle(
            color: ColorManager.black,
            fontSize: FontSize.s13.sp,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              borderSide: const BorderSide(color: ColorManager.input),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              borderSide: const BorderSide(color: ColorManager.input),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
              borderSide: BorderSide(color: ColorManager.primary, width: 1.5.w),
            ),
          ),
          items: List.generate(24, (index) {
            final h = index;
            final period = h >= 12 ? 'PM' : 'AM';
            var displayHour = h % 12;
            if (displayHour == 0) displayHour = 12;
            final displayHourStr = displayHour.toString().padLeft(2, '0');
            return DropdownMenuItem<int>(
              value: h,
              child: Text('$displayHourStr:00 $period'),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getRegularStyle(
            color: ColorManager.darkGray,
            fontSize: FontSize.s13.sp,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: ColorManager.primary,
        ),
      ],
    );
  }
}

