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
        body: water.toJson(),
      );
    } catch (e) {
      print("error: $e");
    }
  }
}
