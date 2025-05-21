import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});
  // final List<FlutterCalenderEvent> todaysEvents = [
  //   FlutterCalenderEvent(
  //     'Event A',
  //     startTime: DateTime(
  //         DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 0),
  //     endTime: DateTime(
  //         DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 0),
  //     description: 'A special event',
  //     color: Colors.blue[700],
  //   ),
  // ];

  // final List<FlutterCalenderEvent> eventList = [
  //   FlutterCalenderEvent(
  //     'MultiDay Event A',
  //     description: 'test desc',
  //     startTime: DateTime(
  //         DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 0),
  //     endTime: DateTime(DateTime.now().year, DateTime.now().month,
  //         DateTime.now().day + 2, 12, 0),
  //     color: Colors.orange,
  //     isMultiDay: true,
  //   ),
  //   FlutterCalenderEvent(
  //     'Event X',
  //     description: 'test desc',
  //     startTime: DateTime(DateTime.now().year, DateTime.now().month,
  //         DateTime.now().day, 10, 30),
  //     endTime: DateTime(DateTime.now().year, DateTime.now().month,
  //         DateTime.now().day, 11, 30),
  //     color: Colors.lightGreen,
  //     isAllDay: false,
  //     isDone: true,
  //   ),
  //   FlutterCalenderEvent(
  //     'Allday Event B',
  //     description: 'test desc',
  //     startTime: DateTime(DateTime.now().year, DateTime.now().month,
  //         DateTime.now().day - 2, 14, 30),
  //     endTime: DateTime(DateTime.now().year, DateTime.now().month,
  //         DateTime.now().day + 2, 17, 0),
  //     color: Colors.pink,
  //     isAllDay: true,
  //   ),
  //   FlutterCalenderEvent(
  //     'Normal Event D',
  //     description: 'test desc',
  //     startTime: DateTime(DateTime.now().year, DateTime.now().month,
  //         DateTime.now().day, 14, 30),
  //     endTime: DateTime(
  //         DateTime.now().year, DateTime.now().month, DateTime.now().day, 17, 0),
  //     color: Colors.indigo,
  //   ),
  //   FlutterCalenderEvent(
  //     'Normal Event E',
  //     description: 'test desc',
  //     startTime: DateTime(
  //         DateTime.now().year, DateTime.now().month, DateTime.now().day, 7, 45),
  //     endTime: DateTime(
  //         DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 0),
  //     color: Colors.indigo,
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Example'),
      ),
      body: Center(
        child: SizedBox(),
      ),
    );
  }
}
