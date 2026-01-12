import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../utils/theme.dart';
import '../../providers/calendar_provider.dart';
import '../../models/calendar_event.dart';
import '../../utils/app_strings.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CalendarProvider>(context, listen: false);
    provider.loadFestivals(_focusedDay);
    provider.loadUserEvents(_focusedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.getString(context, 'calendar', fallback: 'Calendar')),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: Consumer<CalendarProvider>(
        builder: (context, provider, _) {
          final events = provider.getEventsForDate(_selectedDay);

          return Column(
            children: [
              // Calendar Widget
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                eventLoader: (day) => provider.getEventsForDate(day),
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: AppTheme.primaryYellow,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppTheme.primaryYellow.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: AppTheme.primaryYellow,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                  provider.loadFestivals(focusedDay);
                  provider.loadUserEvents(focusedDay);
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
              ),

              // Events List
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Events on ${DateFormat('MMMM d, yyyy').format(_selectedDay)}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      if (provider.loading)
                        Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow))
                      else if (events.isEmpty)
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.event_busy, size: 64, color: AppTheme.mediumGray),
                                SizedBox(height: 16),
                                Text(
                                  'No events on this day',
                                  style: TextStyle(fontSize: 16, color: AppTheme.mediumGray),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              return _buildEventCard(events[index]);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEventCard(CalendarEvent event) {
    IconData icon;
    Color color;

    switch (event.eventType) {
      case 'festival':
        icon = Icons.celebration;
        color = Colors.orange;
        break;
      case 'auspicious':
        icon = Icons.stars;
        color = Colors.green;
        break;
      case 'consultation':
        icon = Icons.person;
        color = AppTheme.primaryYellow;
        break;
      default:
        icon = Icons.event;
        color = AppTheme.mediumGray;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          event.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(event.description),
            if (event.eventType == 'auspicious') ...[
              SizedBox(height: 4),
              Text(
                'Time: ${DateFormat('h:mm a').format(event.date)}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.primaryYellow,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        trailing: event.isRecurring
            ? Icon(Icons.repeat, color: AppTheme.mediumGray)
            : null,
      ),
    );
  }
}

