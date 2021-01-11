import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

///
/// Common Util is util class with many static methods
class CommonUtil {
  static String CurrentCountry = "US";
  static const MethodChannel _channel =
      const MethodChannel('flutter_native_image');

  static final dateMonFormat = DateFormat("MM-dd");

  ///
  /// Validate email string
  static bool isValidEmail(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(email);
  }

  static bool isStringNotEmpty(String str) {
    return str != null && str.isNotEmpty;
  }

  static bool isStringEmpty(String str) {
    return str == null || str.isEmpty;
  }

  static bool isHttpUrl(String url) {
    return url.toLowerCase().startsWith('http');
  }

  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  static String baseUrl = "https://api.mocki.io/v1/b4209c6d/";

  static void checkFileAndDelete(File imageFile) async {
    bool val = await imageFile.exists();
    if (val != null && val == true) {
      imageFile.delete(recursive: true);
    }
  }

  static Future<File> compressImage(String fileName,
      {int percentage = 70,
      int quality = 70,
      int targetWidth = 0,
      int targetHeight = 0}) async {
    var file = await _channel.invokeMethod("compressImage", {
      'file': fileName,
      'quality': quality,
      'percentage': percentage,
      'targetWidth': targetWidth,
      'targetHeight': targetHeight
    });

    return new File(file);
  }

  static String getReadableDateString(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    //print(' date $dateTime');
    //print(' today $today');
    final difference = dateTime.difference(now).inDays;
    //print(' difference $difference');
    if (isSaveDay(dateTime, today)) {
      DateFormat format = DateFormat('h:mm a');
      return format.format(dateTime);
    } else if (isSaveDay(dateTime, yesterday)) {
      return 'Yesterday';
    } else if (difference == 1) {
      DateFormat format = DateFormat('E');
      return format.format(dateTime);
    } else if (dateTime.year == today.year) {
      DateFormat format = DateFormat('dd/M');
      return format.format(dateTime);
    } else {
      DateFormat format = DateFormat('dd/M/yyyy');
      return format.format(dateTime);
    }
  }

  static bool isSaveDay(DateTime date1, DateTime date2) {
    if (date1 == null || date2 == null) {
      return false;
      //throw new IllegalArgumentException("The dates must not be null");
    }
    return (date1.year == date2.year &&
        date1.day == date2.day &&
        date1.month == date2.month);
  }

  static String convertStringUtcDateToLocal(
      String dateString, DateFormat convertedDateTimeFormat) {
    String convertedDateString = dateString;
    DateTime date = DateTime.parse(dateString);
    date = DateTime.utc(
        date.year, date.month, date.day, date.hour, date.minute, date.second);
    final convertedDate = date.toLocal();
    convertedDateString = convertedDateTimeFormat.format(convertedDate);
    return convertedDateString;
  }

  static dynamic getJsonVal(Map<String, dynamic> json, String key) {
    return json.containsKey(key) ? json[key] : null;
  }

  static String stringFormat(String template, List replacements) {
    const String placeholderPattern = '(\{\{([a-zA-Z0-9]+)\}\})';
    var regExp = RegExp(placeholderPattern);
    for (var replacement in replacements) {
      template = template.replaceFirst(regExp, replacement.toString());
    }
    return template;
  }
}
