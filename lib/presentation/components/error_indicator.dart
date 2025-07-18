import 'dart:math';

import 'package:flutter/material.dart';
import 'package:github_profile_viewer/utils/constants.dart';
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
          AssetImage('assets/images/error/no_internet_connection.png'),
          Strings.noInternetConnectionErrorMessage,
          true,
          onRetry,
        ),
        NotFoundException e => _buildErrorWidget(
          AssetImage('assets/images/error/not_found.png'),
          e.message,
        ),
        _ => _buildErrorWidget(
          AssetImage('assets/images/error/unexpected_error.png'),
          Strings.unexpectedErrorMessage,
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
      builder: (context, constraints) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: Dimens.paddingSmall,
            children: [
              Image(
                image: image,
                width: min(Dimens.widthSmall, constraints.maxWidth / 2),
                errorBuilder: (context, error, stackTrace) => Tooltip(
                  message: Strings.failedToLoadImageErrorMessage,
                  child: Icon(
                    Icons.broken_image_outlined,
                    semanticLabel: Strings.failedToLoadImageErrorMessage,
                  ),
                ),
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
              if (canRetry) ...[
                SizedBox(height: Dimens.paddingMedium),
                OutlinedButton(onPressed: onRetry, child: Text(Strings.retryButtonText)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
