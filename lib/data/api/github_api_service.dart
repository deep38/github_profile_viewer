import 'package:get/get.dart';
import 'package:github_profile_viewer/domain/service/github_data_service.dart';

class GithubApiService extends GetConnect implements GithubDataService {
  @override
  void onInit() {
    httpClient.baseUrl = "https://api.github.com";

    super.onInit();
  }

  @override
  Future<Response> getUser(String username) async {
    return await get(
      "/users/$username",
      headers: {"Accept": "application/vnd.github+json"},
    );
  }

  @override
  Future<Response> getRepos(String username) async {
     return await get(
      "/users/$username/repos",
      headers: {"Accept": "application/vnd.github+json"},
    );
  }

  
  @override
  Future<Response> getRepository(String username, String reponame) async {
     return await get(
      "/repos/$username/$reponame",
      headers: {"Accept": "application/vnd.github+json"},
    );
  }
}
