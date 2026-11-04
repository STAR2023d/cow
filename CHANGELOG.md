# Changelog

## Unreleased
- Rewrote README and added a roadmap
- Removed unused `models/milk.dart` and `models/milk_entry_enum.dart`
- Fixed session totals in analytics (case mismatch); added `MilkSession.afternoon`
- Analytics screen now shows only today's milk entries (was all-time)
- Removed unused `dashboard_analytics.dart`
- Added `lib/theme/app_theme.dart` (`AppColors`, `AppTheme`); screens no longer borrow colours from `MainDashboard`
- Replaced the default counter test with breeding logic, database and theme tests