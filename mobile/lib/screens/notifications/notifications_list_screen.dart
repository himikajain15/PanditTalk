import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/theme.dart';

class NotificationsListScreen extends StatefulWidget {
  @override
  State<NotificationsListScreen> createState() => _NotificationsListScreenState();
}

class _NotificationsListScreenState extends State<NotificationsListScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: "Booking Confirmed",
      message: "Your booking with Pandit Sharma has been confirmed for tomorrow at 10:00 AM",
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
      type: NotificationType.booking,
      isRead: false,
    ),
    NotificationItem(
      title: "New Message",
      message: "Pandit Kumar sent you a message",
      timestamp: DateTime.now().subtract(Duration(hours: 5)),
      type: NotificationType.message,
      isRead: false,
    ),
    NotificationItem(
      title: "Daily Horoscope Ready",
      message: "Your daily horoscope prediction is now available",
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      type: NotificationType.horoscope,
      isRead: true,
    ),
    NotificationItem(
      title: "Wallet Recharged",
      message: "₹500 has been added to your wallet successfully",
      timestamp: DateTime.now().subtract(Duration(days: 2)),
      type: NotificationType.wallet,
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: AppTheme.primaryYellow,
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  for (var notification in _notifications) {
                    notification.isRead = true;
                  }
                });
              },
              child: Text(
                "Mark all read",
                style: TextStyle(color: AppTheme.black),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 64, color: AppTheme.mediumGray),
                  const SizedBox(height: 16),
                  Text(
                    "No notifications yet",
                    style: TextStyle(fontSize: 18, color: AppTheme.mediumGray),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => Divider(height: 1),
              itemBuilder: (ctx, i) {
                final notification = _notifications[i];
                return _buildNotificationTile(notification);
              },
            ),
    );
  }

  Widget _buildNotificationTile(NotificationItem notification) {
    IconData icon;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.booking:
        icon = Icons.event_available;
        iconColor = Colors.green;
        break;
      case NotificationType.message:
        icon = Icons.message;
        iconColor = Colors.blue;
        break;
      case NotificationType.horoscope:
        icon = Icons.wb_sunny;
        iconColor = AppTheme.primaryYellow;
        break;
      case NotificationType.wallet:
        icon = Icons.account_balance_wallet;
        iconColor = Colors.purple;
        break;
      default:
        icon = Icons.notifications;
        iconColor = AppTheme.mediumGray;
    }

    final timeAgo = _formatTimeAgo(notification.timestamp);

    return Container(
      color: notification.isRead ? AppTheme.white : AppTheme.lightYellow.withOpacity(0.3),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: AppTheme.darkGray),
            ),
            const SizedBox(height: 4),
            Text(
              timeAgo,
              style: TextStyle(fontSize: 12, color: AppTheme.mediumGray),
            ),
          ],
        ),
        trailing: !notification.isRead
            ? Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppTheme.primaryYellow,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          setState(() {
            notification.isRead = true;
          });
        },
      ),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    } else {
      return DateFormat('MMM dd, yyyy').format(timestamp);
    }
  }
}

class NotificationItem {
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType {
  booking,
  message,
  horoscope,
  wallet,
  other,
}

