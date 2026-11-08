# AI in Mwaura's Farm

## Structure

- `lib/services/ai/ai_generator.dart`: `AiGenerator` interface, `AiResult` (value or failure reason) and `GeminiGenerator`
- `lib/services/ai/vet_service.dart`: vet assessment (prompt, danger-sign override, reply parser)
- `lib/services/ai_service.dart`: older milk-production insights (to be moved onto `AiGenerator`)

## Vet assistant safety rules

- Never gives drug doses; tells the farmer to ask a vet for medicines.
- Reminds farmers to withhold milk from treated cows.
- Danger phrases (bloat, cannot stand, difficult calving, etc.) always force "emergency", whatever the AI says. This can only raise urgency, never lower it.
- An unrecognised urgency from the AI is treated as "see a vet soon".
- The danger phrase list is English only so far.

## Known limits

- `google_generative_ai` is no longer maintained; plan a move to `firebase_ai` or a small server-side proxy before a public release.
- `GEMINI_API_KEY` is compiled into the app, so it can be extracted from a distributed build. Fine for personal testing, not for publishing.
- Swapping provider = write a new class implementing `AiGenerator`.
- A 503 means Google's servers are overloaded. Requests are retried twice (after 2 s, then 5 s) before the farmer is told the AI is busy.

## Running with a key

```bash
flutter run --dart-define=GEMINI_API_KEY=your_key_here
```

## What the vet assistant knows about the cow

Breed, age, current breeding stage (with expected calving date) and the last 7 days of milk, gathered by `vet_case_builder.dart`. The farmer only types the symptoms and how long.

## Structure

- `lib/services/ai/ai_generator.dart`: `AiGenerator` interface, `AiResult` (value or failure reason) and `GeminiGenerator`
- `lib/services/ai/ai_messages.dart`: farmer-friendly wording for each failure
- `lib/services/ai/vet_service.dart`, `vet_case_builder.dart`, `vet_record.dart`: vet assistant
- `lib/services/ai/production_insights_service.dart`: milk insights (asks only on request, caches identical data)

## Finance advisor

- `finance_advisor_service.dart`: `findFinanceAlerts` (plain arithmetic, instant, works offline), the prompt, the reply parser, and `FinanceAdvisorService` (asks only on request, caches identical numbers and questions).
- Compares a month with the month before. A month in progress is compared with the same days of the previous month.
- Rules in the system instruction: only use the numbers given, no tax/loan/investment/legal advice, say so when the data is thin. Amounts are assumed to be Kenyan shillings. English only for now.
Keep keys out of shell commands. Put them in a private file outside the project and pass it in:

```bash
flutter run -d linux --dart-define-from-file=$HOME/.config/cow/env.json
```
with `{"GEMINI_API_KEY": "...", "GEMINI_MODEL": "...", "GEMINI_FALLBACK_MODEL": "..."}`. The fallback model is tried once when the main model is still overloaded after its retries.