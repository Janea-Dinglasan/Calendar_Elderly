import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
<<<<<<< HEAD
import 'package:flutter_application_1/screens/calendar_page.dart';
import 'package:flutter_application_1/screens/add_task_page.dart';

void main() {
  testWidgets('Tapping add task button opens AddTaskPage', (WidgetTester tester) async {
    // Build our app with CalendarPage
    await tester.pumpWidget(MaterialApp(home: CalendarPage()));

    // Verify that CalendarPage is displayed
    expect(find.text('My Calendar'), findsOneWidget);

    // Tap the 'Add Task' button in the BottomNavigationBar
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that AddTaskPage is now displayed
    expect(find.byType(AddTaskPage), findsOneWidget);
=======
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: CalendarApp()));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
>>>>>>> 00e71dc1e982c53e6caa7e900d347355895d2e88
  });
}
