import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:github_profile_viewer/domain/repos/github_data_repository.dart';
import 'package:github_profile_viewer/presentation/model/repo_mini.dart';
import 'package:github_profile_viewer/presentation/model/user.dart';
import 'package:github_profile_viewer/utils/enums.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePageController extends GetxController {
  ProfilePageController(this._githubRepository);

  final GithubDataRepository _githubRepository;

  final userLoadingState = LoadingState.initial.obs;
  final reposLoadingState = LoadingState.initial.obs;
  final user = Rx<User?>(null);
  final repos = Rx<List<RepoMini>?>(null);
  final error = Rx<Exception?>(null);
  final currentSortBy = SortBy.name.obs;
  final currentSortOrder = SortOrder.asc.obs;

  final TextEditingController searchTextEditingController = TextEditingController();

  String? _currentUserName;
  List<RepoMini>? _repos;

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

  void onSortOrderChange(SortOrder? sortOrder) {
    currentSortOrder.value = sortOrder ?? SortOrder.asc;

    _sortRepos();
  }

  void onSortByChange(SortBy? sortBy) {
    currentSortBy.value = sortBy ?? SortBy.name;

    _sortRepos();
  }

  void filterRepos(String query) {
    searchTextEditingController.text = query;

    repos.value = _repos?.where((repo) => repo.name.contains(query)).toList();
  }

  void onClearSearch() {
    filterRepos("");
  }

  void _sortRepos() {
    switch (currentSortOrder.value) {
      case SortOrder.asc:
        switch (currentSortBy.value) {
          case SortBy.name:
            _sortReposByComparator(
              (first, second) =>
                  first.name.toLowerCase().compareTo(second.name.toLowerCase()),
            );

          case SortBy.stars:
            _sortReposByComparator(
              (first, second) => first.stars.compareTo(second.stars),
            );

          case SortBy.updatedDate:
            _sortReposByComparator(
              (first, second) => first.updatedAt.compareTo(second.updatedAt),
            );
        }
        break;
      case SortOrder.desc:
        switch (currentSortBy.value) {
          case SortBy.name:
            _sortReposByComparator(
              (first, second) =>
                  second.name.toLowerCase().compareTo(first.name.toLowerCase()),
            );

          case SortBy.stars:
            _sortReposByComparator(
              (first, second) => second.stars.compareTo(first.stars),
            );

          case SortBy.updatedDate:
            _sortReposByComparator(
              (first, second) => second.updatedAt.compareTo(first.updatedAt),
            );
        }
        break;
    }
  }

  void _sortReposByComparator(int Function(RepoMini, RepoMini) comparator) {
    repos.value?.sort(comparator);
    if (repos.value?.length == _repos?.length) {
      _repos = repos.value;
    } else {
      _repos?.sort(comparator);
    }
  }

  void _loadRepos(String username) {
    reposLoadingState.value = LoadingState.loading;
    _githubRepository
        .getRepos(username)
        .then((data) {
          _repos = data;
          repos.value = _repos;
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
