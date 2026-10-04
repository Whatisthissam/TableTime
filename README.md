# TableTime – Restaurant Reservation & Food Pre-Order App

A modern, responsive, and tactile Flutter dining application engineered to eliminate physical wait times by seamlessly uniting **table floor-plan reservations** with **pre-arrival food ordering**.

Built with **Flutter**, **Dart**, and **Material 3**, TableTime delivers an end-to-end restaurant guest journey—from browsing available dining zones and selecting specific tables to customizing orders, experiencing fluid Bézier-curve add-to-cart micro-animations, and reviewing bookings with live notification reminders.

---

## Table of Contents
1. [Problem Statement](#problem-statement)
2. [Key Objectives](#key-objectives)
3. [Main Features](#main-features)
4. [Complete User Flow](#complete-user-flow)
5. [Screenshots](#screenshots)
6. [Technology Stack](#technology-stack)
7. [Core Flutter Concepts Used](#core-flutter-concepts-used)
8. [Cart Implementation Using Dart Map](#cart-implementation-using-dart-map)
9. [Dynamic Quantity and Price Calculation](#dynamic-quantity-and-price-calculation)
10. [Add-to-Cart Flight Animation](#add-to-cart-flight-animation)
11. [Restaurant Table Selection](#restaurant-table-selection)
12. [Menu Category Filtering](#menu-category-filtering)
13. [Checkout & Confirmation](#checkout--confirmation)
14. [Project Folder Structure](#project-folder-structure)
15. [How to Run the Project](#how-to-run-the-project)
16. [Deployment on Render](#deployment-on-render)
17. [Testing & Verified Functionality](#testing--verified-functionality)
18. [Limitations](#limitations)

---

## Problem Statement

Traditional dine-in restaurant operations suffer from two major friction points:
1. **Unpredictable Table Wait Times**: Guests arrive at popular restaurants during peak rush hours without knowing table availability, leading to crowded lobbies and long physical wait times.
2. **Post-Seating Kitchen Delays**: After being seated, guests spend 10–15 minutes reviewing menus and placing orders, after which the kitchen requires another 20–35 minutes to prepare dishes. This extends total turnaround time and limits restaurant table turnover.

While existing apps address either food delivery or basic table reservations separately, they lack a unified system that connects **interactive floor-plan table selection** directly with **pre-arrival kitchen food dispatch**.

---

## Key Objectives

- **Zero-Wait Dine-In Experience**: Allow guests to pre-order dishes so the kitchen can begin preparation before their arrival.
- **Interactive Floor Plan Allocation**: Empower guests to view the physical restaurant layout (Main Dining, Window View, Garden Patio) and pick their exact preferred table.
- **Real-Time State Synchronization**: Maintain transparent cart quantities, line totals, taxes (GST 5%), and service fees with $O(1)$ efficiency.
- **Fluid & Tactile Micro-Interactions**: Engage users with custom Bézier-curve flying animations, bouncing buttons, and floating cart capsules.
- **Booking Reminders**: Provide instant visual notification reminders on the home screen for active bookings.

---

## Main Features

- 🏛️ **Dynamic Reservation Configurator**: Quick guest count steppers (1 to 10+ guests), interactive calendar date selection, and meal time slot chips.
- 🪑 **Interactive Restaurant Floor Plan**: Visual status indicators for tables (`Available` vs `Occupied`), seating capacities, ambient location tags (Window, Patio, Indoor), and selection guards.
- 🍽️ **Categorized Digital Menu**: 26 authentic dishes across 6 categories (`Starters`, `Main Course`, `Pizza`, `Burgers`, `Drinks`, `Desserts`) with veg/non-veg tags, chef badges, and descriptions.
- ✨ **Parabolic Add-to-Cart Flight Animation**: Custom physics-based quadratic Bézier curve trajectory flying miniature food orbs directly into the floating cart capsule.
- 🛍️ **Interactive Floating Cart Bar**: Shows dynamic item counts and subtotal, with animated squash-and-stretch shopping bag reactions, starburst sparkles, and `+1` toasts.
- 🛒 **Full-Featured Cart**: Real-time quantity adjustments (`+` / `-`), item removal, line-item price calculation, and kitchen special instructions note field.
- 💳 **Multi-Payment Checkout**: Detailed reservation summary, breakdown of taxes and restaurant fees, and simulated payment methods (UPI, Cards, Net Banking, Pay at Counter).
- 🎟️ **Instant Confirmation Ticket**: Unique generated booking reference ID (`TT-XXXXX`), QR code verification simulation, and home navigation state reset.
- 🔔 **Booking Reminder Dialog**: Interactive bell icon on the home screen displaying current reservation details, arrival time countdown, and pre-ordered dishes.

---

## Complete User Flow

The application follows a linear, 7-stage guided dining flow:

```
[ 1. Home Screen ]
       │
       ▼ (Tap "Reserve Now" or "Book a Table")
[ 2. Reservation Details ] ─── (Pick Party Size, Date & Time Slot)
       │
       ▼ (Tap "Choose Your Table")
[ 3. Table Selector ] ──────── (Inspect Floor Plan & Select Available Table)
       │
       ▼ (Tap "Continue to Menu")
[ 4. Menu & Pre-Order ] ────── (Filter Categories, Add Dishes with Bézier Animation)
       │
       ▼ (Tap "View Cart" Floating Capsule)
[ 5. Cart Screen ] ─────────── (Adjust Quantities, Add Special Kitchen Notes)
       │
       ▼ (Tap "Continue to Checkout")
[ 6. Checkout Screen ] ─────── (Review Booking Summary, Select Payment Method)
       │
       ▼ (Tap "Confirm Reservation & Pre-Order")
[ 7. Confirmation Screen ] ─── (View Booking ID, Table Details & QR Ticket)
       │
       ▼ (Tap "Back to Home")
[ Home Screen (Updated) ] ─── (Bell Icon shows active reminder popup)
```

---

## Screenshots

### Home
[INSERT IPHONE SIMULATOR SCREENSHOT HERE]

### Reservation Details
[INSERT IPHONE SIMULATOR SCREENSHOT HERE]

### Table Selector
[INSERT IPHONE SIMULATOR SCREENSHOT HERE]

### Menu
[INSERT IPHONE SIMULATOR SCREENSHOT HERE]

### Cart
[INSERT IPHONE SIMULATOR SCREENSHOT HERE]

### Checkout
[INSERT IPHONE SIMULATOR SCREENSHOT HERE]

### Confirmation
[INSERT IPHONE SIMULATOR SCREENSHOT HERE]

---

## Technology Stack

- **Flutter SDK**: `^3.13.1` (Supports iOS, Android, Web, macOS, Linux, Windows)
- **Dart SDK**: `^3.13.1` (Sound Null Safety)
- **Design Architecture**: Material 3 (Material You) with custom warm terracotta luxury palette
- **State Management**: `provider: ^6.1.5+1` (`ChangeNotifierProvider` & `ChangeNotifier`)
- **Typography**: `google_fonts: ^6.2.1` (*Outfit* for bold display titles & *Plus Jakarta Sans* for UI body)
- **Date & Number Formatting**: `intl: ^0.20.3`
- **Icons**: `cupertino_icons: ^1.0.8` & Flutter Material Icons

---

## Core Flutter Concepts Used

The application exercises foundational and advanced Flutter framework concepts:

| Concept | Purpose & Implementation in Code |
| :--- | :--- |
| **`Scaffold`** | Provides root visual layout structure with background color, safe area wrapping, and top app bar across all 7 screens. |
| **`AppBar` & `AppHeader`** | Custom reusable app bar (`lib/widgets/app_header.dart`) with responsive back navigation and action controls. |
| **`Container`** | Styled box model with custom borders, rounded corners (`BorderRadius`), linear gradients, and soft elevation shadows. |
| **`Row` & `Column`** | Flexbox layout engines arranging metadata badges, dish titles, price summaries, and stepper controls. |
| **`Card`** | Material surfaces used to display interactive tables, food items, and checkout bill summaries. |
| **`Image` (`Image.asset`)** | Renders 26 high-resolution local food photographs with graceful fallback icon error handlers. |
| **`GridView`** | Implements `SliverGridDelegateWithFixedCrossAxisCount` in `menu_screen.dart` and `table_selector_screen.dart` for responsive two-column layouts. |
| **`Stack`** | Layers elements on top of each other: badges over food images, notification dots over bell icons, floating cart capsules, and flight animation overlays. |
| **`Chips` (`FilterChip`)** | Horizontal scrolling category filter pills (`All`, `Starters`, `Main Course`, `Pizza`, etc.) and time slot selectors. |
| **`OverlayEntry`** | Injects temporary floating animation widgets directly into the root overlay stack without rebuilding the underlying view hierarchy. |
| **`AnimationController`** | Drives precision ticker-based animations for button squashes, Bézier trajectories, badge pops, and icon rotations. |

---

## Cart Implementation Using Dart Map

Rather than using an indexed `List<CartItem>`, the cart is implemented using a Dart `Map<String, CartItem>` keyed by the unique food item ID (`item.id`).

```dart
// lib/state/app_state.dart
class AppState extends ChangeNotifier {
  // Cart State using Map for O(1) operations
  final Map<String, CartItem> _cart = {};

  Map<String, CartItem> get cart => _cart;

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
}
```

### Architectural Benefits:
1. **$O(1)$ Instant Item Lookup**: Checking if an item is already in the cart is instantaneous.
2. **Prevention of Duplicate Entries**: Prevents identical items from appearing as separate rows in the cart.
3. **Clean Quantity Adjustments**: Modifying item count directly by key without running iterative list searches.

---

## Dynamic Quantity and Price Calculation

All pricing calculations are computed dynamically in `AppState` using functional Dart expressions (`.fold()`), ensuring complete consistency across the menu, cart, checkout, and confirmation screens:

$$\text{Subtotal} = \sum (\text{item.price} \times \text{item.quantity})$$

$$\text{Service Fee} = \begin{cases} ₹49.00, & \text{if cart is not empty} \\ ₹0.00, & \text{if cart is empty} \end{cases}$$

$$\text{GST (5\%)} = \text{Subtotal} \times 0.05$$

$$\text{Grand Total} = \text{Subtotal} + \text{Service Fee} + \text{GST}$$

```dart
// lib/state/app_state.dart
int get totalItemCount => 
    _cart.values.fold(0, (sum, item) => sum + item.quantity);

double get subtotal => 
    _cart.values.fold(0.0, (sum, item) => sum + item.lineTotal);

double get serviceFee => 
    _cart.isEmpty ? 0.0 : 49.00;

double get tax => 
    subtotal * 0.05; // 5% GST

double get total => 
    subtotal + serviceFee + tax;
```

---

## Add-to-Cart Flight Animation

When a user taps the add button on any food card, a two-phase coordinated animation is triggered:

1. **Button Spring Reaction**:
   - The tapped `+` button executes an `AnimatedScale` sequence (shrinks to `0.78` then springs to `1.24` before settling) with a $90^\circ$ rotation and haptic feedback.
2. **Quadratic Bézier Parabolic Flight**:
   - The global screen coordinates of the tapped dish image are calculated via `RenderBox.localToGlobal()`.
   - A temporary `OverlayEntry` spawns a miniature food orb with a white border and glow shadow.
   - The orb travels along a 2D quadratic Bézier curve toward the floating bottom cart capsule:

$$B(t) = (1 - t)^2 P_0 + 2(1 - t)t P_1 + t^2 P_2 \quad (t \in [0, 1])$$

Where $P_0$ is the food card center, $P_1$ is an elevated arc apex control point, and $P_2$ is the cart icon center.

3. **Cart Impact Feedback**:
   - On landing, the shopping bag icon executes a squash-and-stretch scale (`0.75` $\rightarrow$ `1.28` $\rightarrow$ `1.0`), tilts dynamically, pulses a starburst ripple, and spawns a floating `+1` indicator.

---

## Restaurant Table Selection

Table selection is governed by the `RestaurantTable` model (`lib/models/restaurant_table.dart`):

- **Data Attributes**: Each table contains an `id`, `name` (e.g., `Booth 05`, `T-01`), `capacity` (2 to 6 guests), `status` (`available` or `occupied`), `location` (Window View, Main Dining Room, Garden Patio), and feature tags.
- **Selection Guard**:
  ```dart
  void selectTable(RestaurantTable table) {
    // Occupied tables cannot be tapped or selected
    if (!table.isAvailable) return;
    _selectedTable = table;
    notifyListeners();
  }
  ```
- **Visual Feedback**:
  - Available tables display warm terracotta borders, guest capacity icons, and ambient tags.
  - Occupied tables are styled in muted greys with a `Reserved` status chip and cannot be selected.

---

## Menu Category Filtering

The menu offers instant category filtering through dynamic `FilterChip` widgets:

- **Categories**: `All`, `Starters` (5 items), `Main Course` (5 items), `Pizza` (4 items), `Burgers` (4 items), `Drinks` (4 items), and `Desserts` (4 items).
- **Reactive Re-filtering**:
  ```dart
  final filteredItems = _selectedCategory == 'All'
      ? FoodData.items
      : FoodData.items.where((i) => i.category == _selectedCategory).toList();
  ```
- **Dietary Distinction**: Every dish displays a green circular badge for Vegetarian or a red triangle badge for Non-Vegetarian items.

---

## Checkout & Confirmation

1. **Review Your Booking**:
   - Displays reserved table badge, guest count, booking date, and arrival time.
   - Lists all pre-ordered dishes with their quantities and line totals.
   - Provides a text field for special dietary notes or kitchen requests.
2. **Transparent Billing**:
   - Itemizes Subtotal, Kitchen Queue & Service Fee (₹49), and 5% GST with total payable amount.
3. **Simulated Payment Gateway**:
   - Selectable payment radio buttons: UPI, Credit/Debit Card, Net Banking, or Pay at Restaurant.
4. **Booking Confirmation Screen**:
   - Generates an instant booking token (`TT-XXXXX`).
   - Displays a simulated QR code ticket.
   - Tapping **Back to Home** resets the cart and reservation state for new bookings while preserving the confirmed booking inside the home notification reminder system.

---

## Project Folder Structure

```
TableTime/
├── .dockerignore                     # Docker build exclusion rules
├── .gitignore                        # Git ignore file (excludes secrets, .env, build caches)
├── Dockerfile                        # Multi-stage container build for Render
├── README.md                         # Comprehensive documentation
├── analysis_options.yaml             # Dart static analysis lint rules
├── nginx.conf                        # Production Nginx SPA routing & caching config
├── pubspec.yaml                      # Dependencies and asset declarations
├── render.yaml                       # Render 1-click blueprint deployment specification
├── assets/
│   ├── food/                         # 26 high-resolution dish image assets
│   └── stitch_screens/               # Reference design assets
├── lib/
│   ├── main.dart                     # App entry point, MultiProvider configuration
│   ├── data/
│   │   ├── food_data.dart            # 26 curated menu items across 6 categories
│   │   └── table_data.dart           # 8 floor-plan tables with status and metadata
│   ├── models/
│   │   ├── booking.dart              # Final confirmed booking record model
│   │   ├── cart_item.dart            # Food item wrapper with mutable quantity
│   │   ├── food_item.dart            # Food dish data model
│   │   ├── reservation.dart          # Reservation parameters model
│   │   └── restaurant_table.dart     # Restaurant table entity and TableStatus enum
│   ├── screens/
│   │   ├── cart_screen.dart          # Pre-order review and quantity management
│   │   ├── checkout_screen.dart      # Billing overview and payment selector
│   │   ├── confirmation_screen.dart  # Booking ticket and QR code view
│   │   ├── home_screen.dart          # Landing dashboard with reminder notification
│   │   ├── menu_screen.dart          # Filterable food grid & Bézier flight animation
│   │   ├── reservation_screen.dart   # Guest count, date, and time slot selector
│   │   └── table_selector_screen.dart# Interactive visual restaurant floor plan
│   ├── state/
│   │   └── app_state.dart            # Centralized ChangeNotifier state manager
│   ├── theme/
│   │   └── app_theme.dart            # Terracotta luxury color palette & typography
│   └── widgets/
│       ├── app_header.dart           # Standardized application navigation bar
│       ├── booking_reminder_dialog.dart # Home notification reminder popup dialog
│       ├── cart_item_card.dart       # Individual cart item card with steppers
│       ├── category_chip.dart        # Horizontal menu category filter pill
│       ├── food_card.dart            # Appetizing food card with spring button
│       ├── price_summary.dart        # Reusable bill breakdown component
│       ├── progress_indicator.dart   # Step-by-step breadcrumb progress bar
│       └── table_card.dart           # Table card with availability states
└── test/
    ├── flow_test.dart                # End-to-end 18-step functional integration test
    └── reminder_dialog_test.dart     # Notification reminder modal widget test
```

---

## How to Run the Project

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.13.1`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.13.1`)
- An active iOS Simulator, Android Emulator, or Google Chrome browser

### Steps

1. **Clone the repository**:
   ```bash
   git clone <YOUR_GITHUB_REPO_URL>
   cd Flutter-MajorProject
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify static analysis**:
   ```bash
   flutter analyze
   ```

4. **Run on connected device or simulator**:
   - **iOS Simulator**:
     ```bash
     flutter run -d ios
     ```
   - **Android Emulator / Device**:
     ```bash
     flutter run -d android
     ```
   - **Google Chrome (Web)**:
     ```bash
     flutter run -d chrome
     ```

5. **Run test suite**:
   ```bash
   flutter test
   ```

---

## Deployment on Render

This repository includes a production-ready **Render Blueprint** (`render.yaml`), **multi-stage Dockerfile** (`Dockerfile`), and **Nginx configuration** (`nginx.conf`) for zero-configuration hosting on [Render](https://render.com).

### Option 1: 1-Click Render Blueprint (Recommended)
1. Push this project to your GitHub repository.
2. Log into your [Render Dashboard](https://dashboard.render.com).
3. Click **New +** $\rightarrow$ **Blueprint**.
4. Connect your GitHub repository. Render will automatically detect `render.yaml`, build the Docker container using Flutter stable, and serve the compiled web assets via Nginx on Render's free tier.

### Option 2: Manual Docker Web Service
1. On Render, click **New +** $\rightarrow$ **Web Service**.
2. Select your GitHub repository.
3. Set the Environment to **Docker**.
4. Set the Health Check Path to `/`.
5. Click **Create Web Service**.

---

## Testing & Completed Functionality

The project includes an end-to-end automated integration test suite (`test/flow_test.dart`) that verifies the full user journey:

```
✓ 1. Launch App (Home Screen loads with branding)
✓ 2. Navigate to Reservation Details
✓ 3. Select Party Size (4 Guests) and Time Slot (8:00 PM)
✓ 4. Navigate to Floor Plan Table Selector
✓ 5. Select Available Table (T-01)
✓ 6. Attempt selecting Occupied Table (T-02) -> Selection Guard verified
✓ 7. Navigate to Menu & Pre-Order Screen
✓ 8. Test Category Filtering (Pizza -> Margherita Pizza displayed, Burgers hidden)
✓ 9. Add Margherita Pizza to cart (triggers flight animation)
✓ 10. Increment Margherita Pizza quantity (cart count updates to 2)
✓ 11. Add Classic Cheeseburger (cart count updates to 3, subtotal ₹947)
✓ 12. Open Cart Screen
✓ 13. Test incrementing and decrementing quantity in Cart
✓ 14. Navigate to Checkout Screen
✓ 15. Verify Reservation summary, Table badge, and Price breakdown
✓ 16. Tap "Confirm Reservation & Pre-Order"
✓ 17. Verify Confirmation Screen with booking reference
✓ 18. Tap "Back to Home" -> Verify State Reset & Home return
```

To run all automated tests:
```bash
flutter test
```

---

## Limitations

1. **Local Assets vs. Firebase Cloud Storage**:
   > **Note on Firebase Cloud Storage**:
   > Firebase Cloud Storage was originally evaluated during project planning for hosting dynamic menu dish photographs. However, it was **not implemented in the final project** because configuring a production Firebase Cloud Storage bucket requires a paid billing plan (Blaze Plan). To maintain zero external billing overhead, full offline reliability, and fast load times, all 26 high-resolution food dish images are bundled locally within `assets/food/`.
2. **Simulated Payment Gateway**: The checkout screen simulates successful transactions via mock payment selectors (UPI, Card, Net Banking) without connecting to a live banking API (e.g., Razorpay or Stripe).
3. **In-Memory State Persistence**: State is managed reactively during the user session using `ChangeNotifier`. Restarting or killing the application process resets the active reservation and cart data unless backed by local persistent storage (e.g., Hive or SQLite).
4. **Single Restaurant Floor Plan**: The current version demonstrates table reservation for a flagship bistro (*Le Gourmet Bistro*); multi-restaurant directory browsing is reserved for future releases.

---

## License

This project is developed as an academic major project for educational and demonstration purposes. All food images are bundled as local demonstration assets.
