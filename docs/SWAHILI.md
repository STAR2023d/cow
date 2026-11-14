# Kiswahili UI

The app speaks English or Kiswahili. The farmer picks the language in the drawer (**Language: English / Kiswahili**); the choice is remembered (`LanguageController`, `shared_preferences`). Flutter's own parts (date picker, Back buttons) follow it, and so do dates through `lib/utils/format.dart` (`Intl.defaultLocale`).

## How strings work

- English: `lib/l10n/app_en.arb` (the template, with notes for translators). Kiswahili: `lib/l10n/app_sw.arb`.
- `flutter gen-l10n` (also run by `flutter pub get` / build) writes `lib/l10n/app_localizations*.dart` (class `L10n`). These generated files are committed.
- In code: `context.l10n.logMilk`, or `context.l10n.daysLeft(3)` for strings with values and plurals. Never build sentences by joining English pieces; add a whole sentence with placeholders to both ARB files.
- Values saved in English stay English in the database and are translated only on screen: milking sessions (`sessionLabel`), feed types (`feedTypeLabel`), health record types (`recordTypeLabel`). Breeding stage, milestone and due texts are computed in English for the AI vet prompt and tests; screens show `stageText`, `milestoneText` and `dueText` (`lib/l10n/labels.dart`).
- A test fails if `app_sw.arb` is missing any English key (`test/l10n_test.dart`).

## Review needed

The Kiswahili was written by the AI assistant, not a native speaker. **Before farmers use it, a native Kenyan speaker must review `app_sw.arb`**, preferring words farmers actually use (for example "lita", "ng'ombe", "maziwa yamezuiliwa"). Corrections only touch the ARB file.

## Progress

1. Done (2026-11-14): setup, language switch, dashboard and its cards, drawer, Log milk sheet, milk price screens, undo messages.
2. Done (2026-11-14): herd and add cow, single-cow milk entry, feeding, health (record types and presets), breeding, cow delete dialog.
3. Expenses, statement, monthly report, PDFs, calves, analytics.
4. AI: answers in the app language (vet, insights, finance advisor), and Kiswahili danger phrases for the vet's "call a vet now" check. Safety-related: needs a vet or extension officer to review the phrase list.
