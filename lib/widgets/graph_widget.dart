import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphWidget extends StatelessWidget {
  final List<FlSpot> moodData;

  const GraphWidget({Key? key, required this.moodData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: moodData,
            isCurved: true,
            barWidth: 4,
            color: Colors.blue,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
