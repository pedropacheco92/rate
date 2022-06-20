import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rate/rate.dart';

Widget mockMaterialApp(Widget child) => MaterialApp(
      home: Scaffold(body: child),
    );

void main() {
  testWidgets('Rate should have 5 empty stars', (tester) async {
    await tester.pumpWidget(mockMaterialApp(const Rate(key: Key('test'))));
    final iconFinder = find.byIcon(Icons.star_border);

    expect(iconFinder, findsNWidgets(5));
    expect(find.byKey(const Key('test')), findsOneWidget);
    expect(find.byKey(const Key('star_rate_0')), findsOneWidget);
    expect(find.byKey(const Key('star_rate_1')), findsOneWidget);
    expect(find.byKey(const Key('star_rate_2')), findsOneWidget);
    expect(find.byKey(const Key('star_rate_3')), findsOneWidget);
    expect(find.byKey(const Key('star_rate_4')), findsOneWidget);
  });

  testWidgets('Rate should have 5 stars', (tester) async {
    await tester.pumpWidget(mockMaterialApp(const Rate(initialValue: 5)));
    final iconFinder = find.byIcon(Icons.star);

    expect(iconFinder, findsNWidgets(5));
  });

  testWidgets('Rate should have 3 stars and 2 empty', (tester) async {
    await tester.pumpWidget(mockMaterialApp(const Rate(initialValue: 3)));

    expect(find.byIcon(Icons.star), findsNWidgets(3));
    expect(find.byIcon(Icons.star_border), findsNWidgets(2));
  });

  testWidgets('Rate should have 2.5 stars', (tester) async {
    await tester.pumpWidget(mockMaterialApp(const Rate(
      initialValue: 2.5,
      allowHalf: true,
    )));

    expect(find.byIcon(Icons.star), findsNWidgets(2));
    expect(find.byIcon(Icons.star_half), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsNWidgets(2));
  });

  testWidgets('Rate should handle click on stars', (tester) async {
    await tester.pumpWidget(mockMaterialApp(const Rate()));

    expect(find.byIcon(Icons.star_border), findsNWidgets(5));
    expect(find.byIcon(Icons.star), findsNothing);

    final starFinder = find.byKey(const Key('star_rate_2'));
    await tester.tap(starFinder);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star_border), findsNWidgets(2));
    expect(find.byIcon(Icons.star), findsNWidgets(3));

    // test double click with clear, should be zero
    await tester.tap(starFinder);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star_border), findsNWidgets(5));
    expect(find.byIcon(Icons.star), findsNothing);
  });

  testWidgets('Rate should handle click on stars without clear',
      (tester) async {
    await tester.pumpWidget(mockMaterialApp(const Rate(allowClear: false)));

    expect(find.byIcon(Icons.star_border), findsNWidgets(5));
    expect(find.byIcon(Icons.star), findsNothing);

    final starFinder = find.byKey(const Key('star_rate_2'));
    await tester.tap(starFinder);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star_border), findsNWidgets(2));
    expect(find.byIcon(Icons.star), findsNWidgets(3));

    // test double click without clear, should stay the same
    await tester.tap(starFinder);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star_border), findsNWidgets(2));
    expect(find.byIcon(Icons.star), findsNWidgets(3));
  });

  testWidgets('Rate should handle changing on stars', (tester) async {
    await tester.pumpWidget(mockMaterialApp(const Rate()));

    expect(find.byIcon(Icons.star_border), findsNWidgets(5));
    expect(find.byIcon(Icons.star), findsNothing);

    final starFinder = find.byKey(const Key('star_rate_2'));
    await tester.tap(starFinder);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star_border), findsNWidgets(2));
    expect(find.byIcon(Icons.star), findsNWidgets(3));

    final starFinder2 = find.byKey(const Key('star_rate_3'));
    await tester.tap(starFinder2);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star_border), findsNWidgets(1));
    expect(find.byIcon(Icons.star), findsNWidgets(4));
  });

  testWidgets('Rate should handle half click on stars', (tester) async {
    await tester.pumpWidget(mockMaterialApp(const Rate(
      allowHalf: true,
    )));

    final starFinder = find.byKey(const Key('star_rate_2'));

    // offset click to tap half star
    await tester.tapAt(tester.getCenter(starFinder) - const Offset(7, 0));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star_border), findsNWidgets(2));
    expect(find.byIcon(Icons.star), findsNWidgets(2));
    expect(find.byIcon(Icons.star_half), findsOneWidget);
  });

  testWidgets('Rate should handle hover', (tester) async {
    await tester.pumpWidget(mockMaterialApp(const Rate()));

    final starFinder = find.byKey(const Key('star_rate_2'));

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();
    await gesture.moveTo(tester.getCenter(starFinder));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star_border), findsNWidgets(2));
    expect(find.byIcon(Icons.star), findsNWidgets(3));
  });

  testWidgets('Rate should handle on half', (tester) async {
    await tester.pumpWidget(mockMaterialApp(const Rate(allowHalf: true)));

    final starFinder = find.byKey(const Key('star_rate_2'));

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();
    await gesture.moveTo(tester.getCenter(starFinder));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star_border), findsNWidgets(2));
    expect(find.byIcon(Icons.star), findsNWidgets(2));
    expect(find.byIcon(Icons.star_half), findsOneWidget);
  });
}
