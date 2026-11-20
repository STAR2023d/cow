# Mwaura's Farm (Flutter dairy app for small Kenyan farmers)

- Flutter/Dart, Linux desktop target. Drift (SQLite), schema v13, Provider.
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
Done: milk entry edit (litres, buyer; `edit_milk_entry_dialog.dart`, `updateMilkEntry`) and delete (`deleteMilkEntry`).
Done: PDF export for Financial Statement and Monthly Report (`lib/services/pdf_layout.dart`, `statement_pdf.dart`, `monthly_report_pdf.dart`, `pdf_export.dart`; saved to Documents/Mwauras Farm, opened with xdg-open).
Done: UX pass started: drawer grouped (Herd, Daily care, Money; no placeholders); whole-herd milk sheet (`herd_milk_sheet.dart`, `lib/models/herd_milk.dart`; dashboard "Log milk" button). Shared formats in `lib/utils/format.dart` (KSh 5,500, 6.5 L, 14 Nov 2026). Light/dark theme: colours via `context.farm.*` (`lib/theme/app_theme.dart`), never fixed `Colors.*` in screens; `ThemeController` (shared_preferences), switch in drawer. Deletes use `deleteWithUndo` (`lib/screens/widgets/undo_delete.dart`) + `restore*` in the DB; cow delete still confirms. UX list done.
Done: milk price setting (`milk_price_screen.dart`, `MilkPriceCard`, `setPricePerLitre` start-of-day + same-day replace; see docs/FINANCE.md). Later: price per buyer (next schema).
Done: milking list (schema v11, `Cow.inMilk`, `setInMilk`; Log milk sheet shows only cows on the list, "Milking list" button edits it).
Gemini default model is `gemini-3.5-flash-lite` (`gemini-3.8-flash` hung for this key, 2026-11-14).
Swahili UI: stages 1-3 of 4 done (see docs/SWAHILI.md). New screen text goes in `lib/l10n/app_en.arb` + `app_sw.arb`, used as `context.l10n.x`; never hard-coded English.
Android (family use, owner chose 2026-11-19): keys stay built into the APK until the app is sold; backend proxy stays in Later. Main manifest has INTERNET. PDFs open on phones via `open_filex` (`openFile` in `pdf_export.dart`). Still to do: try the APK on a real phone.
Done: cows leaving the herd (schema v12, owner chose 2026-11-19: keep records, hide the cow). `removeFromHerd`/`returnToHerd`; daily lists use `watchHerd`/`herdCows`, name lookups on old records keep `watchAllCow`; `deleteCow` deletes all her records (mistakes only, `cowRecordCount` shown). The v12 upgrade runs `deleteOrphanRecords` once. UI: `CowRemoveDialog` (`lib/abstract/dialog_deletion.dart`), `left_herd_screen.dart`.
Done: one milk form (`lib/screens/widgets/milk_log_form.dart`, `MilkLogForm`, `cowId` for one cow) used by `herd_milk_sheet.dart` and `milk_entry.dart`; off-list cows have Add, cow screen has a milking-list switch; `recentBuyers()` feeds buyer chips.
Done: schema v13 `Cow.bornOn` (age from `lib/models/cow_age.dart`, `ageOn`/`ageLabel`; old `age` column unused). Cow edit: `CowAdd(cow: ...)`, `updateCowDetails` (writes only given fields), photos copied by `lib/services/cow_photos.dart`.
Done: Settings screen (`settings_screen.dart`): farm name (`FarmNameController`, `lib/settings/farm_name.dart`, `context.farmName`; never `l10n.appTitle` for the farm name in screens or PDFs), language and colours (`settings_choices.dart`), Erase all data.
Done: Erase all data ( `erase_data_dialog.dart`, `lib/services/erase_data.dart`, `backupTo` VACUUM INTO + `eraseAllData`). Owner's test data erased 2026-11-20; old DB kept as `my_database.before-erase-2026-11-20.sqlite`.
Feeding hidden (owner, 2026-11-19): off drawer and quick actions; `feeding_screen.dart`, `FeedingLog` table and data kept. Feed money = Expenses, Feed category. Making it useful is in ROADMAP Later.
Next: check Claude/OpenAI when keys exist; then pick from Later (in-app provider settings, going public).
Done: phase-2 and phase-3 merged into main (fast-forward, 2026-11-13).
Later (owner said not now, 2026-11-14): Swahili stage 4 (AI answers in app language + Kiswahili danger phrases; needs vet review). Until then AI answers stay English (vet has its own language choice) and the danger check only knows English words.
Later: going public with paid AI (key-holding backend proxy, phone OTP accounts, metering and spending caps, M-Pesa credits, privacy policy + Kenya DPA, app-store billing check, closed beta).