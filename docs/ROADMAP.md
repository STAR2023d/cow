# Roadmap

Work happens in small steps. Each step is checked with `flutter analyze` and `flutter test` before the next one starts.

## Phase 0: Tidy-up

- [x] Fix README
- [x] Remove dead files
- [x] Remove unused `dashboard_analytics.dart` (AI chart widget to be rebuilt in Phase 2/3)
- [x] Central theme file
- [x] Replace default test with real tests
- [x] Split `main_dashboard.dart` into widgets (drawer, milk yield card, herd summary, quick actions and activity)

## Phase 1: Breeding tracker

- [x] Schema and date logic
- [x] Database operations
- [x] Status card
- [x] Per-cow breeding screen
- [x] Dashboard alerts (checks due, dry-off, calving)
- [x] Calf register (read-only, built from breeding cycles)
- [x] Calf register table: birth weight, weaning, calves bought in (schema v10)

## Phase 2: AI vet service

- [x] AI provider interface (`AiGenerator`, replacing `ai_service.dart`) with failure reasons, retry when busy, and a fallback model
- [x] Symptom checker (Vet Assistant) with urgency levels
- [x] Save vet assessments to health records
- [x] Production insights on `AiGenerator`, on demand with caching
- [ ] Offline fallback: useful answers with no internet (today the app explains the failure instead)
- [x] Record medicine and milk withdrawal days on health records
- [x] Warn when logging milk for a cow on hold, and on the dashboard
- [x] Vaccination and tick-control reminders

## Phase 3: AI financial management

- [x] Show calf-sale income in statements (keep `Expenses` for costs, `LedgerEntries` for other income)
- [x] Expense categories
- [x] Earnings per buyer (`BuyerEarnings`, Monthly Report panel)
- [x] Monthly analytics and charts
- [x] AI finance advisor

## Phase 4: UI

- [ ] Dashboard redesign and bottom navigation
- [ ] Responsive layout
- [ ] Swahili / English

## Phase 5: Extras

- [ ] Mastitis tracking
- [ ] Per-cow profitability
- [ ] Backup and export (PDF/CSV)

## Later (after the roadmap)

### AI provider switching

- [x] Call Gemini, Anthropic, OpenAI and OpenAI-compatible services over plain HTTP, replacing `google_generative_ai`
- [x] Provider factory: pick the provider and model from build settings (`--dart-define`), behind the existing `AiGenerator` interface
- [ ] In-app settings screen to switch provider and model
- [x] Cross-provider fallback: when one provider is busy or down, try the next (`AI_FALLBACK_PROVIDERS`)

### Going public with paid AI

- [ ] Backend proxy that holds the API keys (no keys in the app)
- [ ] Accounts with phone-number OTP sign-in
- [ ] Usage metering and spending caps per farmer
- [ ] M-Pesa credits (Daraja or an aggregator)
- [ ] Privacy policy and Kenya Data Protection Act compliance
- [ ] Check app-store billing rules for selling AI credits
- [ ] Closed beta with real farmers
