import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/features/facility/services/presentation/manager/services_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddServiceBottomSheet extends StatefulWidget {
  final bool isLab;

  const AddServiceBottomSheet({super.key, required this.isLab});

  @override
  State<AddServiceBottomSheet> createState() => _AddServiceBottomSheetState();
}

class _AddServiceBottomSheetState extends State<AddServiceBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _estimatedTimeController = TextEditingController();
  final _sessionDurationController = TextEditingController();
  final _instructionsController = TextEditingController();

  late String _category;
  PlatformFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _category = widget.isLab ? 'test' : 'scan';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _estimatedTimeController.dispose();
    _sessionDurationController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedImage = result.files.first;
      });
    }
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.all(24.r),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: ColorManager.lightGray,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Add New Service",
                  style: getBoldStyle(
                    color: ColorManager.black,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Service Name",
                    hintText: _category == 'test'
                        ? "e.g., Urine Analysis - Full"
                        : "e.g., X-Ray - Chest PA view",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? "Name is required" : null,
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Price (\$)",
                    hintText: "e.g., 100",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Price is required";
                    if (double.tryParse(val) == null) {
                      return "Invalid price format";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _estimatedTimeController,
                  decoration: InputDecoration(
                    labelText: "Estimated Time",
                    hintText: _category == 'test'
                        ? "e.g., Result in 3h"
                        : "e.g., 45 min session",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  validator: (val) => val == null || val.isEmpty
                      ? "Estimated time is required"
                      : null,
                ),
                SizedBox(height: 16.h),
                if (_category == 'scan') ...[
                  TextFormField(
                    controller: _sessionDurationController,
                    decoration: InputDecoration(
                      labelText: "Session Duration",
                      hintText: "e.g., 45 min",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    validator: (val) =>
                        _category == 'scan' && (val == null || val.isEmpty)
                        ? "Session duration is required"
                        : null,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.image, size: 18.sp),
                        label: const Text("Pick Image"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.lightGray,
                          foregroundColor: ColorManager.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          _pickedImage != null
                              ? _pickedImage!.name
                              : "No image selected",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getRegularStyle(
                            color: ColorManager.gray,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                ] else ...[
                  TextFormField(
                    controller: _instructionsController,
                    decoration: InputDecoration(
                      labelText: "Instructions",
                      hintText: "e.g., First morning sample",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    validator: (val) =>
                        _category == 'test' && (val == null || val.isEmpty)
                        ? "Instructions are required"
                        : null,
                  ),
                  SizedBox(height: 16.h),
                ],
                SizedBox(height: 12.h),
                BlocConsumer<ServicesCubit, ServicesState>(
                  listener: (context, state) {
                    if (state is AddServiceSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Service added successfully!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      if (context.mounted) {
                        context.pop();
                      }
                    } else if (state is AddServiceFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error: ${state.errorMessage}"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: state is AddServiceLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  if (_category == 'scan' &&
                                      _pickedImage == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please select an image file for scan service",
                                        ),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                    return;
                                  }

                                  context.read<ServicesCubit>().addService(
                                    name: _nameController.text.trim(),
                                    category: _category,
                                    price: double.parse(
                                      _priceController.text.trim(),
                                    ),
                                    estimatedTime: _estimatedTimeController.text
                                        .trim(),
                                    sessionDuration: _category == 'scan'
                                        ? _sessionDurationController.text.trim()
                                        : null,
                                    instructions: _category == 'test'
                                        ? _instructionsController.text.trim()
                                        : null,
                                    imagePath: _category == 'scan'
                                        ? _pickedImage?.path
                                        : null,
                                  );
                                }
                              },
                        child: state is AddServiceLoading
                            ? SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: const CircularProgressIndicator(
                                  color: ColorManager.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Add Service",
                                style: getBoldStyle(
                                  color: ColorManager.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                      ),
                    );
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
