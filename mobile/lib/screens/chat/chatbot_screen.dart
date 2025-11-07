import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../services/kundali_service.dart';

class AIKundaliChatScreen extends StatefulWidget {
  const AIKundaliChatScreen({super.key});
  @override
  State<AIKundaliChatScreen> createState() => _AIKundaliChatScreenState();
}

class _AIKundaliChatScreenState extends State<AIKundaliChatScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();

  bool _popupShown = false;
  bool _isTyping = false;
  int _step = 0;
  String? _name;
  // ignore: unused_field
  String? _place;
  String? _datetime;

  late AnimationController _dotsController;

  @override
  void initState() {
    super.initState();
    _dotsController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();

    Future.delayed(const Duration(milliseconds: 300), () {
      _showPopupIfNeeded();
      _askNextQuestion();
    });
  }

  @override
  void dispose() {
    _dotsController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _showPopupIfNeeded() {
    if (!_popupShown) {
      _popupShown = true;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "✨ Free for New Users!",
            style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
          ),
          content: const Text("After one free use, charges will be applicable."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Got it")),
          ],
        ),
      );
    }
  }

  void _askNextQuestion() async {
    setState(() => _isTyping = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isTyping = false);

    String question;
    if (_step == 0) {
      question = "What is your name?";
    } else if (_step == 1) {
      question = "Where were you born (place of birth)?";
    } else {
      question = "Date & time of birth? (e.g. 12-Aug-1990 10:30 AM)";
    }

    setState(() {
      _messages.add({"isUser": false, "text": question});
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"isUser": true, "text": text});
      _controller.clear();
    });

    if (_step == 0) {
      _name = text;
      _step++;
      Future.delayed(const Duration(milliseconds: 600), _askNextQuestion);
    } else if (_step == 1) {
      _place = text;
      _step++;
      Future.delayed(const Duration(milliseconds: 600), _askNextQuestion);
    } else {
      _datetime = text;
      Future.delayed(const Duration(milliseconds: 800), _generateKundali);
    }
  }

  Future<void> _generateKundali() async {
    setState(() {
      _isTyping = true;
      _messages.add({"isUser": false, "text": "Generating your Kundali… 🕉️ Please wait."});
    });

    try {
      // For simplicity, determine zodiac sign based on month/day from _datetime
      String sign = _getZodiacSignFromDate(_datetime ?? "");

      final kundaliData = await KundaliService.getKundali(sign);

      setState(() => _isTyping = false);

      if (kundaliData != null) {
        final desc = kundaliData["description"] ?? "Unable to fetch details right now.";

        setState(() {
          _messages.add({"isUser": false, "text": "Here is your Kundali result, $_name 🧘‍♀️:"});
          _messages.add({"isUser": false, "text": desc});
        });
      } else {
        setState(() {
          _messages.add({"isUser": false, "text": "Failed to generate Kundali. Please try again later 🙏."});
        });
      }
    } catch (e) {
      setState(() {
        _isTyping = false;
        _messages.add({"isUser": false, "text": "Error generating Kundali: $e"});
      });
    }
  }

  String _getZodiacSignFromDate(String dateString) {
    try {
      // Try to parse date from the string
      final RegExp dateRegex = RegExp(r'(\d{1,2})[-/ ]([A-Za-z]+)');
      final match = dateRegex.firstMatch(dateString);
      if (match == null) return "aries";

      int day = int.tryParse(match.group(1) ?? "1") ?? 1;
      String month = match.group(2)!.toLowerCase();

      const months = [
        "january",
        "february",
        "march",
        "april",
        "may",
        "june",
        "july",
        "august",
        "september",
        "october",
        "november",
        "december"
      ];
      int monthNum = months.indexOf(month) + 1;

      // Determine zodiac based on date range
      if ((monthNum == 3 && day >= 21) || (monthNum == 4 && day <= 19)) return "aries";
      if ((monthNum == 4 && day >= 20) || (monthNum == 5 && day <= 20)) return "taurus";
      if ((monthNum == 5 && day >= 21) || (monthNum == 6 && day <= 20)) return "gemini";
      if ((monthNum == 6 && day >= 21) || (monthNum == 7 && day <= 22)) return "cancer";
      if ((monthNum == 7 && day >= 23) || (monthNum == 8 && day <= 22)) return "leo";
      if ((monthNum == 8 && day >= 23) || (monthNum == 9 && day <= 22)) return "virgo";
      if ((monthNum == 9 && day >= 23) || (monthNum == 10 && day <= 22)) return "libra";
      if ((monthNum == 10 && day >= 23) || (monthNum == 11 && day <= 21)) return "scorpio";
      if ((monthNum == 11 && day >= 22) || (monthNum == 12 && day <= 21)) return "sagittarius";
      if ((monthNum == 12 && day >= 22) || (monthNum == 1 && day <= 19)) return "capricorn";
      if ((monthNum == 1 && day >= 20) || (monthNum == 2 && day <= 18)) return "aquarius";
      if ((monthNum == 2 && day >= 19) || (monthNum == 3 && day <= 20)) return "pisces";

      return "aries";
    } catch (_) {
      return "aries";
    }
  }

  Widget _typingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) => AnimatedBuilder(
          animation: _dotsController,
          builder: (_, __) {
            final value = (_dotsController.value * 3).floor();
            return Opacity(
              opacity: value == index ? 1.0 : 0.3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.saffron,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const saffron = AppTheme.saffron;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: saffron,
        title: const Text("AI Kundali Chat"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (_isTyping && i == _messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                        ],
                      ),
                      child: _typingIndicator(),
                    ),
                  );
                }

                final msg = _messages[i];
                final isUser = msg["isUser"] as bool;
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: isUser ? saffron.withOpacity(0.3) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                      ],
                    ),
                    child: Text(msg["text"], style: const TextStyle(color: Colors.black87)),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: saffron))),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type your answer…",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: saffron),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
