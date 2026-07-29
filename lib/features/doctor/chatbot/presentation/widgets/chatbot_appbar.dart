import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';



class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
backgroundColor:  ColorManager.lightGray,
      leading: const SizedBox(),
      shadowColor: ColorManager.black.withAlpha(80),
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 45.w,
                height: 45.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorManager.primary,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    ImageAssets.chatbot,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: ColorManager.lightGreen,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorManager.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 12.w),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Doctor Assistant",
                style: getBoldStyle(
                  color: ColorManager.black,
                  fontSize: 16.sp,
                ),
              ),

              SizedBox(height: 2.h),
              Text(
                "Always here to help",
                style: getMediumStyle(
                  color: Colors.grey,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
