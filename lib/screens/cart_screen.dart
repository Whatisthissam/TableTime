import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/price_summary.dart';
import 'checkout_screen.dart';

/// Screen 5 — Cart Screen matching Stitch Screen 5 design
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final tableName = state.selectedTable?.name ?? 'Table 04';
    final dateFormat = DateFormat('EEE, dd MMM');
    final formattedDate = dateFormat.format(state.selectedDate);
    final itemsList = state.cart.values.toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const AppHeader(title: 'Menu & Pre Order Selection'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Context pill with edit icon
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  border: Border.all(color: AppTheme.surfaceContainerHigh),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 6, color: AppTheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '$tableName • $formattedDate • ${state.selectedTime}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: AppTheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Progress Bar
              const ReservationProgressIndicator(
                currentStep: ReservationStep.menu,
              ),
              const SizedBox(height: 14),

              // Section Header: Pre-Order Dishes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Pre-Order Dishes',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                    ),
                    child: Text(
                      '${state.totalItemCount} items',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              const Text(
                'Items queued for chef preparation upon table seating.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.outline,
                ),
              ),
              const SizedBox(height: 16),

              // Cart Items List or Empty State
              if (state.isCartEmpty)
                _buildEmptyCartView(context)
              else
                Column(
                  children: itemsList.map((cartItem) {
                    return CartItemCard(
                      item: cartItem,
                      onIncrement: () => state.addToCart(cartItem.foodItem),
                      onDecrement: () => state.decrementQuantity(cartItem.foodItem.id),
                      onRemove: () => state.removeItem(cartItem.foodItem.id),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 16),

              // Special Instructions Card
              _buildSpecialInstructionsCard(context, state),
              const SizedBox(height: 16),

              // Zero Wait Guarantee Card
              _buildZeroWaitCard(),
              const SizedBox(height: 16),

              // Bill Breakdown
              PriceSummary(
                subtotal: state.subtotal,
                serviceFee: state.serviceFee,
                tax: state.tax,
                total: state.total,
              ),
              const SizedBox(height: 20),

              // Action Buttons
              // 1. Primary CTA: Continue to Checkout
              Container(
                decoration: BoxDecoration(
                  boxShadow: state.isCartEmpty ? null : AppTheme.primaryButtonShadow,
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                ),
                child: FilledButton(
                  onPressed: state.isCartEmpty
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CheckoutScreen(),
                            ),
                          );
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: state.isCartEmpty ? AppTheme.occupiedGrey : AppTheme.primary,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Flexible(
                        child: Text(
                          'Continue to Checkout',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 2. Secondary Button: + Add more dishes
              Center(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppTheme.surfaceContainerLow,
                    foregroundColor: AppTheme.primary,
                    side: const BorderSide(color: AppTheme.surfaceContainerHigh),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 18, color: AppTheme.primary),
                      SizedBox(width: 6),
                      Text(
                        'Add more dishes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Footer
              Center(
                child: Text(
                  '© 2024 TableTime • Terms • Help',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: AppTheme.outline,
                      ),
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCartView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius2Xl),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: AppTheme.surfaceContainerHigh),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 30,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your pre-order cart is empty',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add dishes from the menu to ensure they are hot & ready when you arrive.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.outline,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.tonal(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Browse Menu'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialInstructionsCard(BuildContext context, AppState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius2Xl),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.edit_note, size: 18, color: AppTheme.secondary),
              SizedBox(width: 8),
              Text(
                'Special Instructions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            onChanged: state.setSpecialInstructions,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Add kitchen note (e.g. less spicy, extra cutlery, dressing on the side)...',
              hintStyle: const TextStyle(fontSize: 12, color: AppTheme.outline),
              filled: true,
              fillColor: AppTheme.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                borderSide: const BorderSide(color: AppTheme.surfaceContainerHigh),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                borderSide: const BorderSide(color: AppTheme.surfaceContainerHigh),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZeroWaitCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.secondaryLight.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(color: AppTheme.secondary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.flash_on,
              size: 18,
              color: AppTheme.secondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Zero Wait Guarantee',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.secondary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Your food will be prepared before your arrival so waiting time is minimized.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
