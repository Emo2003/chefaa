import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/features/patient/search/presentation/manager/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();

    return BlocBuilder<SearchCubit, SearchState>(
      buildWhen: (previous, current) => current is SearchDraftChanged,
      builder: (context, state) {
        return SizedBox(
          height: AppSize.s38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
            itemCount: cubit.filterTabs.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSize.s8),
            itemBuilder: (context, index) {
              final filter = cubit.filterTabs[index];
              final isSelected = cubit.isChipSelected(filter);
              final label = cubit.labelFor(filter);

              return Builder(
                builder: (chipContext) {
                  return GestureDetector(
                    onTap: () => _handleTap(
                      context: context,
                      chipContext: chipContext,
                      filter: filter,
                    ),
                    child: Container(
                      width: AppSize.s100,
                      height: AppSize.s25,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ColorManager.primary
                            : ColorManager.lightGray,
                        borderRadius: BorderRadius.circular(AppRadius.r24),
                        border: Border.all(
                          color: isSelected
                              ? ColorManager.primary
                              : ColorManager.input,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.all(AppPadding.p6),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    SvgAssets.filter,
                                    width: AppSize.s15,
                                    height: AppSize.s15,
                                  ),
                                  const SizedBox(width: AppSize.s6),
                                ],
                              ),
                            ),
                          Expanded(
                            child: Center(
                              child: Text(
                                label,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isSelected
                                      ? ColorManager.white
                                      : ColorManager.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _handleTap({
    required BuildContext context,
    required BuildContext chipContext,
    required FilterType filter,
  }) async {
    final cubit = context.read<SearchCubit>();

    switch (filter) {
      case FilterType.filters:
        if (cubit.hasActiveSelections()) {
          cubit.clearFilters();
          await cubit.applySearch();
        }
        break;
      case FilterType.gender:
        await _showGenderMenu(
          context: context,
          chipContext: chipContext,
          cubit: cubit,
        );
        break;
      case FilterType.specialization:
        final result = await context.push<String>(
          AppRoutesNames.specialityPage,
        );

        if (!context.mounted) return;

        if (result != null && result.isNotEmpty) {
          await cubit.updateAndSearch(specialization: result);
        }
        break;
      case FilterType.location:
        final result = await context.push<String>(
          AppRoutesNames.locationFilter,
        );

        if (!context.mounted) return;

        if (result != null && result.isNotEmpty) {
          await cubit.updateAndSearch(location: result);
        }
        break;
    }
  }

  Future<void> _showGenderMenu({
    required BuildContext context,
    required BuildContext chipContext,
    required SearchCubit cubit,
  }) async {
    final renderObject = chipContext.findRenderObject();
    if (renderObject is! RenderBox) return;

    final position = renderObject.localToGlobal(Offset.zero);

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + AppSize.s45,
        position.dx,
        position.dy,
      ),
      color: ColorManager.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      items: ['Male', 'Female', 'Any'].map((value) {
        final normalized = value.toLowerCase();
        final selectedGender = cubit.draftQuery.gender.toLowerCase();
        final isSelected =
            (value == 'Any' && selectedGender.isEmpty) ||
            selectedGender == normalized;

        return PopupMenuItem<String>(
          value: value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value),
              if (isSelected)
                const Icon(Icons.check, color: ColorManager.blue600),
            ],
          ),
        );
      }).toList(),
    );

    if (selected == null || !context.mounted) return;

    if (selected == 'Any') {
      await cubit.updateAndSearch(gender: '');
      return;
    }

    await cubit.updateAndSearch(gender: selected.toLowerCase());
  }
}
