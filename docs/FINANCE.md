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
