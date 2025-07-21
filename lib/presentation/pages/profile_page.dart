import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:github_profile_viewer/presentation/components/error_indicator.dart';
import 'package:github_profile_viewer/presentation/components/loading_state_widget.dart';
import 'package:github_profile_viewer/presentation/components/repo_card.dart';
import 'package:github_profile_viewer/presentation/components/repository_list_header.dart';
import 'package:github_profile_viewer/presentation/components/section_widget.dart';
import 'package:github_profile_viewer/presentation/components/shimmer_loading.dart';
import 'package:github_profile_viewer/presentation/components/stat_widget.dart';
import 'package:github_profile_viewer/presentation/controllers/profile_page_controller.dart';
import 'package:github_profile_viewer/presentation/model/repo_mini.dart';
import 'package:github_profile_viewer/presentation/model/user.dart';
import 'package:github_profile_viewer/utils/constants.dart';
import 'package:github_profile_viewer/utils/enums.dart';
import 'package:github_profile_viewer/utils/routes.dart';
import 'package:github_profile_viewer/utils/theme_extensions.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _loadUserData(ProfilePageController? controller) {
    final username = Get.parameters[Strings.parameterUsername];
    if (username != null) {
      controller?.loadUserData(username);
    } else {
      controller?.error.value = Exception(
        Strings.userNameNotProvidedErrorMessage,
      );
      controller?.userLoadingState.value = LoadingState.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),

      body: GetX<ProfilePageController>(
        initState: (state) {
          _loadUserData(state.controller);
        },

        builder: (controller) {
          return LoadingStateWidget(
            enableTransition: true,
            state: controller.userLoadingState.value,
            error: ErrorIndicator(
              error: controller.error.value,
              onRetry: () => _loadUserData(controller),
            ),
            loading: _ProfilePageLoading(),
            success: LayoutBuilder(
              builder: (_, constraints) {
                final headerSliver = SliverToBoxAdapter(
                  child: _UserProfileHeader(
                    nullableUser: controller.user.value,
                    openUrl: controller.openUrl,
                  ),
                );

                final bodySliver = Obx(() {
                  return LoadingStateWidget(
                    state: controller.reposLoadingState.value,
                    error: SliverToBoxAdapter(
                      child: ErrorIndicator(
                        error: controller.error.value,
                        onRetry: controller.reloadRepos,
                      ),
                    ),
                    initial: SliverToBoxAdapter(),
                    loading: SliverFillRemaining(
                      child: SingleChildScrollView(
                        child: Shimmer.fromColor(
                          baseColor: context.theme
                              .extension<ShimmerEffectThemeExtension>()
                              ?.baseColor,
                          highlightColor: context.theme
                              .extension<ShimmerEffectThemeExtension>()
                              ?.highlightColor,
                          child: _RepositoryListLoading(),
                        ),
                      ),
                    ),
                    success: _RepoistoryList(
                      nullableUsername: controller.user.value?.username,
                      nullableRepos: controller.repos.value,
                      sortBy: controller.currentSortBy.value,
                      sortOrder: controller.currentSortOrder.value,
                      searchTextEditingController:
                          controller.searchTextEditingController,
                      onSearchQueryChange: controller.filterRepos,
                      onSortByChange: controller.onSortByChange,
                      onSortOrderChange: controller.onSortOrderChange,
                      onClearSearch: controller.onClearSearch,
                    ),
                  );
                });

                return constraints.maxWidth > Dimens.widthMedium
                    ? Row(
                        children: [
                          Flexible(
                            child: CustomScrollView(slivers: [headerSliver]),
                          ),
                          Flexible(
                            child: CustomScrollView(slivers: [bodySliver]),
                          ),
                        ],
                      )
                    : CustomScrollView(slivers: [headerSliver, bodySliver]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _ProfilePageLoading extends StatelessWidget {
  const _ProfilePageLoading();

  @override
  Widget build(BuildContext context) {
    final header = _UserProfileHeaderLayout(
      avatar: ShimmerCircleAvatar(radius: Dimens.radiusMedium),
      name: ShimmerLine(width: Dimens.lineWidthMedium),
      username: ShimmerLine(
        height: Dimens.lineHeightSmall,
        width: Dimens.lineWidthSmall,
      ),
      stats: ShimmerLine(
        height: Dimens.lineHeightXLarge,
        borderRadius: Dimens.borderRadiusMedium,
      ),
      bio: ShimmerLine(
        height: Dimens.lineHeightXXLarge,
        borderRadius: Dimens.borderRadiusMedium,
      ),
    );

    final body = _RepositoryListLoading();
    return Shimmer.fromColor(
      baseColor: context.theme
          .extension<ShimmerEffectThemeExtension>()
          ?.baseColor,
      highlightColor: context.theme
          .extension<ShimmerEffectThemeExtension>()
          ?.highlightColor,
      child: LayoutBuilder(
        builder: (_, constraints) {
          return constraints.maxWidth > Dimens.widthMedium
              ? Row(
                  children: [
                    Expanded(child: SingleChildScrollView(child: header)),
                    Expanded(child: SingleChildScrollView(child: body)),
                  ],
                )
              : SingleChildScrollView(child: Column(children: [header, body]));
        },
      ),
    );
  }
}

class _RepositoryListLoading extends StatelessWidget {
  const _RepositoryListLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShimmerRepositoryListHeader(),
          Divider(),
          ...List.filled(2, ShimmerCard(height: Dimens.lineHeightXXLarge)),
        ],
      ),
    );
  }
}

class _UserProfileHeader extends StatelessWidget {
  const _UserProfileHeader({required this.nullableUser, required this.openUrl});

  final User? nullableUser;
  final void Function(String) openUrl;

  @override
  Widget build(BuildContext context) {
    final user = nullableUser;
    if (user != null) {
      return _UserProfileHeaderLayout(
        avatar: CircleAvatar(
          foregroundImage: NetworkImage(user.avatarUrl),
          radius: Dimens.radiusMedium,
        ),
        name: user.name != null
            ? Text(
                user.name!,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              )
            : null,
        username: GestureDetector(
          onTap: () => openUrl(user.profileLink),
          child: Text(
            "@${user.username}",
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
        ),
        stats: Card(
          elevation: 0,
          color: context.theme.colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(Dimens.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatWidget(
                  title: Strings.followersLabel,
                  value: user.followers.toString(),
                ),
                StatWidget(
                  title: Strings.followingLabel,
                  value: user.following.toString(),
                ),
                StatWidget(
                  title: Strings.publicReposLabel,
                  value: user.publicRepos.toString(),
                ),
              ],
            ),
          ),
        ),
        bio: user.bio != null
            ? Card(
                elevation: 0,
                color: context.theme.colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.paddingSmall),
                  child: SectionWidget(
                    title: 'About',
                    child: Text(
                      user.bio!,
                      maxLines: 5,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ),
              )
            : null,
      );
    } else {
      return Center(child: Text(Strings.userIsNullErrorMessage));
    }
  }
}

class _UserProfileHeaderLayout extends StatelessWidget {
  const _UserProfileHeaderLayout({
    required this.avatar,
    required this.name,
    required this.username,
    required this.stats,
    required this.bio,
  });

  final Widget avatar;
  final Widget? name;
  final Widget username;
  final Widget stats;
  final Widget? bio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMedium),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          avatar,

          ?name,

          username,

          const SizedBox(height: Dimens.paddingSmall),

          stats,

          if (bio != null) ...[
            const SizedBox(height: Dimens.paddingSmall),

            ?bio,
          ],

          Divider(),
        ],
      ),
    );
  }
}

