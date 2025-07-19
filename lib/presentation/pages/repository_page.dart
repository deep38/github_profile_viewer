import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_profile_viewer/presentation/components/error_indicator.dart';
import 'package:github_profile_viewer/presentation/components/info_chip.dart';
import 'package:github_profile_viewer/presentation/components/loading_state_widget.dart';
import 'package:github_profile_viewer/presentation/components/section_widget.dart';
import 'package:github_profile_viewer/presentation/components/shimmer_loading.dart';
import 'package:github_profile_viewer/presentation/controllers/repository_page_controller.dart';
import 'package:github_profile_viewer/presentation/model/repository.dart';
import 'package:github_profile_viewer/utils/constants.dart';
import 'package:github_profile_viewer/utils/enums.dart';
import 'package:github_profile_viewer/utils/extensions.dart';

class RepositoryPage extends StatelessWidget {
  const RepositoryPage({super.key});

  void _loadRepositoryData(RepositoryPageController? controller) {
    final username = Get.parameters[Strings.parameterUsername];
    final reponame = Get.parameters[Strings.parameterReponame];
    if (username != null && reponame != null) {
      controller?.loadRepository(username, reponame);
    } else {
      controller?.error.value = Exception(
        Strings.userNameOrRepositoryNameNotProvidedErrorMessage,
      );
      controller?.loadingState.value = LoadingState.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Repository')),
      body: GetX<RepositoryPageController>(
        initState: (state) => _loadRepositoryData(state.controller),
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.only(
              left: Dimens.paddingMedium,
              right: Dimens.paddingMedium,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: LoadingStateWidget(
              enableTransition: true,
              state: controller.loadingState.value,
              loading: _RepositoryInfoLoading(),
              error: ErrorIndicator(
                error: controller.error.value,
                onRetry: () => _loadRepositoryData(controller),
              ),
              success: _RepositoryInfo(
                repository: controller.repo.value,
                openUrl: controller.openUrl,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RepositoryInfo extends StatelessWidget {
  const _RepositoryInfo({required this.repository, required this.openUrl});

  final Repository? repository;
  final void Function(String) openUrl;

  @override
  Widget build(BuildContext context) {
    final repo = repository;
    if (repo != null) {
      final subtitleTextStyle = Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor);

      return _RepositoryInfoLayout(
        avatar: GestureDetector(
          onTap: () => openUrl(repo.owner.htmlUrl),
          child: CircleAvatar(
            radius: Dimens.radiusMedium,
            foregroundImage: NetworkImage(repo.owner.avatarUrl),
          ),
        ),
        name: GestureDetector(
          onTap: () => openUrl(repo.htmlUrl),
          child: Text(
            repo.fullName,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        visibilityInfo: Container(
          decoration: BoxDecoration(
            border: BoxBorder.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(Dimens.borderRadiusMedium),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.paddingXSmall,
            vertical: Dimens.paddingXXSmall,
          ),
          child: Text(repo.visibility.toUpperCase(), style: subtitleTextStyle),
        ),
        updatedDateInfo: Text(
          "Updated on ${repo.updatedAt.formatToMMMMDDYYYY()}",
          style: subtitleTextStyle,
        ),
        description: repo.description != null
            ? Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimens.paddingSmall,
                    horizontal: Dimens.paddingMedium,
                  ),

                  child: SectionWidget(
                    title: 'Description',
                    child: Text(repo.description!),
                  ),
                ),
              )
            : null,
        otherDetails: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Dimens.paddingSmall,
              horizontal: Dimens.paddingMedium,
            ),
            child: SectionWidget(
              title: 'Other details',
              child: Wrap(
                spacing: Dimens.paddingMedium,
                runSpacing: Dimens.paddingSmall,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  if (repo.language != null)
                    InfoChip(
                      icon: Icon(Icons.code),
                      label: Text(repo.language!),
                    ),
                  InfoChip(
                    icon: Icon(Icons.star_border_outlined),
                    label: Text("${repo.stars} Stars"),
                  ),
                  InfoChip(
                    icon: Icon(Icons.call_split_rounded),
                    label: Text("${repo.forks} Forks"),
                  ),
                  InfoChip(
                    icon: Icon(Icons.error_outline_rounded),
                    label: Text("${repo.openIssues} Open issues"),
                  ),
                  InfoChip(
                    icon: Icon(Icons.remove_red_eye_outlined),
                    label: Text("${repo.watchers} Watchers"),
                  ),
                  InfoChip(
                    icon: Icon(Icons.subscriptions_outlined),
                    label: Text("${repo.subscribersCount} Subscribers"),
                  ),
                  InfoChip(
                    icon: Icon(Icons.people_outline_rounded),
                    label: Text("${repo.networkCount} Networks"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Center(child: Text(Strings.nullRepositoryMessage));
  }
}

class _RepositoryInfoLoading extends StatelessWidget {
  const _RepositoryInfoLoading();

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: _RepositoryInfoLayout(
        avatar: ShimmerCircleAvatar(radius: Dimens.radiusMedium),
        name: ShimmerLine(width: Dimens.lineWidthLarge, height: Dimens.lineHeightMedium),
        visibilityInfo: ShimmerLine(width: Dimens.lineWidthSmall, height: Dimens.lineHeightMedium,),
        updatedDateInfo: ShimmerLine( width: Dimens.lineWidthXXLarge, ),
        description: ShimmerCard(),
        otherDetails: ShimmerCard(height: Dimens.lineHeightXXLarge,),
      ),
    );
  }
}

class _RepositoryInfoLayout extends StatelessWidget {
  const _RepositoryInfoLayout({
    required this.avatar,
    required this.name,
    required this.visibilityInfo,
    required this.updatedDateInfo,
    required this.description,
    required this.otherDetails,
  });

  final Widget avatar;
  final Widget name;
  final Widget visibilityInfo;
  final Widget updatedDateInfo;
  final Widget? description;
  final Widget otherDetails;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: Dimens.widthMedium),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                avatar,
                SizedBox(width: Dimens.paddingMedium),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimens.paddingSmall),

                      Wrap(
                        children: [
                          name,
                          SizedBox(width: Dimens.paddingXSmall),
                          visibilityInfo,
                        ],
                      ),

                      SizedBox(height: Dimens.paddingXXSmall),
                      updatedDateInfo,
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: Dimens.paddingMedium),

            if (description != null) ...[
              ?description,
              SizedBox(height: Dimens.paddingMedium),
            ],

            otherDetails,
          ],
        ),
      ),
    );
  }
}
