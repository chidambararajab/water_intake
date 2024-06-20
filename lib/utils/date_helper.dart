String convertDateTimeToString(DateTime dateTime) {
  String month = dateTime.month.toString();
  String day = dateTime.day.toString();
  String year = dateTime.year.toString();
  if (month.length == 1) {
    month = '0${dateTime.month}';
  }
  if (day.length == 1) {
    day = '0${dateTime.day}';
  }

  return '$year/$month/$day';
}
