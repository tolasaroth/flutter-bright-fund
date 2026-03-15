import 'package:flutter/cupertino.dart';
import 'package:gofundme/utils/colors.dart';
import 'package:gofundme/widgets/app_navigation_bar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _pushNotifications = true;

  void _showComingSoon(String title) {
    showCupertinoDialog<void>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: const Text('This option is not connected yet.'),
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

  Future<void> _showSignOutSheet() async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Sign out of this account?'),
        message: const Text('You can sign back in at any time.'),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              _showComingSoon('Signed out');
            },
            child: const Text('Sign Out'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
      navigationBar: const AppNavigationBar(
        title: 'Settings',
        showAddButton: false,
      ),
      backgroundColor: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [

            _buildSection(
              header: 'NOTIFICATIONS',
              children: [
                _ToggleTile(
                  label: 'Notifications',
                  icon: CupertinoIcons.bell_fill,
                  color: CupertinoColors.activeBlue,
                  value: _pushNotifications,
                  onChanged: (v) => setState(() => _pushNotifications = v),
                ),
              ],
            ),

            _buildSection(
              header: 'PRIVACY & SECURITY',
              children: [
                _NavTile(
                  label: 'Change Password',
                  icon: CupertinoIcons.lock_fill,
                  color: CupertinoColors.activeBlue,
                  onTap: () => _showComingSoon('Change Password'),
                ),
              ],
            ),

            _buildSection(
              header: 'GENERAL',
              children: [
                _NavTile(
                  label: 'Language',
                  icon: CupertinoIcons.globe,
                  color: CupertinoColors.activeBlue,
                  trailing: const _InfoBadge(label: 'English'),
                  onTap: () => _showComingSoon('Language'),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                child: _SignOutButton(onPressed: _showSignOutSheet),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String header,
    required List<Widget> children,
  }) {
    return SliverToBoxAdapter(
      child: CupertinoListSection.insetGrouped(
      backgroundColor: AppColors.surface,
        header: Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 12, right: 12),
          child: Text(
            header,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
        ),
        children: children,
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
      title: Text(label),
      leading: _LeadingIcon(icon: icon, color: color),
      additionalInfo: trailing,
      trailing: const CupertinoListTileChevron(),
      onTap: onTap,
    );
  }
}


class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      title: Text(label),
      leading: _LeadingIcon(icon: icon, color: color),
      trailing: CupertinoSwitch(
        value: value,
        activeColor: color,
        onChanged: onChanged,
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5.resolveFrom(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: CupertinoColors.secondaryLabel,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Leading icon square
// ─────────────────────────────────────────────
class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.30),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 17, color: CupertinoColors.white),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      onPressed: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: CupertinoColors.systemRed.withValues(alpha: 0.35),
          ),
          color: CupertinoColors.systemRed.withValues(alpha: 0.08),
        ),
        child: const SizedBox(
          height: 50,
          width: double.infinity,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.square_arrow_left,
                  color: CupertinoColors.systemRed,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Sign Out',
                  style: TextStyle(
                    color: CupertinoColors.systemRed,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}