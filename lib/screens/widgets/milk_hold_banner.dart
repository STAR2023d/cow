import 'package:cow/utils/format.dart';
import 'package:cow/database/app_database.dart';
import 'package:cow/health/milk_withdrawal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Orange warning shown while [cowId]'s milk is on hold after treatment.
/// Shows nothing when there is no active hold.
class MilkHoldBanner extends StatefulWidget {
  final int cowId;

  /// Health records to check; defaults to the database's withdrawal
  /// records. Tests pass their own.
  final Stream<List<HealthRecordData>>? records;

  const MilkHoldBanner({super.key, required this.cowId, this.records});

  @override
  State<MilkHoldBanner> createState() => _MilkHoldBannerState();
}

class _MilkHoldBannerState extends State<MilkHoldBanner> {
  late final Stream<List<HealthRecordData>> _records =
      widget.records ?? context.read<AppDatabase>().watchWithdrawalRecords();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<HealthRecordData>>(
      stream: _records,
      builder: (context, snapshot) {
        final holds = activeHolds(
          snapshot.data ?? const [],
          DateTime.now(),
        ).where((h) => h.cowId == widget.cowId);
        if (holds.isEmpty) return const SizedBox.shrink();
        final safeFrom = weekdayDate(holds.first.withdrawal.safeFrom);
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            border: Border.all(color: Colors.orange.shade700),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange.shade800),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Milk on hold: do not sell until $safeFrom',
                  style: TextStyle(
                    color: Colors.orange.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
