import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_profile_viewer/presentation/components/responsive_layout.dart';
import 'package:github_profile_viewer/utils/constants.dart';
import 'package:github_profile_viewer/utils/extensions.dart';
import 'package:github_profile_viewer/utils/routes.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({super.key});

  final TextEditingController _usernameTextEditingController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void onSubmit() {
    if (_formKey.currentState?.validate() == true) {
      Get.toNamed(Routes.profilePage(_usernameTextEditingController.text));
    }
  }

  String? _usernameValidator(String? username) {
    if (username == null || username.trim().isEmpty) {
      return Strings.emptyUserNameErrorMessage;
    }

    if (username.trim().length > 39) {
      return Strings.tooLongUserNameErrorMessage;
    }

    if (!username.trim().isValidUsername()) {
      return Strings.invalidUserNameErrorMessage;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        headerFlex: 3,
        bodyFlex: 4,
        headerBuilder: (_) => Stack(
          children: [
            ClipPath(
              clipper: _WaveClipper(),
              child: Container(
                // transform: Mat,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "GitHub",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    "PROFILE VIEWER",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
        bodyBuilder: (constraints) {
          final isLargeWidth = constraints.maxWidth > Dimens.widthMedium;

          final form = Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.paddingMedium,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: Dimens.paddingLarge),
                _FormHeading(),
                SizedBox(height: Dimens.paddingXLarge),
                TextFormField(
                  key: Key(Strings.welcomePageUserNameFieldKey),
                  controller: _usernameTextEditingController,
                  validator: _usernameValidator,
                  decoration: InputDecoration(
                    labelText: "Username",
                    hintText: "Enter username",
                    errorMaxLines: 2,
                    border: OutlineInputBorder(),
                    constraints: BoxConstraints(
                      minWidth: min(
                        Dimens.widthMedium,
                        max(MediaQuery.of(context).size.width, Dimens.sizeMedium),
                      ),
                      maxWidth: Dimens.widthMedium,
                    ),
                  ),

                  textInputAction: TextInputAction.go,
                  onFieldSubmitted: (_) => onSubmit(),
                ),

                SizedBox(height: Dimens.paddingMedium),

                ElevatedButton(
                  key: Key(Strings.welcomePageUsernameSubmitButtonKey),
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    fixedSize: Size.fromWidth(
                      MediaQuery.of(context).size.width,
                    ),
                    maximumSize: Size.fromWidth(Dimens.widthMedium),
                  ),
                  child: const Text(Strings.viewProfileButtonText),
                ),
              ],
            ),
          );

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.paddingMedium,
            ),
            child: Form(
              key: _formKey,
              child: isLargeWidth ? SingleChildScrollView(child: form) : form,
            ),
          );
        },
      ),
    );
  }
}

class _FormHeading extends StatelessWidget {
  const _FormHeading();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Just enter username to'),
        AnimatedTextKit(
          repeatForever: true,

          animatedTexts: [
            TyperAnimatedText(
              'Search.',
              textStyle: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
              speed: Duration(milliseconds: Time.millisecondsFast),
            ),

            TyperAnimatedText(
              'Explore.',
              textStyle: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
              speed: Duration(milliseconds: Time.millisecondsFast),
            ),

            TyperAnimatedText(
              'Connect.',
              textStyle: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
              speed: Duration(milliseconds: Time.millisecondsFast),
            ),
          ],
        ),
      ],
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - (size.height / 6));

    final firstPoint = Point<double>(0, size.height - (size.height / 6));
    final secondPoint = Point<double>(size.width / 2, size.height);
    final thirdPoint = Point<double>(
      size.width,
      size.height - (size.height / 6),
    );
    path.cubicTo(
      firstPoint.x,
      firstPoint.y,
      secondPoint.x,
      secondPoint.y,
      thirdPoint.x,
      thirdPoint.y,
    );

    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
