import 'package:flutter_test/flutter_test.dart';
import 'package:greenleaf/main.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('Greenleaf shows 8 sample plants, watering happy message, and navigation',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const GreenleafApp());
    await tester.pumpAndSettle();

    // Desktop viewport shows phone frame status bar ("9:41")
    expect(find.text('9:41'), findsOneWidget);
    expect(find.text('greenleaf'), findsOneWidget);
    expect(find.text("Today's Plants to Water"), findsOneWidget);

    // Tap Watered on the first plant and verify happy message appears
    await tester.tap(find.text('Watered').first);
    await tester.pumpAndSettle();
    expect(find.textContaining('happy and hydrated'), findsOneWidget);

    // Switch to My Plants and verify all 8 sample plants are present
    await tester.tap(find.text('My Plants'));
    await tester.pumpAndSettle();
    expect(find.text('8 plants'), findsOneWidget);

    const expectedPlants = [
      'Money Plant',
      'Aloe Vera',
      'Snake Plant',
      'Tulsi',
      'Rose',
      'Mint',
      'Peace Lily',
      'Cactus',
    ];
    final myPlantsScrollable = find.descendant(
      of: find.byKey(const Key('my-plants-list')),
      matching: find.byType(Scrollable),
    );
    for (final name in expectedPlants) {
      await tester.scrollUntilVisible(
        find.text(name),
        200,
        scrollable: myPlantsScrollable,
      );
      expect(find.text(name), findsOneWidget);
    }

    // Open Plant Details for Cactus
    await tester.tap(find.text('Cactus'));
    await tester.pumpAndSettle();
    expect(find.text('Plant Details'), findsOneWidget);
    expect(find.text('Water every 21 days'), findsOneWidget);

    // Tap Watered in Plant Details
    await tester.tap(find.text('Watered'));
    await tester.pumpAndSettle();
    expect(find.text('Watered Today ✓'), findsOneWidget);

    // Go back and switch to Add Plant
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Plant'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Plant Name'),
      'Lavender',
    );
    final addPlantScrollable = find
        .descendant(
          of: find.byKey(const Key('add-plant-list')),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(
      find.text('Save Plant'),
      200,
      scrollable: addPlantScrollable,
    );
    await tester.tap(find.text('Save Plant'));
    await tester.pumpAndSettle();

    expect(find.text('Lavender'), findsWidgets);
  });

  testWidgets('Greenleaf renders full screen without phone notch on mobile viewport',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const GreenleafApp());
    await tester.pumpAndSettle();

    // No simulated desktop phone status bar on mobile viewport
    expect(find.text('9:41'), findsNothing);
    expect(find.text('greenleaf'), findsOneWidget);
  });
}
