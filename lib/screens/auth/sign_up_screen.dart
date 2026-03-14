import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gofundme/services/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ─── Design Tokens ────────────────────────────────────────────────────────────
class _C {
  static const ink = Color(0xFF1A1612);
  static const muted = Color(0xFF7A7068);
  static const border = Color(0xFFE8E2D8);
  static const fieldBg = Color(0xFFFFFFFF);
  static const danger = Color(0xFFC94040);
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _profileImageController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _selectedRole;
  bool _isLoading = false;
  bool _agreedToTerms = false;

  AnimationController? _fadeCtrl;
  Animation<double> _fadeAnim = const AlwaysStoppedAnimation(1.0);

  static const _roles = [
    'Individual',
    'Student',
    'Entrepreneur',
    'Investor',
    'Non-Profit',
  ];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl!, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl?.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _profileImageController.dispose();
    super.dispose();
  }

  // ─── Validation ──────────────────────────────────────────────────────────

  String? _validate() {
    if (_firstNameController.text.trim().isEmpty) {
      return 'First name is required.';
    }
    if (_lastNameController.text.trim().isEmpty) {
      return 'Last name is required.';
    }
    if (_emailController.text.trim().isEmpty) return 'Email is required.';
    if (!_emailController.text.contains('@')) {
      return 'Enter a valid email address.';
    }
    if (_phoneController.text.trim().isEmpty) {
      return 'Phone number is required.';
    }
    if (_selectedRole == null) return 'Please select an account type.';
    if (_passwordController.text.isEmpty) return 'Password is required.';
    if (_passwordController.text.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    if (_confirmPasswordController.text != _passwordController.text) {
      return 'Passwords do not match.';
    }
    if (!_agreedToTerms) return 'Please agree to the Terms & Privacy Policy.';
    return null;
  }

  Future<void> _handleSignUp() async {
    final error = _validate();
    if (error != null) {
      _showDialog('Validation Error', error);
      return;
    }
    setState(() => _isLoading = true);
    try {
      await AuthService().register(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        profileImage: _profileImageController.text.trim().isEmpty
            ? null
            : _profileImageController.text.trim(),
        rolesRequest: [_selectedRole!],
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/sign-in');
    } catch (e) {
      _showDialog('Sign Up Failed', e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showDialog(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
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

  void _showRolePicker() {
    int tempIndex = _selectedRole == null
        ? 0
        : _roles.indexOf(_selectedRole!).clamp(0, _roles.length - 1);
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: _C.fieldBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: _C.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.dmSans(color: _C.muted, fontSize: 15),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Account Type',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: _C.ink,
                  ),
                ),
                CupertinoButton(
                  child: Text(
                    'Done',
                    style: GoogleFonts.dmSans(
                      color: CupertinoColors.activeBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    setState(() => _selectedRole = _roles[tempIndex]);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: tempIndex,
                ),
                itemExtent: 44,
                onSelectedItemChanged: (i) => tempIndex = i,
                children: _roles
                    .map(
                      (r) => Center(
                        child: Text(
                          r,
                          style: GoogleFonts.dmSans(
                            fontSize: 17,
                            color: _C.ink,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: _buildTopBar(),
      child: SafeArea(
        top: false,
        bottom: false,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [Expanded(child: _buildForm())],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 270,
          child: SvgPicture.asset(
            '/logo/brightfund_logo.svg',
            fit: BoxFit.contain,
            alignment: Alignment.center,
            placeholderBuilder: (context) =>
                const Center(child: CupertinoActivityIndicator()),
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.poppins(
              fontSize: 29,
              height: 1.08,
              fontWeight: FontWeight.w600,
              color: _C.ink,
            ),
            children: [
              const TextSpan(text: 'Create an'),
              TextSpan(
                text: ' account',
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
          'Join to raise, support, and manage campaigns in one place.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 13.5,
            color: _C.ink,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Hero now lives inside the scroll view ──
          _buildHero(),
          const SizedBox(height: 22),

          // Name row
          Row(
            children: [
              Expanded(
                child: _FieldGroup(
                  label: 'First Name',
                  child: _StyledTextField(
                    controller: _firstNameController,
                    placeholder: 'First name',
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FieldGroup(
                  label: 'Last Name',
                  child: _StyledTextField(
                    controller: _lastNameController,
                    placeholder: 'Last name', // fixed typo
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _FieldGroup(
            label: 'Email',
            required: true,
            child: _StyledTextField(
              controller: _emailController,
              placeholder: 'example@gmail.com',
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
            ),
          ),
          const SizedBox(height: 14),

          _FieldGroup(
            label: 'Phone',
            required: true,
            child: _StyledTextField(
              controller: _phoneController,
              placeholder: '+855 12 345 678',
              keyboardType: TextInputType.phone,
            ),
          ),
          const SizedBox(height: 14),

          _FieldGroup(
            label: 'Type',
            required: true,
            child: GestureDetector(
              onTap: _showRolePicker,
              child: _PickerField(value: _selectedRole),
            ),
          ),
          const SizedBox(height: 14),

          _FieldGroup(
            label: 'Password',
            required: true,
            child: _StyledTextField(
              controller: _passwordController,
              placeholder: 'New password',
              obscureText: !_isPasswordVisible,
              suffix: GestureDetector(
                onTap: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
                child: Icon(
                  _isPasswordVisible
                      ? CupertinoIcons.eye
                      : CupertinoIcons.eye_slash,
                  size: 18,
                  color: _C.muted,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          _FieldGroup(
            label: 'Confirm Password',
            required: true,
            child: _StyledTextField(
              controller: _confirmPasswordController,
              placeholder: 'Confirm password',
              obscureText: !_isConfirmPasswordVisible,
              suffix: GestureDetector(
                onTap: () => setState(
                  () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
                ),
                child: Icon(
                  _isConfirmPasswordVisible
                      ? CupertinoIcons.eye
                      : CupertinoIcons.eye_slash,
                  size: 18,
                  color: _C.muted,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Terms row
          Row(
            children: [
              CupertinoCheckbox(
                value: _agreedToTerms,
                activeColor: CupertinoColors.activeBlue,
                onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: _C.muted,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms of Service',
                        style: const TextStyle(
                          color: CupertinoColors.activeBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: ' & '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          color: CupertinoColors.activeBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // CTA
          GestureDetector(
            onTap: _isLoading ? null : _handleSignUp,
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
                        'Create Account',
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
          const SizedBox(height: 18),

          // Sign in link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: GoogleFonts.dmSans(fontSize: 13, color: _C.muted),
              ),
              CupertinoButton(
                padding: const EdgeInsets.only(left: 4),
                minSize: 0,
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/sign-in'),
                child: Text(
                  'Sign in',
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

// ─── Styled Text Field ────────────────────────────────────────────────────────

class _StyledTextField extends StatefulWidget {
  const _StyledTextField({
    required this.controller,
    required this.placeholder,
    this.keyboardType,
    this.obscureText = false,
    this.autocorrect = true,
    this.textCapitalization = TextCapitalization.none,
    this.suffix,
  });

  final TextEditingController controller;
  final String placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool autocorrect;
  final TextCapitalization textCapitalization;
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
        textCapitalization: widget.textCapitalization,
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
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}

// ─── Picker Field ─────────────────────────────────────────────────────────────

class _PickerField extends StatelessWidget {
  const _PickerField({this.value});
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _C.fieldBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value ?? 'Select account type',
              style: GoogleFonts.dmSans(
                fontSize: 15,
                color: value == null ? const Color(0xFFC0B9AE) : _C.ink,
              ),
            ),
          ),
          const Icon(CupertinoIcons.chevron_down, size: 16, color: _C.muted),
        ],
      ),
    );
  }
}

// ─── Field Group ──────────────────────────────────────────────────────────────

class _FieldGroup extends StatelessWidget {
  const _FieldGroup({
    required this.label,
    required this.child,
    this.required = false,
  });

  final String label;
  final Widget child;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            if (required)
              Text(
                ' *',
                style: GoogleFonts.dmSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: _C.danger,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
