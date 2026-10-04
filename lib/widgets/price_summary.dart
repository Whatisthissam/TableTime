import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Price breakdown summary card matching Stitch screens 5 & 6
class PriceSummary extends StatelessWidget {
  final double subtotal;
  final double serviceFee;
  final double tax;
  final double total;
  final String title;

  const PriceSummary({
    super.key,
    required this.subtotal,
    required this.serviceFee,
    required this.tax,
    required this.total,
    this.title = 'Bill Breakdown',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius2Xl),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          // Subtotal
          _buildRow('Items Subtotal', '₹${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 10),
          // Service Fee
          _buildRow(
            'Restaurant Service & Kitchen Queue Fee',
            '₹${serviceFee.toStringAsFixed(2)}',
            showInfo: true,
          ),
          const SizedBox(height: 10),
          // Tax
          _buildRow('Taxes (GST 5%)', '₹${tax.toStringAsFixed(2)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: AppTheme.surfaceContainerHigh),
          ),
          // Total Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Inclusive of all duties',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool showInfo = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (showInfo) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppTheme.outline,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
      ],
    );
  }
}
