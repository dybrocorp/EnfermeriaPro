import 'package:flutter/foundation.dart';
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
      'enfermeria_pro_event_channel_v4', // Incremented ID for fresh configuration
      'Alertas Prioritarias',
      channelDescription: 'Alarmas y alertas críticas para eventos',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      enableLights: true,
      enableVibration: true,
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

  static Future<void> showTestNotification() async {
    await showNotification(
      id: 9999,
      title: 'Prueba de Alerta',
      body: 'Si ves esto, las notificaciones directas están funcionando.',
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

    // Check for exact alarm permission on Android 13+ (optional but recommended)
    final bool? isExactPermissionGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.canScheduleExactNotifications();
        
    if (isExactPermissionGranted == false) {
      debugPrint("ALERTA: No se pueden programar alarmas exactas. Solicite permiso al usuario.");
      // Note: Ideally we guide the user to settings here, but for now we log it.
    }

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
          'enfermeria_pro_event_channel_v4',
          'Alertas de Eventos',
          channelDescription: 'Canal para alertas de calendario y estudio',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          audioAttributesUsage: AudioAttributesUsage.alarm,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
