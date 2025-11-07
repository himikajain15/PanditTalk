import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/pandit.dart';
import '../../widgets/pandit_card.dart';
import '../booking/booking_screen.dart';
import '../../utils/theme.dart';

class PanditListScreen extends StatefulWidget {
  @override
  _PanditListScreenState createState() => _PanditListScreenState();
}

class _PanditListScreenState extends State<PanditListScreen> {
  List<Pandit> _list = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPandits();
  }

  Future<void> _loadPandits() async {
    final bp = Provider.of<BookingProvider>(context, listen: false);
    final list = await bp.fetchPandits();
    setState(() {
      _list = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Pandits"),
        backgroundColor: AppTheme.gold,
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            tooltip: "Sync from Google Sheets",
            onPressed: () async {
              setState(() => _loading = true);
              final bp = Provider.of<BookingProvider>(context, listen: false);
              final syncResult = await bp.syncPanditsFromSheets();
              await _loadPandits(); // Reload after sync
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(syncResult['error'] ?? 
                      "Synced ${syncResult['synced'] ?? 0} pandits, Updated ${syncResult['updated'] ?? 0}"),
                    backgroundColor: syncResult['error'] != null ? Colors.red : Colors.green,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: AppTheme.gold))
          : RefreshIndicator(
              onRefresh: _loadPandits,
              child: _list.isEmpty
                  ? ListView(
                      children: [SizedBox(height: 120), Center(child: Text("No pandits found."))],
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(12),
                      itemCount: _list.length,
                      itemBuilder: (ctx, i) {
                        final p = _list[i];
                        return PanditCard(
                          pandit: p,
                          onBook: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(pandit: p)));
                          },
                        );
                      },
                    ),
            ),
    );
  }
}
