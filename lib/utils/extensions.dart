extension StringExtensions on String {
  bool isValidUsername() {
    final usernameRegexp = RegExp(r'^[a-zA-Z0-9]+[-]{0,1}[a-zA-Z0-9]+$');
    return usernameRegexp.hasMatch(this);
  }
}
