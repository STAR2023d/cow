# AI in Mwaura's Farm

## Providers

The app can use **Gemini**, **Claude (Anthropic)**, **OpenAI**, or any **OpenAI-compatible** service. All are called over plain HTTP with the `http` package (no provider SDKs; `google_generative_ai` was removed in step 12b). The vet assistant, production insights and finance advisor only see the `AiGenerator` interface, so they work the same with every provider.

| Provider | Endpoint | Notes |
| --- | --- | --- |
| `gemini` (default) | `generateContent` | Key sent in a header, not the URL. Temperature 0.3; JSON mode when asked. Waits up to 90 s. |
| `anthropic` | Messages API, version `2026-10-21` | No `temperature` (that API version rejects it). JSON asked for in the system prompt. Only `text` blocks are read (thinking blocks are skipped). A `refusal` is shown as "no answer". Server-side refusal fallback is on (`fallbacks: "default"`, beta `server-side-fallback-2026-07-01`), so Anthropic retries a refused request on another Claude model itself. |
| `openai` | Chat Completions | Bearer key; `response_format: json_object` for JSON. |
| `compatible` | `<OPENAI_BASE_URL>/chat/completions` | Same as `openai` at another address. Set `OPENAI_JSON_MODE=false` if the service rejects `response_format`. |

Free testing with Groq: set `AI_PROVIDER` to `compatible`, `OPENAI_BASE_URL` to `https://api.groq.com/openai/v1`, `OPENAI_API_KEY` to the Groq key and `OPENAI_MODEL` to an exact model ID. Groq no longer offers Llama chat models (as of 2026-11-14); `openai/gpt-oss-20b` passed the live check, and `openai/gpt-oss-120b` and `qwen/qwen3.8-27b` are also available. Free tiers have low request limits, and some may keep what is sent, so use test data only.

## Settings

Keep keys out of shell commands and out of the repository. Put them in a private file outside the project and pass it in:

```bash
flutter run -d linux --dart-define-from-file=$HOME/.config/cow/env.json
```

| Setting | Default | Meaning |
| --- | --- | --- |
| `AI_PROVIDER` | `gemini` | `gemini`, `anthropic`, `openai` or `compatible` |
| `GEMINI_API_KEY` | | |
| `GEMINI_MODEL` | `gemini-3.8-flash` | |
| `GEMINI_FALLBACK_MODEL` | (none) | Second Gemini model, tried once when the main one stays busy |
| `ANTHROPIC_API_KEY` | | |
| `ANTHROPIC_MODEL` | `claude-opus-5-5` | Most capable; `claude-haiku-5-5` costs far less per request |
| `OPENAI_API_KEY` | | Also used for `compatible` |
| `OPENAI_MODEL` | (none, required) | |
| `OPENAI_BASE_URL` | OpenAI | Required for `compatible`, e.g. `http://localhost:8080/v1` |
| `OPENAI_JSON_MODE` | `true` | |
| `AI_FALLBACK_PROVIDERS` | (none) | Other providers to try, in order, e.g. `anthropic,openai` |

Example file: `{"AI_PROVIDER": "gemini", "GEMINI_API_KEY": "...", "ANTHROPIC_API_KEY": "...", "AI_FALLBACK_PROVIDERS": "anthropic"}`.

Settings that are incomplete (unknown provider, missing key or model, `compatible` without a valid base URL) make the AI report "not set up" without sending any request.

A template with every setting empty is kept next to the private file, at `~/.config/cow/env.example.json`. Leave a setting empty until there is a real key; a placeholder word would be sent as the key.

## Live check

`test/live/ai_live_test.dart` sends real requests to every provider that has settings: one short reply and one vet case, which must parse and contain no doses. A plain `flutter test` passes no settings, so it is skipped and costs nothing. Run it with:

```bash
flutter test test/live --dart-define-from-file=$HOME/.config/cow/env.json
```

