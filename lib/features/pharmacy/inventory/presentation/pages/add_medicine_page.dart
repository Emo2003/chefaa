import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/core/widgets/inside_app_bar.dart';
import 'package:chefaa/core/widgets/loading.dart';
import 'package:chefaa/features/pharmacy/inventory/presentation/manager/pharmacy_inventory_cubit.dart';
import 'package:go_router/go_router.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({super.key});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _thresholdController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  String? _selectedCategory;

  final List<String> _categories = [
    "analgesic",
    "antibiotic",
    "antiviral",
    "antidiabetic",
    "cardiac",
    "diabetes",
    "allergy",
    "vitamins",
    "antihistamine",
    "antifungal",
    "antiseptic",
    "respiratory",
    "gastrointestinal",
    "dermatology",
    "supplements",
    "other"
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _thresholdController.dispose();
    _manufacturerController.dispose();
    _expiryController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorManager.primary,
              onPrimary: ColorManager.white,
              onSurface: ColorManager.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Format date as yyyy-MM-dd
        _expiryController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> requestBody = {
        "medicineName": _nameController.text.trim(),
        "category": _selectedCategory,
        "price": double.tryParse(_priceController.text.trim()) ?? 0,
        "quantity": int.tryParse(_quantityController.text.trim()) ?? 0,
        "minThreshold": int.tryParse(_thresholdController.text.trim()) ?? 0,
        "description": _descriptionController.text.trim(),
        "manufacturer": _manufacturerController.text.trim(),
        "expiryDate": _expiryController.text.trim(),
        "image": _imageController.text.trim().isNotEmpty
            ? _imageController.text.trim()
            : "https://example.com/panadol.jpg",
      };

      context.read<PharmacyInventoryCubit>().addMedicine(requestBody);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightGray,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: InsideAppBar(
          title: "Add Medicine",
          subtitle: "Add a new medicine item to your store inventory",
          isLayout: false,
        ),
      ),
      body: BlocListener<PharmacyInventoryCubit, PharmacyInventoryState>(
        listener: (context, state) {
          if (state is AddMedicineLoading) {
            Loading.show(context);
          } else {
            Loading.hide(context);
            if (state is AddMedicineSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Medicine added successfully'),
                  backgroundColor: ColorManager.lightGreen,
                ),
              );
              context.pop(true);
            } else if (state is AddMedicineError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: ColorManager.error,
                ),
              );
            }
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p20,
            vertical: AppPadding.p24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Medicine Details",
                  style: getBoldStyle(color: ColorManager.black, fontSize: 18.sp),
                ),
                16.verticalSpace,

                // Medicine Name
                CustomTextField(
                  controller: _nameController,
                  text: "Medicine Name",
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Medicine name is required";
                    }
                    return null;
                  },
                ),
                16.verticalSpace,

                // Category Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    fillColor: ColorManager.white,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 18.h,
                    ),
                    hintText: "Select Category",
                    hintStyle: getRegularStyle(
                      color: ColorManager.gray,
                      fontSize: 16.sp,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.r),
                      borderSide: const BorderSide(color: ColorManager.gray, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.r),
                      borderSide: const BorderSide(color: ColorManager.primary, width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.r),
                      borderSide: const BorderSide(color: ColorManager.error, width: 1.2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.r),
                      borderSide: const BorderSide(color: ColorManager.error, width: 1.5),
                    ),
                  ),
                  dropdownColor: ColorManager.white,
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category[0].toUpperCase() + category.substring(1),
                        style: getRegularStyle(color: ColorManager.black, fontSize: 16.sp),
                      ),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Category is required' : null,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                ),
                16.verticalSpace,

                // Manufacturer
                CustomTextField(
                  controller: _manufacturerController,
                  text: "Manufacturer (e.g. GSK, Bayer)",
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Manufacturer is required";
                    }
                    return null;
                  },
                ),
                16.verticalSpace,

                Row(
                  children: [
                    // Price
                    Expanded(
                      child: CustomTextField(
                        controller: _priceController,
                        text: "Price (EGP)",
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Required";
                          }
                          final numValue = double.tryParse(value);
                          if (numValue == null || numValue <= 0) {
                            return "Invalid price";
                          }
                          return null;
                        },
                      ),
                    ),
                    12.horizontalSpace,
                    // Quantity
                    Expanded(
                      child: CustomTextField(
                        controller: _quantityController,
                        text: "Quantity",
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Required";
                          }
                          final numValue = int.tryParse(value);
                          if (numValue == null || numValue < 0) {
                            return "Invalid qty";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,

                Row(
                  children: [
                    // Min Threshold
                    Expanded(
                      child: CustomTextField(
                        controller: _thresholdController,
                        text: "Min Threshold",
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Required";
                          }
                          final numValue = int.tryParse(value);
                          if (numValue == null || numValue < 0) {
                            return "Invalid value";
                          }
                          return null;
                        },
                      ),
                    ),
                    12.horizontalSpace,
                    // Expiry Date Picker Trigger
                    Expanded(
                      child: GestureDetector(
                        onTap: _selectExpiryDate,
                        behavior: HitTestBehavior.opaque,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _expiryController,
                            text: "Expiry Date",
                            isReadOnly: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,

                // Image URL
                CustomTextField(
                  controller: _imageController,
                  text: "Image URL (optional)",
                  keyboardType: TextInputType.url,
                ),
                16.verticalSpace,

                // Description
                CustomTextField(
                  controller: _descriptionController,
                  text: "Description (e.g. For headache and fever)",
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Description is required";
                    }
                    return null;
                  },
                ),
                32.verticalSpace,

                // Submit Button
                CustomBtn(
                  text: "Add Medicine",
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
