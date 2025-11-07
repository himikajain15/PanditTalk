import 'package:flutter/material.dart';
import '../models/pandit.dart';

class PanditCard extends StatelessWidget {
  final Pandit pandit;
  final VoidCallback onBook;

  PanditCard({required this.pandit, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical:6),
      child: ListTile(
        leading: CircleAvatar(child: Text(pandit.username.isNotEmpty ? pandit.username[0].toUpperCase() : "P")),
        title: Text(pandit.username),
        subtitle: Text("${pandit.expertise}\n₹${pandit.feePerMinute}/min • ${pandit.experienceYears} yrs"),
        isThreeLine: true,
        trailing: ElevatedButton(onPressed: onBook, child: Text("Book")),
      ),
    );
  }
}
