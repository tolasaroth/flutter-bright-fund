// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:gofundme/services/auth_service.dart';
import 'forget_password_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = true;

  Future<void> _handleSignIn() async {

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please enter both email and password');
      return;
    }

    try {

      final response = await AuthService().signIn(email, password);

      final accessToken = response['access_token'] as String?;
      final refreshToken = response['refresh_token'] as String?;
      final status = response['status'] as String?;
      final path = response['path'] as String?;
      final message = response['message'] as String?;

      print('Login successful: $message');
      print('Access Token: $accessToken');
      print('Refresh Token: $refreshToken');
      print('Status: $status');

      // await SharedPreferences.getInstance().then((prefs) {
      //   prefs.setString('access_token', accessToken ?? '');
      //   prefs.setString('refresh_token', refreshToken ?? '');
      // });

      // Navigate based on the path from API
      if (!mounted) return;
      if (path != null && path.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      print('Login failed: $e');
      _showErrorDialog(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Login Failed'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF2ECC71),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            /// HEADER
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      // color: CupertinoColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Icon(
                        CupertinoIcons.rocket_fill,
                        size: 60,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'BrightFund',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.white,
                    ),
                  ),
                ],
              ),
            ),

            /// FORM
            Expanded(
              flex: 6,
              child: Container(
                decoration: const BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Sign In',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Welcome back. Enter your credentials to access your account',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// EMAIL
                      Text(
                        'Email Address',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CupertinoTextField(
                        controller: _emailController,
                        placeholder: 'kong.chan@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                        padding: const EdgeInsets.all(16),
                        decoration: _inputDecoration(),
                      ),

                      const SizedBox(height: 16),

                      /// PASSWORD + FORGOT
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => const ForgetPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF2ECC71),
                              ),
                            ),
                          ),
                        ],
                      ),

                      CupertinoTextField(
                        controller: _passwordController,
                        placeholder: '••••••••',
                        obscureText: !_isPasswordVisible,
                        padding: const EdgeInsets.all(16),
                        decoration: _inputDecoration(),
                        suffix: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            );
                          },
                          child: Icon(
                            _isPasswordVisible
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// REMEMBER ME
                      Row(
                        children: [
                          // Padding(padding: const EdgeInsets.only(right: 8)),
                          CupertinoCheckbox(
                            value: _rememberMe,
                            activeColor: const Color(0xFF2ECC71),
                            onChanged: (v) =>
                                setState(() => _rememberMe = v ?? false),
                          ),
                          const SizedBox(width: 8),
                          const Text('Remember Me'),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// LOGIN BUTTON
                      CupertinoButton.filled(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        borderRadius: BorderRadius.circular(12),
                        onPressed: _handleSignIn,
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// SIGN UP
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an Account? ",
                            style: TextStyle(color: CupertinoColors.systemGrey),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () =>
                                Navigator.pushNamed(context, '/sign-up'),
                            child: const Text(
                              'Sign up here',
                              style: TextStyle(
                                color: Color(0xFF2ECC71),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// SOCIAL
                      const Center(
                        child: Text(
                          'or sign in with',
                          style: TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          _SocialButton(
                            icon: CupertinoIcons.globe,
                            label: 'Google',
                            color: CupertinoColors.systemRed,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 12),
                          _SocialButton(
                            icon: CupertinoIcons.app_badge_fill,
                            label: 'Apple',
                            color: CupertinoColors.black,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _inputDecoration() {
    return BoxDecoration(
      color: CupertinoColors.extraLightBackgroundGray,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: CupertinoColors.systemGrey4),
    );
  }
}

/// SOCIAL BUTTON
class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: CupertinoColors.systemGrey4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
