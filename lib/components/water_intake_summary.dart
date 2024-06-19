import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/bars/bar_graph.dart';
import 'package:water_intake/data/water_data.dart';

class WaterSummary extends StatelessWidget {
  DateTime startofWeek;
  WaterSummary({super.key, required this.startofWeek});

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterData>(builder: (context, value, child) {
      return const Padding(
        padding: EdgeInsets.only(top: 25.0),
        child: SizedBox(
          height: 200,
          child: BarGraph(
            maxY: 100,
            sunWaterAmt: 19,
            monWaterAmt: 20,
            tueWaterAmt: 34,
            wedWaterAmt: 12,
            thurWaterAmt: 22,
            friWaterAmt: 50,
            satWaterAmt: 45,
          ),
        ),
      );
    });
  }
}
