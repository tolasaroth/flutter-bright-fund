import 'package:flutter/cupertino.dart';
import 'package:gofundme/widgets/app_navigation_bar.dart';
import 'package:gofundme/utils/colors.dart';

class _C {
  static const blue = Color(0xFF007AFF);
  static const green = Color(0xFF34C759);
  static const orange = Color(0xFFFF9500);
  static const red = Color(0xFFFF3B30);
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileScreenInner();
  }
}

class _ProfileScreenInner extends StatefulWidget {
  const _ProfileScreenInner();

  @override
  State<_ProfileScreenInner> createState() => _ProfileScreenInnerState();
}

class _ProfileScreenInnerState extends State<_ProfileScreenInner> {
  String _fullName = 'Bora Touch';
  String _email = 'bora.touch@gofundme.app';
  String _phone = '+855 12 345 678';
  String _bio = 'Helping communities grow, one campaign at a time. 🌱';
  String _location = 'Phnom Penh, Cambodia';
  String _website = 'boratouch.com';

  final int _campaigns = 12;
  final int _donors = 347;
  final String _raised = '\$48,200';

  bool _isEditing = false;

  late final TextEditingController _nameCtrl =
      TextEditingController(text: _fullName);
  late final TextEditingController _emailCtrl =
      TextEditingController(text: _email);
  late final TextEditingController _phoneCtrl =
      TextEditingController(text: _phone);
  late final TextEditingController _bioCtrl =
      TextEditingController(text: _bio);
  late final TextEditingController _locationCtrl =
      TextEditingController(text: _location);
  late final TextEditingController _websiteCtrl =
      TextEditingController(text: _website);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    _locationCtrl.dispose();
    _websiteCtrl.dispose();
    super.dispose();
  }

  void _saveChanges() {
    setState(() {
      _fullName = _nameCtrl.text.trim().isEmpty ? _fullName : _nameCtrl.text.trim();
      _email = _emailCtrl.text.trim().isEmpty ? _email : _emailCtrl.text.trim();
      _phone = _phoneCtrl.text.trim().isEmpty ? _phone : _phoneCtrl.text.trim();
      _bio = _bioCtrl.text.trim().isEmpty ? _bio : _bioCtrl.text.trim();
      _location = _locationCtrl.text.trim().isEmpty ? _location : _locationCtrl.text.trim();
      _website = _websiteCtrl.text.trim().isEmpty ? _website : _websiteCtrl.text.trim();
      _isEditing = false;
    });
  }

  void _cancelEditing() {
    _nameCtrl.text = _fullName;
    _emailCtrl.text = _email;
    _phoneCtrl.text = _phone;
    _bioCtrl.text = _bio;
    _locationCtrl.text = _location;
    _websiteCtrl.text = _website;
    setState(() => _isEditing = false);
  }

  void _showComingSoon(String label) {
    showCupertinoDialog<void>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(label),
        content: const Text('This feature is not connected yet.'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAvatarSheet() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Change Profile Photo'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon('Take Photo');
            },
            child: const Text('Take Photo'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon('Choose from Library');
            },
            child: const Text('Choose from Library'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon('Remove Photo');
            },
            child: const Text('Remove Current Photo'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return CupertinoPageScaffold(
      navigationBar: AppNavigationBar(
        title: 'Profile',
        showAddButton: false,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isEditing ? _saveChanges : () => setState(() => _isEditing = true),
          child: Text(
            _isEditing ? 'Save' : 'Edit',
            style: const TextStyle(
              color: _C.blue,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(
              child: _ProfileHero(
                name: _fullName,
                bio: _bio,
                isDark: isDark,
                isEditing: _isEditing,
                onAvatarTap: _isEditing ? _showAvatarSheet : null,
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: _StatsRow(
                  campaigns: _campaigns,
                  donors: _donors,
                  raised: _raised,
                  isDark: isDark,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: _SectionCard(
                header: 'PERSONAL INFO',
                isDark: isDark,
                children: [
                  _InfoRow(
                    icon: CupertinoIcons.person_fill,
                    color: CupertinoColors.activeBlue,
                    label: 'Full Name',
                    value: _fullName,
                    isEditing: _isEditing,
                    controller: _nameCtrl,
                    keyboardType: TextInputType.name,
                    placeholder: 'Full name',
                  ),
                  _InfoRow(
                    icon: CupertinoIcons.mail_solid,
                    color: CupertinoColors.activeBlue,
                    label: 'Email',
                    value: _email,
                    isEditing: _isEditing,
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    placeholder: 'Email address',
                  ),
                  _InfoRow(
                    icon: CupertinoIcons.phone_fill,
                    color: CupertinoColors.activeBlue,
                    label: 'Phone',
                    value: _phone,
                    isEditing: _isEditing,
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    placeholder: 'Phone number',
                    isLast: true,
                  ),
                ],
              ),
            ),

            if (!_isEditing)
              SliverToBoxAdapter(
                child: _SectionCard(
                  header: 'ACCOUNT',
                  isDark: isDark,
                  children: [
                    _ActionRow(
                      icon: CupertinoIcons.trash_fill,
                      color: _C.red,
                      label: 'Delete Account',
                      labelColor: _C.red,
                      onTap: () => _confirmDeleteAccount(context),
                      isLast: true,
                    ),
                  ],
                ),
              ),

            if (_isEditing)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 32),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _cancelEditing,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _C.red.withValues(alpha: 0.35),
                        ),
                        color: _C.red.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: _C.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            if (!_isEditing) const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all associated data. This action cannot be undone.',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon('Account Deleted');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.name,
    required this.bio,
    required this.isDark,
    required this.isEditing,
    this.onAvatarTap,
  });

  final String name;
  final String bio;
  final bool isDark;
  final bool isEditing;
  final VoidCallback? onAvatarTap;

  List<Color> get _gradient => [
        const Color(0xFF007AFF),
        const Color(0xFF5856D6),
      ];

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(92),
                    boxShadow: [
                      BoxShadow(
                        color: _gradient[0].withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                if (isEditing)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _C.blue,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF000000)
                              : CupertinoColors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        CupertinoIcons.camera_fill,
                        size: 14,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: CupertinoColors.label,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF34C759), Color(0xFF32ADE6)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.checkmark_seal_fill,
                  size: 12,
                  color: CupertinoColors.white,
                ),
                SizedBox(width: 4),
                Text(
                  'Student',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.campaigns,
    required this.donors,
    required this.raised,
    required this.isDark,
  });

  final int campaigns;
  final int donors;
  final String raised;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Row(
          children: [
            _StatItem(
              value: '$campaigns',
              label: 'Campaigns',
              color: _C.blue,
            ),
            _VertDivider(isDark: isDark),
            _StatItem(
              value: '$donors',
              label: 'Donors',
              color: _C.green,
            ),
            _VertDivider(isDark: isDark),
            _StatItem(
              value: raised,
              label: 'Raised',
              color: _C.orange,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  const _VertDivider({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.5,
      height: 36,
      color: isDark
          ? const Color(0xFF3A3A3C)
          : const Color(0xFFE5E5EA),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.header,
    required this.children,
    required this.isDark,
  });

  final String header;
  final List<Widget> children;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              header,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1C1C1E) : CupertinoColors.white,
              ),
              child: Column(children: children),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.isEditing,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.placeholder = '',
    this.isLast = false,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final bool isEditing;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String placeholder;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.28),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 20, color: CupertinoColors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: isEditing
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.tertiaryLabel,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          CupertinoTextField(
                            controller: controller,
                            keyboardType: keyboardType,
                            placeholder: placeholder,
                            padding: EdgeInsets.zero,
                            decoration: null,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? CupertinoColors.white
                                  : CupertinoColors.black,
                            ),
                            placeholderStyle: const TextStyle(
                              fontSize: 15,
                              color: CupertinoColors.placeholderText,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.tertiaryLabel,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            value,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: CupertinoColors.label,
                            ),
                          ),
                        ],
                      ),
              ),
              if (isEditing)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    CupertinoIcons.pencil,
                    size: 15,
                    color: CupertinoColors.tertiaryLabel,
                  ),
                ),
            ],
          ),
        ),

        if (!isLast)
          Container(
            height: 0.5,
            margin: const EdgeInsets.only(left: 58),
            color: CupertinoColors.separator.resolveFrom(context),
          ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {

  const _ActionRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.isLast = false,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.28),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 18, color: CupertinoColors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: labelColor ??
                          CupertinoColors.label.resolveFrom(context),
                    ),
                  ),
                ),
                const Icon(
                  CupertinoIcons.chevron_right,
                  size: 15,
                  color: CupertinoColors.tertiaryLabel,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Container(
            height: 0.5,
            margin: const EdgeInsets.only(left: 58),
            color: CupertinoColors.separator.resolveFrom(context),
          ),
      ],
    );
  }
}