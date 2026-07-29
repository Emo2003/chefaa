import 'package:chefaa/features/doctor/chatbot/presentation/manager/doc_chatbot_cubit.dart';
import 'package:chefaa/features/doctor/chatbot/presentation/pages/doc_chatbot_page.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/pages/daily_brief_page.dart';
import 'package:chefaa/features/doctor/home/presentation/manager/clinic_cubit.dart';
import 'package:chefaa/features/doctor/home/presentation/pages/doctor_home.dart';
import 'package:chefaa/features/doctor/patients/presentation/manager/patients_cubit.dart';
import 'package:chefaa/features/doctor/patients/presentation/pages/patients_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:chefaa/core/config/get_config.dart';
import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/features/doctor/profile/presentation/pages/profile_page.dart';
import 'package:chefaa/features/doctor/daily_brief/presentation/manager/brief_cubit.dart';

class DoctorLayout extends StatefulWidget {
  const DoctorLayout({super.key});

  @override
  State<DoctorLayout> createState() => _DoctorLayoutState();
}

class _DoctorLayoutState extends State<DoctorLayout> {
  int _selectedIndex = 0;

  final List<Widget> _tabs =  [
    const DoctorHome(),
    BlocProvider(
        create: (_) =>getIt<PatientsCubit>(),
        child: const PatientsPage()),
  BlocProvider(
  create: (_) =>getIt<BriefCubit>(),
  child: const DailyBriefPage()),

  BlocProvider(
  create: (_) =>getIt<DocChatbotCubit>(),
  child: const DocChatbotPage()),

     const DoctorProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ClinicCubit>(),
      child: Scaffold(
        body: _tabs[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: getSemiBoldStyle(color: ColorManager.darkGray),
          unselectedLabelStyle: getSemiBoldStyle(color: ColorManager.darkGray),
          backgroundColor: ColorManager.white,
          selectedItemColor: ColorManager.primary,
          unselectedItemColor: ColorManager.gray,
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(SvgAssets.home, width: 20, height: 20),
              activeIcon: SvgPicture.asset(SvgAssets.homeActive, width: 20, height: 20),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(SvgAssets.patient, width: 32.w, height: 32.h),
              activeIcon: SvgPicture.asset(SvgAssets.patientActive, width: 32.w, height: 32.h),
              label: 'Patients',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(SvgAssets.docBrief, width: 32.w, height: 32.h),
              activeIcon: SvgPicture.asset(SvgAssets.docBriefActive, width: 32.w, height: 32.h),
              label: 'Briefing',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(SvgAssets.chat),
              activeIcon: SvgPicture.asset(SvgAssets.chatActive),
              label: 'ChatBot',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(SvgAssets.profile),
              activeIcon: SvgPicture.asset(SvgAssets.profileActive),
              label: 'Me',
            ),
          ],
        ),
      ),
    );
  }
}