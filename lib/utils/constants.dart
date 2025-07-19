
sealed class Strings {

  static const appName = 'GitHub Profile Viewer';

  // Route parameters
  static const parameterUsername = 'username';
  static const parameterReponame = 'reponame';

  // Error messages
  static const emptyUserNameErrorMessage = 'Please enter username';
  static const invalidUserNameErrorMessage = 'Invalide username. Username can only contain alphabets, numbers and single -(hyphen) inbetween.';
  static const tooLongUserNameErrorMessage = 'Username is too long. it must be less than 40 characters.';
  static const userNotFoundErrorMessage = 'User not found.';
  static const repositoryListNotFoundErrorMessage = 'Repository list not found.';
  static const repositoryNotFoundErrorMessage = 'Repository not found.';
  static const noInternetConnectionErrorMessage = 'No internet connection. Check your connectivity then refresh.';
  static const unexpectedErrorMessage = 'Something went wrong. Please try again.';
  static const userNameOrRepositoryNameNotProvidedErrorMessage = "Username or Repository name not provided.";
  static const userNameNotProvidedErrorMessage = "Username not provided.";
  static const userIsNullErrorMessage = 'Username is null';
  static const failedToLoadImageErrorMessage = 'Failed to load image.';

  // UI Text
  static const viewProfileButtonText = 'View Profile';
  static const retryButtonText = 'Retry';
  static const repositoryListNotFoundMessage = 'No repository found for this user.';
  static const noItemsMatchYourSearch = 'No items matches your search.';
  static const nullRepositoryMessage = "Repository is null";
  static const followersLabel = "Followers";
  static const followingLabel = "Following";
  static const publicReposLabel = "Public repos";
  static const emptyListMessage = "Nothing to show here.";

  // Key Strings
  static const welcomePageUsernameSubmitButtonKey = 'usernameSubmitButton';
  static const welcomePageUserNameFieldKey = 'usernameInputField';
}


// Dimens
sealed class Dimens {
  static const paddingXXSmall = 2.0;
  static const paddingXSmall = 4.0;
  static const paddingSmall = 8.0;
  static const paddingMedium = 16.0;
  static const paddingLarge = 32.0;
  static const paddingXLarge = 64.0;

  static const lineHeightSmall = 16.0;
  static const lineHeightMedium = 24.0;
  static const lineHeightLarge = 40.0;
  static const lineHeightXLarge = 72.0;
  static const lineHeightXXLarge = 120.0;

  /// value: 24.0
  static const lineWidthXXSmall = 24.0;
  /// value: 40.0
  static const lineWidthXSmall = 40.0;
  /// value: 56.0
  static const lineWidthSmall = 56.0;
  /// value: 80.0
  static const lineWidthMedium = 80.0;
  /// value: 112.0
  static const lineWidthLarge = 112.0;
  /// value: 136.0
  static const lineWidthXLarge = 136.0;
  /// value: 160.0
  static const lineWidthXXLarge = 160.0;


  static const sizeMedium = 36.0;

  static const borderRadiusMedium = 16.0;
  static const radiusMedium = 56.0;

  static const widthSmall = 200.0;
  static const widthMedium = 600.0;


  // 160,112,56,120,72,24,40,80
}

sealed class Time {
  static const millisecondsFast = 100;
  static const millisecondsMedium = 300;
}