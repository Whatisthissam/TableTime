import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/food_item.dart';
import '../models/cart_item.dart';
import '../models/restaurant_table.dart';
import '../models/reservation.dart';
import '../models/booking.dart';
import '../data/table_data.dart';
import '../data/food_data.dart';

/// Centralized state manager for TableTime using ChangeNotifier.
/// Manages reservation parameters, floor-plan tables, cart state,
/// dynamic pricing formulas, confirmed booking records, and active reminders.
class AppState extends ChangeNotifier {
  // --- Reservation State ---
  int _partySize = 2;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTime = '7:30 PM';
  
  late List<RestaurantTable> _tables;
  RestaurantTable? _selectedTable;

  // --- Cart State (Mandatory Map<String, CartItem>) ---
  final Map<String, CartItem> _cart = {};

  // --- Additional Metadata & Reminders ---
  String _specialInstructions = '';
  Booking? _confirmedBooking;
  Booking? _activeReminderBooking;
  bool _hasUnreadReminder = true;

  AppState() {
    _initTables();
    _initDefaultReminder();
  }

  void _initTables() {
    _tables = List.from(TableData.initialTables);
    // Auto-select Table T-04 by default if matching Stitch initial state
    final defaultTable = _tables.firstWhere(
      (t) => t.id == 'table_t04',
      orElse: () => _tables.firstWhere((t) => t.isAvailable),
    );
    _selectedTable = defaultTable;
  }

  void _initDefaultReminder() {
    final defaultTable = _tables.firstWhere(
      (t) => t.id == 'table_t04',
      orElse: () => _tables.first,
    );

    final defaultItems = [
      CartItem(
        foodItem: FoodData.items.firstWhere(
          (i) => i.id == 'pizza_01',
          orElse: () => FoodData.items[0],
        ),
        quantity: 1,
      ),
      CartItem(
        foodItem: FoodData.items.firstWhere(
          (i) => i.id == 'starter_02',
          orElse: () => FoodData.items[1],
        ),
        quantity: 1,
      ),
      CartItem(
        foodItem: FoodData.items.firstWhere(
          (i) => i.id == 'drink_01',
          orElse: () => FoodData.items[2],
        ),
        quantity: 2,
      ),
    ];

    final sub = defaultItems.fold(0.0, (s, i) => s + i.lineTotal);
    const fee = 49.0;
    final tx = sub * 0.05;

    _activeReminderBooking = Booking(
      bookingId: 'TT-40921',
      reservation: Reservation(
        guests: 2,
        date: DateTime.now(),
        arrivalTime: '8:30 PM',
        selectedTable: defaultTable,
      ),
      cartItems: defaultItems,
      subtotal: sub,
      serviceFee: fee,
      tax: tx,
      total: sub + fee + tx,
      createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
      restaurantName: 'Le Gourmet Bistro',
      specialInstructions: 'Window seat preferred. Keep the lime soda extra chilled.',
    );
  }

  // --- Getters ---
  int get partySize => _partySize;
  DateTime get selectedDate => _selectedDate;
  String get selectedTime => _selectedTime;
  List<RestaurantTable> get tables => List.unmodifiable(_tables);
  RestaurantTable? get selectedTable => _selectedTable;
  Map<String, CartItem> get cart => _cart;
  String get specialInstructions => _specialInstructions;
  Booking? get confirmedBooking => _confirmedBooking;
  Booking? get activeReminderBooking => _activeReminderBooking;
  bool get hasUnreadReminder => _hasUnreadReminder;

  // --- Cart Computed Properties ---
  int get totalItemCount => _cart.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _cart.values.fold(0.0, (sum, item) => sum + item.lineTotal);

  /// Restaurant Service & Kitchen Queue Fee (₹49 when cart has items)
  double get serviceFee => _cart.isEmpty ? 0.0 : 49.00;

  /// 5% GST
  double get tax => subtotal * 0.05;

  /// Final dynamic grand total
  double get total => subtotal + serviceFee + tax;

  bool get isCartEmpty => _cart.isEmpty;

  // --- Reservation Mutators ---
  void setPartySize(int size) {
    if (size < 1) return;
    _partySize = size;
    notifyListeners();
  }

  void incrementPartySize() {
    _partySize++;
    notifyListeners();
  }

  void decrementPartySize() {
    if (_partySize > 1) {
      _partySize--;
      notifyListeners();
    }
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  void selectTable(RestaurantTable table) {
    // Only AVAILABLE tables can be selected. Occupied tables cannot be tapped.
    if (!table.isAvailable) return;
    _selectedTable = table;
    notifyListeners();
  }

  // --- Cart Mutators (Dart Map based) ---
  void addToCart(FoodItem item) {
    if (_cart.containsKey(item.id)) {
      _cart[item.id]!.quantity++;
    } else {
      _cart[item.id] = CartItem(foodItem: item, quantity: 1);
    }
    notifyListeners();
  }

  void decrementQuantity(String foodId) {
    if (!_cart.containsKey(foodId)) return;
    final item = _cart[foodId]!;
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _cart.remove(foodId);
    }
    notifyListeners();
  }

  void removeItem(String foodId) {
    if (_cart.containsKey(foodId)) {
      _cart.remove(foodId);
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void setSpecialInstructions(String notes) {
    _specialInstructions = notes;
    notifyListeners();
  }

  // --- Booking Operations ---
  Booking createBooking() {
    final randomDigits = 20000 + Random().nextInt(9000);
    final bookingId = 'TT-$randomDigits';

    final reservation = Reservation(
      guests: _partySize,
      date: _selectedDate,
      arrivalTime: _selectedTime,
      selectedTable: _selectedTable,
    );

    final booking = Booking(
      bookingId: bookingId,
      reservation: reservation,
      cartItems: _cart.values.toList(),
      subtotal: subtotal,
      serviceFee: serviceFee,
      tax: tax,
      total: total,
      createdAt: DateTime.now(),
      restaurantName: 'Le Gourmet Bistro',
      specialInstructions: _specialInstructions,
    );

    _confirmedBooking = booking;
    _activeReminderBooking = booking;
    _hasUnreadReminder = true;
    notifyListeners();
    return booking;
  }

  // --- Reminder Notification Mutators ---
  void markReminderAsRead() {
    if (_hasUnreadReminder) {
      _hasUnreadReminder = false;
      notifyListeners();
    }
  }

  void dismissReminder() {
    _activeReminderBooking = null;
    _hasUnreadReminder = false;
    notifyListeners();
  }

  void restoreDefaultReminder() {
    _initDefaultReminder();
    _hasUnreadReminder = true;
    notifyListeners();
  }

  /// Resets state after booking completion when navigating Back to Home
  void resetForNewReservation() {
    _cart.clear();
    _specialInstructions = '';
    _confirmedBooking = null;
    // Note: _activeReminderBooking is preserved so user can see their active reminder on Home page!
    _partySize = 2;
    _selectedTime = '7:30 PM';
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    _initTables();
    notifyListeners();
  }
}
