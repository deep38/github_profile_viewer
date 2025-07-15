import 'package:github_profile_viewer/presentation/model/repo.dart';
import 'package:github_profile_viewer/presentation/model/user.dart';

abstract class GithubDataService {
  /// Get github user by username
  /// 
  /// Throws [UserNotFoundException], if user is not available with prvided username.
  /// Throws [NoNetworkException], if internet connection is not available.
  Future<User> getUser(String username);

  /// Get github user by username
  /// 
  /// Throws [NoNetworkException], if internet connection is not available.
  Future<List<RepoMini>> getRepos(String username);

}