
import 'package:flutter/material.dart';
import 'package:github_profile_viewer/utils/constants.dart';

class SectionWidget extends StatelessWidget {
  const SectionWidget({super.key, required this.title, required this.child});

  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Padding(padding: const EdgeInsets.all(Dimens.paddingSmall), child: child),
        ],
      ),
    );
  }
}
