import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chefaa/core/resources/styles_manager.dart';

class AnimatedBotMessage extends StatefulWidget {
  final String message;

  const AnimatedBotMessage({
    super.key,
    required this.message,
  });

  @override
  State<AnimatedBotMessage> createState() =>
      _AnimatedBotMessageState();
}

class _AnimatedBotMessageState
    extends State<AnimatedBotMessage> {
  String displayedText = '';
  Timer? timer;
  int currentIndex = 0;

  late final List<String> chars;

  @override
  void initState() {
    super.initState();

    chars = _cleanMessage(widget.message)
        .characters
        .toList();

    timer = Timer.periodic(
      const Duration(milliseconds: 15),
          (_) {
        if (!mounted) return;

        if (currentIndex < chars.length) {
          setState(() {
            displayedText += chars[currentIndex];
            currentIndex++;
          });
        } else {
          timer?.cancel();
        }
      },
    );
  }

  String _cleanMessage(String text) {
    return text
        .replaceAll('\u0000', '')
        .replaceAll('\uFFFD', '')
        .trim();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: displayedText,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: getSemiBoldStyle(
          color: Colors.black,
          fontSize: 15.sp,
        ),
        strong: getBoldStyle(
          color: Colors.black,
          fontSize: 16.sp,
        ),
      ),
    );
  }
}