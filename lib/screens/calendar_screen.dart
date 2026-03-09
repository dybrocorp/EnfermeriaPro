import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';
import '../utils/notification_helper.dart';
import '../models/calendar_event.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  
  Map<DateTime, List<CalendarEvent>> _events = {};
  late TextEditingController _eventController;
  TimeOfDay _selectedTime = TimeOfDay.now();
  int? _alertFrequency; // null, 15, 30

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _eventController = TextEditingController();
    _loadEvents();
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final String? eventsString = prefs.getString('calendar_events_v2');
    if (eventsString != null) {
      final Map<String, dynamic> rawEvents = jsonDecode(eventsString);
      setState(() {
        _events = rawEvents.map((key, value) {
          final DateTime date = DateTime.parse(key);
          final List<CalendarEvent> eventList = (value as List)
              .map((e) => CalendarEvent.fromJson(e))
              .toList();
          return MapEntry(date, eventList);
        });
      });
    }
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> rawEvents = _events.map((key, value) {
      return MapEntry(key.toIso8601String(), value.map((e) => e.toJson()).toList());
    });
    await prefs.setString('calendar_events_v2', jsonEncode(rawEvents));
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return _events[_normalizeDate(day)] ?? [];
  }

  void _addEvent() async {
    if (_eventController.text.isEmpty) return;
    
    final normalizedDate = _normalizeDate(_selectedDay ?? _focusedDay);
    final eventDateTime = DateTime(
      normalizedDate.year,
      normalizedDate.month,
      normalizedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final newEvent = CalendarEvent(
      title: _eventController.text,
      dateTime: eventDateTime,
      alertFrequency: _alertFrequency,
    );

    setState(() {
      if (_events[normalizedDate] != null) {
        _events[normalizedDate]!.add(newEvent);
      } else {
        _events[normalizedDate] = [newEvent];
      }
    });

    _eventController.clear();
    Navigator.pop(context);
    await _saveEvents();
    
    // Schedule notifications
    await NotificationHelper.scheduleEventNotifications(newEvent);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento guardado y alertas programadas')),
      );
    }
  }
  
  void _deleteEvent(DateTime date, int index) async {
    final normalizedDate = _normalizeDate(date);
    // Note: In a real app, we should also cancel the scheduled notification
    // using the specific notification IDs.
    setState(() {
      _events[normalizedDate]?.removeAt(index);
      if (_events[normalizedDate]?.isEmpty ?? true) {
        _events.remove(normalizedDate);
      }
    });
    await _saveEvents();
  }

  void _showAddEventDialog() {
    _selectedTime = TimeOfDay.now();
    _alertFrequency = null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Añadir Evento\n${_selectedDay?.day}/${_selectedDay?.month}/${_selectedDay?.year}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _eventController,
                  decoration: const InputDecoration(
                    hintText: 'Ej. Examen de Anatomía',
                    labelText: 'Nombre del Evento',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Hora del examen:'),
                  trailing: TextButton(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (time != null) {
                        setDialogState(() => _selectedTime = time);
                      }
                    },
                    child: Text(_selectedTime.format(context)),
                  ),
                ),
                const Divider(),
                const Text('Frecuencia de alertas:', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<int?>(
                  value: _alertFrequency,
                  isExpanded: true,
                  hint: const Text('Comportamiento por defecto (Auto)'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Automático (24h antes, cada 30m)')),
                    DropdownMenuItem(value: 15, child: Text('Cada 15 minutos')),
                    DropdownMenuItem(value: 30, child: Text('Cada 30 minutos')),
                  ],
                  onChanged: (val) {
                    setDialogState(() => _alertFrequency = val);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: _addEvent,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Calendario Estudiantil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEventList() {
    final events = _getEventsForDay(_selectedDay ?? _focusedDay);

    if (events.isEmpty) {
      return const Center(
        child: Text(
          'No hay eventos para este día.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        final event = events[index];
        final timeStr = DateFormat('hh:mm a').format(event.dateTime);
        
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.warning,
              child: Icon(Icons.event_note, color: Colors.white),
            ),
            title: Text(
              event.title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            subtitle: Text(
              'Hora: $timeStr | Alerta: ${event.alertFrequency ?? "Auto"} min',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.danger),
              onPressed: () => _deleteEvent(_selectedDay ?? _focusedDay, index),
            ),
          ),
        );
      },
    );
  }
}
