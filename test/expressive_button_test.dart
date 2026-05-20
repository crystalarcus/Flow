import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redesigned/widgets/utils/m3expressive/expressive_button.dart';

void main() {
  testWidgets('ExpressiveButton keeps round corners when keepRound is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpressiveSpringButton(
            isSelected: true,
            onTap: () {},
            keepRound: true,
            height: 56.0,
          ),
        ),
      ),
    );

    // Initial state with isSelected: true sets controller to 1.0
    await tester.pump();

    final containerFinder = find.byType(Container);
    final container = tester.widget<Container>(containerFinder);
    final decoration = container.decoration as BoxDecoration;
    final borderRadius = decoration.borderRadius as BorderRadius;

    // thickness is 56, so radius should be 28 (thickness / 2)
    expect(borderRadius.topLeft.x, 28.0);
  });

  testWidgets(
      'ExpressiveButton uses 14px radius when selected and keepRound is false',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpressiveSpringButton(
            isSelected: true,
            onTap: () {},
            keepRound: false,
            height: 56.0,
          ),
        ),
      ),
    );

    await tester.pump();

    final containerFinder = find.byType(Container);
    final container = tester.widget<Container>(containerFinder);
    final decoration = container.decoration as BoxDecoration;
    final borderRadius = decoration.borderRadius as BorderRadius;

    expect(borderRadius.topLeft.x, 14.0);
  });

  testWidgets('ExpressiveIconButton keeps round corners when keepRound is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpressiveSpringIconButton(
            isSelected: true,
            onTap: () {},
            keepRound: true,
            icon: Icons.add,
            unselectedLength: 56.0,
          ),
        ),
      ),
    );

    await tester.pump();

    final containerFinder = find.byType(Container);
    final container = tester.widget<Container>(containerFinder);
    final decoration = container.decoration as BoxDecoration;
    final borderRadius = decoration.borderRadius as BorderRadius;

    expect(borderRadius.topLeft.x, 28.0);
  });

  testWidgets(
      'ExpressiveIconButton uses 16px radius when selected and keepRound is false',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpressiveSpringIconButton(
            isSelected: true,
            onTap: () {},
            keepRound: false,
            icon: Icons.add,
            unselectedLength: 56.0,
          ),
        ),
      ),
    );

    await tester.pump();

    final containerFinder = find.byType(Container);
    final container = tester.widget<Container>(containerFinder);
    final decoration = container.decoration as BoxDecoration;
    final borderRadius = decoration.borderRadius as BorderRadius;

    expect(borderRadius.topLeft.x, 16.0);
  });

  testWidgets('ExpressiveButton animates borderRadius on selection',
      (WidgetTester tester) async {
    bool isSelected = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return ExpressiveButton(
                isSelected: isSelected,
                onTap: () {
                  setState(() => isSelected = !isSelected);
                },
                thickness: 48.0,
                text: 'Test',
              );
            },
          ),
        ),
      ),
    );

    // Initial state: unselected -> fully circle (radius = 24)
    await tester.pump();
    var decoration =
        tester.widget<Container>(find.byType(Container)).decoration
            as BoxDecoration;
    expect((decoration.borderRadius as BorderRadius).topLeft.x, 24.0);

    // Tap to select
    await tester.tap(find.byType(ExpressiveButton));
    await tester.pump(); // Start animation
    await tester.pump(const Duration(milliseconds: 500)); // End animation

    decoration = tester.widget<Container>(find.byType(Container)).decoration
        as BoxDecoration;
    expect((decoration.borderRadius as BorderRadius).topLeft.x, 12.0);
  });
}
