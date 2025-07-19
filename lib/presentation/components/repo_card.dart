import 'package:flutter/material.dart';
import 'package:github_profile_viewer/presentation/components/shimmer_loading.dart';
import 'package:github_profile_viewer/presentation/model/repo_mini.dart';
import 'package:github_profile_viewer/utils/constants.dart';
import 'package:github_profile_viewer/utils/extensions.dart';

class RepoCard extends StatelessWidget {
  const RepoCard({super.key, required this.repo, required this.onClick});

  final RepoMini repo;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    final subtitleColor = Theme.of(context).hintColor;
    final subtitleTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: subtitleColor);
    return Card(
      elevation: 0.3,
      child: InkWell(
        onTap: onClick,
        child: _RepoCardLayout(
          title: Text(
            repo.name,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          description: repo.description != null
              ? Text(repo.description!, style: subtitleTextStyle, maxLines: 2)
              : null,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star_border_outlined,
                semanticLabel: "Stars",
                color: subtitleColor,
              ),
              Text(
                repo.stars.toString(),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: subtitleColor),
              ),
            ],
          ),
          trailing: Text(
            "Updated on ${repo.updatedAt.formatToMMMMDDYYYY()}",
            style: subtitleTextStyle,
          ),
        ),
      ),
    );
  }
}

class ShimerRepoCard extends StatelessWidget {
  const ShimerRepoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _RepoCardLayout(
      title: ShimmerLine(width: Dimens.lineWidthLarge,),
      description: ShimmerLine(height: Dimens.lineHeightSmall,),
      leading: ShimmerLine(width: Dimens.lineWidthSmall,),
      trailing: ShimmerLine(height: Dimens.lineHeightSmall, width: Dimens.lineWidthXLarge,),
    );
  }
}

class _RepoCardLayout extends StatelessWidget {
  const _RepoCardLayout({
    required this.title,
    required this.leading,
    required this.trailing,
    this.description,
  });

  final Widget title;
  final Widget? description;
  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.paddingMedium,
        vertical: Dimens.paddingSmall,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,

          ?description,

          SizedBox(height: Dimens.paddingMedium),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [leading, trailing],
          ),
        ],
      ),
    );
  }
}
