import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:github_profile_viewer/domain/service/github_data_service.dart';
import 'package:github_profile_viewer/presentation/model/repo.dart';
import 'package:github_profile_viewer/presentation/model/user.dart';
import 'package:github_profile_viewer/utils/exceptions.dart';

class GithubApiService extends GetConnect implements GithubDataService {
  @override
  void onInit() {
    httpClient.baseUrl = "https://api.github.com";

    super.onInit();
  }

  @override
  Future<User> getUser(String username) async {
    final response = await get(
      "/users/$username",
      headers: {"Accept": "application/vnd.github+json"},
    );

    log("Response status: code ${response.statusCode}, message ${response.statusText}", name: 'GitHubApiService:getUser');
    log("Response body: ${response.bodyString}", name: 'GitHubApiService:getUser');
    
    if (response.status.connectionError) {
      throw NoNetworkException();
    } else if (response.status.isNotFound) {
      throw UserNotFoundException();
    }
    return User.fromJson(response.bodyString!);
  }

  @override
  Future<List<RepoMini>> getRepos(String username) async {
     final response = await get(
      "/users/$username/repos",
      headers: {"Accept": "application/vnd.github+json"},
    );

    log("Response status: code ${response.statusCode}, message ${response.statusText}", name: 'GitHubApiService:getUser');
    log("Response body: ${response.bodyString}", name: 'GitHubApiService:getUser');
    
    
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
}
