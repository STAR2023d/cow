import 'package:cow/l10n/language_controller.dart';
import 'package:cow/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Farm name banner at the top of the dashboard.
class FarmHeaderCard extends StatelessWidget {
  const FarmHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: context.farm.faint),
      ),
      child: Column(
        children: [
          Text(
            context.l10n.appTitle.toUpperCase(),
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.l10n.headerTagline,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: context.farm.muted,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