Add `--name gemini` (or `anthropic`, `openai`, `compatible`) to check one provider, and `--dart-define=OPENAI_MODEL=...` to try a model without editing the file. It prints only the provider, model, result and the start of each reply, never keys.

Results on 2026-11-14: Gemini short reply OK, vet case timed out at the old 45 s limit (raised to 90 s since); Groq `openai/gpt-oss-20b` passed both in about 4 s. Claude and OpenAI not checked yet (no keys).

## Retries and fallback

1. **Same provider:** a busy reply (429, 500, 502, 503, 504, or Anthropic's 529) is retried after 2 s, then 5 s. For Gemini, a `GEMINI_FALLBACK_MODEL` is then tried once more.
2. **Other providers:** if the result is still busy or unreachable (no connection, timeout), each provider in `AI_FALLBACK_PROVIDERS` is tried in turn. Unknown, repeated or not-set-up providers are skipped.
3. **Never retried elsewhere:** a blocked answer (safety filter or refusal). If one model declines a vet question the app does not shop around for another answer. Other errors (for example a bad key) are also returned as they are.
4. A main provider that is not set up does not fall back; the farmer is told the AI is not set up.

## Vet assistant safety rules

- Never gives drug doses; tells the farmer to ask a vet for medicines.
- Reminds farmers to withhold milk from treated cows.
- Danger phrases (bloat, cannot stand, difficult calving, etc.) always force "emergency", whatever the AI says. This can only raise urgency, never lower it.
- An unrecognised urgency from the AI is treated as "see a vet soon".
- The danger phrase list is English only so far.

## What the vet assistant knows about the cow

Breed, age, current breeding stage (with expected calving date) and the last 7 days of milk, gathered by `vet_case_builder.dart`. The farmer only types the symptoms and how long.

## Finance advisor

- `finance_advisor_service.dart`: `findFinanceAlerts` (plain arithmetic, instant, works offline), the prompt, the reply parser, and `FinanceAdvisorService` (asks only on request, caches identical numbers and questions).
- Compares a month with the month before. A month in progress is compared with the same days of the previous month.
- Rules in the system instruction: only use the numbers given, no tax/loan/investment/legal advice, say so when the data is thin. Amounts are assumed to be Kenyan shillings. English only for now.
- Earnings per buyer is not sent to the advisor yet.

## Known limits

- API keys are compiled into the app, so they can be extracted from a distributed build. Fine for personal testing, not for publishing: a key-holding backend proxy is planned (see "Going public with paid AI" in `docs/ROADMAP.md`).
- The provider is chosen at build time; there is no in-app settings screen.
- Prompts were written and tested with Gemini. A real vet case also parsed correctly through Groq (`openai/gpt-oss-20b`). Claude and OpenAI replies have not been checked against real farm questions yet.
- Gemini can be slow: a vet case has taken more than 45 s. Setting `AI_FALLBACK_PROVIDERS` (for example `compatible`) lets the app ask another provider when Gemini times out.

## Structure

- `lib/services/ai/ai_generator.dart`: `AiGenerator` interface, `AiResult` (value or failure reason), `retryWhenBusy`, `fallbackWhenBusy`
- `lib/services/ai/providers/`: `http_ai.dart` (shared request and error sorting), `gemini_http.dart`, `anthropic_http.dart`, `openai_http.dart`
- `lib/services/ai/ai_provider_factory.dart`: `AiConfig` (settings), `buildAiGenerator`, `RetryingGenerator`, `ChainGenerator`, `ConfiguredAiGenerator` (the app's default)
- `lib/services/ai/ai_messages.dart`: farmer-friendly wording for each failure
- `lib/services/ai/vet_service.dart`, `vet_case_builder.dart`, `vet_record.dart`: vet assistant
- `lib/services/ai/production_insights_service.dart`: milk insights (asks only on request, caches identical data)
- `lib/services/ai/finance_advisor_service.dart`: finance advisor
