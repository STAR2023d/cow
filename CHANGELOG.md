# Changelog

## Unreleased

- Rewrote README and added a roadmap
- Removed unused `models/milk.dart` and `models/milk_entry_enum.dart`
- Fixed session totals in analytics (case mismatch); added `MilkSession.afternoon`
- Analytics screen now shows only today's milk entries (was all-time)
- Removed unused `dashboard_analytics.dart`
- Added `lib/theme/app_theme.dart` (`AppColors`, `AppTheme`); screens no longer borrow colours from `MainDashboard`
- Replaced the default counter test with breeding logic, database and theme tests
- Extracted the navigation drawer into `lib/screens/widgets/app_drawer.dart`
- Extracted the 7-day milk yield card into `lib/screens/widgets/milk_yield_card.dart`
- Split `main_dashboard.dart` into widgets: `farm_header_card`, `quick_actions_hub`, `recent_activity_card` (dashboard is now about 70 lines)
- Added per-cow breeding screen (`lib/breeding/breeding_screen.dart`) with cycle history, opened from the Herd list
- Added `watchBreedingHistory` and a `main.dart` entry-point test
- Breeding steps (heat, service, checks, calving) now use a date picker so past events can be recorded accurately
- Added herd-wide breeding overview (`breeding_overview_screen.dart`); the dashboard Breeding button now opens it instead of a placeholder cow
- Added `nextMilestone` logic with tests; stage labels moved to `breeding_labels.dart`
- Added Breeding Alerts card to the dashboard (overdue / due within 7 days / awaiting calf outcome)
- Moved breeding row building into `breeding_rows.dart`, shared by the overview and the alerts card
- Added AI provider interface (`AiGenerator`, `AiResult`) and vet assessment logic with danger-sign override and tests
- Added `docs/AI.md`
- Added Vet Assistant screen (drawer): pick a cow, describe symptoms, get a colour-coded urgency card; danger signs show instantly without internet
- Vet assistant automatically includes the cow's breed, age, breeding stage and last 7 days of milk
- Vet Assistant results can be saved to the cow's health records (type Illness, with a follow-up date)
- AI model can be chosen with `--dart-define=GEMINI_MODEL=...`
- Analytics AI insights now run only when the farmer taps Analyse, are cached for identical milk data, and use the shared `AiGenerator` (fixes repeated AI calls on every redraw)
- Removed the old `ai_service.dart`; default model is now `gemini-3.8-flash`
- AI requests now retry up to twice when Google is overloaded (503) or rate-limited (429), with a clearer "AI is very busy" message
