import 'package:flutter/material.dart';
import 'package:SerialMan/global_widgets/Custom_NavigationBar/custom_servicetaker_navigationbar.dart';

import '../../Screen/profile_screen/profile_screen.dart';
import '../../Screen/servicetaker_screen/appointments_screen.dart';
import '../../Screen/servicetaker_screen/servicetaker_homescreen.dart';
import '../../Screen/servicetaker_screen/setting_screen.dart';
import '../../global_widgets/My_Appbar.dart';

class ServiceTakerLayout extends StatefulWidget {
  const ServiceTakerLayout({super.key});

  @override
  State<ServiceTakerLayout> createState() => _ServiceTakerLayoutState();
}

class _ServiceTakerLayoutState extends State<ServiceTakerLayout> {
  int _currentIndex = 0;

  final List<Widget> _serviceTakerScreens = [
    ServicetakerHomescreen(businessTypeId: ''),
    AppointmentsScreen(),
    SettingScreen(),
    profile_screen(currentIndex: 3, onTap: (_) {}),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        // onLogotap: () {
        //   setState(() {
        //     _currentIndex = 0;
        //   });
        // },
      ),
      body: IndexedStack(index: _currentIndex, children: _serviceTakerScreens),
      bottomNavigationBar: CustomServicetakerNavigationbar(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}
