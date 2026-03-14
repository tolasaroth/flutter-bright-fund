import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'configs/app_routes.dart';

import 'package:gofundme/screens/auth/sign_in_screen.dart';
import 'package:gofundme/screens/auth/sign_up_screen.dart';
import 'package:gofundme/screens/auth/forget_password_screen.dart';
import 'package:gofundme/screens/layout/main_layout.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }

  runApp(const BrightFund());
}

class BrightFund extends StatelessWidget {
  
  const BrightFund({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'BrightFund',
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.activeBlue,
        primaryContrastingColor: CupertinoColors.white,
        barBackgroundColor: CupertinoColors.systemBackground,
      ),

      initialRoute: AppRoutes.home,

      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case AppRoutes.home:
            return CupertinoPageRoute(
              builder: (_) => const MainLayout(),
            );

          case AppRoutes.signIn:
            return CupertinoPageRoute(
              builder: (_) => const SignInScreen(),
            );

          case AppRoutes.signUp:
            return CupertinoPageRoute(
              builder: (_) => const SignUpScreen(),
            );

          case AppRoutes.forgetPassword:
            return CupertinoPageRoute(
              builder: (_) => const ForgetPasswordScreen(),
            );

          default:
            return CupertinoPageRoute(
              builder: (_) => const SignInScreen(),
            );
        }
      },
    );
  }
}