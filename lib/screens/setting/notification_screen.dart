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

final List<AppNotification> _todayNotifications = [
  AppNotification(
    id: '1',
    title: 'Campaign funded!',
    body: 'Your campaign "Help rebuild the community center" has reached its goal.',
    timeAgo: 'Just now',
    type: NotificationType.campaign,
    avatarInitials: 'CF',
    avatarColor: const Color(0xFF00B86B),
  ),
  AppNotification(
    id: '2',
    title: 'New donation received',
    body: 'Sarah M. donated \$50 to your campaign "Medical Fund for Jake".',
    timeAgo: '14 min ago',
    type: NotificationType.payment,
    avatarInitials: 'SM',
    avatarColor: const Color(0xFF007AFF),
  ),
  AppNotification(
    id: '3',
    title: 'Withdrawal processed',
    body: '\$1,200 has been transferred to your bank account ending in 4521.',
    timeAgo: '1 hr ago',
    type: NotificationType.payment,
    isRead: true,
    avatarInitials: '\$',
    avatarColor: const Color(0xFF34C759),
  ),
];

final List<AppNotification> _earlierNotifications = [
  AppNotification(
    id: '4',
    title: 'Campaign update',
    body: 'You posted an update on "Help rebuild the community center".',
    timeAgo: 'Yesterday',
    type: NotificationType.update,
    isRead: true,
    avatarInitials: 'U',
    avatarColor: const Color(0xFFFF9500),
  ),
  AppNotification(
    id: '5',
    title: 'New comment',
    body: 'James R. left a comment: "Amazing cause, happy to help!"',
    timeAgo: 'Yesterday',
    type: NotificationType.update,
    isRead: true,
    avatarInitials: 'JR',
    avatarColor: const Color(0xFFAF52DE),
  ),
  AppNotification(
    id: '6',
    title: 'Reminder: Campaign expiring',
    body: 'Your campaign "Art Supplies for Kids" expires in 3 days.',
    timeAgo: '2 days ago',
    type: NotificationType.alert,
    isRead: true,
    avatarInitials: '!',
    avatarColor: const Color(0xFFFF3B30),
  ),
  AppNotification(
    id: '7',
    title: 'Donation milestone reached',
    body: '"Medical Fund for Jake" has reached 75% of its funding goal!',
    timeAgo: '3 days ago',
    type: NotificationType.campaign,
    isRead: true,
    avatarInitials: '75',
    avatarColor: const Color(0xFF00B86B),
  ),
];

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