# Roadmap

Work happens in small steps. Each step is checked with `flutter analyze` and `flutter test` before the next one starts.

## Phase 0: Tidy-up

- [x] Fix README
- [x] Remove dead files
- [x] Remove unused `dashboard_analytics.dart` (AI chart widget to be rebuilt in Phase 2/3)
- [x] Central theme file
- [x] Replace default test with real tests
- [ ] Split `main_dashboard.dart` into widgets (4a drawer, 4b milk yield card, 4c herd summary, 4d quick actions and activity)

## Phase 1: Breeding tracker

- [x] Schema and date logic
- [x] Database operations
- [x] Status card
- [ ] Per-cow breeding screen
- [ ] Dashboard alerts (checks due, dry-off, calving)
- [ ] Calf register

## Phase 2: AI vet service

- [ ] Restructure `ai_service.dart` with an offline fallback and caching
- [ ] Symptom checker with urgency levels
- [ ] Medicine withdrawal-period warnings
- [ ] Vaccination and tick-control reminders

## Phase 3: AI financial management

- [ ] Unify `Expenses` and `LedgerEntries`
- [ ] Expense categories
- [ ] Earnings per buyer
- [ ] Monthly analytics and charts
- [ ] AI finance advisor

## Phase 4: UI

- [ ] Dashboard redesign and bottom navigation
- [ ] Responsive layout
- [ ] Swahili / English

## Phase 5: Extras

- [ ] Mastitis tracking
- [ ] Per-cow profitability
- [ ] Backup and export (PDF/CSV)
- [x] Split `main_dashboard.dart` into widgets
- [x] Per-cow breeding screen
