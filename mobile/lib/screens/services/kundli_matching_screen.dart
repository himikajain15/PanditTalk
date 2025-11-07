import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class KundliMatchingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kundli Matching'),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.favorite, size: 80, color: Colors.pink),
            SizedBox(height: 20),
            Text(
              'Marriage Compatibility',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Match kundlis to check compatibility',
              style: TextStyle(fontSize: 14, color: AppTheme.mediumGray),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            
            // Partner 1 Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Partner 1 Details', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    TextField(decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
                    SizedBox(height: 12),
                    TextField(decoration: InputDecoration(labelText: 'Date of Birth', border: OutlineInputBorder())),
                    SizedBox(height: 12),
                    TextField(decoration: InputDecoration(labelText: 'Time of Birth', border: OutlineInputBorder())),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Partner 2 Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Partner 2 Details', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    TextField(decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
                    SizedBox(height: 12),
                    TextField(decoration: InputDecoration(labelText: 'Date of Birth', border: OutlineInputBorder())),
                    SizedBox(height: 12),
                    TextField(decoration: InputDecoration(labelText: 'Time of Birth', border: OutlineInputBorder())),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Check Compatibility', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

