import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_profile_viewer/main.dart';

void main() {
  group("Username form test", () {
    testWidgets(
      "Valid username input test",
      testUsernameInputFormWithValidUsername,
    );

    testWidgets("Invalid username input test", testUsernameInputFormWithInvalidUsername);

    testWidgets("Very long username input test", testUsernameInputFormWithVeryLongUsername);
  });
}

Future<void> testUsernameInputFormWithValidUsername(WidgetTester tester) async {
  await tester.pumpWidget(MyApp());

  expect(find.byKey(Key("usernameInputField")), findsOneWidget);
  expect(find.byKey(Key("usernameSubmitButton")), findsOneWidget);

  final usernameField = find.byKey(Key("usernameInputField"));
  final submitButton = find.byKey(Key("usernameSubmitButton"));

  await tester.enterText(usernameField, "octate");
  await tester.tap(submitButton);
  await tester.pump();

  expect(find.text("Invalid username"), findsNothing);
  expect(find.text("Username is too long"), findsNothing);
}

Future<void> testUsernameInputFormWithInvalidUsername(
  WidgetTester tester,
) async {
  await tester.pumpWidget(MyApp());

  expect(find.byKey(Key("usernameInputField")), findsOneWidget);
  expect(find.byKey(Key("usernameSubmitButton")), findsOneWidget);

  final usernameField = find.byKey(Key("usernameInputField"));
  final submitButton = find.byKey(Key("usernameSubmitButton"));

  await tester.enterText(usernameField, "-oct#ate");
  await tester.tap(submitButton);
  await tester.pump();

  expect(find.text("Invalide username. Username can only contain alphabets, numbers and single -(hyphen) inbetween."), findsOne);
}

Future<void> testUsernameInputFormWithVeryLongUsername(WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byKey(Key("usernameInputField")), findsOneWidget);
    expect(find.byKey(Key("usernameSubmitButton")), findsOneWidget);

    final usernameField = find.byKey(Key("usernameInputField"));
    final submitButton = find.byKey(Key("usernameSubmitButton"));

    await tester.enterText(
      usernameField,
      "octatsflaldfsflsfjlslakdfkloeowlsdofodaldflelefldfsle",
    );
    await tester.tap(submitButton);
  await tester.pump();

    expect(find.text("Username is too long. it must be less than 40 characters."), findsOne);
  }