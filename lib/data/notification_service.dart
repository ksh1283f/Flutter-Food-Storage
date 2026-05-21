

import 'package:flutter/foundation.dart';
import 'package:flutter_food_storage/domain/logic/date_utils.dart';
import 'package:flutter_food_storage/domain/models/dish.dart';
import 'package:flutter_food_storage/domain/models/enums.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

const _channelId = 'dish_reminder';
const _notiId = 0;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  
  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings, iOS: iosSettings
      )
    );

    await _plugin.resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>()
                  ?.createNotificationChannel(const AndroidNotificationChannel(
                      _channelId,
                      '반찬 알림',
                      description: '매일 아침 반찬 유통기한 알림',
                      importance: Importance.high,
                    )
                  );
  }

  static Future<bool> requestPermission() async {
    // ios
    if(defaultTargetPlatform == TargetPlatform.iOS){
      return await _plugin
                  .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
                  ?.requestPermissions(alert: true, badge: false, sound: false) ?? false;
    }

    // android
    if(defaultTargetPlatform == TargetPlatform.android){
      final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await android?.requestNotificationsPermission() ?? false;
    }

    return false;
  }

  static Future<void> scheduleDailyReminder(List<Dish> dishes) async { 
    await _plugin.cancelAll();

    // 만료되지 않은 active반찬만, dday 오름차순
    final upcoming = dishes
          .where((d) => d.status == DishStatus.active && calcDDay(d.expireAt)>=0)
          .toList()
          ..sort((a,b) => calcDDay(a.expireAt).compareTo(calcDDay(b.expireAt)));

    if(upcoming.isEmpty) return;

    final todayAndSoon =
        upcoming.where((d) => calcDDay(d.expireAt) <= 2).toList();
    final target =
        todayAndSoon.isNotEmpty ? todayAndSoon : upcoming.take(3).toList();

    final names = target.map((d) => d.name).join(',');
    final body = todayAndSoon.isNotEmpty
        ? '오늘 먹어야 할 반찬이 있어요: $names'
        : '곧 먹어야 할 반찬이 있어요: $names';

    await _plugin.zonedSchedule(
      id: _notiId,
      title: '🍱 반찬 알림',
      body: body,
      scheduledDate: _nextInstanceOf9AM(),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          '반찬 알림',
          channelDescription: '매일 아침 반찬 유통기한 알림',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexact,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOf9AM() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 9);
    if(scheduled.isBefore(now)){
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  static Future<void> setupNotifications(List<Dish> dishes) async {
    final granted = await requestPermission();
    if(granted){
      await scheduleDailyReminder(dishes);
    }
  }
}