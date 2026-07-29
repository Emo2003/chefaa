import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes_names.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/models/onboarding_model.dart';
import '../widgets/onboarding_container.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController controller = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) => Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      OnboardingModel.onboardingData[index].image,
                      cacheHeight: 1200,
                      cacheWidth: 1200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: OnboardingContainer(
                      next: nextPage,
                      screenIndex: index,
                      onboarding: OnboardingModel.onboardingData,
                    ),
                  ),
                ],
              ),
              itemCount: OnboardingModel.onboardingData.length,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> nextPage() async {
    if (currentIndex < OnboardingModel.onboardingData.length - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    } else {
      await StorageService.markOnboardingSeen();
      if (!mounted) return;
      context.pushReplacement(AppRoutesNames.login);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}