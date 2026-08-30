import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_learning_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'visitedGettingStartedPageOnce': false,
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_tts'), (
          MethodCall methodCall,
        ) async {
          return 1;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_tts'), null);
  });

  testWidgets('shows KiddoMind splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.textContaining('KiddoMind'), findsOneWidget);
    expect(find.text('Loading...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
  });
}
