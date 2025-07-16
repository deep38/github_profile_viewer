import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_profile_viewer/presentation/components/info_chip.dart';
import 'package:github_profile_viewer/presentation/components/loading_state_widget.dart';
import 'package:github_profile_viewer/presentation/controllers/repository_page_controller.dart';
import 'package:github_profile_viewer/presentation/model/repository.dart';
import 'package:github_profile_viewer/utils/enums.dart';
import 'package:github_profile_viewer/utils/extensions.dart';

class RepositoryPage extends StatelessWidget {
  const RepositoryPage({super.key});

  void _loadUserData(RepositoryPageController? controller) {
    final username = Get.parameters['username'];
    final reponame = Get.parameters['reponame'];
    if (username != null && reponame != null) {
      controller?.loadRepository(username, reponame);
    } else {
      controller?.error.value = Exception(
        "Username or Repository name not provided",
      );
      controller?.loadingState.value = LoadingState.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetX<RepositoryPageController>(
        initState: (state) => _loadUserData(state.controller),
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LoadingStateWidget(
              state: controller.loadingState.value,
              success: _buildSuccess(
                context,
                controller.repo.value,
                controller.openUrl,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuccess(
    BuildContext context,
    Repository? repo,
    void Function(String) openUrl,
  ) {
    if (repo != null) {
      final subtitleTextStyle = Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor);

      return Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => openUrl(repo.owner.htmlUrl),
                child: CircleAvatar(
                  radius: 50,
                  foregroundImage: NetworkImage(repo.owner.avatarUrl),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                
                    Wrap(
                      children: [
                        GestureDetector(
                          onTap: () => openUrl(repo.htmlUrl),
                          child: Text(
                            repo.fullName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 4),
                        Container(
                          decoration: BoxDecoration(
                            border: BoxBorder.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Text(
                            repo.visibility.toUpperCase(),
                            style: subtitleTextStyle,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2),
                    Text(
                      "Updated on ${repo.updatedAt.formatToMMMMDDYYYY()}",
                      style: subtitleTextStyle,
                    ),

                    SizedBox(height: 8),
                    if (repo.description != null)
                      Text(repo.description!, style: subtitleTextStyle, maxLines: 2, overflow: TextOverflow.ellipsis,),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            children: [
              if (repo.language != null)
                InfoChip(icon: Icon(Icons.code), label: Text(repo.language!)),
              InfoChip(
                icon: Icon(Icons.star_border_outlined),
                label: Text("${repo.stars} Stars"),
              ),
              InfoChip(
                icon: Icon(Icons.call_split_rounded),
                label: Text("${repo.forks} Forks"),
              ),
              //   ],
              // ),

              // SizedBox(height: 16,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
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
        ],
      );
    }

    return Center(child: Text("Repository is null"));
  }
}
