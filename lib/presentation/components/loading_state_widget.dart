import 'package:flutter/material.dart';
import 'package:github_profile_viewer/presentation/components/error_indicator.dart';
import 'package:github_profile_viewer/utils/enums.dart';

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key, required this.state, 
  this.initial = const SizedBox(),
  this.loading = const Center(child: CircularProgressIndicator.adaptive(),),
  required this.success,
  this.error = const ErrorIndicator()
  });

  final LoadingState state;
  final Widget initial;
  final Widget loading;
  final Widget success;
  final Widget error;

  @override
  Widget build(BuildContext context) {
    return switch(state) {
      LoadingState.initial => initial,
      LoadingState.loading => loading,
      LoadingState.success => success,
      LoadingState.error => error,
    };
  }
}