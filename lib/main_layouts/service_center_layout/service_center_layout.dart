import 'package:flutter/material.dart';
import '../../Screen/servicecenter_screen/home_screen.dart';
import '../../Screen/servicecenter_screen/servicecenter_screen.dart';
import '../../Screen/servicecenter_screen/servicecenter_settingScreen.dart';
import '../../Screen/servicecenter_screen/servicetype_screen.dart';
import '../../global_widgets/Custom_NavigationBar/custom_servicecenter_navigationBar.dart';
import '../../global_widgets/My_Appbar.dart';

class ServiceCenterLayout extends StatefulWidget {
  const ServiceCenterLayout({super.key});

  @override
  State<ServiceCenterLayout> createState() => _ServiceCenterLayoutState();
}

class _ServiceCenterLayoutState extends State<ServiceCenterLayout> {
  int _currentIndex = 0;

  final List<Widget> _serviceCenterScreens = [
    HomeScreen(),
    ServicecenterScreen(),
    ServicetypeScreen(),
    Servicecenter_Settingscreen(),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(),
      body: IndexedStack(index: _currentIndex, children: _serviceCenterScreens),
      bottomNavigationBar: CustomServicecenterNavigationbar(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}
