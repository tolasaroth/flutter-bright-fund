import 'package:flutter/cupertino.dart';
import 'package:gofundme/utils/colors.dart';
import 'package:gofundme/widgets/app_navigation_bar.dart';

// ─────────────────────────────────────────────
//  Domain models
// ─────────────────────────────────────────────
enum NotificationType { campaign, payment, update, alert }

enum NotificationBucket { today, yesterday, earlier }

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final NotificationType type;
  final NotificationBucket bucket;
  final bool isRead;
  final String? avatarInitials;
  final Color? avatarColor;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.type,
    required this.bucket,
    this.isRead = false,
    this.avatarInitials,
    this.avatarColor,
  });

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        title: title,
        body: body,
        timeAgo: timeAgo,
        type: type,
        bucket: bucket,
        isRead: isRead ?? this.isRead,
        avatarInitials: avatarInitials,
        avatarColor: avatarColor,
      );
}

// ─────────────────────────────────────────────
//  Palette
// ─────────────────────────────────────────────
class _C {
  static const green = Color(0xFF34C759);
  static const blue = Color(0xFF007AFF);
  static const indigo = Color(0xFF5856D6);
  static const orange = Color(0xFFFF9500);
  static const red = Color(0xFFFF3B30);
}

// ─────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _showUnreadOnly = false;

  late final List<AppNotification> _notifications = [
    const AppNotification(
      id: '1',
      title: 'Campaign goal reached 🎉',
      body: 'Help Build a Village School is now fully funded.',
      timeAgo: '5m ago',
      type: NotificationType.campaign,
      bucket: NotificationBucket.today,
      isRead: false,
      avatarInitials: 'HB',
      avatarColor: _C.green,
    ),
    const AppNotification(
      id: '2',
      title: 'Payment received',
      body: 'You received \$35 from Chenda for Clean Water Project.',
      timeAgo: '42m ago',
      type: NotificationType.payment,
      bucket: NotificationBucket.today,
      isRead: false,
      avatarInitials: 'CH',
      avatarColor: _C.blue,
    ),
    const AppNotification(
      id: '3',
      title: 'Campaign update',
      body: 'New photos were added to Save the City Shelter.',
      timeAgo: '2h ago',
      type: NotificationType.update,
      bucket: NotificationBucket.today,
      isRead: true,
      avatarInitials: 'SS',
      avatarColor: _C.indigo,
    ),
    const AppNotification(
      id: '4',
      title: 'Reminder',
      body: 'Your draft campaign has not been published yet.',
      timeAgo: 'Yesterday',
      type: NotificationType.alert,
      bucket: NotificationBucket.yesterday,
      isRead: true,
      avatarInitials: 'DR',
      avatarColor: _C.orange,
    ),
    const AppNotification(
      id: '5',
      title: 'Payment failed',
      body: 'A donor payment could not be processed. Tap to retry.',
      timeAgo: '2d ago',
      type: NotificationType.alert,
      bucket: NotificationBucket.earlier,
      isRead: false,
      avatarInitials: 'PF',
      avatarColor: _C.red,
    ),
  ];

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<AppNotification> get _filtered =>
      _showUnreadOnly ? _notifications.where((n) => !n.isRead).toList() : _notifications;

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  List<AppNotification> _forBucket(NotificationBucket b) =>
      _filtered.where((n) => n.bucket == b).toList();

  String _bucketLabel(NotificationBucket b) => switch (b) {
        NotificationBucket.today => 'Today',
        NotificationBucket.yesterday => 'Yesterday',
        NotificationBucket.earlier => 'Earlier',
      };

  IconData _iconFor(NotificationType t) => switch (t) {
        NotificationType.campaign => CupertinoIcons.heart_fill,
        NotificationType.payment => CupertinoIcons.money_dollar_circle_fill,
        NotificationType.update => CupertinoIcons.info_circle_fill,
        NotificationType.alert => CupertinoIcons.exclamationmark_triangle_fill,
      };

  Color _colorFor(NotificationType t) => switch (t) {
        NotificationType.campaign => _C.green,
        NotificationType.payment => _C.blue,
        NotificationType.update => _C.indigo,
        NotificationType.alert => _C.orange,
      };

  void _markRead(String id) {
    final i = _notifications.indexWhere((n) => n.id == id);
    if (i != -1 && !_notifications[i].isRead) {
      setState(() => _notifications[i] = _notifications[i].copyWith(isRead: true));
    }
  }

  void _toggleRead(String id) {
    final i = _notifications.indexWhere((n) => n.id == id);
    if (i == -1) return;
    setState(() => _notifications[i] =
        _notifications[i].copyWith(isRead: !_notifications[i].isRead));
  }

  void _delete(String id) =>
      setState(() => _notifications.removeWhere((n) => n.id == id));

  void _markAllRead() =>
      setState(() => _notifications.replaceRange(
            0,
            _notifications.length,
            _notifications.map((n) => n.copyWith(isRead: true)).toList(),
          ));

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final buckets = NotificationBucket.values;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.surface,
      navigationBar: AppNavigationBar(
        title: 'Notifications',
        showAddButton: false,
        trailing: _unreadCount > 0
            ? _UnreadBadge(count: _unreadCount)
            : null,
      ),
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // ── Filter bar + Mark all ────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoSlidingSegmentedControl<bool>(
                        groupValue: _showUnreadOnly,
                        children: const {
                          false: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 7),
                            child: Text('All',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                          ),
                          true: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 7),
                            child: Text('Unread',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                          ),
                        },
                        onValueChanged: (v) {
                          if (v != null) setState(() => _showUnreadOnly = v);
                        },
                      ),
                    ),
                    if (_unreadCount > 0) ...[
                      const SizedBox(width: 10),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _markAllRead,
                        child: const Text(
                          'Mark all read',
                          style: TextStyle(
                            fontSize: 13,
                            color: _C.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ── Empty state ───────────────────────────────────────────────
            if (_filtered.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyView(),
              )
            else
              ...buckets.map((bucket) {
                final items = _forBucket(bucket);
                if (items.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }

                return SliverToBoxAdapter(
                  child: _BucketSection(
                    label: _bucketLabel(bucket),
                    items: items,
                    iconFor: _iconFor,
                    colorFor: _colorFor,
                    onTap: _markRead,
                    onToggleRead: _toggleRead,
                    onDelete: _delete,
                  ),
                );
              }),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _BucketSection extends StatelessWidget {
  const _BucketSection({
    required this.label,
    required this.items,
    required this.iconFor,
    required this.colorFor,
    required this.onTap,
    required this.onToggleRead,
    required this.onDelete,
  });

  final String label;
  final List<AppNotification> items;
  final IconData Function(NotificationType) iconFor;
  final Color Function(NotificationType) colorFor;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onToggleRead;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
          ),
          // Card container
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  _NotificationTile(
                    item: items[i],
                    icon: iconFor(items[i].type),
                    color: items[i].avatarColor ?? colorFor(items[i].type),
                    onTap: () => onTap(items[i].id),
                    onToggleRead: () => onToggleRead(items[i].id),
                    onDelete: () => onDelete(items[i].id),
                  ),
                  if (i < items.length - 1)
                    Container(
                      height: 0.5,
                      margin: const EdgeInsets.only(left: 70),
                      color: CupertinoColors.separator.resolveFrom(context),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.item,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.onToggleRead,
    required this.onDelete,
  });

  final AppNotification item;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onToggleRead;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return Dismissible(
      key: ValueKey(item.id),
      background: _SwipeBg(
        alignment: Alignment.centerLeft,
        color: _C.blue,
        icon: item.isRead ? CupertinoIcons.mail : CupertinoIcons.checkmark_circle_fill,
        label: item.isRead ? 'Unread' : 'Read',
        isLeading: true,
      ),
      secondaryBackground: const _SwipeBg(
        alignment: Alignment.centerRight,
        color: _C.red,
        icon: CupertinoIcons.delete_solid,
        label: 'Delete',
        isLeading: false,
      ),
      confirmDismiss: (dir) async {
        if (dir == DismissDirection.startToEnd) {
          onToggleRead();
          return false;
        }
        onDelete();
        return true;
      },
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          color: item.isRead
              ? (isDark ? const Color(0xFF1C1C1E) : CupertinoColors.white)
              : _C.blue.withValues(alpha: isDark ? 0.12 : 0.05),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              _Avatar(
                initials: item.avatarInitials,
                color: color,
                icon: icon,
                isRead: item.isRead,
              ),
              const SizedBox(width: 12),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: item.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: CupertinoColors.label.resolveFrom(context),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Time + unread dot row
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.timeAgo,
                              style: TextStyle(
                                fontSize: 12,
                                color: CupertinoColors.tertiaryLabel
                                    .resolveFrom(context),
                              ),
                            ),
                            if (!item.isRead) ...[
                              const SizedBox(width: 5),
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: _C.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.4,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Avatar
// ─────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.initials,
    required this.color,
    required this.icon,
    required this.isRead,
  });

  final String? initials;
  final Color color;
  final IconData icon;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(13),
        border: isRead
            ? null
            : Border.all(color: color.withValues(alpha: 0.35), width: 1.5),
      ),
      alignment: Alignment.center,
      child: initials != null && initials!.trim().isNotEmpty
          ? Text(
              initials!,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            )
          : Icon(icon, color: color, size: 20),
    );
  }
}

// ─────────────────────────────────────────────
//  Swipe action background
// ─────────────────────────────────────────────
class _SwipeBg extends StatelessWidget {
  const _SwipeBg({
    required this.alignment,
    required this.color,
    required this.icon,
    required this.label,
    required this.isLeading,
  });

  final Alignment alignment;
  final Color color;
  final IconData icon;
  final String label;
  final bool isLeading;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      color: color,
      padding: EdgeInsets.only(
        left: isLeading ? 20 : 0,
        right: isLeading ? 0 : 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: CupertinoColors.white, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 22),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF007AFF), Color(0xFF5856D6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: CupertinoColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: CupertinoColors.activeBlue.resolveFrom(context),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                CupertinoIcons.bell_slash_fill,
                size: 34,
                color: CupertinoColors.white,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Campaign updates and payment\nalerts will show up here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }
}