import 'package:get/get.dart';

abstract class GithubDataService {
  /// Get github user by username
  /// 
  /// Throws [UserNotFoundException], if user is not available with prvided username.
  /// Throws [NoNetworkException], if internet connection is not available.
  Future<Response> getUser(String username);

  /// Get user repository list by username
  /// 
  /// Throws [NoNetworkException], if internet connection is not available.
  Future<Response> getRepos(String username);

  /// Get repositry details by username and repository name.
  /// 
  /// Throws [NoNetworkException], if internet connection is not available.
  Future<Response> getRepository(String username, String reponame);

  
}