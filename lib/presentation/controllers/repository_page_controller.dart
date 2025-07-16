import 'dart:developer';

import 'package:get/get.dart';
import 'package:github_profile_viewer/domain/repos/github_repository.dart';
import 'package:github_profile_viewer/presentation/model/repository.dart';
import 'package:github_profile_viewer/utils/enums.dart';
import 'package:url_launcher/url_launcher.dart';

class RepositoryPageController extends GetxController {

  RepositoryPageController(this._githubRepository);
  
  final GithubRepository _githubRepository;
  final loadingState = LoadingState.success.obs;
  final repo = Rx<Repository?>(null);
  final error = Rx<Exception?>(null);

  void loadRepository(String username, String reponame) {
    loadingState.value = LoadingState.loading;
    _githubRepository
        .getRepository(username, reponame)
        .then((data) {
          repo.value = data;
          loadingState.value = LoadingState.success;
        })
        .catchError((e) {
          log("Error $e");
          if (e is Exception) {
            error.value = e;
          } else {
            error.value = Exception("Unexpected error occured.");
          }
          loadingState.value = LoadingState.error;
        });
  }

  void openUrl(String url) async {
    final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
  }
}