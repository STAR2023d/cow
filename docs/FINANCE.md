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
