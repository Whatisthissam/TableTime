import 'package:flutter/material.dart';
import '../models/restaurant_table.dart';
import '../theme/app_theme.dart';

/// Restaurant table card designed to represent a table on the floor plan
class TableCard extends StatelessWidget {
  final RestaurantTable table;
  final bool isSelected;
  final VoidCallback onSelect;

  const TableCard({
    super.key,
    required this.table,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isOccupied = table.isOccupied;

    Color borderColor;
    Color bgColor;
    Color textColor;

    if (isSelected) {
      borderColor = AppTheme.primary;
      bgColor = AppTheme.primaryLight.withValues(alpha: 0.5);
      textColor = AppTheme.primary;
    } else if (isOccupied) {
      borderColor = AppTheme.surfaceContainerHigh;
      bgColor = AppTheme.occupiedBg;
      textColor = AppTheme.occupiedGrey;
    } else {
      borderColor = AppTheme.surfaceContainerHigh;
      bgColor = AppTheme.surface;
      textColor = AppTheme.onSurface;
    }

    return GestureDetector(
      onTap: isOccupied ? null : onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : AppTheme.cardShadow,
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Indicator row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isOccupied)
                        const Icon(Icons.lock_outline, size: 11, color: AppTheme.occupiedGrey)
                      else if (!isSelected)
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: const BoxDecoration(
                            color: AppTheme.vegGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Flexible(
                        child: Text(
                          table.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Visual Restaurant Table shape with chairs
                  _buildTableVisual(context, isSelected, isOccupied),
                  const SizedBox(height: 4),
                  // Subtitle / Type label
                  Flexible(
                    child: Text(
                      isSelected ? 'Selected' : (isOccupied ? (table.timeSlotInfo ?? 'Reserved') : table.typeLabel),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppTheme.primary : (isOccupied ? AppTheme.occupiedGrey : AppTheme.outline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Top Right Checkmark when selected
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableVisual(BuildContext context, bool isSelected, bool isOccupied) {
    Color surfaceColor;
    Color chairColor;
    Color centerTextColor;

    if (isSelected) {
      surfaceColor = AppTheme.primary;
      chairColor = AppTheme.primary;
      centerTextColor = Colors.white;
    } else if (isOccupied) {
      surfaceColor = AppTheme.surfaceContainerHigh;
      chairColor = AppTheme.occupiedGrey.withValues(alpha: 0.5);
      centerTextColor = AppTheme.occupiedGrey;
    } else {
      surfaceColor = AppTheme.surfaceContainer;
      chairColor = AppTheme.vegGreen;
      centerTextColor = AppTheme.onSurfaceVariant;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top chairs
        _buildChairRow(chairColor, table.capacity ~/ 2),
        const SizedBox(height: 3),
        // Central table surface
        Container(
          width: table.capacity > 2 ? 80 : 54,
          height: 44,
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(table.capacity > 4 ? 12 : 8),
          ),
          child: Center(
            child: Text(
              table.capacity > 2 ? '${table.capacity} Guests' : '${table.capacity}p',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: centerTextColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        // Bottom chairs
        _buildChairRow(chairColor, table.capacity ~/ 2),
      ],
    );
  }

  Widget _buildChairRow(Color color, int count) {
    final actualCount = count < 1 ? 1 : count;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        actualCount,
        (index) => Container(
          width: 14,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
