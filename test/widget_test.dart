import 'package:flutter_test/flutter_test.dart';
import 'package:devnotes/main.dart'; // Update the import to your main.dart file

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp()); // Use the correct class for your app, typically `MyApp`

    // Verify that the app starts correctly, you can add more tests here if needed.
    expect(find.text('Welcome to your Gratitude Journal'), findsOneWidget);
  });
}
