import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/models/notification_model.dart';
import 'package:robosoc/utilities/notification_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, _) {
          final notifications = notificationProvider.notifications;

          if (notifications.isEmpty) {
            return const Center(
              child: Text('No notifications'),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationTile(notification: notification);
            },
          );
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const NotificationTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        _getNotificationIcon(notification.type),
        color: notification.isRead ? Colors.grey : Colors.blue,
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Text(notification.message),
      trailing: Text(
        _formatDate(notification.createdAt),
        style: const TextStyle(fontSize: 12),
      ),
      onTap: () {
        if (!notification.isRead) {
          Provider.of<NotificationProvider>(context, listen: false)
              .markAsRead(notification.id);
        }
      },
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'issue_request':
        return Icons.add_circle_outline;
      case 'return_request':
        return Icons.remove_circle_outline;
      case 'approval':
        return Icons.check_circle_outline;
      default:
        return Icons.notifications;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}