class _RepoistoryList extends StatelessWidget {
  const _RepoistoryList({
    required this.nullableUsername,
    required this.nullableRepos,
    required this.sortBy,
    required this.sortOrder,
    required this.searchTextEditingController,
    required this.onSearchQueryChange,
    required this.onSortByChange,
    required this.onSortOrderChange,
    required this.onClearSearch,
  });

  final String? nullableUsername;
  final List<RepoMini>? nullableRepos;
  final SortBy sortBy;
  final SortOrder sortOrder;
  final TextEditingController searchTextEditingController;
  final void Function(String) onSearchQueryChange;
  final void Function(SortBy?) onSortByChange;
  final void Function(SortOrder?) onSortOrderChange;
  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    final repos = nullableRepos;
    final username = nullableUsername;
    if (repos != null) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMedium),
        sliver: SliverStickyHeader(
          header: ColoredBox(
            color: Theme.of(context).canvasColor,
            child: Column(
              children: [
                RepositoryListHeader(
                  sortBy: sortBy,
                  sortOrder: sortOrder,
                  onSearchQueryChange: onSearchQueryChange,
                  onSortByChange: onSortByChange,
                  onSortOrderChange: onSortOrderChange,
                  searchTextEditingController: searchTextEditingController,
                  onClearSearch: onClearSearch,
                ),
                Divider(),
              ],
            ),
          ),
          sliver: repos.isNotEmpty
              ? SliverList.builder(
                  itemCount: repos.length,
                  itemBuilder: (builderContext, index) {
                    final repo = repos[index];
                    return RepoCard(
                      repo: repo,
                      onClick: () {
                        if (username == null) {
                          Get.snackbar(
                            "Navigating to repository",
                            "Username not provided",
                          );
                          return;
                        }
                        Get.toNamed(Routes.repositoryPage(username, repo.name));
                      },
                    );
                  },
                )
              : SliverFillRemaining(
                  child: Center(
                    child: Text(
                      searchTextEditingController.text.isEmpty
                          ? Strings.repositoryListNotFoundMessage
                          : Strings.noItemsMatchYourSearch,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ),
      );
    }

    return SliverFillRemaining(
      child: Center(child: Text(Strings.emptyListMessage)),
    );
  }
}
