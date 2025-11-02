import 'package:flutter/material.dart';
import 'package:SerialMan/global_widgets/Custom_NavigationBar/custom_servicecenter_navigationBar.dart';
import 'package:SerialMan/global_widgets/Custom_NavigationBar/custom_servicetaker_navigationbar.dart';
import '../Screen/Auth_screen/login_screen.dart';
import '../main_layouts/service_center_layout/service_center_layout.dart';
import '../main_layouts/service_taker_layout/service_taker_layout.dart';

class AppRouteNames {
  static const String login = '/login';
  static const String companyHome = '/home';
  static const String customerHome = '/customerHome';
}

class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    AppRouteNames.login: (context) => const LoginScreen(),
    AppRouteNames.companyHome: (context) => ServiceCenterLayout(),
    AppRouteNames.customerHome: (context) => const ServiceTakerLayout(),
  };
}
