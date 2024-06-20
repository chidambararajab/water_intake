import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/bars/bar_graph.dart';
import 'package:water_intake/data/water_data.dart';
import 'package:water_intake/utils/date_helper.dart';

class WaterSummary extends StatelessWidget {
  DateTime startofWeek;
  WaterSummary({super.key, required this.startofWeek});

  double calculateMaxY(
    WaterData waterData,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    double? maxAmount = 0;
    Map<String, double> dailyWaterSummary =
        waterData.calculateDailyWaterSummary();
    List<double> values = [
      dailyWaterSummary[sunday] ?? 0,
      dailyWaterSummary[monday] ?? 0,
      dailyWaterSummary[tuesday] ?? 0,
      dailyWaterSummary[wednesday] ?? 0,
      dailyWaterSummary[thursday] ?? 0,
      dailyWaterSummary[friday] ?? 0,
      dailyWaterSummary[saturday] ?? 0
    ];
    values.sort();
    maxAmount = values.last * 1.2;

    return maxAmount == 0 ? 100 : double.parse(maxAmount.toString());
  }

  @override
  Widget build(BuildContext context) {
    String sunday =
        convertDateTimeToString(startofWeek.add(const Duration(days: 0)));
    String monday =
        convertDateTimeToString(startofWeek.add(const Duration(days: 1)));
    String tuesday =
        convertDateTimeToString(startofWeek.add(const Duration(days: 2)));
    String wednesday =
        convertDateTimeToString(startofWeek.add(const Duration(days: 3)));
    String thursday =
        convertDateTimeToString(startofWeek.add(const Duration(days: 4)));
    String friday =
        convertDateTimeToString(startofWeek.add(const Duration(days: 5)));
    String saturday =
        convertDateTimeToString(startofWeek.add(const Duration(days: 6)));

    return Consumer<WaterData>(builder: (context, value, child) {
      Map<String, double> dailyWaterSummary =
          value.calculateDailyWaterSummary();
      return Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: SizedBox(
          height: 200,
          child: BarGraph(
            maxY: calculateMaxY(
              value,
              sunday,
              monday,
              tuesday,
              wednesday,
              thursday,
              friday,
              saturday,
            ),
            sunWaterAmt: dailyWaterSummary[sunday] ?? 0,
            monWaterAmt: dailyWaterSummary[monday] ?? 0,
            tueWaterAmt: dailyWaterSummary[tuesday] ?? 0,
            wedWaterAmt: dailyWaterSummary[wednesday] ?? 0,
            thurWaterAmt: dailyWaterSummary[thursday] ?? 0,
            friWaterAmt: dailyWaterSummary[friday] ?? 0,
            satWaterAmt: dailyWaterSummary[saturday] ?? 0,
          ),
        ),
      );
    });
  }
}
