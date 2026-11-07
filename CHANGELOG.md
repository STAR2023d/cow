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
