import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../models/food_item.dart';
import '../data/food_data.dart';
import '../widgets/app_header.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/category_chip.dart';
import '../widgets/food_card.dart';
import 'cart_screen.dart';

/// Screen 4 — Food Menu with category filtering and enhanced parabolic flying add-to-cart animation
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  String _selectedCategory = 'All';

  // Global key to locate the cart icon in the floating bottom bar
  final GlobalKey _cartIconKey = GlobalKey();

  // 1. Shopping Bag Squash & Stretch + 3D Swing Tilt
  late AnimationController _bagImpactController;
  late Animation<double> _bagScaleX;
  late Animation<double> _bagScaleY;
  late Animation<double> _bagRotation;

  // 2. Item Count Badge Elastic Pop
  late AnimationController _badgePopController;
  late Animation<double> _badgeScaleAnimation;

  // 3. Star / Sparkle Particle Burst
  late AnimationController _sparklesController;
  late Animation<double> _sparklesAnimation;

  // 4. Expanding Ripple Wave Ring
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;

  // 5. Floating '+1' Badge
  late AnimationController _plusOneController;
  late Animation<double> _plusOneCurved;

  // Active flying animation items and controllers for seamless rapid taps
  final List<OverlayEntry> _activeEntries = [];
  final List<AnimationController> _activeControllers = [];

  @override
  void initState() {
    super.initState();

    // 1. Shopping Bag Squash & Stretch + Playful Swing Tilt
    _bagImpactController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 540),
    );
    _bagScaleX = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.28).chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.28, end: 0.88).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.88, end: 1.08).chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.08, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
    ]).animate(_bagImpactController);

    _bagScaleY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.80).chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.80, end: 1.25).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.25, end: 0.94).chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.94, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
    ]).animate(_bagImpactController);

    _bagRotation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -0.12).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.12, end: 0.09).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.09, end: -0.04).chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.04, end: 0.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 15,
      ),
    ]).animate(_bagImpactController);

    // 2. Item Count Badge Elastic Pop
    _badgePopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _badgeScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.48).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.48, end: 0.90).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.90, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_badgePopController);

    // 3. Sparkle Particle Burst
    _sparklesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _sparklesAnimation = CurvedAnimation(
      parent: _sparklesController,
      curve: Curves.easeOutCubic,
    );

    // 4. Expanding Ripple Wave
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _rippleAnimation = CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOutQuad,
    );

    // 5. Floating '+1' Badge
    _plusOneController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _plusOneCurved = CurvedAnimation(
      parent: _plusOneController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _bagImpactController.dispose();
    _badgePopController.dispose();
    _sparklesController.dispose();
    _rippleController.dispose();
    _plusOneController.dispose();
    for (final entry in _activeEntries) {
      entry.remove();
    }
    _activeEntries.clear();
    for (final controller in _activeControllers) {
      controller.dispose();
    }
    _activeControllers.clear();
    super.dispose();
  }

  void _triggerImpactReactions() {
    _bagImpactController.forward(from: 0.0);
    _badgePopController.forward(from: 0.0);
    _sparklesController.forward(from: 0.0);
    _rippleController.forward(from: 0.0);
    _plusOneController.forward(from: 0.0);
    HapticFeedback.mediumImpact();
  }

  /// Triggers the parabolic arc flying add-to-cart animation
  void _triggerAddToCartAnimation(GlobalKey imageKey, FoodItem item) {
    final state = context.read<AppState>();
    // 1. Immediately update cart state
    state.addToCart(item);

    // 2. Compute start center and destination cart center
    final renderBoxImage = imageKey.currentContext?.findRenderObject() as RenderBox?;
    final renderBoxCart = _cartIconKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBoxImage == null || renderBoxCart == null) {
      _triggerImpactReactions();
      return;
    }

    final imageSize = renderBoxImage.size;
    final startCenter = renderBoxImage.localToGlobal(
      Offset(imageSize.width / 2, imageSize.height / 2),
    );
    final cartSize = renderBoxCart.size;
    final endCenter = renderBoxCart.localToGlobal(
      Offset(cartSize.width / 2, cartSize.height / 2),
    );

    // Parabolic arc control point:
    // It leaps upward and slightly outward, creating a fluid arc toss into the cart capsule
    final controlPoint = Offset(
      startCenter.dx + (endCenter.dx - startCenter.dx) * 0.25 - 45,
      startCenter.dy - 130, // leaping arc upward
    );

    const double initialOrbSize = 58.0;

    final flightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 680),
    );
    _activeControllers.add(flightController);

    final curved = CurvedAnimation(
      parent: flightController,
      curve: Curves.easeInOutCubic,
    );

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: curved,
          builder: (context, child) {
            final t = curved.value;
            // 2D Quadratic Bézier Curve:
            // B(t) = (1-t)^2 * P0 + 2(1-t)t * P1 + t^2 * P2
            final oneMinusT = 1.0 - t;
            final currentCenterX = oneMinusT * oneMinusT * startCenter.dx +
                2 * oneMinusT * t * controlPoint.dx +
                t * t * endCenter.dx;
            final currentCenterY = oneMinusT * oneMinusT * startCenter.dy +
                2 * oneMinusT * t * controlPoint.dy +
                t * t * endCenter.dy;

            // Orb shrinks dynamically from initialOrbSize to ~22px
            final currentSize = initialOrbSize * (1.0 - (0.62 * t));
            final currentOpacity = t > 0.85 ? ((1.0 - t) / 0.15).clamp(0.0, 1.0) : 1.0;

            return Positioned(
              left: currentCenterX - (currentSize / 2),
              top: currentCenterY - (currentSize / 2),
              child: Opacity(
                opacity: currentOpacity,
                child: Transform.rotate(
                  angle: t * 0.85, // gentle tactile rotation during flight
                  child: Container(
                    width: currentSize,
                    height: currentSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.55),
                          blurRadius: 14,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppTheme.primary,
                          child: const Icon(
                            Icons.restaurant,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    _activeEntries.add(entry);
    Overlay.of(context).insert(entry);

    flightController.forward().then((_) {
      if (mounted) {
        entry.remove();
        _activeEntries.remove(entry);
        flightController.dispose();
        _activeControllers.remove(flightController);

        // Arrival impact reactions:
        _triggerImpactReactions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    // Filter menu items by selected category chip
    final filteredItems = _selectedCategory == 'All'
        ? FoodData.items
        : FoodData.items.where((i) => i.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const AppHeader(title: 'Menu & Pre Order Selection'),
      body: SafeArea(
        child: Stack(
          children: [
            // Scrollable Menu Content
            SingleChildScrollView(
              padding: const EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Indicator
                  const ReservationProgressIndicator(
                    currentStep: ReservationStep.menu,
                  ),
                  const SizedBox(height: 12),

                  // Reservation Context Card
                  _buildReservationContextCard(context, state),
                  const SizedBox(height: 16),

                  // Section Title
                  Text(
                    'What would you like to\neat?',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.onSurface,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.soup_kitchen_outlined, size: 14, color: AppTheme.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Dishes will be freshly prepared for arrival at ${state.selectedTime}.',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.outline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category Chips Row (Horizontal Scroll)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: FoodData.categories.map((cat) {
                        final isSel = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CategoryChip(
                            label: cat,
                            isSelected: isSel,
                            onSelected: () {
                              setState(() {
                                _selectedCategory = cat;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 2-Column Responsive Food Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredItems.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.62,
                    ),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return FoodCard(
                        item: item,
                        onAddToCart: (key) => _triggerAddToCartAnimation(key, item),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Footer notice
                  Center(
                    child: Text(
                      '© 2024 TableTime • Support',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: AppTheme.outline,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            // Floating Bottom Cart Sticky Bar matching Stitch Screen 4
            Positioned(
              left: 18,
              right: 18,
              bottom: 14,
              child: _buildFloatingCartBar(context, state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationContextCard(BuildContext context, AppState state) {
    final tableName = state.selectedTable?.name ?? 'Table 04';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.table_restaurant, size: 16, color: AppTheme.primary),
                const SizedBox(width: 6),
                Text(
                  tableName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 6),
                const Text('•', style: TextStyle(color: AppTheme.outline)),
                const SizedBox(width: 6),
                Text(
                  '${state.partySize} Guests',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(width: 6),
                const Text('•', style: TextStyle(color: AppTheme.outline)),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    state.selectedTime,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusPill),
            ),
            child: const Text(
              'RESERVED',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCartBar(BuildContext context, AppState state) {
    final tableName = state.selectedTable?.name ?? 'Table 04';
    final itemCount = state.totalItemCount;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2825), // Solid dark espresso capsule
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        border: Border.all(
          color: const Color(0xFF443E3A),
          width: 1.2,
        ),
        boxShadow: AppTheme.floatingBarShadow,
      ),
      child: Row(
        children: [
          // Animated Bouncing Cart Icon with Ripple & Badge & Sparkles & +1 Floater
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // 1. Expanding Ripple Wave Ring
              AnimatedBuilder(
                animation: _rippleAnimation,
                builder: (context, child) {
                  if (!_rippleController.isAnimating) return const SizedBox.shrink();
                  final scale = 1.0 + (_rippleAnimation.value * 1.1);
                  final opacity = (1.0 - _rippleAnimation.value).clamp(0.0, 1.0);
                  return Container(
                    width: 42 * scale,
                    height: 42 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primary.withValues(alpha: opacity * 0.85),
                        width: 2.2,
                      ),
                    ),
                  );
                },
              ),

              // 2. Sparkle Particle Burst
              AnimatedBuilder(
                animation: _sparklesAnimation,
                builder: (context, child) {
                  if (!_sparklesController.isAnimating) return const SizedBox.shrink();
                  final progress = _sparklesAnimation.value;
                  final distance = 12.0 + (26.0 * progress);
                  final particleOpacity = (1.0 - progress).clamp(0.0, 1.0);
                  final particleScale = progress < 0.3
                      ? (progress / 0.3)
                      : (1.0 - (progress - 0.3) / 0.7);

                  return Stack(
                    alignment: Alignment.center,
                    children: List.generate(6, (i) {
                      final angle = (i * 60) * (pi / 180.0);
                      final dx = cos(angle) * distance;
                      final dy = sin(angle) * distance;

                      return Transform.translate(
                        offset: Offset(dx, dy),
                        child: Opacity(
                          opacity: particleOpacity,
                          child: Transform.scale(
                            scale: particleScale,
                            child: Icon(
                              i % 2 == 0 ? Icons.auto_awesome : Icons.star_rounded,
                              size: i % 2 == 0 ? 11 : 9,
                              color: i % 2 == 0
                                  ? const Color(0xFFFBBF24)
                                  : const Color(0xFFFB923C),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),

              // 3. Shopping Bag Icon with Physics Squash & Stretch + 3D Tilt Jiggle
              AnimatedBuilder(
                animation: _bagImpactController,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.diagonal3Values(
                      _bagScaleX.value,
                      _bagScaleY.value,
                      1.0,
                    )..rotateZ(_bagRotation.value),
                    child: child,
                  );
                },
                child: Container(
                  key: _cartIconKey,
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),

              // 4. Elastic Pop Item Count Badge
              if (itemCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: ScaleTransition(
                    scale: _badgeScaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEA580C), AppTheme.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.5),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 19,
                        minHeight: 19,
                      ),
                      child: Center(
                        child: Text(
                          '$itemCount',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // 5. Floating '+1' Pop Animation
              AnimatedBuilder(
                animation: _plusOneCurved,
                builder: (context, child) {
                  if (!_plusOneController.isAnimating) return const SizedBox.shrink();
                  final progress = _plusOneCurved.value;
                  final dy = -16.0 - (26.0 * progress);
                  final scale = progress < 0.25
                      ? (0.6 + 0.6 * (progress / 0.25))
                      : (1.2 - 0.2 * ((progress - 0.25) / 0.75));
                  final opacity = (1.0 - progress).clamp(0.0, 1.0);
                  return Positioned(
                    top: dy,
                    child: Opacity(
                      opacity: opacity,
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEA580C), AppTheme.primary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withValues(alpha: 0.6),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            '+1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(width: 14),
          // Price and Items Text with AnimatedSwitcher
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                  child: Text(
                    itemCount == 0
                        ? 'Empty Cart'
                        : '$itemCount Items • ₹${state.subtotal.toStringAsFixed(0)}',
                    key: ValueKey<String>('$itemCount-${state.subtotal}'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.circle, size: 6, color: AppTheme.vegGreen),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'Synced with $tableName',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // View Cart CTA Button
          FilledButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CartScreen(),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              minimumSize: const Size(90, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusPill),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View Cart',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
