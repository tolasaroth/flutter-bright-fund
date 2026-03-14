import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gofundme/utils/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/logo/brightfund_logo.svg',
                      height: 270,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Welcome to BrightFund',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        height: 1.1,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1612),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Raise, support, and grow what matters most.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: const Color(0xFF7A7068),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              _PrimaryButton(
                label: 'Sign In',
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/sign-in'),
              ),
              const SizedBox(height: 10),
              _OutlineButton(
                label: 'Sign Up',
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/sign-up'),
              ),
              const SizedBox(height: 10),
              _OutlineButton(
                label: 'Continue with Google',
                leading: Image.asset(
                  'assets/icon/google.png',
                  width: 20,
                  height: 20,
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 10),
              _OutlineButton(
                label: 'Continue with Apple',
                leading: Image.asset(
                  'assets/icon/apple.png',
                  width: 20,
                  height: 20,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: CupertinoColors.activeBlue,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: CupertinoColors.white,
              letterSpacing: 0.02 * 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({
    required this.label,
    required this.onPressed,
    this.leading,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8E2D8), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 10)],
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1612),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
