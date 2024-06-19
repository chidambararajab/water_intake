import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:water_intake/models/water_model.dart';

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

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        waterDataList.clear();

        var extractedData = json.decode(response.body) as Map<String, dynamic>;
        waterDataList = extractedData.entries
            .map<WaterModel>(
                (e) => WaterModel.fromJson(e.value, DateTime.now().toString()))
            .toList();
        notifyListeners();
        return waterDataList;
      } else {
        return [];
      }
    } catch (e) {
      print("error: $e");
      return [];
    }
  }
}
