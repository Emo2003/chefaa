import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import 'package:chefaa/core/config/get_config.dart';
import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/font_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/widgets/custom_circle_avatar.dart';

import 'package:chefaa/features/facility/dashboard/data/models/patient_detail_data.dart';
import 'package:chefaa/features/facility/dashboard/data/models/pending_upload_item.dart';
import 'package:chefaa/features/facility/dashboard/data/models/uploaded_result_item.dart';
import 'package:chefaa/features/facility/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:chefaa/features/facility/dashboard/presentation/widgets/detailed_analysis_card.dart';
import 'package:chefaa/features/facility/dashboard/presentation/widgets/empty_state_card_widget.dart';
import 'package:chefaa/features/facility/dashboard/presentation/widgets/facility_results_upload_zone.dart';
import 'package:chefaa/features/facility/dashboard/presentation/widgets/pending_upload_item_card.dart';
import 'package:chefaa/features/facility/dashboard/presentation/widgets/recently_uploaded_item_card.dart';
import 'package:chefaa/features/facility/dashboard/presentation/widgets/section_header_widget.dart';
import 'facility_results_dummy_data.dart';
import 'package:go_router/go_router.dart';

class FacilityResultsPage extends StatefulWidget {
  const FacilityResultsPage({super.key});

  @override
  State<FacilityResultsPage> createState() => _FacilityResultsPageState();
}

class _FacilityResultsPageState extends State<FacilityResultsPage> {
  late List<PendingUploadItem> _pendingUploads;
  late List<UploadedResultItem> _recentlyUploaded;
  late Map<String, PatientDetailData> _patientsDetails;
  String _selectedPatientName = "";

  @override
  void initState() {
    super.initState();
    _pendingUploads = [];
    _recentlyUploaded = [];
    _patientsDetails = getInitialPatientDetails();
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "P";
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return (parts[0].isNotEmpty && parts[1].isNotEmpty)
          ? (parts[0][0] + parts[1][0]).toUpperCase()
          : name[0].toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : "P";
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "Just now";
    try {
      final dateTime = DateTime.parse(dateStr);
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    } catch (_) {
      return dateStr;
    }
  }

