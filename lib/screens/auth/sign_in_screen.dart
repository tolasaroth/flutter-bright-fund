// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gofundme/services/auth_service.dart';
import 'forget_password_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ─── Design Tokens (shared with SignUpScreen) ─────────────────────────────────
class _C {
  static const ink = Color(0xFF282828);
  static const muted = Color(0xFF7A7068);
  static const border = Color(0xFFE8E2D8);
  static const fieldBg = Color(0xFFFFFFFF);
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = true;
  bool _isLoading = false;

  AnimationController? _fadeCtrl;
  Animation<double> _fadeAnim = const AlwaysStoppedAnimation(1.0);

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl!, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl?.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── Logic ───────────────────────────────────────────────────────────────

  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please enter both email and password.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await AuthService().signIn(email, password);

      final accessToken = response['access_token']?.toString();
      final refreshToken = response['refresh_token']?.toString();
      final message = response['message']?.toString();

      print('Login successful: $message');
      print('Access Token: $accessToken');
      print('Refresh Token: $refreshToken');

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('Login failed: $e');
      _showErrorDialog(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Sign In Failed'),
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

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(
        bottom: false,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopBar(),
              _buildHero(),
              Expanded(child: _buildForm()),
            ],
          ),
        ),
      ),
    );
  }

  ObstructingPreferredSizeWidget _buildTopBar() {
    return CupertinoNavigationBar(
      backgroundColor: CupertinoColors.systemBackground
          .resolveFrom(context)
          .withValues(alpha: 0.85),
      border: Border(
        bottom: BorderSide(
          color: CupertinoColors.separator
              .resolveFrom(context)
              .withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      middle: const SizedBox.shrink(),
      leading: GestureDetector(
        onTap: () async {
          final didPop = await Navigator.maybePop(context);
          if (!didPop && context.mounted) {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, '/sign-in');
          }
        },
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            CupertinoIcons.chevron_left,
            color: CupertinoColors.activeBlue,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 270,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: SvgPicture.asset(
                    '/logo/brightfund_logo.svg',
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    placeholderBuilder: (context) => const Center(child: CupertinoActivityIndicator()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 29,
                height: 1.08,
                color: _C.ink,
                fontWeight: FontWeight.w600,
              ),
              children: [
                const TextSpan(text: 'Sign In'),
                TextSpan(
                  text: ' Now',
                  style: GoogleFonts.poppins(
                    fontSize: 29,
                    height: 1.08,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2B5CE6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Support what matters most, all from one place.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              color: _C.ink,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Social buttons
          Row(
            children: [
              Expanded(
                child: _SocialButton(
                  icon: Image.asset('/icon/google.png', width: 20, height: 20),
                  label: 'Google',
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SocialButton(
                  icon: Image.asset('/icon/apple.png', width: 20, height: 20),
                  label: 'Apple',
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Divider
          Row(
            children: [
              const Expanded(child: Divider(color: _C.border, thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'OR WITH EMAIL',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    letterSpacing: 0.06 * 11,
                    color: _C.muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: _C.border, thickness: 1)),
            ],
          ),
          const SizedBox(height: 14),

          // Email
          _FieldGroup(
            label: 'Email Address',
            child: _StyledTextField(
              controller: _emailController,
              placeholder: 'example@gmail.com',
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
            ),
          ),
          const SizedBox(height: 14),

          // Password label row with forgot link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PASSWORD',
                style: GoogleFonts.dmSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.04 * 11.5,
                  color: _C.muted,
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 0,
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => const ForgetPasswordScreen(),
                  ),
                ),
                child: Text(
                  'Forgot password?',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: CupertinoColors.activeBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _StyledTextField(
            controller: _passwordController,
            placeholder: 'Password',
            obscureText: !_isPasswordVisible,
            suffix: GestureDetector(
              onTap: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
              child: Icon(
                _isPasswordVisible
                    ? CupertinoIcons.eye
                    : CupertinoIcons.eye_slash,
                color: _C.muted,
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Remember me
          Row(
            children: [
              CupertinoCheckbox(
                value: _rememberMe,
                activeColor: CupertinoColors.activeBlue,
                onChanged: (v) => setState(() => _rememberMe = v ?? false),
              ),
              const SizedBox(width: 8),
              Text(
                'Remember me',
                style: GoogleFonts.dmSans(fontSize: 13, color: _C.muted),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // CTA
          GestureDetector(
            onTap: _isLoading ? null : _handleSignIn,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 54,
              decoration: BoxDecoration(
                color: _isLoading
                    ? const Color.fromRGBO(43, 92, 230, 0.7)
                    : CupertinoColors.activeBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: _isLoading
                    ? const CupertinoActivityIndicator(
                        color: CupertinoColors.white,
                      )
                    : Text(
                        'Sign In',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.white,
                          letterSpacing: 0.02 * 15,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Sign up link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: GoogleFonts.dmSans(fontSize: 13, color: _C.muted),
              ),
              CupertinoButton(
                padding: const EdgeInsets.only(left: 4),
                minSize: 0,
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/sign-up'),
                child: Text(
                  'Sign up',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: CupertinoColors.activeBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Field Group ──────────────────────────────────────────────────────────────

class _FieldGroup extends StatelessWidget {
  const _FieldGroup({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.04 * 11.5,
            color: _C.muted,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

// ─── Styled Text Field ────────────────────────────────────────────────────────

class _StyledTextField extends StatefulWidget {
  const _StyledTextField({
    required this.controller,
    required this.placeholder,
    this.keyboardType,
    this.obscureText = false,
    this.autocorrect = true,
    this.suffix,
  });

  final TextEditingController controller;
  final String placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool autocorrect;
  final Widget? suffix;

  @override
  State<_StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<_StyledTextField> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: _C.fieldBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 1.5),
      ),
      child: CupertinoTextField(
        controller: widget.controller,
        placeholder: widget.placeholder,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(),
        style: GoogleFonts.dmSans(fontSize: 15, color: _C.ink),
        placeholderStyle: GoogleFonts.dmSans(
          fontSize: 15,
          color: const Color(0xFFC0B9AE),
        ),
        suffix: widget.suffix != null
            ? Padding(
                padding: const EdgeInsets.only(right: 14),
                child: widget.suffix,
              )
            : null,
        // onTap: () => setState(() => _focused = true),
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
          // if (mounted) setState(() => _focused = false);
        },
      ),
    );
  }
}

// ─── Social Button ────────────────────────────────────────────────────────────

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final Widget icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: _C.fieldBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.border, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _C.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
