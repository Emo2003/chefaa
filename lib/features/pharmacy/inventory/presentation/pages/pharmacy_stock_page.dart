import 'package:chefaa/core/config/get_config.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/core/widgets/inside_app_bar.dart';
import 'package:chefaa/features/pharmacy/inventory/presentation/manager/pharmacy_inventory_cubit.dart';
import 'package:chefaa/features/pharmacy/inventory/presentation/widgets/medicine_title.dart';
import 'package:chefaa/features/pharmacy/inventory/presentation/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/app_routes_names.dart';

class PharmacyStockPage extends StatefulWidget {
  const PharmacyStockPage({super.key});

  @override
  State<PharmacyStockPage> createState() => _PharmacyStockPageState();
}

class _PharmacyStockPageState extends State<PharmacyStockPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "all";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildFilterChip(String label, String value, BuildContext context) {
    final isSelected = _selectedFilter == value;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? ColorManager.white : ColorManager.primary,
          fontSize: 14.sp,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            _selectedFilter = value;
          });
          context.read<PharmacyInventoryCubit>().getMedicines(
            search: _searchController.text.trim(),
            filter: value == "all" ? null : value,
          );
        }
      },
      selectedColor: ColorManager.primary,
      backgroundColor: ColorManager.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(
          color: isSelected ? ColorManager.primary : ColorManager.lightBlue,
          width: 1.2,
        ),
      ),
      showCheckmark: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PharmacyInventoryCubit>(
      create: (context) => getIt<PharmacyInventoryCubit>()..getMedicines(),
      child: Scaffold(
        backgroundColor: const Color(0xffF6F7FB),
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: InsideAppBar(
            title: "Pharmacy Stock",
            isLayout: true,
            subtitle:
                "Track inventory, low stock alerts & medicine availability",
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                final cubit = context.read<PharmacyInventoryCubit>();

                final added = await context.push<bool>(
                  AppRoutesNames.addMedicine,
                );

                if (added == true && context.mounted) {
                  cubit.getMedicines(
                    search: _searchController.text.trim(),
                    filter: _selectedFilter == "all" ? null : _selectedFilter,
                  );
                }
              },
              backgroundColor: ColorManager.primary,
              child: const Icon(Icons.add, color: ColorManager.white),
            );
          },
        ),
        body: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: Column(
                children: [
                  CustomTextField(
                    controller: _searchController,
                    text: "Search Medicines .....",
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    isSearch: true,
                    onChanged: (value) {
                      context.read<PharmacyInventoryCubit>().getMedicines(
                        search: value.trim(),
                        filter: _selectedFilter == "all"
                            ? null
                            : _selectedFilter,
                      );
                    },
                  ),
                  12.verticalSpace,

                  // Filters Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _buildFilterChip("All", "all", context),
                        10.horizontalSpace,
                        _buildFilterChip("Low Stock", "low", context),
                      ],
                    ),
                  ),
                  16.verticalSpace,

                  Expanded(
                    child:
                        BlocBuilder<
                          PharmacyInventoryCubit,
                          PharmacyInventoryState
                        >(
                          builder: (context, state) {
                            if (state is GetMedicinesLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: ColorManager.primary,
                                ),
                              );
                            } else if (state is GetMedicinesError) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      state.errorMessage,
                                      style: TextStyle(
                                        color: ColorManager.error,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    16.verticalSpace,
                                    ElevatedButton(
                                      onPressed: () {
                                        context
                                            .read<PharmacyInventoryCubit>()
                                            .getMedicines(
                                              search: _searchController.text
                                                  .trim(),
                                              filter: _selectedFilter == "all"
                                                  ? null
                                                  : _selectedFilter,
                                            );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorManager.primary,
                                        foregroundColor: ColorManager.white,
                                      ),
                                      child: const Text("Retry"),
                                    ),
                                  ],
                                ),
                              );
                            } else if (state is GetMedicinesSuccess) {
                              final medicines =
                                  state.response.data?.medicines ?? [];
                              final lowStockItems =
                                  state.response.data?.lowStockItems ?? [];

                              if (medicines.isEmpty && lowStockItems.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.inventory_2_outlined,
                                        size: 64,
                                        color: ColorManager.gray,
                                      ),
                                      16.verticalSpace,
                                      Text(
                                        "No medicines found",
                                        style: TextStyle(
                                          color: ColorManager.darkGray,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    if (lowStockItems.isNotEmpty) ...[
                                      SectionCard(
                                        isAlert: true,
                                        title: "Low Stock Alert",
                                        iconColor: Colors.red,
                                        children: lowStockItems.map((med) {
                                          final int stock =
                                              med.quantity?.toInt() ?? 0;
                                          final int minThreshold =
                                              med.minThreshold?.toInt() ?? 10;
                                          return MedicineTile(
                                            totalStock: minThreshold > 0
                                                ? minThreshold * 10
                                                : 100,
                                            name: med.medicineName ?? "Unknown",
                                            category: med.category ?? "N/A",
                                            stock: stock,
                                            price: med.price?.toInt() ?? 0,
                                            status: "Low",
                                            statusColor: Colors.red,
                                          );
                                        }).toList(),
                                      ),
                                      16.verticalSpace,
                                    ],
                                    if (medicines.isNotEmpty)
                                      SectionCard(
                                        title: "All Medicines",
                                        iconColor: Colors.blue,
                                        children: medicines.map((med) {
                                          final int stock =
                                              med.quantity?.toInt() ?? 0;
                                          final int minThreshold =
                                              med.minThreshold?.toInt() ?? 10;
                                          final bool isLow =
                                              stock <= minThreshold;

                                          return MedicineTile(
                                            totalStock: minThreshold > 0
                                                ? minThreshold * 10
                                                : 100,
                                            name: med.medicineName ?? "Unknown",
                                            category: med.category ?? "N/A",
                                            stock: stock,
                                            price: med.price?.toInt() ?? 0,
                                            status: isLow ? "Low" : "In Stock",
                                            statusColor: isLow
                                                ? Colors.orange
                                                : Colors.green,
                                          );
                                        }).toList(),
                                      ),
                                  ],
                                ),
                              );
                            } else if (state is GetLowStockSuccess) {
                              final lowStockItems =
                                  state.response.data?.lowStockItems ?? [];

                              if (lowStockItems.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.inventory_2_outlined,
                                        size: 64,
                                        color: ColorManager.gray,
                                      ),
                                      16.verticalSpace,
                                      Text(
                                        "No low stock medicines found",
                                        style: TextStyle(
                                          color: ColorManager.darkGray,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    SectionCard(
                                      isAlert: true,
                                      title: "Low Stock Medicines",
                                      iconColor: Colors.red,
                                      children: lowStockItems.map((med) {
                                        final int stock =
                                            med.quantity?.toInt() ?? 0;
                                        final int minThreshold =
                                            med.minThreshold?.toInt() ?? 10;
                                        return MedicineTile(
                                          totalStock: minThreshold > 0
                                              ? minThreshold * 10
                                              : 100,
                                          name: med.medicineName ?? "Unknown",
                                          category: med.category ?? "N/A",
                                          stock: stock,
                                          price: med.price?.toInt() ?? 0,
                                          status: "Low",
                                          statusColor: Colors.red,
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return const SizedBox();
                          },
                        ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
