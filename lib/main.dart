import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import 'package:SerialMan/providers/app_provider/app_provider.dart';
import 'package:SerialMan/providers/auth_provider/auth_providers.dart';
import 'package:SerialMan/routes/app_routes.dart';
import 'package:SerialMan/utils/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screen/Auth_screen/login_screen.dart';
import 'main_layouts/service_center_layout/service_center_layout.dart';
import 'main_layouts/service_taker_layout/service_taker_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MultiProvider(providers: AppProviders.providers, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColor().primariColor,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: AppColor().primariColor.withOpacity(0.4),
          selectionHandleColor: AppColor().primariColor,
        ),
      ),
      // initialRoute:initialRoute,
      routes: AppRouter.routes,

      home: Builder(
        builder: (context) {
          return const AuthWrapper();
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<void> _initializationFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializationFuture = Provider.of<AuthProvider>(
      context,
      listen: false,
    ).loadUserFromToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CustomLoading(
                color: AppColor().primariColor,
                //size: 20,
                strokeWidth: 2.5,
              ),
            ),
          );
        }

        final authProvider = Provider.of<AuthProvider>(context);

        if (authProvider.accessToken != null) {
          final userType = authProvider.userType?.toLowerCase() ?? '';
          if (userType == 'company') {
            return ServiceCenterLayout();
          } else {
            return const ServiceTakerLayout();
          }
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
