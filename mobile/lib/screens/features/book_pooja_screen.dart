import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class BookPoojaScreen extends StatefulWidget {
  const BookPoojaScreen({super.key});

  @override
  State<BookPoojaScreen> createState() => _BookPoojaScreenState();
}

class _BookPoojaScreenState extends State<BookPoojaScreen> {
  final List<Map<String, dynamic>> poojas = [
    {
      'name': 'Ganesh Pooja',
      'description': 'For removing obstacles and new beginnings',
      'duration': '1-2 hours',
      'price': '₹2,100',
      'image': '🪔',
    },
    {
      'name': 'Lakshmi Pooja',
      'description': 'For wealth and prosperity',
      'duration': '2-3 hours',
      'price': '₹3,100',
      'image': '🪷',
    },
    {
      'name': 'Satyanarayan Pooja',
      'description': 'For peace and harmony in family',
      'duration': '3-4 hours',
      'price': '₹5,100',
      'image': '🕉️',
    },
    {
      'name': 'Griha Pravesh',
      'description': 'Housewarming ceremony',
      'duration': '2-3 hours',
      'price': '₹7,100',
      'image': '🏠',
    },
    {
      'name': 'Navgraha Pooja',
      'description': 'For planetary peace',
      'duration': '3-4 hours',
      'price': '₹9,100',
      'image': '⭐',
    },
    {
      'name': 'Rudrabhishek',
      'description': 'Shiva worship for health and prosperity',
      'duration': '2-3 hours',
      'price': '₹4,100',
      'image': '🔱',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Pooja'),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryYellow.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // New Banner
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryYellow, Colors.orange.shade700],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Book pandits for authentic pooja ceremonies at your home!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Pooja List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: poojas.length,
                itemBuilder: (context, index) {
                  final pooja = poojas[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () => _showPoojaDetails(pooja),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Icon
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryYellow.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  pooja['image'],
                                  style: const TextStyle(fontSize: 32),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            
                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pooja['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    pooja['description'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        pooja['duration'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        pooja['price'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryYellow,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            // Arrow
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPoojaDetails(Map<String, dynamic> pooja) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        pooja['image'],
                        style: const TextStyle(fontSize: 64),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Text(
                      pooja['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    Text(
                      pooja['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    _buildDetailRow(Icons.access_time, 'Duration', pooja['duration']),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.currency_rupee, 'Price', pooja['price']),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.people, 'Pandits', '1-2 experienced pandits'),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.home, 'Location', 'At your home'),
                    
                    const SizedBox(height: 32),
                    
                    const Text(
                      'What\'s Included:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildIncludedItem('✓ Experienced Pandit(s)'),
                    _buildIncludedItem('✓ All pooja materials (samagri)'),
                    _buildIncludedItem('✓ Setup and cleanup'),
                    _buildIncludedItem('✓ Prasad preparation'),
                    _buildIncludedItem('✓ Recorded video of ceremony'),
                  ],
                ),
              ),
            ),
            
            // Book Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showBookingForm(pooja);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryYellow,
                      foregroundColor: AppTheme.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Book Now - ${pooja['price']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryYellow),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.black,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIncludedItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  void _showBookingForm(Map<String, dynamic> pooja) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Book ${pooja['name']}'),
        content: const Text('Booking form will be implemented here with date, time, and address selection.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking confirmed! Our team will contact you shortly.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryYellow,
              foregroundColor: AppTheme.black,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

