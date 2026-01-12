import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math';
import '../../utils/theme.dart';
import '../../utils/app_strings.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';

class TarotCardScreen extends StatefulWidget {
  const TarotCardScreen({Key? key}) : super(key: key);

  @override
  State<TarotCardScreen> createState() => _TarotCardScreenState();
}

class _TarotCardScreenState extends State<TarotCardScreen> {
  String? _selectedSpread = 'single';
  List<TarotCard> _drawnCards = [];
  bool _isDrawing = false;
  bool _showInterpretation = false;
  String? _interpretation;
  String? _error;

  // Standard 78-card Tarot deck
  final List<TarotCard> _tarotDeck = _createTarotDeck();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.getString(context, 'tarotReading', fallback: 'Tarot Card Reading'),
        ),
        backgroundColor: AppTheme.primaryYellow,
        foregroundColor: AppTheme.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryYellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.primaryYellow),
                      SizedBox(width: 8),
                      Text(
                        AppStrings.getString(
                          context,
                          'tarotInstructions',
                          fallback: 'How to use:',
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    AppStrings.getString(
                      context,
                      'tarotInstructionsText',
                      fallback:
                          '1. Focus on your question or concern\n2. Choose a spread type\n3. Tap "Draw Cards" to reveal your reading\n4. Get AI-powered interpretation',
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Spread Selection
            Text(
              AppStrings.getString(context, 'selectSpread', fallback: 'Select Spread Type'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _buildSpreadSelector(),
            SizedBox(height: 24),

            // Draw Cards Button
            if (_drawnCards.isEmpty)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isDrawing ? null : _drawCards,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryYellow,
                    foregroundColor: AppTheme.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isDrawing
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.black),
                          ),
                        )
                      : Text(
                          AppStrings.getString(
                            context,
                            'drawCards',
                            fallback: 'Draw Cards',
                          ),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

            // Drawn Cards Display
            if (_drawnCards.isNotEmpty) ...[
              SizedBox(height: 24),
              Text(
                AppStrings.getString(context, 'yourCards', fallback: 'Your Cards'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              _buildCardsDisplay(),
              SizedBox(height: 24),

              // Get Interpretation Button
              if (!_showInterpretation)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isDrawing ? null : _getInterpretation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isDrawing
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            AppStrings.getString(
                              context,
                              'getInterpretation',
                              fallback: 'Get AI Interpretation',
                            ),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),

              // Interpretation Result
              if (_showInterpretation && _interpretation != null) ...[
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2C1A4D), Color(0xFF4A2B6F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.getString(
                              context,
                              'interpretation',
                              fallback: 'Interpretation',
                            ),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.share, color: Colors.white),
                            onPressed: _shareReading,
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        _interpretation!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Error Message
              if (_error != null) ...[
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Reset Button
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _resetReading,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryYellow,
                    side: BorderSide(color: AppTheme.primaryYellow),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppStrings.getString(context, 'newReading', fallback: 'New Reading'),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSpreadSelector() {
    final spreads = [
      {
        'key': 'single',
        'name': AppStrings.getString(context, 'singleCard', fallback: 'Single Card'),
        'description': AppStrings.getString(
          context,
          'singleCardDesc',
          fallback: 'Quick insight for today',
        ),
        'icon': Icons.style,
      },
      {
        'key': 'three',
        'name': AppStrings.getString(context, 'threeCard', fallback: 'Three Card'),
        'description': AppStrings.getString(
          context,
          'threeCardDesc',
          fallback: 'Past, Present, Future',
        ),
        'icon': Icons.view_agenda,
      },
      {
        'key': 'celtic',
        'name': AppStrings.getString(context, 'celticCross', fallback: 'Celtic Cross'),
        'description': AppStrings.getString(
          context,
          'celticCrossDesc',
          fallback: 'Comprehensive 10-card reading',
        ),
        'icon': Icons.grid_view,
      },
    ];

    return Column(
      children: spreads.map((spread) {
        final isSelected = _selectedSpread == spread['key'];
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedSpread = spread['key'] as String;
                _drawnCards.clear();
                _showInterpretation = false;
                _interpretation = null;
                _error = null;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryYellow.withOpacity(0.2)
                    : AppTheme.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppTheme.primaryYellow : AppTheme.lightGray,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryYellow
                          : AppTheme.lightGray,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      spread['icon'] as IconData,
                      color: isSelected ? AppTheme.black : AppTheme.mediumGray,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          spread['name'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          spread['description'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: AppTheme.primaryYellow),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCardsDisplay() {
    if (_selectedSpread == 'single') {
      return _buildSingleCard(_drawnCards[0]);
    } else if (_selectedSpread == 'three') {
      return _buildThreeCardSpread();
    } else {
      return _buildCelticCrossSpread();
    }
  }

  Widget _buildSingleCard(TarotCard card) {
    return Center(
      child: Container(
        width: 200,
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: _buildCardWidget(card, 0),
      ),
    );
  }

  Widget _buildThreeCardSpread() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                AppStrings.getString(context, 'past', fallback: 'Past'),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                height: 200,
                child: _buildCardWidget(_drawnCards[0], 0),
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            children: [
              Text(
                AppStrings.getString(context, 'present', fallback: 'Present'),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                height: 200,
                child: _buildCardWidget(_drawnCards[1], 1),
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            children: [
              Text(
                AppStrings.getString(context, 'future', fallback: 'Future'),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                height: 200,
                child: _buildCardWidget(_drawnCards[2], 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCelticCrossSpread() {
    // Simplified Celtic Cross - show first 6 cards in a grid
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.6,
      ),
      itemCount: _drawnCards.length > 6 ? 6 : _drawnCards.length,
      itemBuilder: (context, index) {
        return _buildCardWidget(_drawnCards[index], index);
      },
    );
  }

  Widget _buildCardWidget(TarotCard card, int index) {
    final isReversed = card.isReversed;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isReversed
              ? [Colors.grey.shade800, Colors.grey.shade900]
              : [Color(0xFF2C1A4D), Color(0xFF4A2B6F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryYellow.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '🃏',
            style: TextStyle(fontSize: 48),
          ),
          SizedBox(height: 8),
          Text(
            card.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isReversed)
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                AppStrings.getString(context, 'reversed', fallback: 'Reversed'),
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _drawCards() {
    setState(() {
      _isDrawing = true;
      _drawnCards.clear();
      _showInterpretation = false;
      _interpretation = null;
      _error = null;
    });

    // Simulate card drawing animation
    Future.delayed(Duration(milliseconds: 500), () {
      if (!mounted) return;

      final random = Random();
      final deck = List<TarotCard>.from(_tarotDeck);
      deck.shuffle(random);

      int cardCount = 1;
      if (_selectedSpread == 'three') {
        cardCount = 3;
      } else if (_selectedSpread == 'celtic') {
        cardCount = 10;
      }

      final drawn = <TarotCard>[];
      for (int i = 0; i < cardCount; i++) {
        final card = deck[i];
        // 30% chance of reversed card
        final isReversed = random.nextDouble() < 0.3;
        drawn.add(TarotCard(
          name: card.name,
          suit: card.suit,
          number: card.number,
          isReversed: isReversed,
          meaning: card.meaning,
          reversedMeaning: card.reversedMeaning,
        ));
      }

      setState(() {
        _drawnCards = drawn;
        _isDrawing = false;
      });
    });
  }

  Future<void> _getInterpretation() async {
    setState(() {
      _isDrawing = true;
      _error = null;
    });

    try {
      final authService = AuthService();
      final token = await authService.getToken();
      final api = ApiService();

      // Prepare cards data for API
      final cardsData = _drawnCards.map((card) {
        return {
          'name': card.name,
          'suit': card.suit,
          'number': card.number,
          'is_reversed': card.isReversed,
          'meaning': card.isReversed ? card.reversedMeaning : card.meaning,
        };
      }).toList();

      String spreadType = 'single';
      if (_selectedSpread == 'three') {
        spreadType = 'three_card';
      } else if (_selectedSpread == 'celtic') {
        spreadType = 'celtic_cross';
      }

      // Call backend API for AI interpretation
      final response = await api.post(
        '/api/core/tarot/interpret/',
        {
          'spread_type': spreadType,
          'cards': cardsData,
        },
        token: token,
        timeout: Duration(seconds: 120),
      );

      if (mounted) {
        setState(() {
          _isDrawing = false;
          if (response is Map && response.containsKey('interpretation')) {
            _interpretation = response['interpretation'];
            _showInterpretation = true;
          } else if (response is Map && response.containsKey('error')) {
            _error = response['error'].toString();
            // Fallback to local interpretation
            _interpretation = _generateLocalInterpretation();
            _showInterpretation = true;
          } else {
            // Fallback to local interpretation
            _interpretation = _generateLocalInterpretation();
            _showInterpretation = true;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDrawing = false;
          // Fallback to local interpretation
          _interpretation = _generateLocalInterpretation();
          _showInterpretation = true;
        });
      }
    }
  }

  String _generateLocalInterpretation() {
    if (_drawnCards.isEmpty) return '';

    String interpretation = '';
    if (_selectedSpread == 'single') {
      final card = _drawnCards[0];
      interpretation = '''
**${card.name}** ${card.isReversed ? '(Reversed)' : ''}

${card.isReversed ? card.reversedMeaning : card.meaning}

This card offers guidance for your current situation. Reflect on its message and how it relates to your question or concern.
''';
    } else if (_selectedSpread == 'three') {
      interpretation = '''
**Past: ${_drawnCards[0].name}** ${_drawnCards[0].isReversed ? '(Reversed)' : ''}
${_drawnCards[0].isReversed ? _drawnCards[0].reversedMeaning : _drawnCards[0].meaning}

**Present: ${_drawnCards[1].name}** ${_drawnCards[1].isReversed ? '(Reversed)' : ''}
${_drawnCards[1].isReversed ? _drawnCards[1].reversedMeaning : _drawnCards[1].meaning}

**Future: ${_drawnCards[2].name}** ${_drawnCards[2].isReversed ? '(Reversed)' : ''}
${_drawnCards[2].isReversed ? _drawnCards[2].reversedMeaning : _drawnCards[2].meaning}

This three-card spread shows your journey from past influences through present circumstances to future possibilities. Consider how these energies connect and guide your path forward.
''';
    } else {
      interpretation = '''
**Celtic Cross Reading**

This comprehensive spread reveals deep insights into your situation. The cards drawn suggest:

${_drawnCards.take(6).map((card) {
        return '• **${card.name}** ${card.isReversed ? '(Reversed)' : ''}: ${card.isReversed ? card.reversedMeaning : card.meaning}';
      }).join('\n\n')}

Reflect on how these cards interact and what guidance they offer for your path ahead.
''';
    }

    return interpretation;
  }

  Future<void> _shareReading() async {
    if (_interpretation == null || _drawnCards.isEmpty) return;

    final cardsList = _drawnCards.map((c) => '${c.name}${c.isReversed ? ' (Reversed)' : ''}').join(', ');
    final shareText = '''
🔮 Tarot Card Reading

Cards: $cardsList

$_interpretation

— Sent from PanditTalk app
''';

    await Share.share(shareText, subject: 'My Tarot Reading');
  }

  void _resetReading() {
    setState(() {
      _drawnCards.clear();
      _showInterpretation = false;
      _interpretation = null;
      _error = null;
    });
  }
}

class TarotCard {
  final String name;
  final String suit;
  final int? number;
  final bool isReversed;
  final String meaning;
  final String reversedMeaning;

  TarotCard({
    required this.name,
    required this.suit,
    this.number,
    this.isReversed = false,
    required this.meaning,
    required this.reversedMeaning,
  });
}

List<TarotCard> _createTarotDeck() {
  final cards = <TarotCard>[];

  // Major Arcana (22 cards)
  final majorArcana = [
    {'name': 'The Fool', 'meaning': 'New beginnings, innocence, spontaneity', 'reversed': 'Recklessness, poor judgment, naivety'},
    {'name': 'The Magician', 'meaning': 'Manifestation, resourcefulness, power', 'reversed': 'Manipulation, untapped talents'},
    {'name': 'The High Priestess', 'meaning': 'Intuition, sacred knowledge, inner voice', 'reversed': 'Secrets, disconnected from intuition'},
    {'name': 'The Empress', 'meaning': 'Femininity, beauty, nature, abundance', 'reversed': 'Creative block, dependence on others'},
    {'name': 'The Emperor', 'meaning': 'Authority, structure, control, fatherhood', 'reversed': 'Tyranny, rigidity, domination'},
    {'name': 'The Hierophant', 'meaning': 'Spiritual wisdom, religious beliefs, conformity', 'reversed': 'Personal beliefs, freedom, challenging the status quo'},
    {'name': 'The Lovers', 'meaning': 'Love, harmony, relationships, values alignment', 'reversed': 'Disharmony, imbalance, misalignment of values'},
    {'name': 'The Chariot', 'meaning': 'Control, willpower, success, action', 'reversed': 'Lack of control, lack of direction, aggression'},
    {'name': 'Strength', 'meaning': 'Strength, courage, persuasion, influence', 'reversed': 'Weakness, self-doubt, inner strength'},
    {'name': 'The Hermit', 'meaning': 'Soul searching, introspection, inner guidance', 'reversed': 'Isolation, withdrawal, avoidance'},
    {'name': 'Wheel of Fortune', 'meaning': 'Good luck, karma, life cycles, destiny', 'reversed': 'Bad luck, resistance to change, breaking cycles'},
    {'name': 'Justice', 'meaning': 'Justice, fairness, truth, cause and effect', 'reversed': 'Unfairness, lack of accountability, dishonesty'},
    {'name': 'The Hanged Man', 'meaning': 'Pause, surrender, letting go, new perspectives', 'reversed': 'Delays, resistance, stalling, indecision'},
    {'name': 'Death', 'meaning': 'Endings, change, transformation, transition', 'reversed': 'Resistance to change, inability to move on'},
    {'name': 'Temperance', 'meaning': 'Balance, moderation, patience, purpose', 'reversed': 'Imbalance, excess, lack of long-term vision'},
    {'name': 'The Devil', 'meaning': 'Shadow self, attachment, addiction, restriction', 'reversed': 'Releasing limiting beliefs, exploring dark thoughts, detachment'},
    {'name': 'The Tower', 'meaning': 'Sudden change, upheaval, chaos, revelation', 'reversed': 'Personal transformation, fear of change, averting disaster'},
    {'name': 'The Star', 'meaning': 'Hope, faith, purpose, renewal, spirituality', 'reversed': 'Lack of faith, despair, self-trust, disconnection'},
    {'name': 'The Moon', 'meaning': 'Illusion, fear, anxiety, subconscious', 'reversed': 'Release of fear, repressed emotion, inner confusion'},
    {'name': 'The Sun', 'meaning': 'Positivity, fun, warmth, success, vitality', 'reversed': 'Inner child, feeling down, overly optimistic'},
    {'name': 'Judgment', 'meaning': 'Judgment, rebirth, inner calling, absolution', 'reversed': 'Lack of self-awareness, doubt, self-loathing'},
    {'name': 'The World', 'meaning': 'Completion, accomplishment, travel, achievement', 'reversed': 'Incompletion, lack of closure, inability to move on'},
  ];

  for (var card in majorArcana) {
    cards.add(TarotCard(
      name: card['name'] as String,
      suit: 'Major Arcana',
      meaning: card['meaning'] as String,
      reversedMeaning: card['reversed'] as String,
    ));
  }

  // Minor Arcana - Wands (14 cards sample)
  final wands = [
    {'name': 'Ace of Wands', 'meaning': 'Inspiration, new opportunities, growth, potential', 'reversed': 'Lack of direction, lack of passion, boredom'},
    {'name': 'Two of Wands', 'meaning': 'Planning, making plans, first steps, leaving comfort', 'reversed': 'Fear of change, playing safe, bad planning'},
    {'name': 'Three of Wands', 'meaning': 'Looking ahead, expansion, rapid growth', 'reversed': 'Obstacles, delays, frustration'},
    {'name': 'Four of Wands', 'meaning': 'Celebration, joy, harmony, relaxation', 'reversed': 'Personal celebration, inner harmony, conflict with others'},
    {'name': 'Five of Wands', 'meaning': 'Disagreement, competition, strife, tension', 'reversed': 'Avoiding conflict, respecting differences'},
    {'name': 'Six of Wands', 'meaning': 'Success, public recognition, progress, self-confidence', 'reversed': 'Private achievement, personal definition of success'},
    {'name': 'Seven of Wands', 'meaning': 'Challenge, competition, protection, perseverance', 'reversed': 'Giving up, overwhelmed, defensive'},
    {'name': 'Eight of Wands', 'meaning': 'Rapid action, movement, quick decisions', 'reversed': 'Delays, frustration, resisting change'},
    {'name': 'Nine of Wands', 'meaning': 'Resilience, grit, last stand, persistence', 'reversed': 'Exhaustion, fatigue, questioning motivations'},
    {'name': 'Ten of Wands', 'meaning': 'Accomplishment, responsibility, burden, completion', 'reversed': 'Inability to delegate, overstressed, burnt out'},
    {'name': 'Page of Wands', 'meaning': 'Exploration, excitement, freedom, inspiration', 'reversed': 'Lack of direction, procrastination, creating conflict'},
    {'name': 'Knight of Wands', 'meaning': 'Action, adventure, impulsiveness, free spirit', 'reversed': 'Anger, impulsiveness, lack of direction'},
    {'name': 'Queen of Wands', 'meaning': 'Courage, determination, joy, vibrancy', 'reversed': 'Selfishness, jealousy, insecurities'},
    {'name': 'King of Wands', 'meaning': 'Natural-born leader, vision, entrepreneur, honor', 'reversed': 'Impulsiveness, haste, ruthless, high expectations'},
  ];

  for (var card in wands) {
    cards.add(TarotCard(
      name: card['name'] as String,
      suit: 'Wands',
      meaning: card['meaning'] as String,
      reversedMeaning: card['reversed'] as String,
    ));
  }

  // Minor Arcana - Cups (14 cards sample)
  final cups = [
    {'name': 'Ace of Cups', 'meaning': 'New feelings, spirituality, intuition, love', 'reversed': 'Blocked or repressed emotions, emotional imbalance'},
    {'name': 'Two of Cups', 'meaning': 'Unified love, partnership, mutual attraction', 'reversed': 'Self-love, breakups, disharmony, distrust'},
    {'name': 'Three of Cups', 'meaning': 'Friendship, community, gatherings, celebrations', 'reversed': 'Overindulgence, gossip, isolation, third-party interference'},
    {'name': 'Four of Cups', 'meaning': 'Meditation, contemplation, apathy, reevaluation', 'reversed': 'Retreat, withdrawal, checking in for alignment'},
    {'name': 'Five of Cups', 'meaning': 'Loss, grief, self-pity, regret', 'reversed': 'Acceptance, moving on, finding peace, forgiveness'},
    {'name': 'Six of Cups', 'meaning': 'Revisiting the past, childhood memories, innocence', 'reversed': 'Living in the past, forgiveness, moving forward'},
    {'name': 'Seven of Cups', 'meaning': 'Opportunities, choices, wishful thinking, illusion', 'reversed': 'Lack of purpose, disarray, confusion, diversion'},
    {'name': 'Eight of Cups', 'meaning': 'Walking away, disillusionment, leaving behind', 'reversed': 'Avoidance, fear of change, fear of loss'},
    {'name': 'Nine of Cups', 'meaning': 'Contentment, satisfaction, gratitude, wish fulfillment', 'reversed': 'Lack of inner joy, smugness, dissatisfaction'},
    {'name': 'Ten of Cups', 'meaning': 'Divine love, alignment, harmony, blessings', 'reversed': 'Disconnection, misaligned values, struggling relationships'},
    {'name': 'Page of Cups', 'meaning': 'Creative opportunities, intuitive messages, curiosity', 'reversed': 'Creative blocks, emotional immaturity, insecurity'},
    {'name': 'Knight of Cups', 'meaning': 'Following the heart, idealist, romantic, charming', 'reversed': 'Moodiness, disappointment, unrealistic expectations'},
    {'name': 'Queen of Cups', 'meaning': 'Compassion, calm, comfort, intuitive', 'reversed': 'Inner feelings, self-care, co-dependency'},
    {'name': 'King of Cups', 'meaning': 'Emotional balance, compassion, diplomacy', 'reversed': 'Emotional manipulation, moodiness, volatility'},
  ];

  for (var card in cups) {
    cards.add(TarotCard(
      name: card['name'] as String,
      suit: 'Cups',
      meaning: card['meaning'] as String,
      reversedMeaning: card['reversed'] as String,
    ));
  }

  // Minor Arcana - Swords (14 cards sample)
  final swords = [
    {'name': 'Ace of Swords', 'meaning': 'Breakthrough, clarity, sharp mind, new idea', 'reversed': 'Confusion, chaos, lack of clarity'},
    {'name': 'Two of Swords', 'meaning': 'Difficult choices, indecision, stalemate', 'reversed': 'Indecision, confusion, information overload'},
    {'name': 'Three of Swords', 'meaning': 'Heartbreak, emotional pain, sorrow, grief', 'reversed': 'Recovery, forgiveness, moving on'},
    {'name': 'Four of Swords', 'meaning': 'Rest, restoration, contemplation, recuperation', 'reversed': 'Restlessness, burnout, stress, lack of focus'},
    {'name': 'Five of Swords', 'meaning': 'Unbridled ambition, win at all costs, sneakiness', 'reversed': 'Reconciliation, making amends, past resentment'},
    {'name': 'Six of Swords', 'meaning': 'Transition, leaving behind, moving on', 'reversed': 'Emotional baggage, unresolved issues, resisting transition'},
    {'name': 'Seven of Swords', 'meaning': 'Deception, trickery, tactics, strategy', 'reversed': 'Imposter syndrome, self-deceit, tactics and strategy'},
    {'name': 'Eight of Swords', 'meaning': 'Imprisonment, entrapment, self-victimization', 'reversed': 'Self-acceptance, new perspective, freedom'},
    {'name': 'Nine of Swords', 'meaning': 'Anxiety, worry, fear, depression, nightmares', 'reversed': 'Inner turmoil, deep-seated fears, secrets'},
    {'name': 'Ten of Swords', 'meaning': 'Betrayal, backstabbing, endings, crisis', 'reversed': 'Recovery, regeneration, resisting an inevitable end'},
    {'name': 'Page of Swords', 'meaning': 'New ideas, curiosity, thirst for knowledge', 'reversed': 'Deception, manipulation, all talk, no action'},
    {'name': 'Knight of Swords', 'meaning': 'Ambitious, action-oriented, driven, fast-thinking', 'reversed': 'Restless, scatterbrained, burn out, no direction'},
    {'name': 'Queen of Swords', 'meaning': 'Independent, unbiased judgment, clear boundaries', 'reversed': 'Overly emotional, easily influenced, bitterness'},
    {'name': 'King of Swords', 'meaning': 'Mental clarity, intellectual power, authority, truth', 'reversed': 'Manipulative, cruel, weakness, abuse of power'},
  ];

  for (var card in swords) {
    cards.add(TarotCard(
      name: card['name'] as String,
      suit: 'Swords',
      meaning: card['meaning'] as String,
      reversedMeaning: card['reversed'] as String,
    ));
  }

  // Minor Arcana - Pentacles (14 cards sample)
  final pentacles = [
    {'name': 'Ace of Pentacles', 'meaning': 'New opportunity, prosperity, new financial beginning', 'reversed': 'Lost opportunity, lack of planning, bad investment'},
    {'name': 'Two of Pentacles', 'meaning': 'Balancing priorities, time management, prioritization', 'reversed': 'Imbalance, unorganized, overwhelmed'},
    {'name': 'Three of Pentacles', 'meaning': 'Teamwork, collaboration, learning, implementation', 'reversed': 'Lack of teamwork, disorganized, group conflict'},
    {'name': 'Four of Pentacles', 'meaning': 'Saving money, security, conservatism, scarcity', 'reversed': 'Over-spending, greed, self-protection'},
    {'name': 'Five of Pentacles', 'meaning': 'Need, poverty, insecurity, isolation', 'reversed': 'Recovery, charity, poverty, isolation'},
    {'name': 'Six of Pentacles', 'meaning': 'Giving, receiving, sharing wealth, generosity', 'reversed': 'Strings attached, stinginess, power and domination'},
    {'name': 'Seven of Pentacles', 'meaning': 'Hard work, perseverance, patience, long-term view', 'reversed': 'Work without results, distractions, lack of rewards'},
    {'name': 'Eight of Pentacles', 'meaning': 'Skill development, quality, mastery, commitment', 'reversed': 'Self-development, perfectionism, misdirected activity'},
    {'name': 'Nine of Pentacles', 'meaning': 'Abundance, luxury, self-sufficiency, financial independence', 'reversed': 'Self-worth, over-investment in work, hustling'},
    {'name': 'Ten of Pentacles', 'meaning': 'Wealth, financial security, family, long-term success', 'reversed': 'Financial failure, debt, lack of stability'},
    {'name': 'Page of Pentacles', 'meaning': 'Manifestation, financial opportunity, new job', 'reversed': 'Lack of progress, procrastination, learn from failure'},
    {'name': 'Knight of Pentacles', 'meaning': 'Efficiency, hard work, responsibility, routine', 'reversed': 'Laziness, boredom, feeling stuck, perfectionist'},
    {'name': 'Queen of Pentacles', 'meaning': 'Practicality, creature comforts, financial security', 'reversed': 'Self-care, work-home conflict, financial independence'},
    {'name': 'King of Pentacles', 'meaning': 'Abundance, security, discipline, prosperity', 'reversed': 'Financial failure, greed, materialistic'},
  ];

  for (var card in pentacles) {
    cards.add(TarotCard(
      name: card['name'] as String,
      suit: 'Pentacles',
      meaning: card['meaning'] as String,
      reversedMeaning: card['reversed'] as String,
    ));
  }

  return cards;
}

