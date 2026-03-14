import 'package:flutter/cupertino.dart';
import 'package:gofundme/services/auth_service.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({super.key, required this.child});
  AuthService get authService => AuthService();
  

  @override
  Widget build(BuildContext context) {
    if (!authService.isLoggedIn) {
      Future.microtask(() {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const SizedBox.shrink();
    }
    return child;
  }
}