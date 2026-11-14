# Mwaura's Farm (Flutter dairy app for small Kenyan farmers)

- Flutter/Dart, Linux desktop target. Drift (SQLite), schema v10, Provider.
- After table changes: `dart run build_runner build --delete-conflicting-outputs`
- Check every change with `flutter analyze` and `flutter test`.
- Run: `flutter run -d linux --dart-define-from-file=$HOME/.config/cow/env.json`
- NEVER read, print or commit `~/.config/cow/env.json` (holds the AI API keys).
- The user's DB is `~/.local/share/com.example.cow/my_database.sqlite`. Back up before schema changes.
- Docs live in README.md, CHANGELOG.md, docs/ (ROADMAP, AI, FINANCE, HEALTH, CALVES). Update them with each step.
- AI settings and providers: see docs/AI.md. Providers are plain HTTP in `lib/services/ai/providers/`.
- Work in small steps. Keep token use low. The user is on a budget.
- The AI vet never gives drug doses.

## Status (branch phase-4)
Done: breeding tracker, AI vet + insights, finance (expenses, monthly report, advisor), milk withdrawal recording and hold logic (`lib/health/milk_withdrawal.dart`, `activeHolds`).
Done: step 8b (milk hold banner on milk entry, `milk_hold_banner.dart`; dashboard card, `milk_hold_card.dart`).
Done: step 9 health reminders (`lib/health/reminders.dart`, `health_reminders_card.dart`, presets in `lib/health/health_presets.dart`).
Done: step 10a read-only calf register (`lib/breeding/calf_register.dart`, `calf_register_screen.dart`, `watchCalvings`).
Done: step 10b schema v10 (`Calves` table, milk `buyer`), calf add/edit (`calf_dialogs.dart`, `docs/CALVES.md`), buyer on milk entry.
Done: earnings per buyer (`lib/models/buyer_earnings.dart`, Monthly Report panel).
Done: step 12 AI provider switching on phase-4 (providers over HTTP, factory `ai_provider_factory.dart`, cross-provider fallback).
Done: step 13 live check (`test/live/ai_live_test.dart`): Gemini and Groq (`compatible`, `openai/gpt-oss-20b`) work; Gemini timeout now 90 s.
Next: rerun the Gemini vet case at 90 s; check Claude/OpenAI when keys exist; then pick from Later (in-app provider settings, Swahili UI, going public).
Done: phase-2 and phase-3 merged into main (fast-forward, 2026-11-13).
Later: Swahili UI.
Later: going public with paid AI (key-holding backend proxy, phone OTP accounts, metering and spending caps, M-Pesa credits, privacy policy + Kenya DPA, app-store billing check, closed beta).