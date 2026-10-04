import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/food_item.dart';
import '../theme/app_theme.dart';

/// Appetizing food item card for the menu 2-column grid.
/// Emits tap event with [GlobalKey] or position for add-to-cart flying animation.
class FoodCard extends StatefulWidget {
  final FoodItem item;
  final void Function(GlobalKey imageKey) onAddToCart;

  const FoodCard({
    super.key,
    required this.item,
    required this.onAddToCart,
  });

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> with SingleTickerProviderStateMixin {
  final GlobalKey _imageKey = GlobalKey();
  late AnimationController _btnController;
  late Animation<double> _btnScale;
  late Animation<double> _btnRotation;
  late Animation<double> _btnRipple;
  late Animation<Color?> _btnColor;

  @override
  void initState() {
    super.initState();
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );

    _btnScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.78).chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.78, end: 1.24).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.24, end: 0.94).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.94, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
    ]).animate(_btnController);

    _btnRotation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.57).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.57, end: 1.57),
        weight: 40,
      ),
    ]).animate(_btnController);

    _btnRipple = CurvedAnimation(
      parent: _btnController,
      curve: Curves.easeOutQuart,
    );

    _btnColor = ColorTween(
      begin: AppTheme.primary,
      end: const Color(0xFFEA580C),
    ).animate(CurvedAnimation(
      parent: _btnController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));
  }

  @override
  void dispose() {
    _btnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Image with Veg/Non-Veg badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTheme.radiusXl),
                ),
                child: SizedBox(
                  key: _imageKey,
                  height: 116,
                  width: double.infinity,
                  child: Image.asset(
                    widget.item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.surfaceContainer,
                      child: const Center(
                        child: Icon(Icons.restaurant, color: AppTheme.outline),
                      ),
                    ),
                  ),
                ),
              ),
              // Veg / Non-Veg Indicator at top-left
              Positioned(
                top: 8,
                left: 8,
                child: _buildDietaryBadge(widget.item.isVeg),
              ),
              // Optional Badge Tag at top-right
              if (widget.item.badgeTag != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                    ),
                    child: Text(
                      widget.item.badgeTag!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dish Name
                Text(
                  widget.item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 3),
                // Short Description
                Text(
                  widget.item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.outline,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                // Price & Add Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${widget.item.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _btnController.forward(from: 0.0);
                        HapticFeedback.mediumImpact();
                        widget.onAddToCart(_imageKey);
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          // Expanding tactile ripple ring
                          AnimatedBuilder(
                            animation: _btnRipple,
                            builder: (context, child) {
                              if (!_btnController.isAnimating) return const SizedBox.shrink();
                              final scale = 1.0 + (_btnRipple.value * 0.85);
                              final opacity = (1.0 - _btnRipple.value).clamp(0.0, 1.0);
                              return Container(
                                width: 32 * scale,
                                height: 32 * scale,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.primary.withValues(alpha: opacity * 0.75),
                                    width: 1.8,
                                  ),
                                ),
                              );
                            },
                          ),
                          // Bouncing Button with rotation and color flash
                          AnimatedBuilder(
                            animation: _btnController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _btnScale.value,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: _btnColor.value ?? AppTheme.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primary.withValues(alpha: 0.45),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Transform.rotate(
                                      angle: _btnRotation.value,
                                      child: const Icon(
                                        Icons.add,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
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

  Widget _buildDietaryBadge(bool isVeg) {
    final color = isVeg ? AppTheme.vegGreen : AppTheme.nonVegRed;
    return Container(
      width: 18,
      height: 18,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Center(
        child: isVeg
            ? Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              )
            : CustomPaint(
                size: const Size(7, 7),
                painter: _TrianglePainter(color),
              ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
