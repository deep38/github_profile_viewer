import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:github_profile_viewer/presentation/components/error_indicator.dart';
import 'package:github_profile_viewer/presentation/components/loading_state_widget.dart';
import 'package:github_profile_viewer/presentation/components/repo_card.dart';
import 'package:github_profile_viewer/presentation/components/responsive_page.dart';
import 'package:github_profile_viewer/presentation/components/stat_widget.dart';
import 'package:github_profile_viewer/presentation/controllers/profile_page_controller.dart';
import 'package:github_profile_viewer/presentation/model/repo.dart';
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
              headerFlex: 1,
              bodyFlex: 2,
              headerBuilder:(_) => _buildUserProfileHeader(context, controller.user.value),
              bodyBuilder:(_) => Obx(
                () => LoadingStateWidget(
                  state: controller.reposLoadingState.value,
                  error: ErrorIndicator(error: controller.error.value, onRetry: controller.reloadRepos,),
                  success: _buildRepoList(context, controller.repos.value),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserProfileHeader(BuildContext context, User? user) {
    if (user != null) {
      return Column(
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

          Text(
            "@${user.username}",
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),

          if (user.bio != null)
            Text(
              user.bio!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),

          const SizedBox(height: 36),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatWidget(title: "Followers", value: user.followers.toString()),
              StatWidget(title: "Followings", value: user.following.toString()),
              StatWidget(
                title: "Public repos",
                value: user.publicRepos.toString(),
              ),
            ],
          ),
        ],
      );
    } else {
      return Center(child: Text("Error: User is null"));
    }
  }
}

Widget _buildRepoList(BuildContext context, List<RepoMini>? repos) {
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
                return RepoCard(repo: repos[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  return Center(child: Text("Repository list is empty."));
}
