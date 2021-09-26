import 'package:fl_chart/fl_chart.dart';
import "package:flutter/material.dart";

class ModularChart extends StatelessWidget {
  final List<Map<DateTime, double>> averages;

  final Color color;

  ModularChart({
    @required this.averages,
    @required this.color,
  });

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
              colors: [color.withOpacity(0.8)],
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (a, b, c, d) {
                return FlDotCirclePainter(strokeWidth: 0, color: color);
              },
            ),
            colors: [color],
            spots: averages.length == 1
                ? [
                    FlSpot(1, averages[0].values.toList()[0]),
                    FlSpot(2, averages[0].values.toList()[0]),
                  ]
                : averages.map((averageDateMap) {
                    return FlSpot(
                        double.parse(
                            (averages.indexOf(averageDateMap) + 1).toString()),
                        averageDateMap.values.toList()[0]);
                  }).toList(),
          ),
        ],
      ),
    );
  }
}
