import 'reservation.dart';
import 'cart_item.dart';

/// Complete confirmed booking model combining reservation and food pre-order
class Booking {
  final String bookingId;
  final Reservation reservation;
  final List<CartItem> cartItems;
  final double subtotal;
  final double serviceFee;
  final double tax;
  final double total;
  final DateTime createdAt;
  final String restaurantName;
  final String specialInstructions;

  const Booking({
    required this.bookingId,
    required this.reservation,
    required this.cartItems,
    required this.subtotal,
    required this.serviceFee,
    required this.tax,
    required this.total,
    required this.createdAt,
    this.restaurantName = 'Le Gourmet Bistro',
    this.specialInstructions = '',
  });
}
