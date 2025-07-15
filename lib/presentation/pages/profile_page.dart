import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:github_profile_viewer/presentation/components/error_indicator.dart';
import 'package:github_profile_viewer/presentation/components/responsive_page.dart';
import 'package:github_profile_viewer/presentation/controllers/profile_page_controller.dart';
import 'package:github_profile_viewer/presentation/model/user.dart';
import 'package:github_profile_viewer/utils/enums.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ProfilePageController>(
      initState: (state) {
        final username = Get.parameters['username'];
        if (username != null) {
          state.controller?.loadUserData(username);
        } else {
          state.controller?.error.value = Exception("Username not provided");
          state.controller?.userLoadingState.value = LoadingState.error;
        }
      },
      builder: (controller) {
        return switch (controller.userLoadingState.value) {
          LoadingState.initial => SizedBox(),
          LoadingState.loading => Center(child: CircularProgressIndicator.adaptive()),
          LoadingState.error => ErrorIndicator(error: controller.error.value,),
          LoadingState.success => _buildSuccessWidget(
            context,
            controller.user.value,
          ),
        };
      },
    );
  }

  Widget _buildSuccessWidget(BuildContext context, User? user) {
    if (user != null) {
      return ResponsivePage(
        header: Column(
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),

            if(user.bio != null)
            Text(
              user.bio!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),

            const SizedBox(height: 36,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatWidget(
                  context,
                  "Followers",
                  user.followers.toString(),
                ),
                _buildStatWidget(
                  context,
                  "Followings",
                  user.following.toString(),
                ),
                _buildStatWidget(
                  context,
                  "Public repos",
                  user.publicRepos.toString(),
                ),
              ],
            ),
          ],
        ),
        body: Placeholder(),
      );
    } else {
      return Center(child: Text("Error: User is null"));
    }
  }
}

Widget _buildStatWidget(BuildContext context, String title, String value) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      Text(
        value,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
      ),
    ],
  );
}
