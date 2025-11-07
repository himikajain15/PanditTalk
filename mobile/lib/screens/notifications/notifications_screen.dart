import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/notification.dart';
import '../../utils/theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification> _notes = [];
  bool _loading = true;
  final ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);

    final res = await api.get('/api/notifications/list/');
    if (res is List) {
      setState(() {
        _notes = res.map((e) => AppNotification.fromJson(e)).toList();
        _loading = false;
      });
    } else {
      // Fallback dummy data
      setState(() {
        _notes = [
          AppNotification(
            id: 1,
            title: "Welcome to Pandittalk",
            body: "Check today's horoscope and consult a pandit!",
            read: false,
          ),
        ];
        _loading = false;
      });
    }
  }

  Widget _tile(AppNotification n) {
    return ListTile(
      leading: const Icon(Icons.notifications, color: AppTheme.saffron),
      title: Text(n.title),
      subtitle: Text(n.body),
      trailing: n.read
          ? null
          : const Icon(Icons.fiber_new, color: Colors.redAccent),
      onTap: () {
        // mark as read (local UI only)
        setState(() {
          // Changed from final -> mutable in model
          n.read = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: AppTheme.saffron,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.saffron),
            )
          : RefreshIndicator(
              onRefresh: _fetch,
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (ctx, i) => _tile(_notes[i]),
              ),
            ),
    );
  }
}
