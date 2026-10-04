import 'food_item.dart';

/// Represents an item in the cart with quantity and calculated line total.
class CartItem {
  final FoodItem foodItem;
  int quantity;

  CartItem({
    required this.foodItem,
    this.quantity = 1,
  });

  /// Dynamically calculated total for this cart entry
  double get lineTotal => foodItem.price * quantity;
}
