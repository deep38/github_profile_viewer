import 'package:github_profile_viewer/utils/constants.dart';

sealed class Routes {
  static const _profilePagePrefix = '/user';
  static const _repositoryPagePrefix = '/repo';

  static const profilePagePath = '$_profilePagePrefix/:${Strings.parameterUsername}';
  static const repositoryPagePath = '$_repositoryPagePrefix/:${Strings.parameterUsername}/:${Strings.parameterReponame}';

  static String profilePage(String username) {
    return '$_profilePagePrefix/${username.trim()}';
  }

  static String repositoryPage(String username, String reponame) {
    return '$_repositoryPagePrefix/${username.trim()}/${reponame.trim()}';
  }
}