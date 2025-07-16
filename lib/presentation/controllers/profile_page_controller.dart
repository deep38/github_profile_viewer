import 'dart:developer';

import 'package:get/get.dart';
import 'package:github_profile_viewer/domain/repos/github_repository.dart';
import 'package:github_profile_viewer/presentation/model/repo_mini.dart';
import 'package:github_profile_viewer/presentation/model/user.dart';
import 'package:github_profile_viewer/utils/enums.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePageController extends GetxController {
  ProfilePageController(this._githubRepository);

  final GithubRepository _githubRepository;

  final userLoadingState = LoadingState.initial.obs;
  final reposLoadingState = LoadingState.initial.obs;
  final user = Rx<User?>(null);
  final repos = Rx<List<RepoMini>?>(null);
  final error = Rx<Exception?>(null);

  String? _currentUserName;

  void loadUserData(String username) {
    _currentUserName = username;
    userLoadingState.value = LoadingState.loading;
    _githubRepository
        .getUser(username)
        .then((data) {
          user.value = data;
          userLoadingState.value = LoadingState.success;

          _loadRepos(username);
        })
        .catchError((e) {
          log("Error $e");
          if (e is Exception) {
            error.value = e;
          } else {
            error.value = Exception("Unexpected error occured.");
          }
          userLoadingState.value = LoadingState.error;
        });
  }

  void reloadRepos() {
    if (_currentUserName != null) {
      _loadRepos(_currentUserName!);
    }
  }

  void openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
  }

  void _loadRepos(String username) {
    reposLoadingState.value = LoadingState.loading;
    _githubRepository
        .getRepos(username)
        .then((data) {
          repos.value = data;
          reposLoadingState.value = LoadingState.success;
        })
        .catchError((e) {
          log("Error $e");
          if (e is Exception) {
            error.value = e;
          } else {
            error.value = Exception("Unexpected error occured.");
          }
          reposLoadingState.value = LoadingState.error;
        });
  }
}
