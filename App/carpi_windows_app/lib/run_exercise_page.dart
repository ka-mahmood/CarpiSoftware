import 'exercise_page.dart';
import 'package:flutter/material.dart';
import 'local_notification_service.dart';
import 'package:tray_manager/tray_manager.dart';
import 'dart:io' show Platform;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class RunExercisePage extends StatefulWidget {
  final ExerciseCardModel exercise;
  RunExercisePage({required this.exercise});
  @override
  // ignore: no_logic_in_create_state
  State<RunExercisePage> createState() => _RunExercisePage(exercise: exercise);
}

class _RunExercisePage extends State<RunExercisePage> with TrayListener {
  // run the exercises - this will be the 'workout' screen
  final ExerciseCardModel exercise;
  _RunExercisePage({required this.exercise});
  
  void sendAndroidNotification(String notifTitle, String notifBody) { // android notification
    final LocalNotificationService localNotificationService =
        LocalNotificationService();
    localNotificationService.checkNotificationPermission();
    localNotificationService.initializeSettings(context);
    localNotificationService.showSimpleNotification(notifTitle, notifBody);
  }


  DateTime selectedDate = DateTime.now();
  DateTime fullDate = DateTime.now();
  final LocalNotificationService _notificationService = LocalNotificationService();

  Future<DateTime> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: selectedDate,
        lastDate: DateTime(2100));
        (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: Theme.of(context).colorScheme,
            ),
            child: child,
          );
        };
    if (date != null) {
      final time = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );

      if (time != null) {
        setState(() {
          fullDate = DateTimeField.combine(date, time);
        });

        await _notificationService.zonedScheduleNotificationFiveSeconds();
      }


      return DateTimeField.combine(date, time);
    } else {
      return selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text(exercise.exerciseName, style: TextStyle(fontSize: 16)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),

          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Next page'),
                    ),
                    body: const Center(
                      child: Text(
                        'This is the next page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'This is the exercise page',
              style: TextStyle(fontSize: 24),
            ),
            IconButton(
              icon: Icon(Icons.notification_add),
              onPressed: () async {
                  if (Platform.isAndroid) {
                    sendAndroidNotification("Carpi Rehab", "It's time to start exercising.");   
                  } else {
                    print('working on adding notifications here!');
                  }      
                },
            ),

            IconButton(
              icon: Icon(Icons.alarm),
              onPressed: () async {
                _selectDate(context);
              },
            )
          ],
        ),
      ),
    );
  }
}