import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:water_intake/bars/bar_data.dart';

class BarGraph extends StatelessWidget {
  final double maxY;
  final double sunWaterAmt;
  final double monWaterAmt;
  final double tueWaterAmt;
  final double wedWaterAmt;
  final double thurWaterAmt;
  final double friWaterAmt;
  final double satWaterAmt;

  const BarGraph({
    super.key,
    required this.maxY,
    required this.sunWaterAmt,
    required this.monWaterAmt,
    required this.tueWaterAmt,
    required this.wedWaterAmt,
    required this.thurWaterAmt,
    required this.friWaterAmt,
    required this.satWaterAmt,
  });

  @override
  Widget build(BuildContext context) {
    BarData barData = BarData(
      sunWaterAmt: sunWaterAmt,
      monWaterAmt: monWaterAmt,
      tueWaterAmt: tueWaterAmt,
      wedWaterAmt: wedWaterAmt,
      thurWaterAmt: thurWaterAmt,
      friWaterAmt: friWaterAmt,
      satWaterAmt: satWaterAmt,
    );
    barData.initBarData();
    return BarChart(BarChartData(
      maxY: maxY,
      minY: 0,
      barGroups: barData.barData
          .map((data) => BarChartGroupData(x: data.x, barRods: [
                BarChartRodData(toY: data.y),
              ]))
          .toList(),
    ));
  }
}
