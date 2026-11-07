# Mwaura's Farm 🐄

A dairy farm management app for small-scale Kenyan farmers, built with Flutter.
It works offline-first: all data is stored on the device in SQLite.

## Features

- **Cow register** with photos and tags, and mother-to-heifer links
- **Milk recording** per cow, per session (Morning / Evening), with daily totals
- **Price history** with effective dates, and cash worked out from litres sold
- **Expenses and financial statements** in 15-day half-periods
- **Feeding log** for herd-wide or per-cow feeding
- **Health records** (vaccination, illness, checkups) with follow-up dates
- **Breeding tracker** from heat to service, pregnancy checks (day 21/42/63), dry-off, calving, and calf outcome _(in progress)_
- **AI insights** on milk production using Gemini

## Tech stack

| Area       | Package                                   |
| ---------- | ----------------------------------------- |
| Database   | `drift` + `drift_flutter` (SQLite)        |
| State / DI | `provider`                                |
| Charts     | `fl_chart`                                |
| AI         | `google_generative_ai` (Gemini 3.7 Flash) |
| Other      | `image_picker`, `intl`, `lucide_icons`    |

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define=GEMINI_API_KEY=your_key_here
```

The app runs without a key, but AI features return nothing.
Never commit your API key.

## Project structure

```
lib/
  main.dart            App entry point, provides the single AppDatabase
  database/            Drift tables, migrations and queries
  breeding/            Breeding schema, date logic, status card
  screens/             App screens
  services/            AI service
  models/              Helpers such as financial period calculations
  abstract/            Shared dialogs and image picking
```

## Running tests

```bash
flutter test
```

Tests cover the breeding date logic, the database (using an in-memory SQLite), and the app theme.

## Documentation

- [Roadmap](docs/ROADMAP.md)
- [Changelog](CHANGELOG.md)

## License

See [LICENSE](LICENSE).
