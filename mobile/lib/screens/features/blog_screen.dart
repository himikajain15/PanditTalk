import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blogs = [
      {
        'title': 'Understanding Your Birth Chart',
        'excerpt': 'Learn how to read and interpret your Vedic birth chart...',
        'author': 'Pandit Sharma',
        'date': '10 Nov 2025',
        'readTime': '5 min read',
        'image': '📊',
      },
      {
        'title': 'Powerful Mantras for Success',
        'excerpt': 'Discover ancient mantras that bring prosperity...',
        'author': 'Pandit Kumar',
        'date': '8 Nov 2025',
        'readTime': '4 min read',
        'image': '🕉️',
      },
      {
        'title': 'Gemstones and Their Benefits',
        'excerpt': 'Explore the healing properties of different gemstones...',
        'author': 'Pandit Verma',
        'date': '5 Nov 2025',
        'readTime': '6 min read',
        'image': '💎',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Astrology Blog'),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          final blog = blogs[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: Text(blog['image'] as String, style: const TextStyle(fontSize: 40)),
              title: Text(blog['title'] as String),
              subtitle: Text('${blog['author']} • ${blog['readTime']}'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reading: ${blog['title']}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

