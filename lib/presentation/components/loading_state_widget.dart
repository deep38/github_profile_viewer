import 'package:flutter/material.dart';
import 'package:github_profile_viewer/presentation/components/error_indicator.dart';
import 'package:github_profile_viewer/utils/constants.dart';
import 'package:github_profile_viewer/utils/enums.dart';

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({
    super.key,
    required this.state,
    this.initial = const SizedBox(),
    this.loading = const Center(child: CircularProgressIndicator.adaptive()),
    required this.success,
    this.error = const ErrorIndicator(),
    this.enableTransition = false,
  });

  final LoadingState state;
  final Widget initial;
  final Widget loading;
  final Widget success;
  final Widget error;
  final bool enableTransition;

  @override
  Widget build(BuildContext context) {
    final widget = switch (state) {
      LoadingState.initial => initial,
      LoadingState.loading => loading,
      LoadingState.success => success,
      LoadingState.error => error,
    };

    return enableTransition
        ? AnimatedSwitcher(
            reverseDuration: Duration(milliseconds: Time.millisecondsMedium),
            duration: Duration(milliseconds: Time.millisecondsMedium),
            child: widget,
          )
        : widget;
  }
}
