import 'package:flutter/material.dart';
import '../utils/theme.dart';

class CountryCodePicker extends StatefulWidget {
  final String? initialCountryCode;
  final Function(String) onCountrySelected;

  const CountryCodePicker({
    Key? key,
    this.initialCountryCode,
    required this.onCountrySelected,
  }) : super(key: key);

  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  String _selectedCode = '+91';
  
  final List<Map<String, String>> countries = [
    {'code': '+91', 'name': 'India', 'flag': '🇮🇳'},
    {'code': '+1', 'name': 'USA', 'flag': '🇺🇸'},
    {'code': '+44', 'name': 'UK', 'flag': '🇬🇧'},
    {'code': '+971', 'name': 'UAE', 'flag': '🇦🇪'},
    {'code': '+966', 'name': 'Saudi Arabia', 'flag': '🇸🇦'},
    {'code': '+65', 'name': 'Singapore', 'flag': '🇸🇬'},
    {'code': '+60', 'name': 'Malaysia', 'flag': '🇲🇾'},
    {'code': '+61', 'name': 'Australia', 'flag': '🇦🇺'},
    {'code': '+86', 'name': 'China', 'flag': '🇨🇳'},
    {'code': '+81', 'name': 'Japan', 'flag': '🇯🇵'},
    {'code': '+82', 'name': 'South Korea', 'flag': '🇰🇷'},
    {'code': '+33', 'name': 'France', 'flag': '🇫🇷'},
    {'code': '+49', 'name': 'Germany', 'flag': '🇩🇪'},
    {'code': '+39', 'name': 'Italy', 'flag': '🇮🇹'},
    {'code': '+34', 'name': 'Spain', 'flag': '🇪🇸'},
    {'code': '+7', 'name': 'Russia', 'flag': '🇷🇺'},
    {'code': '+27', 'name': 'South Africa', 'flag': '🇿🇦'},
    {'code': '+55', 'name': 'Brazil', 'flag': '🇧🇷'},
    {'code': '+52', 'name': 'Mexico', 'flag': '🇲🇽'},
    {'code': '+92', 'name': 'Pakistan', 'flag': '🇵🇰'},
    {'code': '+880', 'name': 'Bangladesh', 'flag': '🇧🇩'},
    {'code': '+94', 'name': 'Sri Lanka', 'flag': '🇱🇰'},
    {'code': '+977', 'name': 'Nepal', 'flag': '🇳🇵'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedCode = widget.initialCountryCode ?? '+91';
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Select Country',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  final country = countries[index];
                  final isSelected = country['code'] == _selectedCode;
                  return ListTile(
                    leading: Text(country['flag']!, style: TextStyle(fontSize: 24)),
                    title: Text(country['name']!),
                    trailing: Text(
                      country['code']!,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppTheme.primaryYellow : AppTheme.mediumGray,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: AppTheme.primaryYellow.withOpacity(0.1),
                    onTap: () {
                      setState(() {
                        _selectedCode = country['code']!;
                      });
                      widget.onCountrySelected(_selectedCode);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCountry = countries.firstWhere(
      (c) => c['code'] == _selectedCode,
      orElse: () => countries[0],
    );

    return InkWell(
      onTap: _showCountryPicker,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primaryYellow.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selectedCountry['flag']!, style: TextStyle(fontSize: 20)),
            SizedBox(width: 6),
            Text(
              selectedCountry['code']!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.black,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 18, color: AppTheme.black),
          ],
        ),
      ),
    );
  }
}

