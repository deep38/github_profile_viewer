import 'package:flutter/material.dart';
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
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMedium, vertical: Dimens.paddingSmall),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                repo.name,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
      
              if (repo.description != null)
                Text(repo.description!, style: subtitleTextStyle, maxLines: 2),
      
              SizedBox(height: Dimens.paddingMedium),
      
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                  Text(
                    "Updated on ${repo.updatedAt.formatToMMMMDDYYYY()}",
                    style: subtitleTextStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
