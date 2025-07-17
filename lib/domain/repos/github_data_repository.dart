import 'dart:convert';

import 'package:github_profile_viewer/domain/service/github_data_service.dart';
import 'package:github_profile_viewer/presentation/model/repo_mini.dart';
import 'package:github_profile_viewer/presentation/model/repository.dart';
import 'package:github_profile_viewer/presentation/model/user.dart';
import 'package:github_profile_viewer/utils/exceptions.dart';

class GithubDataRepository {

  GithubDataRepository(this.service);

  final GithubDataService service;

  Future<User> getUser(String username) async {
    final response = await service.getUser(username);

    if (response.status.connectionError) {
      throw NoNetworkException();
    } else if (response.status.isNotFound) {
      throw UserNotFoundException();
    }
    return User.fromJson(response.bodyString!);
  }

  Future<List<RepoMini>> getRepos(String username) async {
    final response = await service.getRepos(username);
    if (response.status.connectionError) {
      throw NoNetworkException();
    } else if (response.status.isNotFound) {
      throw UserNotFoundException();
    }
    
    final responseJson = jsonDecode(response.bodyString!);
    
    if (responseJson is List) {
      return responseJson.map((e) => RepoMini.fromMap(e)).toList();
    } else {
      throw Exception("Unexpected response.");
    }
  }

  Future<Repository> getRepository(String username, String reponame) async {
    final response = await service.getRepository(username, reponame);
    if (response.status.connectionError) {
      throw NoNetworkException();
    } else if (response.status.isNotFound) {
      throw UserNotFoundException();
    }
    
    try {
      if (response.bodyString == null) {
        throw Exception("Response is empty");
      }
      return Repository.fromJson(response.bodyString!);
    } catch (e) {
      throw Exception("Failed parse json.");
    }
  }
}