import 'package:flutter/cupertino.dart';
import 'package:gofundme/widgets/app_navigation_bar.dart';

enum NotificationType { campaign, payment, update, alert }

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final NotificationType type;
  final bool isRead;
  final String? avatarInitials;
  final Color? avatarColor;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
    this.avatarInitials,
    this.avatarColor,
  });
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const AppNavigationBar(
        title: 'Notifications',
        showAddButton: false,
      ),
      child: const Center(
        child: Text('Notification Screen'),
      ),
    );
  }
}