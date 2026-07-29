import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/core/widgets/loading.dart';
import 'package:chefaa/features/pharmacy/profile/data/models/pharmacy_profile_response.dart';
import 'package:chefaa/features/pharmacy/profile/presentation/manager/pharmacy_profile_cubit.dart';
import 'package:go_router/go_router.dart';

class EditPharmacyProfilePage extends StatefulWidget {
  final PharmacyProfileData? profileData;

  const EditPharmacyProfilePage({super.key, this.profileData});

  @override
  State<EditPharmacyProfilePage> createState() =>
      _EditPharmacyProfilePageState();
}

class _EditPharmacyProfilePageState extends State<EditPharmacyProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _aboutController;
  late final TextEditingController _deliveryTimeController;
  late final TextEditingController _deliveryAreaController;

  late bool _deliveryAvailable;
  late bool _openNow;
  late bool _prescriptionOnly;

  late final List<Map<String, TextEditingController>> _workingHoursControllers;
  late final List<Map<String, TextEditingController>> _addressControllers;

  @override
  void initState() {
    super.initState();

    final data = widget.profileData;

    _aboutController = TextEditingController(
      text: data?.about ?? "We are a good pharmacy.",
    );
    _deliveryTimeController = TextEditingController(
      text: data?.deliveryTime ?? "45-50 min",
    );

    // Delivery Area can be list of dynamics, join them by comma for the text field
    String initialDeliveryArea = "";
    if (data?.deliveryArea != null && data!.deliveryArea!.isNotEmpty) {
      initialDeliveryArea = data.deliveryArea!.join(", ");
    } else {
      initialDeliveryArea = "Cairo";
    }
    _deliveryAreaController = TextEditingController(text: initialDeliveryArea);

    _deliveryAvailable = data?.deliveryAvailable ?? true;
    _openNow = data?.openNow ?? true;
    _prescriptionOnly = data?.settings?.prescriptionOnly ?? false;

    _workingHoursControllers = [];
    if (data?.workingHours != null && data!.workingHours!.isNotEmpty) {
      for (var item in data.workingHours!) {
        if (item is Map) {
          _workingHoursControllers.add({
            "days": TextEditingController(
              text: (item["days"] ?? "").toString(),
            ),
            "time": TextEditingController(
              text: (item["time"] ?? "").toString(),
            ),
          });
        }
      }
    }
    if (_workingHoursControllers.isEmpty) {
      _workingHoursControllers.add({
        "days": TextEditingController(text: "Sat-Thu"),
        "time": TextEditingController(text: "9AM-11PM"),
      });
      _workingHoursControllers.add({
        "days": TextEditingController(text: "Fri"),
        "time": TextEditingController(text: "2PM-11PM"),
      });
    }

    _addressControllers = [];
    if (data?.addresses != null && data!.addresses!.isNotEmpty) {
      for (var item in data.addresses!) {
        if (item is Map) {
          final loc = item["location"];
          final coords = loc != null && loc["coordinates"] is List
              ? loc["coordinates"] as List
              : [31.2357, 30.0444];
          _addressControllers.add({
            "addressText": TextEditingController(
              text: (item["addressText"] ?? "").toString(),
            ),
            "lng": TextEditingController(
              text: coords.isNotEmpty ? coords[0].toString() : "31.2357",
            ),
            "lat": TextEditingController(
              text: coords.length > 1 ? coords[1].toString() : "30.0444",
            ),
          });
        }
      }
    }
    if (_addressControllers.isEmpty) {
      _addressControllers.add({
        "addressText": TextEditingController(text: "15 Street, Maadi, Cairo"),
        "lng": TextEditingController(text: "31.2357"),
        "lat": TextEditingController(text: "30.0444"),
      });
    }
  }

  @override
  void dispose() {
    _aboutController.dispose();
    _deliveryTimeController.dispose();
    _deliveryAreaController.dispose();
    for (var wh in _workingHoursControllers) {
      wh["days"]?.dispose();
      wh["time"]?.dispose();
    }
    for (var addr in _addressControllers) {
      addr["addressText"]?.dispose();
      addr["lng"]?.dispose();
      addr["lat"]?.dispose();
    }
    super.dispose();
  }

  void _addWorkingHour() {
    setState(() {
      _workingHoursControllers.add({
        "days": TextEditingController(),
        "time": TextEditingController(),
      });
    });
  }

  void _removeWorkingHour(int index) {
    if (_workingHoursControllers.length > 1) {
      setState(() {
        final removed = _workingHoursControllers.removeAt(index);
        removed["days"]?.dispose();
        removed["time"]?.dispose();
      });
    }
  }

  void _addAddress() {
    setState(() {
      _addressControllers.add({
        "addressText": TextEditingController(),
        "lng": TextEditingController(text: "31.2357"),
        "lat": TextEditingController(text: "30.0444"),
      });
    });
  }

  void _removeAddress(int index) {
    if (_addressControllers.length > 1) {
      setState(() {
        final removed = _addressControllers.removeAt(index);
        removed["addressText"]?.dispose();
        removed["lng"]?.dispose();
        removed["lat"]?.dispose();
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      // Split deliveryArea by comma and trim each element
      final areaInput = _deliveryAreaController.text.trim();

      final Map<String, dynamic> body = {
        "deliveryAvailable": _deliveryAvailable,
        "openNow": _openNow,
        "prescriptionOnly": _prescriptionOnly,
        "deliveryTime": _deliveryTimeController.text.trim(),
        "deliveryArea":
            areaInput, // Sending as string as shown in the request example
        "about": _aboutController.text.trim(),
        "workingHours": _workingHoursControllers
            .map(
              (wh) => {
                "days": wh["days"]!.text.trim(),
                "time": wh["time"]!.text.trim(),
              },
            )
            .toList(),
        "addresses": _addressControllers
            .map(
              (addr) => {
                "addressText": addr["addressText"]!.text.trim(),
                "location": {
                  "type": "Point",
                  "coordinates": [
                    double.tryParse(addr["lng"]!.text.trim()) ?? 31.2357,
                    double.tryParse(addr["lat"]!.text.trim()) ?? 30.0444,
                  ],
                },
              },
            )
            .toList(),
      };

      context.read<PharmacyProfileCubit>().updatePharmacyProfile(body);
    }
  }

  Widget _buildSwitchRow(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getSemiBoldStyle(
                    color: ColorManager.black,
                    fontSize: 16.sp,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: getRegularStyle(
                      color: ColorManager.gray,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: ColorManager.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade100, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getBoldStyle(color: ColorManager.primary, fontSize: 16.sp),
          ),
          Divider(color: Colors.grey.shade100, thickness: 1.2, height: 20.h),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: getSemiBoldStyle(color: ColorManager.black, fontSize: 20.sp),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: ColorManager.black),
      ),
      body: BlocListener<PharmacyProfileCubit, PharmacyProfileState>(
        listener: (context, state) {
          if (state is PharmacyProfileUpdateLoading) {
            Loading.show(context);
          } else {
            Loading.hide(context);
            if (state is PharmacyProfileUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully'),
                  backgroundColor: ColorManager.lightGreen,
                ),
              );
              context.pop(true);
            } else if (state is PharmacyProfileUpdateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: ColorManager.error,
                ),
              );
            }
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              children: [
                _buildSectionCard(
                  title: "General Information",
                  children: [
                    Text(
                      "About Pharmacy",
                      style: getMediumStyle(
                        color: ColorManager.black,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _aboutController,
                      text: "Describe your pharmacy...",
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Please enter a description";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                _buildSectionCard(
                  title: "Availability & Settings",
                  children: [
                    _buildSwitchRow(
                      "Delivery Available",
                      "Can you deliver medicines to customers?",
                      _deliveryAvailable,
                      (val) => setState(() => _deliveryAvailable = val),
                    ),
                    Divider(color: Colors.grey.shade50, height: 12.h),
                    _buildSwitchRow(
                      "Open Now",
                      "Is the pharmacy currently open for orders?",
                      _openNow,
                      (val) => setState(() => _openNow = val),
                    ),
                    Divider(color: Colors.grey.shade50, height: 12.h),
                    _buildSwitchRow(
                      "Prescription Only",
                      "Does this pharmacy only accept prescription orders?",
                      _prescriptionOnly,
                      (val) => setState(() => _prescriptionOnly = val),
                    ),
                    Divider(color: Colors.grey.shade50, height: 16.h),
                    Text(
                      "Delivery Time",
                      style: getMediumStyle(
                        color: ColorManager.black,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _deliveryTimeController,
                      text: "e.g., 45-50 min",
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Please enter delivery time";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Delivery Area",
                      style: getMediumStyle(
                        color: ColorManager.black,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _deliveryAreaController,
                      text: "e.g., Cairo",
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Please enter delivery area";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                _buildSectionCard(
                  title: "Working Hours",
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _workingHoursControllers.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final wh = _workingHoursControllers[index];
                        return Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: CustomTextField(
                                controller: wh["days"]!,
                                text: "Days (e.g. Sat-Thu)",
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return "Required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              flex: 4,
                              child: CustomTextField(
                                controller: wh["time"]!,
                                text: "Time (e.g. 9AM-11PM)",
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return "Required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            if (_workingHoursControllers.length > 1) ...[
                              SizedBox(width: 4.w),
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red.shade400,
                                ),
                                onPressed: () => _removeWorkingHour(index),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 12.h),
                    TextButton.icon(
                      onPressed: _addWorkingHour,
                      icon: const Icon(Icons.add, color: ColorManager.primary),
                      label: Text(
                        "Add Time Slot",
                        style: getMediumStyle(
                          color: ColorManager.primary,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                _buildSectionCard(
                  title: "Addresses",
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _addressControllers.length,
                      separatorBuilder: (context, index) =>
                          Divider(color: Colors.grey.shade100, height: 24.h),
                      itemBuilder: (context, index) {
                        final addr = _addressControllers[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Address #${index + 1}",
                                  style: getSemiBoldStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 13.sp,
                                  ),
                                ),
                                if (_addressControllers.length > 1)
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red.shade400,
                                      size: 20.sp,
                                    ),
                                    onPressed: () => _removeAddress(index),
                                  ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            CustomTextField(
                              controller: addr["addressText"]!,
                              text: "Street address details...",
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return "Please enter address text";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Longitude",
                                        style: getMediumStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      CustomTextField(
                                        controller: addr["lng"]!,
                                        text: "31.2357",
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        validator: (val) {
                                          if (val == null ||
                                              double.tryParse(val) == null) {
                                            return "Invalid number";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Latitude",
                                        style: getMediumStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      CustomTextField(
                                        controller: addr["lat"]!,
                                        text: "30.0444",
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        validator: (val) {
                                          if (val == null ||
                                              double.tryParse(val) == null) {
                                            return "Invalid number";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 12.h),
                    TextButton.icon(
                      onPressed: _addAddress,
                      icon: const Icon(Icons.add, color: ColorManager.primary),
                      label: Text(
                        "Add Address",
                        style: getMediumStyle(
                          color: ColorManager.primary,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                CustomBtn(text: "Save Changes", onPressed: _saveProfile),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
