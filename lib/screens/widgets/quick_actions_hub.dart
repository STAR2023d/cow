import 'package:cow/l10n/language_controller.dart';
import 'package:cow/breeding/breeding_overview_screen.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/screens/cow_add.dart';
import 'package:cow/screens/feeding_screen.dart';
import 'package:cow/screens/financial_statement_screen.dart';
import 'package:cow/screens/health_screen.dart';
import 'package:cow/screens/widgets/hover_action_button.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Row of shortcut buttons (add cow, statement, feeding, health, breeding).
class QuickActionsHub extends StatelessWidget {
  final AppDatabase db;

  const QuickActionsHub({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _QuickAction(
                  icon: Icons.add,
                  label: context.l10n.qaAddCow,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CowAdd()),
                  ),
                ),
              ),
              Expanded(
                child: _QuickAction(
                  icon: Icons.receipt_long,
                  label: context.l10n.qaStatement,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatementScreen(db: db),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _QuickAction(
                  icon: Icons.grass,
                  label: context.l10n.navFeeding,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedingScreen(db: db),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _QuickAction(
                  icon: Icons.health_and_safety,
                  label: context.l10n.navHealth,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HealthScreen(db: db),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _QuickAction(
                  icon: Icons.favorite,
                  label: context.l10n.navBreeding,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BreedingOverviewScreen(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HoverActionButton(icon: icon, onPressed: onPressed),
        const SizedBox(height: 8.0),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, color: context.farm.muted),
        ),
      ],
    );
  }
}
