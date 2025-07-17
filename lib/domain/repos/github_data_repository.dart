import 'dart:convert';

import 'package:github_profile_viewer/domain/service/github_data_service.dart';
import 'package:github_profile_viewer/presentation/model/repo_mini.dart';
import 'package:github_profile_viewer/presentation/model/repository.dart';
import 'package:github_profile_viewer/presentation/model/user.dart';
import 'package:github_profile_viewer/utils/constants.dart';
import 'package:github_profile_viewer/utils/exceptions.dart';

class GithubDataRepository {
  GithubDataRepository(this.service);

  final GithubDataService service;

  Future<User> getUser(String username) async {
    final response = await service.getUser(username);

    if (response.status.connectionError) {
      throw NoNetworkException();
    } else if (response.status.isNotFound) {
      throw NotFoundException(message: Strings.userNotFoundErrorMessage);
    } else if (response.bodyString == null) {
      throw Exception("Response is empty");
    }
    try {
      return User.fromJson(response.bodyString!);
    } catch (e) {
      throw Exception('Failed to parse json.');
    }
  }

  Future<List<RepoMini>> getRepos(String username) async {
    final response = await service.getRepos(username);
    if (response.status.connectionError) {
      throw NoNetworkException();
    } else if (response.status.isNotFound) {
      throw NotFoundException(message: Strings.repositoryListNotFoundErrorMessage);
    } else if (response.bodyString == null) {
      throw Exception("Response is empty");
    }

    try {
      final responseJson = jsonDecode(response.bodyString!);

      if (responseJson is List) {
        return responseJson.map((e) => RepoMini.fromMap(e)).toList();
      } else {
        throw Exception("Unexpected response.");
      }
    } catch (e) {
      throw Exception('Failed to parse json.');
    }
  }

  Future<Repository> getRepository(String username, String reponame) async {
    final response = await service.getRepository(username, reponame);
    if (response.status.connectionError) {
      throw NoNetworkException();
    } else if (response.status.isNotFound) {
      throw NotFoundException(message: Strings.repositoryNotFoundErrorMessage);
    } else if (response.bodyString == null) {
      throw Exception("Response is empty");
    }

    try {
      return Repository.fromJson(response.bodyString!);
    } catch (e) {
      throw Exception("Failed parse json.");
    }
  }
}
