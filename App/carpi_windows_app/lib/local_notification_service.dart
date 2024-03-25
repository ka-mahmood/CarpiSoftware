import 'dart:convert';

import 'package:carpi_windows_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:timezone/timezone.dart' as tz;
// import 'dart:math';

// taken and modified from https://medium.com/@abubakarsaddqiuekhan/local-notifications-4e5e037106ce

class LocalNotificationService {
  // first of all you have to initialize the local notification plugin and call it's constructor .

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // According to the official documentation
  // The flutter local notification plugin Provides cross-platform functionality for displaying local notifications.
  // The plugin will check the platform that is running on to use the appropriate platform-specific implementation of the plugin.

  // Now it's time to initialize the setting of android , ios and other platform's .

  void initializeSettings(BuildContext context) {

    var androidInitializationSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");

    // That's all for the android initialization settings .
    // Now it's time to add the initialization s of other platforms .
    // The darwin initialization settings is used for ios settings .
    var initializeIOSSettings = const DarwinInitializationSettings();

    LinuxInitializationSettings initializeLinuxSettings =
        const LinuxInitializationSettings(
            defaultActionName: 'Open notification');

    // You have to provide a lot of properties and permission's for ios notification that you can find in the package
    // In this article i only write detail about the android notification's .

    // Initialize settings is used to initialize the setting's for all of the platform's . Here you can initialize the all of the platform's settings that you will want's .
 
    var initializeSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: initializeIOSSettings,
        linux: initializeLinuxSettings);

    // now add the initialization setting in flutter local notification's plugin .

    // Now pass the initializations settings in in the initialize method of the flutter local notifications plugin .

    flutterLocalNotificationsPlugin.initialize(
      initializeSettings,
    
      onDidReceiveNotificationResponse: (details) async {
        flutterLocalNotificationsPlugin.cancel(details.id!);

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ));

        }
    );
  }

  // Now it's time to show the notification .

  void showSimpleNotification(String notifTitle, String notifBody) {
    // Here you have to set the detail's that will be displayed on all of the app's .

    var androidNotificationDetails = const AndroidNotificationDetails(
        // The channel id must be unique for all of the notification's .
        // Required for Android 8.0 or newer.
        "channel_Id_1",
        // channel name
        // Required for Android 8.0 or newer.
        "notification_channel_Name",

        //  The priority is the enum that is used to set the priority of the notification .
        // /// Priority for notifications on Android 7.1 and lower.
        priority: Priority.max,
        //  For detailed information about these topics kindly read it from the official documentation .
        importance: Importance.max,
        // Whether the notification sound will be played when the notification received .
        // Indicates if a sound should be played when the notification is displayed.

// For Android 8.0 or newer, this is tied to the specified channel and cannot be changed after the channel has been created for the first time.
        playSound: true,

        // Specifies if the notification should automatically dismissed upon tapping on it.
        autoCancel: false,

        // Category property is used to set the category of the notification which mean's that it belong's to which category like it is alrm notification , call notification , email or message etc .
        // For detailed information or categories kindly read the android notification category enum
        // https://pub.dev/documentation/flutter_local_notifications/latest/flutter_local_notifications/AndroidNotificationCategory.html

        // category: AndroidNotificationCategory.message  ,

        // color: Colors.red

        channelDescription: "channel_description");

    //  In the same way you have to add the detail's for the other platform's .

    var iosNotificationDetails = const DarwinNotificationDetails();

    // Now set all of the platform notification detail's in notification details class .
    //
    var notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails
        // In the same way you have to add the notification for all of the platform you want's notification .
        );

    flutterLocalNotificationsPlugin.show(
        0, notifTitle, notifBody, notificationDetails,
        payload: "Data received using payload of notification");
  }
 
  Future<void> checkNotificationPermission() async {
    // ignore: unused_local_variable
    Future<PermissionStatus> permissionStatus =
        NotificationPermissions.requestNotificationPermissions();
  }


  Future<void> zonedScheduleNotification(Duration secDuration) async {
    try {
      _checkPendingNotificationRequests();
      int id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
      print("this is the time in seconds: $secDuration");
      tz.TZDateTime time =  tz.TZDateTime.now(tz.local).add(secDuration);
      await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          'Carpi Rehab',
          'Keep it up! Come back for some re-hand-bilitation.',
          time,
          const NotificationDetails(
              android: AndroidNotificationDetails(
                  'your channel id', 'your channel name',
                  importance: Importance.max,
                  priority: Priority.max,
                  showWhen: false,
                  channelDescription: 'your channel description')),
          payload: jsonEncode({'id': id, 'time': time.toString()}),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    } catch (e) {
      print(e);
    }
  }

    Future<void> _checkPendingNotificationRequests() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print('${pendingNotificationRequests.length} pending notification ');

    for (PendingNotificationRequest pendingNotificationRequest
        in pendingNotificationRequests) {
      print("${pendingNotificationRequest.id} ${pendingNotificationRequest.payload ?? ""}");
    }
    print('NOW ${tz.TZDateTime.now(tz.local)}');
  }

}