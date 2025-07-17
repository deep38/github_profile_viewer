import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_profile_viewer/presentation/components/responsive_page.dart';
import 'package:github_profile_viewer/utils/constants.dart';
import 'package:github_profile_viewer/utils/extensions.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({super.key});

  final TextEditingController _usernameTextEditingController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void onSubmit() {
    if (_formKey.currentState?.validate() == true) {
      Get.toNamed('/user/${_usernameTextEditingController.value.text.trim()}');
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
    // final isLandscape = MediaQuery.of(context).size.aspectRatio > 1;
    return Scaffold(
      body: ResponsivePage(
        headerBuilder: (_) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("GitHub", style: Theme.of(context).textTheme.displayLarge),
              Text(
                "PROFILE VIEWER",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
        bodyBuilder: (constraints) {
          final isLargeWidth = constraints.maxWidth > Dimens.mediumWidth;

          final form = Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: isLargeWidth
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
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
                          Dimens.mediumWidth,
                          max(MediaQuery.of(context).size.width, 36.0),
                        ),
                        maxWidth: Dimens.mediumWidth,
                      ),
                    ),
                  ),
              
                  if (isLargeWidth) SizedBox(height: Dimens.paddingMedium),
              
                  ElevatedButton(
                    key: Key(Strings.welcomePageUsernameSubmitButtonKey),
                    onPressed: onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      fixedSize: Size.fromWidth(
                        MediaQuery.of(context).size.width,
                      ),
                      maximumSize: Size.fromWidth(Dimens.mediumWidth),
                    ),
                    child: const Text(Strings.viewProfileButtonText),
                  ),
                ],
              );

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMedium),
            child: Form(
              key: _formKey,
              child: isLargeWidth
              ? SingleChildScrollView(
                child: form,
              )
              : form
            )
          );
        },
      ),
    );
  }
}
