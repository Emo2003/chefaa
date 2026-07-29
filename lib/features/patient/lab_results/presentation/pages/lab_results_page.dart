import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/features/patient/lab_results/data/models/lab_results_response.dart';
import 'package:chefaa/features/patient/lab_results/presentation/manager/lab_results_cubit.dart';
import 'package:chefaa/features/patient/lab_results/presentation/manager/lab_results_state.dart';
import 'package:chefaa/features/patient/lab_results/presentation/widgets/lab_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LabResultsPage extends StatefulWidget {
  const LabResultsPage({super.key});

  @override
  State<LabResultsPage> createState() => _LabResultsPageState();
}

class _LabResultsPageState extends State<LabResultsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDoctorNotesDialog(BuildContext context, LabResultItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          backgroundColor: ColorManager.white,
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: ColorManager.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: ColorManager.primary,
                        size: 20.sp,
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Text(
                        "Doctor Notes",
                        style: getBoldStyle(
                          color: ColorManager.black,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                Text(
                  item.fileName ?? "Lab Report",
                  style: getSemiBoldStyle(
                    color: ColorManager.darkGray,
                    fontSize: 14.sp,
                  ),
                ),
                4.verticalSpace,
                Text(
                  "From: ${item.labName ?? 'Laboratory'}",
                  style: getRegularStyle(
                    color: ColorManager.gray,
                    fontSize: 12.sp,
                  ),
                ),
                16.verticalSpace,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: ColorManager.lightGray.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: ColorManager.input.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    item.doctorNotes ?? "No specific notes provided.",
                    style: getRegularStyle(
                      color: ColorManager.black,
                      fontSize: 13.sp,
                    ).copyWith(height: 1.5),
                  ),
                ),
                24.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      elevation: 0,
                    ),
                    child: Text(
                      "Dismiss",
                      style: getBoldStyle(
                        color: ColorManager.white,
                        fontSize: 14.sp,
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
  }

  void _openFullScreenImage(BuildContext context, LabResultItem item) {
    if (item.fileUrl == null || item.fileUrl!.isEmpty) return;

    showDialog(
      context: context,
      useSafeArea: false,
      builder: (dialogContext) => Dialog.fullscreen(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => dialogContext.pop(),
            ),
            title: Text(
              item.fileName ?? "Report Document",
              style: getBoldStyle(color: ColorManager.white, fontSize: 16.sp),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(
                item.fileUrl!,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      "Failed to load image",
                      style: getMediumStyle(
                        color: ColorManager.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightGray,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: ColorManager.primary,
            size: 24.sp,
          ),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Lab Results",
              style: getBoldStyle(color: ColorManager.black, fontSize: 18.sp),
            ),
            2.verticalSpace,
            Text(
              "View and track laboratory test records",
              style: getRegularStyle(color: ColorManager.gray, fontSize: 11.sp),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            color: ColorManager.input.withValues(alpha: 0.5),
            height: 1.h,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            children: [
              TextFormField(
                controller: _searchController,
                style: getRegularStyle(
                  color: ColorManager.black,
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  hintText: "Search reports or labs...",
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
                    borderSide: const BorderSide(color: ColorManager.input),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: const BorderSide(color: ColorManager.input),
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
              16.verticalSpace,
              Expanded(
                child: BlocBuilder<LabResultsCubit, LabResultsState>(
                  builder: (context, state) {
                    if (state is LabResultsLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primary,
                        ),
                      );
                    }

                    if (state is LabResultsErrorState) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.r),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 60.sp,
                                color: Colors.redAccent,
                              ),
                              16.verticalSpace,
                              Text(
                                state.errorMessage,
                                style: getMediumStyle(
                                  color: ColorManager.black,
                                  fontSize: 14.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              20.verticalSpace,
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<LabResultsCubit>()
                                      .getLabResults();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorManager.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                ),
                                child: Text(
                                  "Try Again",
                                  style: getBoldStyle(
                                    color: ColorManager.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is LabResultsSuccessState) {
                      final filtered = state.results.where((item) {
                        final fileMatch = (item.fileName ?? '')
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                        final labMatch = (item.labName ?? '')
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                        return fileMatch || labMatch;
                      }).toList();

                      if (filtered.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.science_outlined,
                                size: 80.sp,
                                color: ColorManager.gray.withValues(alpha: 0.5),
                              ),
                              16.verticalSpace,
                              Text(
                                _searchQuery.isEmpty
                                    ? "No lab reports found."
                                    : "No reports matching your search.",
                                style: getMediumStyle(
                                  color: ColorManager.gray,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filtered.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return LabResultCard(
                            item: item,
                            onViewPressed: () =>
                                _openFullScreenImage(context, item),
                            onNotesPressed: () =>
                                _showDoctorNotesDialog(context, item),
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
