import 'package:cow/breeding/breeding_schema.dart';

/// Human-readable text for each breeding stage, in one place so every
/// screen words things the same way.
extension BreedingStageLabel on BreedingStage {
  String get label => switch (this) {
    BreedingStage.awaitingService => 'Heat detected — awaiting service',
    BreedingStage.awaitingCheck1 => 'Awaiting 21-day pregnancy check',
    BreedingStage.awaitingCheck2 => 'Awaiting 42-day pregnancy check',
    BreedingStage.awaitingCheck3 => 'Awaiting 63-day pregnancy check',
    BreedingStage.confirmedPregnant =>
      'Pregnancy confirmed — counting down to calving',
    BreedingStage.dryOff => 'Dry-off period (8 weeks to calving)',
    BreedingStage.prep4Weeks => '4 weeks to calving — preparation',
    BreedingStage.prep2Weeks => '2 weeks to calving — preparation',
    BreedingStage.prep1Week => '1 week to calving — final preparation',
    BreedingStage.calved => 'Calved — awaiting outcome',
    BreedingStage.keptAsHeifer => 'Calf kept as heifer',
    BreedingStage.soldCalf => 'Calf sold',
    BreedingStage.failed => 'Returned to heat — re-service needed',
  };
}
