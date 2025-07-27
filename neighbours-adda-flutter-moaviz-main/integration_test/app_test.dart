import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snap_local/main.dart' as app;
import 'package:snap_local/onboarding/screens/onboarding_screen.dart';
import 'package:snap_local/splash/splash_screen.dart';

void main() {
  group('Neighbours Adda', () {
    testWidgets('Login and Verify OTP screen testing',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        // Build the app and trigger a frame
        await tester.pumpWidget(const app.MyApp());

        // Wait for the splash screen to load
        await tester.pumpAndSettle();

        // Verify that SplashScreen is rendered initially
        expect(find.byType(SplashScreen), findsOneWidget);

        // Wait for 4 seconds
        await tester.pumpAndSettle(const Duration(seconds: 4));

        // Verify that the onboarding screen is rendered
        expect(find.byType(OnboardingScreen), findsOneWidget);

        // Find and tap the "Next" button
        final nextButton = find.byKey(const Key("Next"));

        //Swap to next screen
        await tester.tap(nextButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        //Click next to open authentication screen
        await tester.tap(nextButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // //LOGIN SCREEN
        // // Verify that the login screen is rendered
        // expect(find.byType(LoginScreen).first, findsOneWidget);

        // // Enter text in the username and password fields
        // await tester.enterText(
        //     find.byKey(const Key('user_name')), '9438108200');
        // await tester.enterText(find.byKey(const Key('password')), '123456');

        // //close the soft keyboard
        // await tester.testTextInput.receiveAction(TextInputAction.done);
        // await tester.pumpAndSettle();

        // // Tap the login button
        // final loginButton = find.byKey(const Key("login_button"));

        // await tester.tap(loginButton);

        // await tester.pump(const Duration(seconds: 1));

        // //VerifyOTPScreen

        // // Verify that the VerifyOTP screen is rendered
        // expect(find.byType(VerifyOTPScreen), findsOneWidget);

        // // Enter text in the OTP field
        // await tester.enterText(find.byKey(const Key('otp_text_field')), '1234');
        // await tester.pumpAndSettle();

        // // Verify that the bottom bar screen is rendered
        // expect(find.byType(BottomBar), findsOneWidget);
        // await tester.pumpAndSettle(const Duration(seconds: 4));
      });
    });
  });
}
