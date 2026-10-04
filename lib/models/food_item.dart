/// Food item model representing dishes in TableTime.
class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isVeg;
  final String category;
  final String? badgeTag; // e.g. "Chef Choice", "12 min oven"

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isVeg,
    required this.category,
    this.badgeTag,
  });
}
