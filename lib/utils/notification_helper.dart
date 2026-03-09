import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';
import '../models/calendar_event.dart';

class NotificationHelper {
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'enfermeria_pro_channel',
      'Alertas Clínicas',
      channelDescription: 'Recordatorios y alertas de medicina',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  static Future<void> scheduleEventNotifications(CalendarEvent event) async {
    final int eventId = event.dateTime.millisecondsSinceEpoch ~/ 1000;
    
    // Cancel existing notifications for this event to avoid duplicates
    await flutterLocalNotificationsPlugin.cancel(eventId);

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(event.dateTime, tz.local);
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    if (scheduledDate.isBefore(now)) return;

    // Base notification (at the time of the event)
    await _scheduleNotification(
      id: eventId,
      title: 'Recordatorio de Evento',
      body: 'Hoy: ${event.title}',
      scheduledDate: scheduledDate,
    );

    // Periodic Alerts
    if (event.alertFrequency != null && event.alertFrequency! > 0) {
      // Schedule alerts leading up to the event at the specified interval
      // For simplicity, we'll schedule a few alerts before the event
      for (int i = 1; i <= 5; i++) {
        final alertDate = scheduledDate.subtract(Duration(minutes: event.alertFrequency! * i));
        if (alertDate.isAfter(now)) {
          await _scheduleNotification(
            id: eventId + i,
            title: 'Alerta Próxima',
            body: 'Tu evento "${event.title}" es en ${event.alertFrequency! * i} minutos.',
            scheduledDate: alertDate,
          );
        }
      }
    } else {
      // Default behavior: reminders every 30 minutes starting 24h before
      final tz.TZDateTime startOfReminders = scheduledDate.subtract(const Duration(hours: 24));
      
      if (now.isBefore(scheduledDate)) {
        tz.TZDateTime reminderTime = startOfReminders.isAfter(now) ? startOfReminders : now.add(const Duration(minutes: 1));
        
        int reminderId = 100; // Offset for reminder IDs
        while (reminderTime.isBefore(scheduledDate) && reminderId < 148) { // Limit to ~48 reminders
          await _scheduleNotification(
            id: eventId + reminderId,
            title: 'Recordatorio de Examen',
            body: 'No olvides preparar tu examen: ${event.title}',
            scheduledDate: reminderTime,
          );
          reminderTime = reminderTime.add(const Duration(minutes: 30));
          reminderId++;
        }
      }
    }
  }

  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'enfermeria_pro_event_channel',
          'Recordatorios de Eventos',
          channelDescription: 'Alarmas y alertas periódicas para exámenes y eventos',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
