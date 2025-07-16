import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:github_profile_viewer/presentation/components/error_indicator.dart';
import 'package:github_profile_viewer/presentation/components/loading_state_widget.dart';
import 'package:github_profile_viewer/presentation/components/repo_card.dart';
import 'package:github_profile_viewer/presentation/components/responsive_page.dart';
import 'package:github_profile_viewer/presentation/components/stat_widget.dart';
import 'package:github_profile_viewer/presentation/controllers/profile_page_controller.dart';
import 'package:github_profile_viewer/presentation/model/repo_mini.dart';
import 'package:github_profile_viewer/presentation/model/user.dart';
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
      appBar: AppBar(),
      body: GetX<ProfilePageController>(
        initState: (state) {
          _loadUserData(state.controller);
        },
        builder: (controller) {
          debugPrint("Error value: ${controller.error}");
          return LoadingStateWidget(
            state: controller.userLoadingState.value,
            error: ErrorIndicator(
              error: controller.error.value,
              onRetry: () => _loadUserData(controller),
            ),
            success: ResponsivePage(
              headerFlex: 2,
              bodyFlex: 3,
              headerBuilder: (constraints) {
                final header = _buildUserProfileHeader(
                  context,
                  controller.user.value,
                  controller.openUrl,
                );

                return constraints.maxWidth > 500
                    ? SingleChildScrollView(child: header)
                    : header;
              },
              bodyBuilder: (_) => Obx(
                () => LoadingStateWidget(
                  state: controller.reposLoadingState.value,
                  error: ErrorIndicator(
                    error: controller.error.value,
                    onRetry: controller.reloadRepos,
                  ),
                  success: _buildRepoList(
                    context,
                    controller.user.value?.username,
                    controller.repos.value,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserProfileHeader(
    BuildContext context,
    User? user,
    void Function(String) openUrl,
  ) {
    if (user != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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

            if (user.bio != null) ...[
              const SizedBox(height: 8),

              Text(
                user.bio!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],

            const SizedBox(height: 36),

            Row(
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
          ],
        ),
      );
    } else {
      return Center(child: Text("Error: User is null"));
    }
  }
}

Widget _buildRepoList(
  BuildContext context,
  String? username,
  List<RepoMini>? repos,
) {
  if (repos != null) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Public repositories",
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.zero,
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
            ),
          ),
        ],
      ),
    );
  }

  return Center(child: Text("Repository list is empty."));
}
