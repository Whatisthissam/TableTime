import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/price_summary.dart';
import 'confirmation_screen.dart';

/// Screen 6 — Checkout Review combining reservation & food pre-order details
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final tableName = state.selectedTable?.name ?? 'Table 04';
    final tableLocation = state.selectedTable?.location ?? 'Main Dining Room';
    final tableCapacity = state.selectedTable?.capacity ?? 2;
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy');
    final formattedDate = dateFormat.format(state.selectedDate);
    final cartList = state.cart.values.toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const AppHeader(title: 'Reservation Checkout'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar (Step 3 Checkout active)
              const ReservationProgressIndicator(
                currentStep: ReservationStep.checkout,
              ),
              const SizedBox(height: 14),

              // Step Tag & Headline
              const Text(
                'STEP 3 OF 3',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Review Your Booking',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Double check your table reservation and pre-ordered dishes.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.outline,
                ),
              ),
              const SizedBox(height: 18),

              // 1. Table Reservation Section Card (with left red accent stripe)
              _buildTableReservationCard(
                context,
                state,
                tableName,
                tableLocation,
                tableCapacity,
                formattedDate,
              ),
              const SizedBox(height: 18),

              // 2. Kitchen Pre-Order Card (Dishes list)
              _buildKitchenPreOrderCard(context, state, cartList),
              const SizedBox(height: 18),

              // 3. Payment Summary Card
              PriceSummary(
                title: 'Payment Summary',
                subtotal: state.subtotal,
                serviceFee: state.serviceFee,
                tax: state.tax,
                total: state.total,
              ),
              const SizedBox(height: 16),

              // 4. Zero Wait Guarantee Badge
              _buildZeroWaitBadge(),
              const SizedBox(height: 20),

              // 5. Primary CTA: Confirm Reservation & Pre-Order
              Container(
                decoration: BoxDecoration(
                  boxShadow: AppTheme.primaryButtonShadow,
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                ),
                child: FilledButton(
                  onPressed: () {
                    // Create official booking object
                    state.createBooking();

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const ConfirmationScreen(),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 20, color: Colors.white),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Confirm Reservation & Pre-Order (₹${state.total.toStringAsFixed(2)})',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 6. Secondary Button: Cancel or Edit Selections
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel or Edit Selections',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.outline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableReservationCard(
    BuildContext context,
    AppState state,
    String tableName,
    String tableLocation,
    int tableCapacity,
    String formattedDate,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius2Xl),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.7)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radius2Xl),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Red/Terracotta vertical accent bar on left matching Stitch
              Container(
                width: 5,
                color: AppTheme.primary,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryLight,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.table_restaurant,
                                    size: 18,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Table Reservation',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.onSurface,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.circle, size: 6, color: AppTheme.vegGreen),
                                          SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              'Table Locked & Reserved',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.vegGreen,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
                              size: 18,
                              color: AppTheme.outline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Reservation Details Grid
                      _buildDetailRow(
                        icon: Icons.calendar_today_outlined,
                        title: 'Date',
                        value: formattedDate,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailRow(
                              icon: Icons.access_time_outlined,
                              title: 'Arrival Time',
                              value: state.selectedTime,
                              subtitle: 'Priority Seating',
                            ),
                          ),
                          Expanded(
                            child: _buildDetailRow(
                              icon: Icons.people_outline,
                              title: 'Guests',
                              value: '${state.partySize} Guests',
                              subtitle: 'Standard seating',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildDetailRow(
                        icon: Icons.chair_alt_outlined,
                        title: 'Selected Table',
                        value: tableName,
                        subtitle: '$tableLocation • Window View (Cap. $tableCapacity)',
                      ),
                      const SizedBox(height: 14),

                      // Holding time notice
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.timer_outlined, size: 14, color: AppTheme.outline),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Holding Time: 15-minute grace period upon arrival',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.outline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppTheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.outline,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.outline,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKitchenPreOrderCard(
    BuildContext context,
    AppState state,
    List cartList,
  ) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.restaurant_menu,
                        size: 16,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Kitchen Pre-Order (${state.totalItemCount} items)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Text(
                  'Edit dishes >',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Dishes list
          ...cartList.map((cartItem) {
            final food = cartItem.foodItem;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.asset(
                        food.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                color: food.isVeg ? AppTheme.vegGreen : AppTheme.nonVegRed,
                                shape: food.isVeg ? BoxShape.circle : BoxShape.rectangle,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                food.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          food.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.outline,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Qty: ${cartItem.quantity}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹${cartItem.lineTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            );
          }),

          // Notice
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, size: 16, color: AppTheme.secondary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Kitchen will fire starter dishes at ${state.selectedTime}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZeroWaitBadge() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.secondaryLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      child: Row(
        children: const [
          Icon(Icons.shield_outlined, size: 20, color: AppTheme.secondary),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zero Wait Guarantee',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.secondary,
                  ),
                ),
                Text(
                  'Your table is reserved and your food will be freshly plated right when you sit.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.onSurfaceVariant,
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
