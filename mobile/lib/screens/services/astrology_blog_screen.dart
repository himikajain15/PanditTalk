import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class AstrologyBlogScreen extends StatelessWidget {
  final List<Map<String, dynamic>> blogs = [
    {
      'title': 'Mercury Retrograde: What It Means for You',
      'date': 'Nov 5, 2025',
      'image': '☿️',
      'excerpt': 'Understand how Mercury retrograde affects your daily life and communication...',
    },
    {
      'title': 'The Power of Gemstones in Astrology',
      'date': 'Nov 3, 2025',
      'image': '💎',
      'excerpt': 'Discover which gemstones align with your zodiac sign and bring positive energy...',
    },
    {
      'title': 'Understanding Your Birth Chart',
      'date': 'Nov 1, 2025',
      'image': '⭐',
      'excerpt': 'Learn to read and interpret your natal chart for better self-understanding...',
    },
    {
      'title': 'Lunar Eclipse Effects on Zodiac Signs',
      'date': 'Oct 28, 2025',
      'image': '🌙',
      'excerpt': 'How the upcoming lunar eclipse will impact each zodiac sign differently...',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Astrology Blog'),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: blogs.length,
        itemBuilder: (ctx, i) {
          final blog = blogs[i];
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.lightYellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(blog['image'], style: TextStyle(fontSize: 40)),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            blog['title'],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            blog['excerpt'],
                            style: TextStyle(fontSize: 13, color: AppTheme.mediumGray),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            blog['date'],
                            style: TextStyle(fontSize: 12, color: AppTheme.mediumGray),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

