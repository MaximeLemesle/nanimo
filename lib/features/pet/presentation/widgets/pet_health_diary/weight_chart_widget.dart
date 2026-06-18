import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';

class WeightChartWidget extends StatelessWidget {
  final List<HealthDiaryWeightLogModel> logs;

  const WeightChartWidget({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 150, child: _buildChart());
  }

  Widget _buildChart() {
    if (logs.length < 2) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        alignment: Alignment.center,
        child: Text(
          'Ajoutez au moins deux mesures pour voir la courbe',
          textAlign: TextAlign.center,
          style:
              AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    final spots = <FlSpot>[
      for (var i = 0; i < logs.length; i++)
        FlSpot(i.toDouble(), logs[i].weight),
    ];

    return LineChart(
      LineChartData(
        minY: 0,
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppColors.backgroundInvert,
            getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
              final index = spot.x.round();
              final date = (index >= 0 && index < logs.length)
                  ? DateFormatter.date(logs[index].loggedAt)
                  : '';
              return LineTooltipItem(
                _formatWeight(spot.y),
                AppTextStyles.textSmallBold
                    .copyWith(color: AppColors.textInvert),
                children: [
                  TextSpan(
                    text: '\n$date',
                    style: AppTextStyles.textSmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textInvert,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            preventCurveOverShooting: true,
            color: AppColors.primary,
            barWidth: 2,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary100.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  String _formatWeight(double weight) =>
      '${weight.toStringAsFixed(1).replaceAll('.', ',')} kg';
}
