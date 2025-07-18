import 'package:flutter/material.dart';
import 'package:github_profile_viewer/utils/constants.dart';

class InfoChip extends StatelessWidget {
  const InfoChip({super.key, required this.icon, required this.label, this.tooltip});

  final Widget icon;
  final Widget label;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final chip = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: Dimens.paddingXSmall,),
          label
        ],
      );
    return tooltip != null 
    ? Tooltip(
      message: tooltip,
      child: chip,
    )
    : chip;
  }
}