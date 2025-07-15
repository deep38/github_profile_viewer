import 'dart:developer';

import 'package:get/get.dart';
import 'package:github_profile_viewer/domain/service/github_data_service.dart';
import 'package:github_profile_viewer/presentation/model/repo.dart';
import 'package:github_profile_viewer/presentation/model/user.dart';
import 'package:github_profile_viewer/utils/enums.dart';


class ProfilePageController extends GetxController {
  
  ProfilePageController(this._githubDataService);

  final GithubDataService _githubDataService;

  final userLoadingState = LoadingState.initial.obs;
  final reposLoadingState = LoadingState.initial.obs;
  final user = Rx<User?>(null);
  final repos = Rx<List<RepoMini>?>(null);
  final error = Rx<Exception?>(null);

  void loadUserData(String username) {
    userLoadingState.value = LoadingState.loading;
    _githubDataService.getUser(username)
    .then(
      (data) {
        user.value = data;
        userLoadingState.value = LoadingState.success;

        _loadRepos(username);
      },
    )
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

  void _loadRepos(String username) {
    reposLoadingState.value = LoadingState.loading;
    _githubDataService.getRepos(username)
    .then(
      (data) {
        repos.value = data;
        reposLoadingState.value = LoadingState.success;

      },
    )
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