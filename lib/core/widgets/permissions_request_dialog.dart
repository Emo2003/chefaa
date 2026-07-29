import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/services/permissions_service.dart';
import 'package:go_router/go_router.dart';

class PermissionsRequestDialog extends StatefulWidget {
  final Function(Map<String, permission_handler.PermissionStatus>)?
  onPermissionsGranted;
  final bool showOptionalPermissions;

  const PermissionsRequestDialog({
    super.key,
    this.onPermissionsGranted,
    this.showOptionalPermissions = false,
  });

  @override
  State<PermissionsRequestDialog> createState() =>
      _PermissionsRequestDialogState();
}

class _PermissionsRequestDialogState extends State<PermissionsRequestDialog> {
  bool isLoading = false;
  Map<String, permission_handler.PermissionStatus> permissionsStatus = {};

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    setState(() => isLoading = true);

    try {
      final results = await PermissionsService.requestCriticalPermissions();
      permissionsStatus = results;

      if (widget.showOptionalPermissions) {
        final optional = await PermissionsService.requestOptionalPermissions();
        permissionsStatus.addAll(optional);
      }

      setState(() => isLoading = false);

      if (mounted) {
        widget.onPermissionsGranted?.call(permissionsStatus);
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error requesting permissions: $e')),
        );
      }
    }
  }

  Widget _buildPermissionItem(
    String title,
    String description,
    permission_handler.PermissionStatus status,
    VoidCallback onRetry,
  ) {
    final isGranted = status.isGranted;
    final color = isGranted ? ColorManager.primary : ColorManager.error;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Icon(
            isGranted ? Icons.check_circle : Icons.cancel,
            color: color,
            size: 24.sp,
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getMediumStyle(
                    color: ColorManager.black,
                    fontSize: 14.sp,
                  ),
                ),
                4.verticalSpace,
                Text(
                  description,
                  style: getRegularStyle(
                    color: ColorManager.gray,
                    fontSize: 12.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (!isGranted)
            GestureDetector(
              onTap: onRetry,
              child: Text(
                'Retry',
                style: getMediumStyle(
                  color: ColorManager.primary,
                  fontSize: 12.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Permissions Required',
                  style: getBoldStyle(
                    color: ColorManager.black,
                    fontSize: 18.sp,
                  ),
                ),
                8.verticalSpace,
                Text(
                  'Chefaa needs the following permissions to work properly:',
                  style: getRegularStyle(
                    color: ColorManager.gray,
                    fontSize: 13.sp,
                  ),
                ),
                24.verticalSpace,
                if (isLoading)
                  Center(
                    child: SizedBox(
                      height: 50.h,
                      width: 50.w,
                      child: const CircularProgressIndicator(),
                    ),
                  )
                else ...[
                  _buildPermissionItem(
                    'Location',
                    'To find nearby doctors and clinics',
                    permissionsStatus['location'] ??
                        permission_handler.PermissionStatus.denied,
                    () async {
                      final status =
                          await PermissionsService.requestLocationPermission();
                      setState(() => permissionsStatus['location'] = status);
                    },
                  ),
                  _buildPermissionItem(
                    'Notifications',
                    'To receive appointment reminders',
                    permissionsStatus['notifications'] ??
                        permission_handler.PermissionStatus.denied,
                    () async {
                      final status =
                          await PermissionsService.requestNotificationPermission();
                      setState(
                        () => permissionsStatus['notifications'] = status,
                      );
                    },
                  ),
                  _buildPermissionItem(
                    'Camera',
                    'To capture medical documents',
                    permissionsStatus['camera'] ??
                        permission_handler.PermissionStatus.denied,
                    () async {
                      final status =
                          await PermissionsService.requestCameraPermission();
                      setState(() => permissionsStatus['camera'] = status);
                    },
                  ),
                  _buildPermissionItem(
                    'Storage',
                    'To access your photos and files',
                    permissionsStatus['storage'] ??
                        permission_handler.PermissionStatus.denied,
                    () async {
                      final status =
                          await PermissionsService.requestStoragePermission();
                      setState(() => permissionsStatus['storage'] = status);
                    },
                  ),
                ],
                24.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                          final messenger = ScaffoldMessenger.of(context);
                          try {
                            await PermissionsService.openAppSettings();
                          } catch (e) {
                            if (mounted) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text('Error opening settings: $e'),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          'Open Settings',
                          style: getMediumStyle(
                            color: ColorManager.primary,
                            fontSize: 13.sp, // قللتها شوية
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    8.horizontalSpace,
                    Flexible(
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                          context.pop(permissionsStatus);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w, // قللتها من 24 لـ 16
                            vertical: 12.h,
                          ),
                          child: Text(
                            'Continue',
                            style: getMediumStyle(
                              color: ColorManager.white,
                              fontSize: 13.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),              ],
            ),
          ),
        ),
      ),
    );
  }
}
