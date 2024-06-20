import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:water_intake/models/water_model.dart';
import 'package:water_intake/utils/date_helper.dart';

class WaterData extends ChangeNotifier {
  List<WaterModel> waterDataList = [];

  void addWaterData(WaterModel water) async {
    try {
      final url = Uri.https(
        'water-intaker-ecb31-default-rtdb.firebaseio.com',
        'water.json',
      );

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(water.toJson()),
      );

      if (response.statusCode == 200) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        waterDataList.add(WaterModel(
          id: extractedData['name'],
          amount: water.amount,
          dateTime: water.dateTime,
          unit: water.unit,
        ));
      } else {
        print("error: ${response.statusCode}");
      }

      notifyListeners();
    } catch (e) {
      print("error: $e");
    }
  }

  Future<List<WaterModel>> getWaterData() async {
    try {
      final url = Uri.https(
        'water-intaker-ecb31-default-rtdb.firebaseio.com',
        'water.json',
      );

      var response = await http.get(url);

      if (response.statusCode == 200 && response.body != 'null') {
        waterDataList.clear();

        var extractedData = json.decode(response.body) as Map<String, dynamic>;
        waterDataList = extractedData.entries
            .map<WaterModel>((e) => WaterModel.fromJson(e.value, e.key))
            .toList();
        notifyListeners();
        return waterDataList;
      } else {
        return [];
      }
    } catch (e) {
      print("error getWaterData: $e");
      return [];
    }
  }

  Future<int> deleteWaterData(String id) async {
    final url = Uri.https(
      'water-intaker-ecb31-default-rtdb.firebaseio.com',
      'water/$id.json',
    );

    var response = await http.delete(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      waterDataList.removeWhere((e) => e.id == id);
    } else {
      print("error: ${response.statusCode}");
    }

    notifyListeners();

    return response.statusCode;
  }

  String getWeekday(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return 'Sunday';
    }
  }

  DateTime getStartOfWeek() {
    DateTime? startOfWeek;

    DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      if (getWeekday(now.subtract(Duration(days: i))) == 'Sunday') {
        startOfWeek = now.subtract(Duration(days: i));
        break;
      }
    }
    return startOfWeek ?? DateTime.now();
  }

  String calculateWeeklyWaterIntake(WaterData value) {
    double weeklyWaterIntake = 0;
    for (var water in value.waterDataList) {
      if (water.dateTime.weekday == DateTime.now().weekday) {
        weeklyWaterIntake += double.parse(water.amount.toString());
      }
    }
    return weeklyWaterIntake
        .toStringAsFixed(2); // Return weekly Water Intake with 2 decimal point.
  }

  Map<String, double> calculateDailyWaterSummary() {
    Map<String, double> dailyWaterSummary = {};

    for (var water in waterDataList) {
      String date = convertDateTimeToString(water.dateTime);
      if (dailyWaterSummary.containsKey(date)) {
        dailyWaterSummary[date] =
            dailyWaterSummary[date]! + double.parse(water.amount.toString());
      } else {
        dailyWaterSummary[date] = double.parse(water.amount.toString());
      }
    }
    return dailyWaterSummary;
  }
}
