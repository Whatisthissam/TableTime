import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/table_card.dart';
import 'menu_screen.dart';

/// Screen 3 — Restaurant Floor Plan Table Picker matching Stitch Screen 3
class TableSelectorScreen extends StatelessWidget {
  const TableSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final dateFormat = DateFormat('EEE, dd MMM');
    final formattedDate = dateFormat.format(state.selectedDate);

    // Filter tables by floor area
    final windowTables = state.tables.where((t) => t.location == 'Window View').toList();
    final mainRoomTables = state.tables.where((t) => t.location == 'Main Dining Room').toList();
    final patioTables = state.tables.where((t) => t.location == 'Garden Patio').toList();

    final selected = state.selectedTable;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const AppHeader(title: 'Table Selector'),
      body: SafeArea(
        child: Column(
          children: [
            // Top Scrollable Floor Plan
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress Indicator
                    const ReservationProgressIndicator(
                      currentStep: ReservationStep.table,
                    ),
                    const SizedBox(height: 12),

                    // Subtitle & Reservation Summary Chip
                    const Text(
                      'Select an intimate table perfectly suited for your evening.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.people_alt_outlined, size: 14, color: AppTheme.primary),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Party of ${state.partySize} • $formattedDate • ${state.selectedTime}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Legend Row (Available, Selected, Occupied)
                    _buildLegendRow(),
                    const SizedBox(height: 20),

                    // Zone Header: Window View & Kitchen/Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.wb_sunny_outlined, size: 13, color: AppTheme.outline),
                            SizedBox(width: 4),
                            Text(
                              'WINDOW VIEW',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.outline,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.local_bar_outlined, size: 13, color: AppTheme.outline),
                            SizedBox(width: 4),
                            Text(
                              'KITCHEN & BAR',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.outline,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Window View Tables (Booth 05, T-02)
                    Row(
                      children: windowTables.map((table) {
                        final isSel = selected?.id == table.id;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: TableCard(
                              table: table,
                              isSelected: isSel,
                              onSelect: () => state.selectTable(table),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Divider: Main Dining Room
                    _buildSectionDivider('MAIN DINING ROOM'),
                    const SizedBox(height: 12),

                    // Main Dining Room Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: mainRoomTables.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.86,
                      ),
                      itemBuilder: (context, index) {
                        final table = mainRoomTables[index];
                        final isSel = selected?.id == table.id;
                        return TableCard(
                          table: table,
                          isSelected: isSel,
                          onSelect: () => state.selectTable(table),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Divider: Garden Patio
                    _buildSectionDivider('GARDEN PATIO'),
                    const SizedBox(height: 12),

                    // Garden Patio Table
                    ...patioTables.map((table) {
                      final isSel = selected?.id == table.id;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSel ? AppTheme.primaryLight.withValues(alpha: 0.5) : AppTheme.surface,
                          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                          border: Border.all(
                            color: isSel ? AppTheme.primary : AppTheme.surfaceContainerHigh,
                            width: isSel ? 2 : 1,
                          ),
                          boxShadow: AppTheme.cardShadow,
                        ),
                        child: InkWell(
                          onTap: table.isAvailable ? () => state.selectTable(table) : null,
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isSel ? AppTheme.primary : AppTheme.surfaceContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${table.capacity}p',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isSel ? Colors.white : AppTheme.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          table.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppTheme.vegGreenLight,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'Al Fresco',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.vegGreen,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      table.description,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSel)
                                const Icon(Icons.check_circle, color: AppTheme.primary, size: 22),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // Bottom Selected Table Details & Continue CTA
            if (selected != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radius2Xl)),
                  boxShadow: AppTheme.floatingBarShadow,
                  border: Border.all(color: AppTheme.surfaceContainerHigh),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Selected table info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.table_restaurant,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${selected.name} Selected',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryLight,
                                        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                                      ),
                                      child: const Text(
                                        'Perfect Fit',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${selected.location} • ${selected.capacity} Guests',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  selected.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.outline,
                                  ),
                                ),
                                if (selected.features.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 6,
                                    children: selected.features.map((f) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppTheme.surfaceContainer,
                                          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                                        ),
                                        child: Text(
                                          f,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.onSurfaceVariant,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Continue CTA Button
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: AppTheme.primaryButtonShadow,
                          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                        ),
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const MenuScreen(),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continue to Menu',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '🍴 Next: Choose your pre-order dishes',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        border: Border.all(color: AppTheme.surfaceContainerHigh),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem(AppTheme.vegGreen, 'Available'),
          _buildLegendItem(AppTheme.primary, 'Selected'),
          _buildLegendItem(AppTheme.occupiedGrey, 'Occupied'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionDivider(String title) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppTheme.surfaceContainerHigh)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.outline,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppTheme.surfaceContainerHigh)),
      ],
    );
  }
}
