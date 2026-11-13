# Health records

## Milk withdrawal

A health record can carry the medicine given and a number of **milk withdrawal days**. The number comes from the medicine label or the vet. The app only counts days; it does not know what is safe.

- The treatment day counts as day 0. A 3-day withdrawal from the 5th means the milk is held through the 8th and is safe from the 9th.
- This errs on the side of caution because the app does not record the time of day.
- The Health list shows "Milk on hold: safe from …" while a hold is active.

Logic is in `lib/health/milk_withdrawal.dart`. The Milk Entry screen shows an orange banner "Milk on hold: do not sell until …" (`lib/screens/widgets/milk_hold_banner.dart`). A dashboard card is the next step.
