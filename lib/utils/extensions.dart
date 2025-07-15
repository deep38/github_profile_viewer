extension StringExtensions on String {
  bool isValidUsername() {
    final usernameRegexp = RegExp(r'^[a-zA-Z0-9]+[-]{0,1}[a-zA-Z0-9]+$');
    return usernameRegexp.hasMatch(this);
  }
}


extension DateTimeExtensions on DateTime {
  static const List<String> _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

  String formatToMMMMDDYYYY() {
    return "${_months[month]} $day, $year";
  }
}