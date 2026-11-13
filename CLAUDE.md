# Mwaura's Farm (Flutter dairy app for small Kenyan farmers)

- Flutter/Dart, Linux desktop target. Drift (SQLite), schema v9, Provider.
- After table changes: `dart run build_runner build --delete-conflicting-outputs`
- Check every change with `flutter analyze` and `flutter test`.
- Run: `flutter run -d linux --dart-define-from-file=$HOME/.config/cow/env.json`
- NEVER read, print or commit `~/.config/cow/env.json` (holds the Gemini key).
- The user's DB is `~/.local/share/com.example.cow/my_database.sqlite`. Back up before schema changes.
- Docs live in README.md, CHANGELOG.md, docs/ (ROADMAP, AI, FINANCE, HEALTH). Update them with each step.
- Work in small steps. Keep token use low. The user is on a budget.
- The AI vet never gives drug doses.

## Status (branch phase-3)
Done: breeding tracker, AI vet + insights, finance (expenses, monthly report, advisor), milk withdrawal recording and hold logic (`lib/health/milk_withdrawal.dart`, `activeHolds`).
Done: step 8b (milk hold banner on milk entry, `milk_hold_banner.dart`; dashboard card, `milk_hold_card.dart`).
Next: pick from Later.
Later: vaccination/tick reminders, calf register, Swahili UI, buyer field, replace `google_generative_ai`, merge phase branches into main.