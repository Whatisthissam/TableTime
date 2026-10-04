import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import 'home_screen.dart';

/// Screen 7 — Confirmation Ticket Screen matching Stitch Screen 7 design
class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final booking = state.confirmedBooking;

    final bookingId = booking?.bookingId ?? 'TT-20458';
    final tableName = booking?.reservation.selectedTable?.name ?? 'Table 04';
    final tableDesc = booking?.reservation.selectedTable?.location ?? 'Window';
    final guests = booking?.reservation.guests ?? state.partySize;
    final arrivalTime = booking?.reservation.arrivalTime ?? state.selectedTime;
    final date = booking?.reservation.date ?? state.selectedDate;

    final dateFormat = DateFormat('EEE, dd MMM');
    final formattedDate = dateFormat.format(date);

    final cartItems = booking?.cartItems ?? state.cart.values.toList();
    final itemCount = cartItems.fold<int>(0, (sum, i) => sum + i.quantity);
    final total = booking?.total ?? state.total;

    final dishesSummary = cartItems
        .map((i) => '${i.foodItem.name} (x${i.quantity})')
        .join(', ');

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppHeader(
        title: 'TableTime',
        showBack: false,
        isModal: true,
        onBack: () => _returnHome(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // 1. Animated Celebration Green Badge
              _buildCelebrationBadge(),
              const SizedBox(height: 18),

              // 2. Headline & Subtitle
              Text(
                "You're All Set!",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.onSurface,
                      letterSpacing: -0.5,
                    ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Your table is reserved and your food has been thoughtfully pre-ordered.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        color: AppTheme.outline,
                        height: 1.45,
                      ),
                ),
              ),
              const SizedBox(height: 22),

              // 3. Realistic Perforated Ticket Card
              _buildTicketCard(
                context,
                bookingId: bookingId,
                tableName: tableName,
                tableDesc: tableDesc,
                guests: guests,
                arrivalTime: arrivalTime,
                formattedDate: formattedDate,
                itemCount: itemCount,
                dishesSummary: dishesSummary,
                total: total,
              ),
              const SizedBox(height: 18),

              // 4. Chef's Promise Card
              _buildChefsPromiseCard(),
              const SizedBox(height: 22),

              // 5. Primary Button: Add to Google Wallet & Calendar
              Container(
                decoration: BoxDecoration(
                  boxShadow: AppTheme.primaryButtonShadow,
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                ),
                child: FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reservation $bookingId added to Wallet & Calendar!'),
                        backgroundColor: AppTheme.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.wallet_outlined, size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Add to Google Wallet & Calendar',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
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

              // 6. Secondary Button: Back to Home
              OutlinedButton(
                onPressed: () => _returnHome(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppTheme.surfaceContainerLow,
                  foregroundColor: AppTheme.onSurface,
                  side: const BorderSide(color: AppTheme.surfaceContainerHigh),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home_outlined, size: 18, color: AppTheme.primary),
                    SizedBox(width: 8),
                    Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Footer
              Center(
                child: Text(
                  '© 2024 TableTime • Need to Modify? • Support',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: AppTheme.outline,
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

  void _returnHome(BuildContext context) {
    context.read<AppState>().resetForNewReservation();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  Widget _buildCelebrationBadge() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Decorative confetti spots
        Positioned(
          left: 4,
          bottom: 4,
          child: Transform.rotate(
            angle: -0.4,
            child: const Icon(Icons.grain, size: 20, color: AppTheme.primary),
          ),
        ),
        Positioned(
          right: 6,
          top: 8,
          child: Transform.rotate(
            angle: 0.5,
            child: const Icon(Icons.star, size: 16, color: AppTheme.secondary),
          ),
        ),
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: AppTheme.vegGreenLight,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.vegGreen.withValues(alpha: 0.3), width: 3),
            boxShadow: [
              BoxShadow(
                color: AppTheme.vegGreen.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.check,
              size: 40,
              color: AppTheme.vegGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketCard(
    BuildContext context, {
    required String bookingId,
    required String tableName,
    required String tableDesc,
    required int guests,
    required String arrivalTime,
    required String formattedDate,
    required int itemCount,
    required String dishesSummary,
    required double total,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius2Xl),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.8)),
      ),
      child: Column(
        children: [
          // Top Terracotta Accent Strip
          Container(
            height: 4,
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radius2Xl)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                // Ticket Header: Restaurant + QR / Booking ID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/food/logo.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.restaurant,
                                  color: AppTheme.primary,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'CONFIRMED RESERVATION',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primary,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Text(
                                  'Le Gourmet Bistro',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // QR Code icon + Booking ID
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.qr_code,
                            size: 22,
                            color: AppTheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 3),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: bookingId));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Copied $bookingId to clipboard!'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                bookingId,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                              const SizedBox(width: 3),
                              const Icon(
                                Icons.copy,
                                size: 11,
                                color: AppTheme.outline,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 2x2 Details Grid Container
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTicketDetailItem(
                              icon: Icons.chair_alt_outlined,
                              label: 'Table',
                              value: '$tableName ($tableDesc)',
                            ),
                          ),
                          Expanded(
                            child: _buildTicketDetailItem(
                              icon: Icons.people_outline,
                              label: 'Party Size',
                              value: '$guests Guests',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTicketDetailItem(
                              icon: Icons.calendar_today_outlined,
                              label: 'Date',
                              value: formattedDate,
                            ),
                          ),
                          Expanded(
                            child: _buildTicketDetailItem(
                              icon: Icons.access_time_outlined,
                              label: 'Arrival Time',
                              value: arrivalTime,
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

          // Perforated Dashed Line Divider with Notches
          _buildPerforatedDivider(),

          // Lower Ticket Section (Pre-ordered items & Total)
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.restaurant_menu, size: 16, color: AppTheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '$itemCount Pre-Ordered Items',
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.vegGreenLight,
                        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                      ),
                      child: const Text(
                        'Kitchen Queued',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.vegGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  dishesSummary.isEmpty ? 'No pre-ordered dishes' : dishesSummary,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: const [
                          Icon(Icons.check_circle_outline, size: 15, color: AppTheme.vegGreen),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Authorized via UPI',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.outline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '₹${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: AppTheme.outline),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerforatedDivider() {
    return SizedBox(
      height: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left Notch Cutout
          Positioned(
            left: -10,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: AppTheme.background,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Dashed Divider line
          LayoutBuilder(
            builder: (context, constraints) {
              const dashWidth = 5.0;
              const dashSpace = 4.0;
              final dashCount = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  dashCount - 2,
                  (_) => Container(
                    width: dashWidth,
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: dashSpace / 2),
                    color: AppTheme.surfaceContainerHigh,
                  ),
                ),
              );
            },
          ),
          // Right Notch Cutout
          Positioned(
            right: -10,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: AppTheme.background,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChefsPromiseCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius2Xl),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.secondaryLight,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('👨‍🍳', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Chef's Promise",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "We'll have everything hot and ready the moment you take your seat. Just display your reservation ticket to the reception host on arrival.",
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.outline,
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
