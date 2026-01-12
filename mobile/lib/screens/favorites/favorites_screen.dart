import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/theme.dart';
import '../../utils/app_strings.dart';
import '../../providers/booking_provider.dart';
import '../../models/pandit.dart';
import '../booking/booking_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Pandit> _favoritePandits = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _loading = true);
    // TODO: Load from backend or local storage
    final bp = Provider.of<BookingProvider>(context, listen: false);
    final allPandits = await bp.fetchPandits();
    
    // For now, show top rated pandits as favorites
    setState(() {
      _favoritePandits = allPandits.take(5).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryYellow,
        foregroundColor: AppTheme.black,
        title: Text(
          AppStrings.getString(context, 'favorites', fallback: 'Favorite Astrologers'),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow))
          : _favoritePandits.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 64, color: AppTheme.mediumGray),
                      SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(fontSize: 18, color: AppTheme.mediumGray),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add astrologers to your favorites for quick access',
                        style: TextStyle(fontSize: 14, color: AppTheme.mediumGray),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _favoritePandits.length,
                  itemBuilder: (context, index) {
                    final pandit = _favoritePandits[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryYellow.withOpacity(0.3),
                          child: Text(
                            pandit.username[0].toUpperCase(),
                            style: TextStyle(
                              color: AppTheme.primaryYellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(pandit.username),
                        subtitle: Text(pandit.expertise),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            SizedBox(width: 4),
                            Text('${pandit.rating}'),
                            SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.favorite, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _favoritePandits.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookingScreen(pandit: pandit),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

