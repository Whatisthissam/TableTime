import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/progress_indicator.dart';
import 'table_selector_screen.dart';

/// Screen 2 — Reservation Details matching Stitch screen 2 design
class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const AppHeader(title: 'Restaurant Detail'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar
              const ReservationProgressIndicator(
                currentStep: ReservationStep.table,
              ),
              const SizedBox(height: 16),

              // 1. Party Size Card
              _buildPartySizeCard(context, state),
              const SizedBox(height: 20),

              // 2. Select Date Section
              _buildSelectDateSection(context, state),
              const SizedBox(height: 20),

              // 3. Arrival Time Section
              _buildArrivalTimeSection(context, state),
              const SizedBox(height: 20),

              // 4. Your Plan Overview Card
              _buildPlanOverviewCard(context, state),
              const SizedBox(height: 16),

              // 5. Step Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: AppTheme.primary),
                      SizedBox(width: 6),
                      Text(
                        'STEP 1 OF 3',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.outline,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Table Selection',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 6. Bottom CTA Button: Choose Your Table
              Container(
                decoration: BoxDecoration(
                  boxShadow: AppTheme.primaryButtonShadow,
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                ),
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const TableSelectorScreen(),
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
                      Text(
                        'Choose Your Table',
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
              ),
              const SizedBox(height: 24),

              // Footer
              Center(
                child: Text(
                  '© 2024 TableTime • Need Help? • Policies',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: AppTheme.outline,
                      ),
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartySizeCard(BuildContext context, AppState state) {
    final quickOptions = [1, 2, 4, 6, 8];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius2Xl),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.7)),
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: const [
                    Icon(Icons.people_outline, size: 20, color: AppTheme.primary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Party Size',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                ),
                child: const Text(
                  'Standard Seating',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Stepper Display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: state.decrementPartySize,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.remove,
                    size: 20,
                    color: AppTheme.onSurface,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${state.partySize} Guests',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      state.partySize <= 2
                          ? 'Recommended for intimate dining'
                          : 'Ideal for group celebrations',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: state.incrementPartySize,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 20,
                    color: AppTheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Quick Select Pills Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: quickOptions.map((count) {
              final isSelected = state.partySize == count;
              final label = count == 8 ? '8+' : '$count';
              return GestureDetector(
                onTap: () => state.setPartySize(count),
                child: Container(
                  width: 46,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : AppTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.primary.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppTheme.onSurface,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectDateSection(BuildContext context, AppState state) {
    final monthFormat = DateFormat('MMMM yyyy');
    final dayFormat = DateFormat('EEE');
    final dayNumFormat = DateFormat('dd');
    final shortMonthFormat = DateFormat('MMM');

    // Generate next 7 days
    final now = DateTime.now();
    final days = List.generate(7, (i) => now.add(Duration(days: i)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: const [
                  Icon(Icons.calendar_today_outlined, size: 18, color: AppTheme.primary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Select Date',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: state.selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );
                if (picked != null) {
                  state.setSelectedDate(picked);
                }
              },
              child: Text(
                monthFormat.format(state.selectedDate),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final date = days[index];
              final isSelected = DateUtils.isSameDay(date, state.selectedDate);

              return GestureDetector(
                onTap: () => state.setSelectedDate(date),
                child: Container(
                  width: 58,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : AppTheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : AppTheme.surfaceContainerHigh,
                      width: isSelected ? 1.8 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.primary.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayFormat.format(date),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? AppTheme.primary : AppTheme.outline,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dayNumFormat.format(date),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? AppTheme.primary : AppTheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        shortMonthFormat.format(date),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? AppTheme.primary : AppTheme.outline,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          width: 20,
                          height: 2.5,
                          margin: const EdgeInsets.only(top: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildArrivalTimeSection(BuildContext context, AppState state) {
    final times = [
      {'time': '6:30 PM', 'label': 'Available'},
      {'time': '7:00 PM', 'label': 'Fast filling'},
      {'time': '7:30 PM', 'label': 'Prime slot'},
      {'time': '8:00 PM', 'label': 'Available'},
      {'time': '8:30 PM', 'label': 'Available'},
      {'time': '9:00 PM', 'label': 'Late table'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: const [
                  Icon(Icons.access_time_outlined, size: 18, color: AppTheme.primary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Arrival Time',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusPill),
              ),
              child: const Row(
                children: [
                  Icon(Icons.restaurant_menu, size: 12, color: AppTheme.primary),
                  SizedBox(width: 4),
                  Text(
                    'Dinner Service',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: times.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.6,
          ),
          itemBuilder: (context, index) {
            final t = times[index];
            final timeStr = t['time']!;
            final labelStr = t['label']!;
            final isSelected = state.selectedTime == timeStr;

            return GestureDetector(
              onTap: () => state.setSelectedTime(timeStr),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.surfaceContainerHigh,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      timeStr,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      labelStr,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white70 : AppTheme.outline,
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

  Widget _buildPlanOverviewCard(BuildContext context, AppState state) {
    final dateFormat = DateFormat('EEEE, dd MMM');
    final formattedDate = dateFormat.format(state.selectedDate);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius2Xl),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                child: Text(
                  'YOUR PLAN OVERVIEW',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.secondary,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Row(
                children: [
                  Icon(Icons.check_circle, size: 14, color: AppTheme.vegGreen),
                  SizedBox(width: 4),
                  Text(
                    'Instant Confirmation',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.vegGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.restaurant,
                  size: 22,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$formattedDate • ${state.selectedTime} • ${state.partySize} Guests',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: const [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.table_restaurant_outlined, size: 13, color: AppTheme.outline),
                            SizedBox(width: 4),
                            Text(
                              'Main Dining Room',
                              style: TextStyle(fontSize: 11, color: AppTheme.outline),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.hourglass_empty, size: 13, color: AppTheme.outline),
                            SizedBox(width: 4),
                            Text(
                              '2h allotment',
                              style: TextStyle(fontSize: 11, color: AppTheme.outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
