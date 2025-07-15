import 'package:github_profile_viewer/presentation/model/user.dart';

abstract class GithubDataService {
  /// Get github user by username
  /// 
  /// Throws [UserNotFoundException], if user is not available with prvided username.
  Future<User> getUser(String username);

  
}