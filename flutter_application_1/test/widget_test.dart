import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
  });
}
