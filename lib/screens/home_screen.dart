import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/booking_reminder_dialog.dart';
import 'reservation_screen.dart';

/// Screen 1 — Home Landing Page matching Stitch screen 1 design
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Brand Header
              _buildTopHeader(context),
              const SizedBox(height: 18),

              // 2. Hero Restaurant / Chef Curated Card
              _buildHeroCard(context),
              const SizedBox(height: 20),

              // 3. Zero Host Wait Times Badge
              _buildWaitTimePill(),
              const SizedBox(height: 12),

              // 4. Main Headline
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                        height: 1.25,
                        letterSpacing: -0.5,
                      ),
                  children: const [
                    TextSpan(text: 'Reserve your table. Order your food. '),
                    TextSpan(
                      text: 'Be here now.',
                      style: TextStyle(color: AppTheme.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 5. Supporting Description
              Text(
                'Skip the wait. Choose your table and pre-order your favorite dishes before you arrive.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: AppTheme.onSurfaceVariant,
                      height: 1.45,
                    ),
              ),
              const SizedBox(height: 20),

              // 6. Three-Step Interactive Flow Card
              _buildThreeStepFlowCard(),
              const SizedBox(height: 16),

              // 7. Value Prop Dual Cards (0 min wait & Freshly Fired)
              _buildValuePropRow(),
              const SizedBox(height: 22),

              // 8. Primary CTA Button: Reserve Now
              _buildReserveNowButton(context),
              const SizedBox(height: 26),

              // 9. Ready Near You Section
              _buildReadyNearYouSection(context),
              const SizedBox(height: 28),

              // 10. Footer
              Center(
                child: Text(
                  '© 2024 TableTime • Support • Privacy',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: AppTheme.outline,
                      ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Row(
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
                Icons.access_time_filled,
                color: AppTheme.primary,
                size: 22,
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
                'TableTime',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Dine ahead, savor every moment.',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.outline,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Builder(
          builder: (context) {
            final appState = context.watch<AppState>();
            final hasReminder = appState.activeReminderBooking != null;
            final hasUnread = appState.hasUnreadReminder && hasReminder;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => BookingReminderDialog.show(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: hasUnread ? AppTheme.primaryLight : AppTheme.surfaceContainer,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: hasUnread
                              ? AppTheme.primary.withValues(alpha: 0.35)
                              : AppTheme.outlineVariant.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        hasReminder
                            ? (hasUnread
                                ? Icons.notifications_active_rounded
                                : Icons.notifications_outlined)
                            : Icons.notifications_none_outlined,
                        size: 20,
                        color: hasUnread ? AppTheme.primary : AppTheme.onSurface,
                      ),
                    ),
                    if (hasUnread)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radius2Xl),
        boxShadow: AppTheme.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radius2Xl),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/food/pizza.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: AppTheme.surfaceContainer),
            ),
            // Gradient scrim
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
            // Top badges
            Positioned(
              top: 14,
              left: 14,
              right: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'Le Gourmet Bistro',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.onSurface,
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text('•', style: TextStyle(color: AppTheme.outline)),
                          SizedBox(width: 4),
                          Icon(Icons.star, size: 12, color: AppTheme.secondary),
                          SizedBox(width: 2),
                          Text(
                            '4.9',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 7, color: AppTheme.vegGreen),
                        SizedBox(width: 5),
                        Text(
                          'Available Now',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Content
            Positioned(
              bottom: 14,
              left: 14,
              right: 14,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "TONIGHT'S CHEF CURATED",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white70,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Artisanal Hearth Pizza',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Buffalo mozzarella, blistered...',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          '12 min oven',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaitTimePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.secondaryLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 13, color: AppTheme.secondary),
          SizedBox(width: 6),
          Text(
            'Zero Host Wait Times',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreeStepFlowCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppTheme.radius2Xl),
        border: Border.all(color: AppTheme.surfaceContainerHigh),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFlowStep(
              bgColor: const Color(0xFFFFE4E6),
              icon: Icons.table_bar,
              iconColor: const Color(0xFFE11D48),
              title: 'Pick Table',
              subtitle: 'Live floor map',
            ),
          ),
          const Icon(Icons.arrow_forward, size: 14, color: AppTheme.outline),
          Expanded(
            child: _buildFlowStep(
              bgColor: AppTheme.primaryLight,
              icon: Icons.dinner_dining,
              iconColor: AppTheme.primary,
              title: 'Pre-Order',
              subtitle: 'Queued freshly',
            ),
          ),
          const Icon(Icons.arrow_forward, size: 14, color: AppTheme.outline),
          Expanded(
            child: _buildFlowStep(
              bgColor: AppTheme.vegGreenLight,
              icon: Icons.sentiment_satisfied_alt,
              iconColor: AppTheme.vegGreen,
              title: 'Arrive & Dine',
              subtitle: 'Hot upon seating',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowStep({
    required Color bgColor,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 10,
            color: AppTheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildValuePropRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radius2Xl),
              boxShadow: AppTheme.cardShadow,
              border: Border.all(color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_off_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '0 min',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Wait On Arrival',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Walk directly to your table',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radius2Xl),
              boxShadow: AppTheme.cardShadow,
              border: Border.all(color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: AppTheme.vegGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Freshly Fired',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.vegGreen,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Synchronized Dining',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Plated as your party sits',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReserveNowButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: AppTheme.primaryButtonShadow,
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
      ),
      child: FilledButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ReservationScreen(),
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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 18, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Reserve Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildReadyNearYouSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(
              child: Text(
                'Ready Near You',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
            ),
            Text(
              'See all 24 >',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
            boxShadow: AppTheme.cardShadow,
            border: Border.all(color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.6)),
          ),
          child: Row(
            children: [
              // Thumbnail with distance badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    child: SizedBox(
                      width: 68,
                      height: 68,
                      child: Image.asset(
                        'assets/food/pizza.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '0.4 mi',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Le Gourmet Bistro',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Artisanal Italian & Wood-Fi...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.outline,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '15m express',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.vegGreenLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, size: 5, color: AppTheme.vegGreen),
                              SizedBox(width: 3),
                              Text(
                                'Table #12 open',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.vegGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Plus Button
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ReservationScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
