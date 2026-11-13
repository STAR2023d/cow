# Health records

## Milk withdrawal

A health record can carry the medicine given and a number of **milk withdrawal days**. The number comes from the medicine label or the vet. The app only counts days; it does not know what is safe.

- The treatment day counts as day 0. A 3-day withdrawal from the 5th means the milk is held through the 8th and is safe from the 9th.
- This errs on the side of caution because the app does not record the time of day.
- The Health list shows "Milk on hold: safe from …" while a hold is active.

Logic is in `lib/health/milk_withdrawal.dart`. The Milk Entry screen shows an orange banner "Milk on hold: do not sell until …" (`lib/screens/widgets/milk_hold_banner.dart`). The dashboard shows a "Milk on hold" card listing each held cow, its safe date and days left (`lib/screens/widgets/milk_hold_card.dart`); it is hidden when no cow is on hold.

## Health reminders

Reminders come from a record's **follow-up date**. Records have no "done" flag, so a reminder shows while its follow-up date is between 14 days ago and 14 days ahead, then drops off. Logging the follow-up visit does not clear the old reminder; it stays until it is 14 days overdue. A "done" flag would need a schema change.

- The dashboard "Health reminders" card lists them, most overdue first: "Overdue by N days" (red), "Today" (orange), "Tomorrow", "In N days". At most 5 rows, then "+N more". Hidden when there are none.
- Logic is in `lib/health/reminders.dart` (`dueReminders`); the card is `lib/screens/widgets/health_reminders_card.dart`.

### Quick presets

The Log Health Record dialog has preset chips that fill the type, a short description and a suggested follow-up date counted from the record date:

| Preset | Type saved | Follow-up |
| --- | --- | --- |
| Tick control | Tick control | +14 days |
| Vet check | Checkup | +30 days |
| Deworming | Deworming | +90 days |
| Vaccination | Vaccination | +180 days |
| Hoof care | Hoof care | +180 days |

These are rough suggestions only. The farmer can change or remove the date, and the vet's advice comes first. Presets never name a medicine or a dose. A description the farmer already typed is kept. Presets are in `lib/health/health_presets.dart`.
