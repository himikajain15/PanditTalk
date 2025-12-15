import 'package:flutter/material.dart';
import '../../models/pandit.dart';
import '../../services/consultation_service.dart';
import 'pandit_detail_screen.dart';

class PanditsListScreen extends StatefulWidget {
  const PanditsListScreen({super.key});

  @override
  State<PanditsListScreen> createState() => _PanditsListScreenState();
}

class _PanditsListScreenState extends State<PanditsListScreen> {
  bool _isLoading = true;
  List<Pandit> _pandits = [];
  String _filter = 'available';

  @override
  void initState() {
    super.initState();
    _loadPandits();
  }

  Future<void> _loadPandits() async {
    setState(() => _isLoading = true);

    final pandits = await ConsultationService.getAvailablePandits(
      availability: _filter == 'all' ? null : _filter,
    );

    setState(() {
      _pandits = pandits;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Pandit'),
        backgroundColor: const Color(0xFFFFC107),
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Available Now', 'available'),
                  const SizedBox(width: 8),
                  _buildFilterChip('All Pandits', 'all'),
                ],
              ),
            ),
          ),

          // Pandits List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _pandits.isEmpty
                    ? const Center(
                        child: Text('No pandits available'),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadPandits,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _pandits.length,
                          itemBuilder: (context, index) {
                            final pandit = _pandits[index];
                            return _buildPanditCard(pandit);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _filter = value);
        _loadPandits();
      },
      selectedColor: const Color(0xFFFFC107),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildPanditCard(Pandit pandit) {
    final profile = pandit.profile;
    if (profile == null) return const SizedBox();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PanditDetailScreen(pandit: pandit),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Profile Picture
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: const Color(0xFFFFC107),
                        child: pandit.profilePic != null
                            ? ClipOval(
                                child: Image.network(
                                  pandit.profilePic!,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.person, size: 35),
                                ),
                              )
                            : const Icon(Icons.person,
                                size: 35, color: Colors.white),
                      ),
                      if (profile.isAvailable)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                pandit.username,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (profile.isVerified)
                              const Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 20,
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 16, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              '${profile.averageRating.toStringAsFixed(1)} (${profile.totalReviews} reviews)',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${profile.experienceYears} years experience',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),

              // Specializations
              if (profile.specializations.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: profile.specializations.take(3).map((spec) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC107).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        spec,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],

              // Pricing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPriceTag('Chat', profile.chatRate, Icons.chat),
                  _buildPriceTag('Call', profile.callRate, Icons.call),
                  _buildPriceTag('Video', profile.videoRate, Icons.videocam),
                ],
              ),

              const SizedBox(height: 12),

              // Book Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: profile.isAvailable
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PanditDetailScreen(pandit: pandit),
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(profile.isAvailable
                      ? 'Book Consultation'
                      : 'Currently Offline'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceTag(String service, double rate, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          service,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
        Text(
          '₹${rate.toInt()}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

