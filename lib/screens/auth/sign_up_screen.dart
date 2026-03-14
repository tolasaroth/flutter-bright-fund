import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gofundme/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  
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

  static const _roles = [
    'Individual',
    'Student',
    'Entrepreneur',
    'Investor',
    'Non-Profit',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _profileImageController.dispose();
    super.dispose();
  }

  // ─── Validation ─────────────────────────────────────────────────────────

  String? _validate() {
    if (_firstNameController.text.trim().isEmpty) {
      return 'First name is required.';
    }
    if (_lastNameController.text.trim().isEmpty) {
      return 'Last name is required.';
    }
    if (_emailController.text.trim().isEmpty) {
      return 'Email is required.';
    }
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
    if (!_agreedToTerms) {
      return 'Please agree to the Terms & Privacy Policy.';
    }
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
      print('Sign up failed: $e');
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
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => Container(
        height: 280,
        color: CupertinoColors.systemBackground,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: CupertinoColors.systemGrey),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoButton(
                  child: const Text(
                    'Done',
                    style: TextStyle(color: CupertinoColors.activeBlue),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: _selectedRole == null
                      ? 0
                      : _roles
                            .indexOf(_selectedRole!)
                            .clamp(0, _roles.length - 1),
                ),
                itemExtent: 40,
                onSelectedItemChanged: (i) =>
                    setState(() => _selectedRole = _roles[i]),
                children: _roles.map((r) => Center(child: Text(r))).toList(),
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
      backgroundColor: const Color(0xFFF6F6F6),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Back button row
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
                child: CupertinoButton(
                  minSize: 44,
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    final didPop = await Navigator.maybePop(context);
                    if (!didPop && context.mounted) {
                      Navigator.pushReplacementNamed(context, '/sign-in');
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: CupertinoColors.systemGrey4),
                    ),
                    child: const Icon(
                      CupertinoIcons.back,
                      color: CupertinoColors.activeBlue,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),

            // Header
            // Expanded(
            //   flex: 2,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       const Icon(
            //         CupertinoIcons.rocket_fill,
            //         size: 60,
            //         color: CupertinoColors.white,
            //       ),
            //       const SizedBox(height: 12),
            //       Text(
            //         'BrightFund',
            //         style: GoogleFonts.inter(
            //           fontSize: 32,
            //           fontWeight: FontWeight.bold,
            //           color: const Color(0xFFF6F6F6),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // Form card
            Expanded(
              flex: 8,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F6F6),
                  // borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Fill in the details below to get started',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // First Name & Last Name (row)
                      Row(
                        children: [
                          Expanded(
                            child: _FieldGroup(
                              label: 'First Name',
                              child: CupertinoTextField(
                                controller: _firstNameController,
                                placeholder: 'First name',
                                textCapitalization: TextCapitalization.words,
                                padding: const EdgeInsets.all(14),
                                decoration: _box(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _FieldGroup(
                              label: 'Last Name',
                              child: CupertinoTextField(
                                controller: _lastNameController,
                                placeholder: 'Last name',
                                textCapitalization: TextCapitalization.words,
                                padding: const EdgeInsets.all(14),
                                decoration: _box(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email
                      _FieldGroup(
                        label: 'Email Address',
                        required: true,
                        child: CupertinoTextField(
                          controller: _emailController,
                          placeholder: 'example@gmail.com',
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          padding: const EdgeInsets.all(14),
                          decoration: _box(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Phone Number
                      _FieldGroup(
                        label: 'Phone Number',
                        required: true,
                        child: CupertinoTextField(
                          controller: _phoneController,
                          placeholder: '+855 12 345 678',
                          keyboardType: TextInputType.phone,
                          padding: const EdgeInsets.all(14),
                          decoration: _box(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Account Type picker
                      _FieldGroup(
                        label: 'Type',
                        required: true,
                        child: GestureDetector(
                          onTap: _showRolePicker,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: _box(),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedRole ?? 'Select account type',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: _selectedRole == null
                                          ? CupertinoColors.placeholderText
                                          : CupertinoColors.label.resolveFrom(
                                              context,
                                            ),
                                    ),
                                  ),
                                ),
                                const Icon(
                                  CupertinoIcons.chevron_down,
                                  size: 16,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password
                      _FieldGroup(
                        label: 'Password',
                        required: true,
                        child: CupertinoTextField(
                          controller: _passwordController,
                          placeholder: 'New password',
                          obscureText: !_isPasswordVisible,
                          padding: const EdgeInsets.all(14),
                          decoration: _box(),
                          suffix: CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            onPressed: () => setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            ),
                            child: Icon(
                              _isPasswordVisible
                                  ? CupertinoIcons.eye
                                  : CupertinoIcons.eye_slash,
                              color: CupertinoColors.systemGrey,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      _FieldGroup(
                        label: 'Confirm Password',
                        required: true,
                        child: CupertinoTextField(
                          controller: _confirmPasswordController,
                          placeholder: 'Confirm password',
                          obscureText: !_isConfirmPasswordVisible,
                          padding: const EdgeInsets.all(14),
                          decoration: _box(),
                          suffix: CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            onPressed: () => setState(
                              () => _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible,
                            ),
                            child: Icon(
                              _isConfirmPasswordVisible
                                  ? CupertinoIcons.eye
                                  : CupertinoIcons.eye_slash,
                              color: CupertinoColors.systemGrey,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            CupertinoSwitch(
                              value: _agreedToTerms,
                              activeTrackColor: CupertinoColors.activeBlue,
                              onChanged: (value) {
                                setState(() => _agreedToTerms = value);
                              },
                            ),
                            Text(
                              'I agree to the Terms & Privacy Policy',
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        borderRadius: BorderRadius.circular(20),
                        color: CupertinoColors.activeBlue,
                        onPressed: _isLoading ? null : _handleSignUp,
                        child: _isLoading
                            ? const CupertinoActivityIndicator(
                                color: CupertinoColors.white,
                              )
                            : const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: CupertinoColors.white,
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),

                      // Sign in link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(color: CupertinoColors.systemGrey),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.all(5),
                            onPressed: () => Navigator.pushReplacementNamed(
                              context,
                              '/sign-in',
                            ),
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                color: CupertinoColors.activeBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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

  BoxDecoration _box() => BoxDecoration(
    color: CupertinoColors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: CupertinoColors.systemGrey4),
  );
}

// ─── Field Group ─────────────────────────────────────────────────────────────

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
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.systemRed,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
