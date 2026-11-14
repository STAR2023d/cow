# How the money works

## Where money is recorded

- **Milk cash**: litres logged × the price per litre in force on that day (`PriceSettings`, looked up per date). Never stored as a money amount.
- **Expenses** (`Expenses` table): costs, with a description, an amount and a category (feed, vet, labour, transport, other). Expenses saved before categories existed are 'other'.
- **Other income** (`LedgerEntries` table, type `income`): money in that is not milk. Today the only writer is a calf sale (category `calf_sale`).

## Financial statement

Statements cover half-month periods (1st to 15th, 16th to month end).

- Net for the period = milk cash + other income − expenses
- Closing balance = opening balance + net
- Opening balance = the previous period's closing balance, walking back until there is no earlier activity

Only ledger rows of type `income` are counted. Nothing writes ledger `expense` rows yet.

### PDF export

The PDF icon in the statement's top bar saves the period shown as an A4 PDF and opens it in the system viewer (`xdg-open` on Linux), ready to print or send.

- Saved to `Documents/Mwauras Farm/statement-<start>-to-<end>.pdf`, e.g. `statement-2026-11-01-to-2026-11-15.pdf`. Exporting the same period again replaces the file.
- Same figures and lists as the screen: summary, milk records (date, session, litres, cash), other income, expenses. Amounts in KES.
- Code: `lib/services/statement_pdf.dart` (builds the PDF, `pdf` package), `lib/services/pdf_layout.dart` (shared heading, tables, page numbers) and `lib/services/pdf_export.dart` (saves and opens it).
- The PDF uses the built-in Helvetica font, which covers English and Swahili letters but not emoji or other scripts.

## Monthly report

`MonthlyReportCalculator` (`lib/models/monthly_report.dart`) totals one calendar month: litres, milk cash, other income, expenses (overall and per category), profit, and cost per litre (expenses ÷ litres, empty when no milk was logged). The Monthly Report screen shows it, and the AI finance advisor will use the same report.
Alerts (shown without AI): loss for the month; cost per litre up 20%+; income or milk down 20%+; a category up 30%+ (when it is at least 5% of spending); a large new category (20%+ of spending).

## Earnings per buyer

The Monthly Report has an **Earnings per buyer** panel built from the optional Buyer field on milk entries.

- Each entry is valued at the price per litre in force on its day, the same way milk income is worked out, so the buyer amounts add up to the Milk income figure.
- Buyer names are matched ignoring case and extra spaces ("Githunguri Dairy" = "githunguri  dairy"), shown as first typed.
- Entries with no buyer are grouped as **Not recorded**, always listed last.
- Each row shows the amount, litres and share of milk income. There is one farm-wide price, so price per litre is the same for every buyer and is not shown.
- If no entry in the month names a buyer, the panel says so instead of showing bars.

Logic: `earningsByBuyer` in `lib/models/buyer_earnings.dart`, stored on `MonthlyReport.earningsByBuyer`. The AI finance advisor does not use it yet.

### Monthly Report PDF

The PDF icon on the Monthly Report saves the month shown as `Documents/Mwauras Farm/monthly-report-<yyyy-mm>.pdf` and opens it.

- Income, expenses and profit, with a "Last month" column when the month before has data (cut at the same day for a month in progress, like the screen).
- Litres produced and cost per litre, spending by category with shares, and earnings per buyer when buyers were recorded.
- A month in progress is labelled, e.g. "November 2026, 1 to 14 (month in progress)". Exporting it again later replaces the file.
- Code: `lib/services/monthly_report_pdf.dart`.
