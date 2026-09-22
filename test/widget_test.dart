import 'package:flutter_test/flutter_test.dart';

import 'package:pranprohor/main.dart';

void main() {
  testWidgets('PranProhor app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const PranProhorApp());

    expect(find.text('PranProhor'), findsNothing);
  });
}