import 'package:flutter/material.dart';
import 'configs/app_routes.dart';
import 'package:gofundme/screens/auth/login_screen.dart';
import 'package:gofundme/screens/auth/sign_up_screen.dart';
import 'package:gofundme/screens/auth/forget_password_screen.dart';
import 'package:gofundme/screens/auth/otp_screen.dart';
import 'package:gofundme/screens/campaigns/home_screen.dart';
import 'package:gofundme/screens/campaigns/campaign_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrightFund',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2ECC71)),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.signUp: (context) => const SignUpScreen(),
        AppRoutes.forgetPassword: (context) => const ForgetPasswordScreen(),
        AppRoutes.otp: (context) => const OtpScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.campaignDetail: (context) => const CampaignDetailScreen(),
      },
    );
  }
}
