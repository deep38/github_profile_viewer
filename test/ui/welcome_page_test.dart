import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_profile_viewer/main.dart';
import 'package:github_profile_viewer/utils/constants.dart';

void main() {
  group("Username form test", () {
    testWidgets(
      "Valid username input test",
      testUsernameInputFormWithValidUsername,
    );

    testWidgets(
      "Empty username input test",
      testUsernameInputFormWithEmptyUsername,
    );

    testWidgets(
      "Invalid username input test",
      testUsernameInputFormWithInvalidUsername,
    );

    testWidgets(
      "Very long username input test",
      testUsernameInputFormWithVeryLongUsername,
    );
  });
}

Future<void> testUsernameInputFormWithValidUsername(WidgetTester tester) async {
  await tester.pumpWidget(MyApp());

  expect(find.byKey(Key(Strings.welcomePageUserNameFieldKey)), findsOneWidget);
  expect(
    find.byKey(Key(Strings.welcomePageUsernameSubmitButtonKey)),
    findsOneWidget,
  );

  final usernameField = find.byKey(Key(Strings.welcomePageUserNameFieldKey));
  final submitButton = find.byKey(
    Key(Strings.welcomePageUsernameSubmitButtonKey),
  );

  await tester.enterText(usernameField, "octate");
  await tester.tap(submitButton);
  await tester.pump();

  expect(find.text(Strings.emptyUserNameErrorMessage), findsNothing);
  expect(find.text(Strings.invalidUserNameErrorMessage), findsNothing);
  expect(find.text(Strings.tooLongUserNameErrorMessage), findsNothing);
}

Future<void> testUsernameInputFormWithEmptyUsername(WidgetTester tester) async {
  await tester.pumpWidget(MyApp());

  expect(find.byKey(Key(Strings.welcomePageUserNameFieldKey)), findsOneWidget);
  expect(
    find.byKey(Key(Strings.welcomePageUsernameSubmitButtonKey)),
    findsOneWidget,
  );

  // final usernameField = find.byKey(Key(Strings.welcomePageUserNameFieldKey));
  final submitButton = find.byKey(
    Key(Strings.welcomePageUsernameSubmitButtonKey),
  );

  // await tester.enterText(usernameField, "");
  await tester.tap(submitButton);
  await tester.pump();

  expect(find.text(Strings.emptyUserNameErrorMessage), findsOneWidget);
}

Future<void> testUsernameInputFormWithInvalidUsername(
  WidgetTester tester,
) async {
  await tester.pumpWidget(MyApp());

  expect(find.byKey(Key(Strings.welcomePageUserNameFieldKey)), findsOneWidget);
  expect(
    find.byKey(Key(Strings.welcomePageUsernameSubmitButtonKey)),
    findsOneWidget,
  );

  final usernameField = find.byKey(Key(Strings.welcomePageUserNameFieldKey));
  final submitButton = find.byKey(
    Key(Strings.welcomePageUsernameSubmitButtonKey),
  );

  await tester.enterText(usernameField, "-oct#ate");
  await tester.tap(submitButton);
  await tester.pump();

  expect(find.text(Strings.invalidUserNameErrorMessage), findsOneWidget);
}

Future<void> testUsernameInputFormWithVeryLongUsername(
  WidgetTester tester,
) async {
  await tester.pumpWidget(MyApp());

  expect(find.byKey(Key(Strings.welcomePageUserNameFieldKey)), findsOneWidget);
  expect(
    find.byKey(Key(Strings.welcomePageUsernameSubmitButtonKey)),
    findsOneWidget,
  );

  final usernameField = find.byKey(Key(Strings.welcomePageUserNameFieldKey));
  final submitButton = find.byKey(
    Key(Strings.welcomePageUsernameSubmitButtonKey),
  );

  await tester.enterText(
    usernameField,
    "octatsflaldfsflsfjlslakdfkloeowlsdofodaldflelefldfsle",
  );
  await tester.tap(submitButton);
  await tester.pump();

  expect(find.text(Strings.tooLongUserNameErrorMessage), findsOneWidget);
}
