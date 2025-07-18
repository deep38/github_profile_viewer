import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:github_profile_viewer/presentation/components/error_indicator.dart';
import 'package:github_profile_viewer/presentation/components/loading_state_widget.dart';
import 'package:github_profile_viewer/presentation/components/repo_card.dart';
import 'package:github_profile_viewer/presentation/components/repository_list_header.dart';
import 'package:github_profile_viewer/presentation/components/section_widget.dart';
import 'package:github_profile_viewer/presentation/components/stat_widget.dart';
import 'package:github_profile_viewer/presentation/controllers/profile_page_controller.dart';
import 'package:github_profile_viewer/presentation/model/repo_mini.dart';
import 'package:github_profile_viewer/presentation/model/user.dart';
import 'package:github_profile_viewer/utils/constants.dart';
import 'package:github_profile_viewer/utils/enums.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _loadUserData(ProfilePageController? controller) {
    final username = Get.parameters['username'];
    if (username != null) {
      controller?.loadUserData(username);
    } else {
      controller?.error.value = Exception("Username not provided");
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
            state: controller.userLoadingState.value,
            error: ErrorIndicator(
              error: controller.error.value,
              onRetry: () => _loadUserData(controller),
            ),

            success: LayoutBuilder(
              builder: (_, constraints) {
                final headerSliver = SliverToBoxAdapter(
                  child: _UserProfileHeader(
                    nullableUser: controller.user.value,
                    openUrl: controller.openUrl,
                  ),
                );

                final bodySliver = Obx(
                  () {
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
                        child: Center(child: CircularProgressIndicator.adaptive()),
                      ),
                      success: _RepoistoryList(
                        nullableUsername: controller.user.value?.username,
                        nullableRepos: controller.repos.value,
                        sortBy: controller.currentSortBy.value,
                        sortOrder: controller.currentSortOrder.value,
                        searchTextEditingController: controller.searchTextEditingController,
                        onSearchQueryChange: controller.filterRepos,
                        onSortByChange: controller.onSortByChange,
                        onSortOrderChange: controller.onSortOrderChange,
                        onClearSearch: controller.onClearSearch,
                      ),
                    );
                  }
                );

                return constraints.maxWidth > 500
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

class _UserProfileHeader extends StatelessWidget {
  const _UserProfileHeader({required this.nullableUser, required this.openUrl});

  final User? nullableUser;
  final void Function(String) openUrl;

  @override
  Widget build(BuildContext context) {
    final user = nullableUser;
    if (user != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              foregroundImage: NetworkImage(user.avatarUrl),
              radius: 56,
            ),

            if (user.name != null)
              Text(
                user.name!,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),

            GestureDetector(
              onTap: () => openUrl(user.profileLink),
              child: Text(
                "@${user.username}",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),

            const SizedBox(height: Dimens.paddingSmall),

            Card(
              elevation: 0,
              color: context.theme.colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatWidget(
                      title: "Followers",
                      value: user.followers.toString(),
                    ),
                    StatWidget(
                      title: "Followings",
                      value: user.following.toString(),
                    ),
                    StatWidget(
                      title: "Public repos",
                      value: user.publicRepos.toString(),
                    ),
                  ],
                ),
              ),
            ),

            if (user.bio != null) ...[
              const SizedBox(height: Dimens.paddingSmall),

              Card(
                elevation: 0,
                color: context.theme.colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
              ),
            ],

            Divider(),
          ],
        ),
      );
    } else {
      return Center(child: Text("Error: User is null"));
    }
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
                        Get.toNamed('/repo/$username/${repo.name}');
                      },
                    );
                  },
                )
              : SliverFillRemaining(
                  child: Center(
                    child: Text(
                      searchTextEditingController.text.isEmpty
                          ? Strings.repositoryListEmptyMessage
                          : Strings.noItemsMatchYourSearch,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ),
      );
    }

    return SliverFillRemaining(
      child: Center(child: Text("Repository list is empty.")),
    );
  }
}
