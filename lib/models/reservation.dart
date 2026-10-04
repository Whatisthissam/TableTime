import 'restaurant_table.dart';

/// Reservation configuration model
class Reservation {
  final int guests;
  final DateTime date;
  final String arrivalTime;
  final RestaurantTable? selectedTable;

  const Reservation({
    required this.guests,
    required this.date,
    required this.arrivalTime,
    this.selectedTable,
  });

  Reservation copyWith({
    int? guests,
    DateTime? date,
    String? arrivalTime,
    RestaurantTable? selectedTable,
  }) {
    return Reservation(
      guests: guests ?? this.guests,
      date: date ?? this.date,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      selectedTable: selectedTable ?? this.selectedTable,
    );
  }
}
