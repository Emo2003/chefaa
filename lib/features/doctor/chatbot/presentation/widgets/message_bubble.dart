import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'animated_bot_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final String message;
  final bool isBot;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isBot,
  });

  @override
  Widget build(BuildContext context) {
    if (isBot) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppMargin.m5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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

            SizedBox(width: 10.w),

            Flexible(
              child: Container(
                padding: const EdgeInsets.all(
                  AppPadding.p14,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: ColorManager.black.withAlpha(70),
                    ),
                  ],
                ),
                child: AnimatedBotMessage(
                  message: message,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
          MediaQuery.of(context).size.width * .75,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: AppMargin.m5,
        ),
        padding: const EdgeInsets.all(
          AppPadding.p14,
        ),
        decoration: BoxDecoration(
          color: ColorManager.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(10.r),
          ),
        ),
        child: Text(
          message,
          style: getBoldStyle(
            color: ColorManager.white,
            fontSize: 15.sp,
          ),
        ),
      ),
    );
  }
}