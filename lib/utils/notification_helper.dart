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
    // Generate a unique base ID for this event based on its title and timestamp
    final int baseId = (event.title.hashCode + event.dateTime.millisecondsSinceEpoch) % 1000000;
    
    // Cancel any previous notifications associated with this event
    // Ideally we'd track IDs, but as a fallback we cancel by a range if needed,
    // though cancel(id) is standard.
    await flutterLocalNotificationsPlugin.cancel(baseId);

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(event.dateTime, tz.local);
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    if (scheduledDate.isBefore(now)) return;

    // 1. Main Notification (at event time)
    await _scheduleNotification(
      id: baseId,
      title: '¡Es hora del evento!',
      body: 'Inicia ahora: ${event.title}',
      scheduledDate: scheduledDate,
    );

    // 2. Pre-event Alerts
    if (event.alertFrequency != null && event.alertFrequency! > 0) {
      // Schedule 3 reminders before the event
      for (int i = 1; i <= 3; i++) {
        final alertDate = scheduledDate.subtract(Duration(minutes: event.alertFrequency! * i));
        if (alertDate.isAfter(now)) {
          await _scheduleNotification(
            id: baseId + (i * 1000),
            title: 'Recordatorio Próximo',
            body: 'Tu evento "${event.title}" inicia en ${event.alertFrequency! * i} minutos.',
            scheduledDate: alertDate,
          );
        }
      }
    } else {
      // Default: 1 hour before and 15 mins before
      final preAlerts = [60, 15];
      for (var mins in preAlerts) {
        final alertDate = scheduledDate.subtract(Duration(minutes: mins));
        if (alertDate.isAfter(now)) {
          await _scheduleNotification(
            id: baseId + mins,
            title: 'Recordatorio',
            body: 'Tu evento "${event.title}" inicia en $mins minutos.',
            scheduledDate: alertDate,
          );
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
