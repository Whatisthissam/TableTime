import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Progress step enum
enum ReservationStep {
  table,
  menu,
  checkout,
}

/// 3-step progress bar strictly styled according to Stitch screens
class ReservationProgressIndicator extends StatelessWidget {
  final ReservationStep currentStep;

  const ReservationProgressIndicator({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        border: Border.all(color: AppTheme.surfaceContainerHigh),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: _buildStep(
              context,
              index: 1,
              label: 'Table',
              isCurrent: currentStep == ReservationStep.table,
              isCompleted: currentStep.index > ReservationStep.table.index,
            ),
          ),
          const Icon(Icons.chevron_right, size: 12, color: AppTheme.outline),
          Flexible(
            child: _buildStep(
              context,
              index: 2,
              label: 'Menu',
              isCurrent: currentStep == ReservationStep.menu,
              isCompleted: currentStep.index > ReservationStep.menu.index,
            ),
          ),
          const Icon(Icons.chevron_right, size: 12, color: AppTheme.outline),
          Flexible(
            child: _buildStep(
              context,
              index: 3,
              label: 'Checkout',
              isCurrent: currentStep == ReservationStep.checkout,
              isCompleted: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required int index,
    required String label,
    required bool isCurrent,
    required bool isCompleted,
  }) {
    if (isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.vegGreenLight,
          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check, size: 12, color: AppTheme.vegGreen),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                '$index $label',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.vegGreen,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (isCurrent) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Text(
        '$index $label',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppTheme.outline,
        ),
      ),
    );
  }
}
