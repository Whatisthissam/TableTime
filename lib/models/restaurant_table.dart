/// Status enum for restaurant tables
enum TableStatus {
  available,
  selected,
  occupied,
}

/// Model representing a table in the restaurant floor plan
class RestaurantTable {
  final String id;
  final String name; // e.g. "T-04", "Booth 05"
  final int capacity; // e.g. 2, 4, 6
  final TableStatus status;
  final String location; // e.g. "Main Dining Room", "Window View", "Garden Patio"
  final String typeLabel; // e.g. "Window Booth", "Intimate", "Spacious Square"
  final String? timeSlotInfo; // e.g. "7:00 PM" for occupied
  final List<String> features; // e.g. ["Romantic", "Quiet Corner", "Plug Point"]
  final String description;

  const RestaurantTable({
    required this.id,
    required this.name,
    required this.capacity,
    required this.status,
    required this.location,
    required this.typeLabel,
    this.timeSlotInfo,
    this.features = const [],
    this.description = '',
  });

  bool get isAvailable => status == TableStatus.available;
  bool get isOccupied => status == TableStatus.occupied;
  bool get isSelected => status == TableStatus.selected;
}
