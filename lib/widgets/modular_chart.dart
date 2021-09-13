import 'package:fl_chart/fl_chart.dart';
import "package:flutter/material.dart";

class ModularChart extends StatelessWidget {
  final Map<String, int> data;

  ModularChart({@required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(
          border: Border(),
        ),
        clipData: FlClipData(
          top: false,
          bottom: false,
          left: false,
          right: false,
        ),
        minY: 1,
        maxY: 6,
        minX: 0.85,
        gridData: FlGridData(
          horizontalInterval: 0.5,
          drawHorizontalLine: false,
          drawVerticalLine: false,
        ),
        lineTouchData: LineTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: false,
        ),
        lineBarsData: [
          LineChartBarData(
            barWidth: 3,
            isCurved: true,
            isStrokeCapRound: true, // à regarder plus tard
            belowBarData: BarAreaData(
              show: true,
              colors: [Colors.green.withOpacity(0.8)],
            ),
            dotData: FlDotData(
                show: true,
                getDotPainter: (a, b, c, d) {
                  return FlDotCirclePainter(
                      strokeWidth: 0, color: Colors.green);
                }),
            colors: [Colors.green],
            spots: [
              FlSpot(1, 4.6),
              FlSpot(2, 4.8),
              FlSpot(3, 4.5),
              FlSpot(4, 4.7),
              FlSpot(5, 5),
              FlSpot(6, 5),
            ],
          ),
        ],
      ),
    );
  }
}