  void _addNewCustomUpload(String fileName) {
    final String baseName = fileName.split('/').last.split('\\').last;
    final String patientName =
        "Patient Result (${baseName.length > 15 ? '${baseName.substring(0, 12)}...' : baseName})";

    _patientsDetails[patientName] = PatientDetailData(
      id: "#44924",
      name: patientName,
      details: "Uploaded File: $baseName",
      badges: const ["FILE UPLOADED", "REVIEW PENDING"],
      doctorNotes:
          "Result document '$baseName' has been successfully uploaded and is currently queued for doctor validation. A notification will be sent upon review completion.",
      doctorName: "System Upload",
      doctorNotesTime: "Just now",
      aiInsight:
          "Initial system scan shows document formatted correctly. Complete AI analytics will trigger once certified by medical staff.",
      aiLinkText: "Check Progress",
    );

    setState(() {
      _recentlyUploaded.insert(
        0,
        const UploadedResultItem(
          name: "New Upload",
          scanType: "Patient Document",
          time: "Just now",
          status: "Pending review",
          statusBgColor: ColorManager.amber100,
          statusTextColor: ColorManager.amber600,
          icon: Icons.insert_drive_file_outlined,
          iconColor: ColorManager.amber600,
          iconBgColor: ColorManager.amber50,
        ),
      );

      _patientsDetails["New Upload"] = _patientsDetails[patientName]!;
      _selectedPatientName = "New Upload";
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DashboardCubit>()..getDashboard(),
      child: BlocConsumer<DashboardCubit, DashboardState>(
        listener: (context, state) {
          if (state is GetDashboardSuccess) {
            setState(() {
              _pendingUploads = (state.response.pendingUploads ?? []).map((
                item,
              ) {
                final name = item.patientName ?? "Unknown Patient";
                final scanType = item.services?.join(', ') ?? "General Scan";
                return PendingUploadItem(
                  id: item.id,
                  name: name,
                  scanType: scanType,
                  initials: _getInitials(name),
                  avatarBgColor: ColorManager.lightBlue100,
                  avatarTextColor: ColorManager.blue600,
                );
              }).toList();

              _recentlyUploaded = (state.response.uploadedResults ?? []).map((
                item,
              ) {
                final name = item.patientName ?? "Unknown Patient";
                final scanType = item.services?.join(', ') ?? "General Scan";
                return UploadedResultItem(
                  name: name,
                  scanType: scanType,
                  time: _formatDate(item.createdAt),
                  status: item.status ?? "Completed",
                  statusBgColor: ColorManager.mint100,
                  statusTextColor: ColorManager.mint600,
                  icon: Icons.picture_as_pdf_outlined,
                  iconColor: ColorManager.blue600,
                  iconBgColor: ColorManager.lightBlue100,
                );
              }).toList();

              if (_recentlyUploaded.isNotEmpty &&
                  (_selectedPatientName.isEmpty ||
                      _selectedPatientName == "Hassan Gamal")) {
                _selectedPatientName = _recentlyUploaded.first.name;
              }
            });
          } else if (state is GetDashboardFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Failed to load requests: ${state.errorMessage}"),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is UploadResultSuccess) {
            final updatedRequest = state.response.updatedRequest;
            if (updatedRequest != null) {
              final index = _pendingUploads.indexWhere(
                (element) => element.id == updatedRequest.id,
              );
              if (index != -1) {
                final item = _pendingUploads[index];
                setState(() {
                  _pendingUploads.removeAt(index);
                  _recentlyUploaded.insert(
                    0,
                    UploadedResultItem(
                      name: item.name,
                      scanType: item.scanType,
                      time: "Just now",
                      status: "Patient notified",
                      statusBgColor: ColorManager.green100,
                      statusTextColor: ColorManager.green600,
                      icon: Icons.picture_as_pdf_outlined,
                      iconColor: item.avatarTextColor,
                      iconBgColor: item.avatarBgColor,
                    ),
                  );
                  _selectedPatientName = item.name;
                });
              } else {
                final baseName =
                    updatedRequest.resultFile?.split('/').last ??
                    "result_document.png";
                _addNewCustomUpload(baseName);
              }
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.response.message ?? "Result uploaded successfully!",
                ),
                backgroundColor: ColorManager.lightGreen,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is UploadResultFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error: ${state.errorMessage}"),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final currentDetail =
              _patientsDetails[_selectedPatientName] ??
              PatientDetailData(
                id: "#${_selectedPatientName.hashCode.abs().toString().padRight(5).substring(0, 5)}",
                name: _selectedPatientName,
                details: "Patient File",
                badges: const ["COMPLETED"],
                doctorNotes:
                    "No additional doctor notes available for this request.",
                doctorName: "N/A",
                doctorNotesTime: "",
                aiInsight: "AI diagnostic mapping completed successfully.",
                aiLinkText: "Details",
              );

          return Scaffold(
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
                    "Results",
                    style: getBoldStyle(
                      color: ColorManager.slate900,
                      fontSize: FontSize.s18.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Upload & manage patient results",
                    style: getRegularStyle(
                      color: ColorManager.gray,
                      fontSize: FontSize.s11.sp,
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: AppPadding.p16.w),
                  child: CustomCircleAvatar(
                    imagePath: ImageAssets.doctor,
                    radius: AppRadius.r18.r,
                  ),
                ),
              ],
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state is GetDashboardLoading)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: LinearProgressIndicator(
                            color: ColorManager.primary,
                            backgroundColor: ColorManager.lightGray,
                          ),
                        ),
                      SectionHeaderWidget(
                        title: "Pending Upload",
                        badgeText: _pendingUploads.isNotEmpty
                            ? "${_pendingUploads.length} Urgent"
                            : null,
                        badgeColor: ColorManager.lightRed,
                        badgeTextColor: ColorManager.red600,
                      ),
                      SizedBox(height: AppSize.s12.h),
                      if (_pendingUploads.isEmpty)
                        const EmptyStateCardWidget(
                          message: "No pending uploads at the moment.",
                        )
                      else
                        ...List.generate(_pendingUploads.length, (index) {
                          final item = _pendingUploads[index];
                          final isUploading =
                              state is UploadResultLoading &&
                              state.requestId == item.id;
                          return PendingUploadItemCard(
                            item: PendingUploadItem(
                              id: item.id,
                              name: item.name,
                              scanType: item.scanType,
                              initials: item.initials,
                              avatarBgColor: item.avatarBgColor,
                              avatarTextColor: item.avatarTextColor,
                              isUploading: isUploading,
                            ),
                            onUpload: () async {
                              final cubit = BlocProvider.of<DashboardCubit>(
                                context,
                              );
                              final result = await FilePicker.pickFiles(
                                type: FileType.any,
                              );
                              if (result != null && result.files.isNotEmpty) {
                                final filePath = result.files.first.path;
                                if (filePath != null && mounted) {
                                  debugPrint("UI upload requestId = ${item.id}");
                                  cubit.uploadResult(
                                    requestId: "6a3019112eb20b02387e784a",
                                    filePath: filePath,
                                  );
                                }
                              }
                            },
                          );
                        }),

                      SizedBox(height: 24.h),

                      FacilityResultsUploadZone(
                        onSelectFile: () async {
                          final cubit = BlocProvider.of<DashboardCubit>(
                            context,
                          );
                          final result = await FilePicker.pickFiles(
                            type: FileType.any,
                          );
                          if (result != null && result.files.isNotEmpty) {
                            final filePath = result.files.first.path;
                            if (filePath != null && mounted) {
                              debugPrint(
                                "UI upload requestId = 6a3019112eb20b02387e784a",
                              );
                              cubit.uploadResult(
                                requestId: "6a3019112eb20b02387e784a",
                                filePath: filePath,
                              );
                            }
                          }
                        },
                        onCamera: () async {
                          final cubit = BlocProvider.of<DashboardCubit>(
                            context,
                          );
                          final result = await FilePicker.pickFiles(
                            type: FileType.image,
                          );
                          if (result != null && result.files.isNotEmpty) {
                            final filePath = result.files.first.path;
                            if (filePath != null && mounted) {
                              debugPrint(
                                "UI upload requestId = 6a3019112eb20b02387e784a",
                              );
                              cubit.uploadResult(
                                requestId: "6a3019112eb20b02387e784a",
                                filePath: filePath,
                              );
                            }
                          }
                        },
                      ),

                      SizedBox(height: 24.h),

                      const SectionHeaderWidget(title: "Recently Uploaded"),
                      SizedBox(height: AppSize.s12.h),
                      ..._recentlyUploaded.map(
                        (item) => RecentlyUploadedItemCard(
                          item: item,
                          isSelected: _selectedPatientName == item.name,
                          onTap: () {
                            setState(() {
                              _selectedPatientName = item.name;
                            });
                          },
                        ),
                      ),

                      SizedBox(height: 24.h),

                      const SectionHeaderWidget(title: "Detailed Analysis"),
                      SizedBox(height: AppSize.s12.h),
                      DetailedAnalysisCard(detail: currentDetail),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
