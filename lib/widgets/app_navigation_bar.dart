// app_navigation_bar.dart
import 'package:flutter/cupertino.dart';

class AppNavigationBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  const AppNavigationBar({
    super.key,
    required this.title,
    this.onAddPressed,
    this.showAddButton = true,
    this.trailing,
    this.leading,
  });

  final String title;
  final VoidCallback? onAddPressed;
  final bool showAddButton;
  final Widget? trailing;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  bool shouldFullyObstruct(BuildContext context) => false;

  @override
  Widget build(BuildContext context) {
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
      automaticallyImplyLeading: leading == null,
      leading: leading,
      middle: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
        ),
      ),
      trailing: trailing,
    );
  }
}
