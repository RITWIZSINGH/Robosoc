import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/models/notification_model.dart';
import 'package:robosoc/utilities/notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      await Provider.of<NotificationProvider>(context, listen: false)
          .loadNotifications();
    } catch (e) {
      setState(() {
        _error = 'Failed to load notifications: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadNotifications,
        child: Consumer<NotificationProvider>(
          builder: (context, provider, _) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (_error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadNotifications,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Show indexing progress banner if needed
            if (provider.indexingInProgress) {
              return Stack(
                children: [
                  if (provider.notifications.isNotEmpty)
                    _buildNotificationsList(provider.notifications),
                  SafeArea(
                    child: Material(
                      child: Container(
                        color: Colors.yellow[100],
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          'Setting up notifications... This may take a few minutes. '
                          'Some notifications might appear out of order temporarily.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            if (provider.notifications.isEmpty) {
              return Stack(
                children: [
                  const Center(
                    child: Text('No notifications'),
                  ),
                  ListView(), // Required for RefreshIndicator to work with empty content
                ],
              );
            }

            return _buildNotificationsList(provider.notifications);
          },
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationModel> notifications) {
    return ListView.separated(
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationTile(
          key: ValueKey(notification.id),
          notification: notification,
        );
      },
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
    return Container(
      color: notification.isRead ? null : Colors.blue.withOpacity(0.1),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(
          _getNotificationIcon(notification.type),
          color: notification.isRead ? Colors.grey : Colors.blue,
          size: 28,
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(notification.createdAt),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        onTap: () {
          if (!notification.isRead) {
            Provider.of<NotificationProvider>(context, listen: false)
                .markAsRead(notification.id);
          }
        },
      ),
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
        final minutes = difference.inMinutes;
        return minutes <= 0 ? 'Just now' : '$minutes min ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}