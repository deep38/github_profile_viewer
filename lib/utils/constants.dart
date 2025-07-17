
sealed class Strings {

  static const appName = 'GitHub Profile Viewer';

  // Error messages
  static const emptyUserNameErrorMessage = 'Please enter username';
  static const invalidUserNameErrorMessage = 'Invalide username. Username can only contain alphabets, numbers and single -(hyphen) inbetween.';
  static const tooLongUserNameErrorMessage = 'Username is too long. it must be less than 40 characters.';
  static const userNotFoundErrorMessage = 'User not found.';
  static const noInternetConnectionErrorMessage = 'No internet connection. Check your connectivity then refresh.';
  static const unexpectedErrorMessage = 'Something went wrong. Please try again.';

  // UI Text
  static const viewProfileButtonText = 'View Profile';
  static const emptyListMessage = 'Nothing to show here.';

  // Key Strings
  static const welcomePageUsernameSubmitButtonKey = 'usernameSubmitButton';
  static const welcomePageUserNameFieldKey = 'usernameInputField';
}


// Dimens
sealed class Dimens {
  static const paddingSmall = 8.0;
  static const paddingMedium = 16.0;
  static const paddingLarge = 32.0;

  static const mediumWidth = 500.0;
}