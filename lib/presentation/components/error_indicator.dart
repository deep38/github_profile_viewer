import 'dart:math';

import 'package:flutter/material.dart';
import 'package:github_profile_viewer/utils/exceptions.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({super.key, this.error, this.onRetry});

  final Exception? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: switch (error) {
        NoNetworkException _ => _buildErrorWidget(
          AssetImage('images/error/no_internet_connection.png'),
          "No internet connection. Check your connectivity then refresh.",
          true,
          onRetry,
        ),
        UserNotFoundException _ => _buildErrorWidget(
          AssetImage('images/error/not_found.png'),
          "User not found.",
        ),
        _ => _buildErrorWidget(
          AssetImage('images/error/unexpected_error.png'),
          "Something went wrong. Please try again.",
          true,
          onRetry,
        ),
      },
    );
  }

  Widget _buildErrorWidget(
    ImageProvider image,
    String message, [
    bool canRetry = false,
    VoidCallback? onRetry,
  ]) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.0,
        children: [
          Image(
            image: image,
            width: min(300, constraints.maxWidth / 3),
            errorBuilder: (context, error, stackTrace) => Tooltip(message: "Failed to load image.", child: Icon(Icons.broken_image_outlined, semanticLabel: "Failed to load image.",)),
          ),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
          if (canRetry) ...[
            SizedBox(height: 16.0),
            OutlinedButton(onPressed: onRetry, child: Text("Retry")),
          ],
        ],
      ),
    );
  }
}
