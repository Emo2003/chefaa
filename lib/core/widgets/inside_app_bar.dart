import 'package:chefaa/core/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:go_router/go_router.dart';

class InsideAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double height;
  final bool isSpeciality;
  final bool isLayout;

  const InsideAppBar({
    super.key,
    this.isLayout = false,
    this.isSpeciality = false,
    required this.title,
    this.subtitle,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: isSpeciality
          ? ColorManager.lightGray
          : ColorManager.primary,
      elevation: 3,
      shadowColor: ColorManager.lightGray,
      toolbarHeight: height,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
      ),
      title: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: !isLayout
                ? Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: isSpeciality
                        ? ColorManager.black
                        : ColorManager.white,
                    size: 27,
                  )
                : const SizedBox(),
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: AppPadding.p10,
              top: AppPadding.p16,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: getBoldStyle(
                      color: isSpeciality
                          ? ColorManager.black
                          : ColorManager.white,
                      fontSize: 22.sp,
                    ),
                  ),

                  5.verticalSpace,

                  if (!isSpeciality)
                    Text(
                      subtitle ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: getMediumStyle(
                        color: ColorManager.input.withAlpha(210),
                        fontSize: 14.sp,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
