import 'package:flutter/material.dart';
import 'package:github_profile_viewer/utils/exceptions.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({super.key, this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _buildErrorWidget(context),
        ),
      ),
    );
  }

  List<Widget> _buildErrorWidget(BuildContext context) {
    if (error is NoNetworkException) {
      return [
        Text("Error!", style: Theme.of(context).textTheme.headlineLarge),
        Text("No internet connection."),
      ];
    } else if (error is UserNotFoundException) {
      return [
        Text("404", style: Theme.of(context).textTheme.headlineLarge),
        Text("User not found."),
      ];
    } else {
      return [
        Text("Error!", style: Theme.of(context).textTheme.headlineLarge),
        Text("Unexpected error occured."),
      ];
    }
  }
}
