import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/booking.dart';
import '../models/cart_item.dart';
import '../screens/reservation_screen.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// Interactive popup window displaying the user's active table booking
/// and pre-ordered dishes as a reminder notification.
class BookingReminderDialog extends StatelessWidget {
  const BookingReminderDialog({super.key});

  /// Static helper to trigger the popup modal window
  static Future<void> show(BuildContext context) {
    // Mark reminder as read when opened
    Provider.of<AppState>(context, listen: false).markReminderAsRead();

    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => const BookingReminderDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final booking = state.activeReminderBooking;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: 440,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppTheme.surfaceContainerHigh,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Popup Window Header
              _buildHeader(context, booking != null),

              // 2. Scrollable Body
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: booking != null
                      ? _buildActiveReminderContent(context, state, booking)
                      : _buildEmptyReminderContent(context, state),
                ),
              ),

              // 3. Footer Action Buttons
              _buildFooterActions(context, state, booking),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool hasBooking) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 14, 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primary.withValues(alpha: 0.15),
                  AppTheme.secondary.withValues(alpha: 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: AppTheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dining & Seat Reminder',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  hasBooking
                      ? 'Upcoming reservation confirmed'
                      : 'No upcoming reservations',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.outline,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, size: 20),
            color: AppTheme.outline,
            tooltip: 'Close',
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.surfaceContainer,
              padding: const EdgeInsets.all(6),
              minimumSize: const Size(32, 32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveReminderContent(
    BuildContext context,
    AppState state,
    Booking booking,
  ) {
    final reservation = booking.reservation;
    final tableName = reservation.selectedTable?.name ?? 'Table 04';
    final section = reservation.selectedTable?.typeLabel ??
        reservation.selectedTable?.location ??
        'Window Booth';
    final arrivalTime = reservation.arrivalTime;
    final guests = reservation.guests;
    final dateStr = DateFormat('EEE, d MMM').format(reservation.date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // A. Primary Seat & Timing Alert Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryLight.withValues(alpha: 0.65),
                AppTheme.secondaryLight.withValues(alpha: 0.35),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(
              color: AppTheme.primary.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top status pill & booking ID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.vegGreenLight,
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                      border: Border.all(
                        color: AppTheme.vegGreen.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppTheme.vegGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Confirmed & Queued',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.vegGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '#${booking.bookingId}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Seat & Time highlight
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.table_restaurant_rounded,
                      color: AppTheme.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$tableName • $section',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Reserved for $arrivalTime ($dateStr)',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$guests Guests • ${booking.restaurantName}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFFED7AA)),
              const SizedBox(height: 8),

              // Helpful reminder note
              Row(
                children: const [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: AppTheme.secondary,
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Please arrive by 5 mins prior. Dishes are synced with your seating.',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // B. Pre-Ordered Food Items Section ("ye ye khane ke sath")
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Pre-Ordered Food',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppTheme.onSurface,
                letterSpacing: -0.2,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainer,
                borderRadius: BorderRadius.circular(AppTheme.radiusPill),
              ),
              child: Text(
                '${booking.cartItems.length} Dishes',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.outline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // List of pre-ordered food items
        ...booking.cartItems.map((cartItem) => _buildFoodItemRow(cartItem)),

        const SizedBox(height: 16),

        // C. Special Instructions (if any)
        if (booking.specialInstructions.trim().isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: AppTheme.surfaceContainerHigh,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.edit_note_rounded,
                  size: 18,
                  color: AppTheme.secondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chef / Kitchen Note',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking.specialInstructions,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // D. Bill & Total Summary
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.outline,
                    ),
                  ),
                  Text(
                    '₹${booking.total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.vegGreenLight,
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                ),
                child: const Text(
                  'Pre-Paid',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.vegGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFoodItemRow(CartItem cartItem) {
    final food = cartItem.foodItem;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: AppTheme.surfaceContainerHigh,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Food photo thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Image.asset(
                food.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppTheme.surfaceContainer,
                  child: const Icon(
                    Icons.restaurant,
                    size: 20,
                    color: AppTheme.outline,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Food name and category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Veg / Non-veg indicator
                    Container(
                      width: 12,
                      height: 12,
                      padding: const EdgeInsets.all(1.5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: food.isVeg ? AppTheme.vegGreen : AppTheme.nonVegRed,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: food.isVeg ? AppTheme.vegGreen : AppTheme.nonVegRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
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
                const SizedBox(height: 4),
                Text(
                  '${cartItem.quantity} × ₹${food.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppTheme.outline,
                  ),
                ),
              ],
            ),
          ),

          // Line total
          Text(
            '₹${cartItem.lineTotal.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyReminderContent(BuildContext context, AppState state) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainer,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.outlineVariant, width: 1),
          ),
          child: const Icon(
            Icons.notifications_off_outlined,
            size: 34,
            color: AppTheme.outline,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'No Active Reservations',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'You do not have any active table bookings or pre-orders queued right now.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.outline,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () {
            state.restoreDefaultReminder();
          },
          icon: const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('Load Demo Reminder'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primary,
            side: const BorderSide(color: AppTheme.primary, width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusPill),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFooterActions(
    BuildContext context,
    AppState state,
    Booking? booking,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        border: Border(
          top: BorderSide(
            color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (booking != null) ...[
            TextButton(
              onPressed: () {
                state.dismissReminder();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reservation reminder dismissed'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text(
                'Dismiss',
                style: TextStyle(
                  color: AppTheme.outline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (booking == null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ReservationScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
              ),
              child: Text(
                booking != null ? 'Got it, Thanks!' : 'Book a Table Now',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
