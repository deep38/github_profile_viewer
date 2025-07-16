import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_profile_viewer/presentation/components/responsive_page.dart';
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
      return "Please enter username";
    }

    if (username.trim().length > 39) {
      return "Username is too long. it must be less than 40 characters.";
    }

    if (!username.trim().isValidUsername()) {
      return "Invalide username. Username can only contain alphabets, numbers and single -(hyphen) inbetween.";
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
          final isLargeWidth = constraints.maxWidth > 500;

          final form = Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: isLargeWidth
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  TextFormField(
                    key: Key("usernameInputField"),
                    controller: _usernameTextEditingController,
                    validator: _usernameValidator,
                    decoration: InputDecoration(
                      labelText: "Username",
                      hintText: "Enter username",
                      errorMaxLines: 2,
                      border: OutlineInputBorder(),
                      constraints: BoxConstraints(
                        minWidth: min(
                          500.0,
                          max(MediaQuery.of(context).size.width, 36.0),
                        ),
                        maxWidth: 500,
                      ),
                    ),
                  ),
              
                  if (isLargeWidth) SizedBox(height: 16),
              
                  ElevatedButton(
                    key: Key("usernameSubmitButton"),
                    onPressed: onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      fixedSize: Size.fromWidth(
                        MediaQuery.of(context).size.width,
                      ),
                      maximumSize: Size.fromWidth(500),
                    ),
                    child: const Text("View profile"),
                  ),
                ],
              );

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
