// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mwaura\'s Farm';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get logMilk => 'Log milk';

  @override
  String get sectionHerd => 'Herd';

  @override
  String get sectionDailyCare => 'Daily care';

  @override
  String get sectionMoney => 'Money';

  @override
  String get navLogMilk => 'Log Milk';

  @override
  String get navHerdMilk => 'Herd & Milk';

  @override
  String get navBreeding => 'Breeding';

  @override
  String get navCalfRegister => 'Calf Register';

  @override
  String get navFeeding => 'Feeding';

  @override
  String get navHealth => 'Health';

  @override
  String get navVetAssistant => 'Vet Assistant';

  @override
  String get navMilkPrice => 'Milk Price';

  @override
  String get navExpenses => 'Expenses';

  @override
  String get navStatement => 'Financial Statement';

  @override
  String get navMonthlyReport => 'Monthly Report';

  @override
  String get navMilkAnalytics => 'Milk Analytics';

  @override
  String get screenColours => 'Screen colours';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themePhone => 'Phone';

  @override
  String get language => 'Language';

  @override
  String get qaAddCow => 'Add Cow';

  @override
  String get qaStatement => 'Statement';

  @override
  String get headerTagline => 'PURE • FRESH • NATURAL';

  @override
  String get milkYieldTitle => 'MILK YIELD (LITRES)';

  @override
  String get milkToday => 'Today';

  @override
  String get milkYesterdayTodayNotLogged => 'Yesterday · today not logged yet';

  @override
  String get noMilkLoggedYet => 'No milk logged yet';

  @override
  String get noDataYesterday => 'No data for yesterday';

  @override
  String changeFromYesterday(String change) {
    return '$change% from yesterday';
  }

  @override
  String get herdSummaryTitle => 'MY HERD SUMMARY';

  @override
  String get totalAnimals => 'Total Animals';

  @override
  String get noCowsYet => 'No cows yet';

  @override
  String get unknownBreed => 'Unknown';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get noRecentActivity => 'No recent activity';

  @override
  String milkOnHoldCount(int count) {
    return 'Milk on hold ($count)';
  }

  @override
  String cowNumber(int id) {
    return 'Cow #$id';
  }

  @override
  String daysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
    );
    return '$_temp0';
  }

  @override
  String healthRemindersCount(int count) {
    return 'Health reminders ($count)';
  }

  @override
  String overdueBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Overdue by $count days',
      one: 'Overdue by 1 day',
    );
    return '$_temp0';
  }

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get yesterday => 'Yesterday';

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count days',
      one: 'In 1 day',
    );
    return '$_temp0';
  }

  @override
  String breedingAlertsCount(int count) {
    return 'Breeding Alerts ($count)';
  }

  @override
  String get viewAll => 'View all';

  @override
  String deleted(String what) {
    return '$what deleted';
  }

  @override
  String get undo => 'Undo';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get set => 'Set';

  @override
  String get change => 'Change';

  @override
  String get sessionMorning => 'Morning';

  @override
  String get sessionAfternoon => 'Afternoon';

  @override
  String get sessionEvening => 'Evening';

  @override
  String get otherDay => 'Other day';

  @override
  String get buyerForAll => 'Buyer for all (optional)';

  @override
  String get couldNotLoadHerd => 'Couldn\'t load the herd.';

  @override
  String get noCowsAddFirst =>
      'No cows yet. Add a cow from the dashboard first.';

  @override
  String get milkingList => 'Milking list';

  @override
  String get milkingListHelp =>
      'Tick the cows you are milking. Only these show on the milk log.';

  @override
  String get noCowsInMilk =>
      'No cows on the milking list yet. Add the cows you milk.';

  @override
  String get addCowsToMilkingList => 'Add cows to the list';

  @override
  String get removeFromMilkingList => 'Remove from milking list';

  @override
  String saveCowsLitres(int count, String litres, String money) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Save $count cows: $litres ≈ $money',
      one: 'Save 1 cow: $litres ≈ $money',
    );
    return '$_temp0';
  }

  @override
  String usuallyAbout(String litres) {
    return 'Usually about $litres';
  }

  @override
  String noSessionMilkLast7(String session) {
    return 'No $session milk in the last 7 days';
  }

  @override
  String savedLitres(String litres) {
    return 'Saved: $litres';
  }

  @override
  String milkOnHoldUntil(String date) {
    return 'Milk on hold until $date: do not sell';
  }

  @override
  String get enterNumberAboveZero => 'Enter a number above 0';

  @override
  String get typeLitresAtLeastOne => 'Type the litres for at least one cow.';

  @override
  String get checkFiguresTitle => 'Check these figures';

  @override
  String checkFiguresBody(String lines) {
    return 'These look much higher than usual:\n\n$lines\n\nSave them anyway?';
  }

  @override
  String get goBackFix => 'Go back and fix';

  @override
  String get saveAnyway => 'Save anyway';

  @override
  String unusualUsual(String cow, String litres, String usual) {
    return '$cow: $litres (usually about $usual)';
  }

  @override
  String savedSessionMilk(int count, String session, String litres) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Saved $session milk for $count cows: $litres',
      one: 'Saved $session milk for 1 cow: $litres',
    );
    return '$_temp0';
  }

  @override
  String get milkPrice => 'Milk price';

  @override
  String get noPriceYet => 'No price yet';

  @override
  String perLitre(String price) {
    return '$price per litre';
  }

  @override
  String since(String date) {
    return 'since $date';
  }

  @override
  String get changePrice => 'Change price';

  @override
  String get priceExplain =>
      'You set the price here when your buyer changes it. You never type it when logging milk.';

  @override
  String get priceHistory => 'Price history';

  @override
  String fromDate(String date) {
    return 'from $date';
  }

  @override
  String fromDateUpcoming(String date) {
    return 'from $date (upcoming)';
  }

  @override
  String get priceSaved => 'Milk price saved';

  @override
  String get priceWhat => 'Price';

  @override
  String get changeMilkPrice => 'Change milk price';

  @override
  String nowPerLitre(String price) {
    return 'Now: $price per litre';
  }

  @override
  String get newPricePerLitre => 'New price per litre';

  @override
  String get enterPriceAboveZero => 'Enter a price above 0';

  @override
  String get priceTooHigh => 'That looks too high for one litre';

  @override
  String get appliesFrom => 'Applies from';

  @override
  String priceChangeNote(String date) {
    return 'Earnings for milk from $date onward will use the new price. Earlier milk keeps its old price.';
  }

  @override
  String get setYourMilkPrice => 'Set your milk price';

  @override
  String get setPriceExplain =>
      'Earnings use KSh 50 per litre until you set what your buyer pays.';

  @override
  String milkPricePerLitre(String price) {
    return 'Milk price: $price per litre';
  }

  @override
  String moreCount(int count) {
    return '+$count more';
  }

  @override
  String holdCardLine(String cow, String date, String left) {
    return '$cow: do not sell until $date ($left)';
  }

  @override
  String get myHerd => 'My Herd';

  @override
  String errorLoading(String error) {
    return 'Error loading data: $error';
  }

  @override
  String get noCowsInHerd => 'No cows in your herd yet!';

  @override
  String tagLine(String tag) {
    return 'Tag: $tag';
  }

  @override
  String get noTag => 'No tag';

  @override
  String breedAgeLine(String breed, String age) {
    return 'Breed: $breed • Age: $age';
  }

  @override
  String ageYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yrs',
      one: '1 yr',
    );
    return '$_temp0';
  }

  @override
  String get notAvailable => 'N/A';

  @override
  String get couldNotPickImage => 'Couldn\'t pick the image';

  @override
  String cowSaved(String name) {
    return '$name saved';
  }

  @override
  String failedToSave(String error) {
    return 'Could not save: $error';
  }

  @override
  String get tapToUploadPhoto => 'Tap to add a cow photo';

  @override
  String get tagNumber => 'Tag number';

  @override
  String get cowName => 'Cow name';

  @override
  String get enterName => 'Please enter a name';

  @override
  String get breed => 'Breed';

  @override
  String get selectBreed => 'Select cow breed';

  @override
  String get ageInYears => 'Age (years)';

  @override
  String get enterValidNumber => 'Please enter a valid number';

  @override
  String get saveCow => 'Save cow';

  @override
  String get choosePhoto => 'Choose cow photo';

  @override
  String get fromGallery => 'Upload from gallery';

  @override
  String get takePhoto => 'Take a new photo';

  @override
  String get removeCowTitle => 'Remove cow';

  @override
  String removeCowQuestion(String name) {
    return 'Did $name leave the farm, or was she added by mistake?';
  }

  @override
  String get continueLabel => 'Continue';

  @override
  String get cannotBeUndoneTitle => 'This cannot be undone';

  @override
  String deleteCowWarning(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records',
      one: '1 record',
    );
    return '$name and $_temp0 (milk, health, feeding, breeding and calves) will be deleted for good. Use this only for a cow added by mistake.';
  }

  @override
  String get deletePermanently => 'Delete for good';

  @override
  String get deleting => 'Deleting…';

  @override
  String get deletionComplete => 'Deleted';

  @override
  String milkEntryFor(String name) {
    return 'Milk entry: $name';
  }

  @override
  String get milkingSession => 'Milking session';

  @override
  String get milkQuantity => 'Milk quantity';

  @override
  String get enterAmount => 'Please enter the amount';

  @override
  String get quantityAboveZero => 'Quantity must be greater than zero';

  @override
  String get buyerOptional => 'Buyer (optional)';

  @override
  String get buyerHint => 'e.g. dairy co-op, hotel, neighbour';

  @override
  String savedAmount(String litres) {
    return 'Saved $litres';
  }

  @override
  String get historyLog => 'Milk history';

  @override
  String get noMilkEntriesForCow => 'No milk entries logged yet for this cow.';

  @override
  String get editEntry => 'Edit entry';

  @override
  String get deleteEntry => 'Delete entry';

  @override
  String get milkEntryWhat => 'Milk entry';

  @override
  String get milkEntryUpdated => 'Milk entry updated';

  @override
  String get editMilkEntry => 'Edit milk entry';

  @override
  String get litresLabel => 'Litres';

  @override
  String get leaveEmptyRemoveBuyer => 'Leave empty to remove the buyer';

  @override
  String milkOnHoldBanner(String date) {
    return 'Milk on hold: do not sell until $date';
  }

  @override
  String get logFeeding => 'Log feeding';

  @override
  String get feedType => 'Feed type';

  @override
  String get cowOptional => 'Cow (optional)';

  @override
  String get wholeHerd => 'Whole herd';

  @override
  String get quantityKg => 'Quantity (kg)';

  @override
  String get enterQuantity => 'Enter a quantity';

  @override
  String get enterValidNumberShort => 'Enter a valid number';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get noFeedingRecords => 'No feeding records yet';

  @override
  String get unknownCow => 'Unknown cow';

  @override
  String get feedingRecordWhat => 'Feeding record';

  @override
  String get feedHay => 'Hay';

  @override
  String get feedSilage => 'Silage';

  @override
  String get feedConcentrate => 'Concentrate';

  @override
  String get feedPasture => 'Pasture';

  @override
  String get feedMineral => 'Mineral Supplement';

  @override
  String get feedDairyMeal => 'Dairy Meal';

  @override
  String get other => 'Other';

  @override
  String get addCowFirstHealth => 'Add a cow before logging a health record.';

  @override
  String get logHealthRecord => 'Log health record';

  @override
  String get presetsNote =>
      'Presets only suggest a follow-up date. Change it as needed: your vet\'s advice comes first.';

  @override
  String get cow => 'Cow';

  @override
  String get recordType => 'Record type';

  @override
  String dateLine(String date) {
    return 'Date: $date';
  }

  @override
  String get description => 'Description';

  @override
  String get enterDescription => 'Enter a description';

  @override
  String get medicineOptional => 'Medicine (optional)';

  @override
  String get withdrawalDaysOptional => 'Milk withdrawal days (optional)';

  @override
  String get withdrawalHelper =>
      'From the medicine label or your vet. The app only counts the days you enter.';

  @override
  String get enter1to60 => 'Enter 1 to 60 days';

  @override
  String get noFollowUp => 'No follow-up date';

  @override
  String followUpOn(String date) {
    return 'Follow-up: $date';
  }

  @override
  String get removeFollowUp => 'Remove follow-up';

  @override
  String get noHealthRecords => 'No health records yet';

  @override
  String medicineLine(String name) {
    return 'Medicine: $name';
  }

  @override
  String get healthRecordWhat => 'Health record';

  @override
  String get logRecord => 'Log record';

  @override
  String milkHoldEnded(String date) {
    return 'Milk hold ended $date';
  }

  @override
  String milkOnHoldSafeFrom(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Milk on hold: safe from $date ($count days left)',
      one: 'Milk on hold: safe from $date (1 day left)',
    );
    return '$_temp0';
  }

  @override
  String get recVaccination => 'Vaccination';

  @override
  String get recIllness => 'Illness';

  @override
  String get recCheckup => 'Checkup';

  @override
  String get recTreatment => 'Treatment';

  @override
  String get recDeworming => 'Deworming';

  @override
  String get recTickControl => 'Tick control';

  @override
  String get recHoofCare => 'Hoof care';

  @override
  String get presetVetCheck => 'Vet check';

  @override
  String get presetDescVaccination => 'Vaccination as advised by the vet';

  @override
  String get presetDescTick => 'Tick control (spray or dip)';

  @override
  String get presetDescDeworming => 'Deworming';

  @override
  String get presetDescHoof => 'Hoof check and trimming';

  @override
  String get presetDescVetCheck => 'Routine vet check';

  @override
  String cowBreeding(String name) {
    return '$name • Breeding';
  }

  @override
  String get history => 'History';

  @override
  String get noPastCycles => 'No past cycles yet';

  @override
  String get outcomeReturnedToHeat => 'Returned to heat';

  @override
  String get outcomeHeiferKept => 'Calved — heifer kept';

  @override
  String get outcomeCalfSold => 'Calved — calf sold';

  @override
  String get outcomeClosed => 'Closed';

  @override
  String heatOn(String date) {
    return 'Heat: $date';
  }

  @override
  String servedOn(String date) {
    return 'Served: $date';
  }

  @override
  String calvedOn(String date) {
    return 'Calved: $date';
  }

  @override
  String calfSoldFor(String amount) {
    return 'Calf sold for $amount';
  }

  @override
  String get herdBreeding => 'Herd breeding';

  @override
  String get noActiveCycle => 'No active breeding cycle';

  @override
  String milestoneDue(String milestone, String date, String due) {
    return '$milestone: $date • $due';
  }

  @override
  String get loadingBreeding => 'Loading breeding status…';

  @override
  String get logHeatToStart => 'Log heat signs to start one';

  @override
  String get logHeat => 'Log heat';

  @override
  String expectedCalving(String date) {
    return 'Expected calving: $date';
  }

  @override
  String get logServiceDate => 'Log service date';

  @override
  String get logCalving => 'Log calving';

  @override
  String get femaleKeep => 'Female — keep';

  @override
  String get maleSell => 'Male — sell';

  @override
  String checkSuccess(int n) {
    return 'Check $n: success';
  }

  @override
  String get dateHeatSeen => 'Date heat signs were seen';

  @override
  String get dateOfService => 'Date of service';

  @override
  String dateOfCheck(int n) {
    return 'Date of check $n';
  }

  @override
  String get calvingDate => 'Calving date';

  @override
  String get nameTheCalf => 'Name the calf';

  @override
  String get add => 'Add';

  @override
  String get saleAmount => 'Sale amount';

  @override
  String get sell => 'Sell';

  @override
  String get stageAwaitingService => 'Heat detected — awaiting service';

  @override
  String stageAwaitingCheck(int days) {
    return 'Awaiting $days-day pregnancy check';
  }

  @override
  String get stageConfirmed => 'Pregnancy confirmed — counting down to calving';

  @override
  String get stageDryOff => 'Dry-off period (8 weeks to calving)';

  @override
  String stagePrepWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks to calving — preparation',
      one: '1 week to calving — final preparation',
    );
    return '$_temp0';
  }

  @override
  String get stageCalved => 'Calved — awaiting outcome';

  @override
  String get stageKeptHeifer => 'Calf kept as heifer';

  @override
  String get stageSoldCalf => 'Calf sold';

  @override
  String get stageFailed => 'Returned to heat — re-service needed';

  @override
  String get msWaitingService => 'Waiting for service';

  @override
  String get msRecordOutcome => 'Record the calf outcome';

  @override
  String msCheckDue(int n) {
    return 'Check $n due';
  }

  @override
  String get msCalvingExpected => 'Calving expected';

  @override
  String dueOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days overdue',
      one: '1 day overdue',
    );
    return '$_temp0';
  }

  @override
  String get dueToday => 'today';

  @override
  String get dueTomorrow => 'tomorrow';

  @override
  String dueInDays(int count) {
    return 'in $count days';
  }

  @override
  String get expenseSaved => 'Expense saved';

  @override
  String get expenseTitle => 'Expense';

  @override
  String get required => 'Required';

  @override
  String get amount => 'Amount';

  @override
  String get saveExpense => 'Save expense';

  @override
  String get catFeed => 'Feed';

  @override
  String get catVet => 'Vet & medicine';

  @override
  String get catLabour => 'Labour';

  @override
  String get catTransport => 'Transport';

  @override
  String get incomeCalfSale => 'Calf sale';

  @override
  String get income => 'Income';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String periodRange(String start, String end) {
    return '$start to $end';
  }

  @override
  String get openingBalance => 'Opening balance';

  @override
  String milkCashRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Milk cash ($count records)',
      one: 'Milk cash (1 record)',
    );
    return '$_temp0';
  }

  @override
  String otherIncomeEntries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Other income ($count entries)',
      one: 'Other income (1 entry)',
    );
    return '$_temp0';
  }

  @override
  String expensesEntries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Expenses ($count entries)',
      one: 'Expenses (1 entry)',
    );
    return '$_temp0';
  }

  @override
  String get closingBalance => 'Closing balance';

  @override
  String get milkRecords => 'Milk records';

  @override
  String get otherIncome => 'Other income';

  @override
  String savedFile(String path) {
    return 'Saved $path';
  }

  @override
  String savedFileNotOpened(String path) {
    return 'Saved $path (could not open it)';
  }

  @override
  String couldNotSavePdf(String error) {
    return 'Could not save the PDF: $error';
  }

  @override
  String get couldNotLoadMonth =>
      'Couldn\'t load this month. Please try again.';

  @override
  String get nothingThisMonth => 'Nothing recorded this month.';

  @override
  String get profit => 'Profit';

  @override
  String get milk => 'Milk';

  @override
  String litresProduced(String litres) {
    return '$litres produced';
  }

  @override
  String get costPerLitreNone => 'Cost per litre: no milk logged';

  @override
  String costPerLitre(String amount) {
    return 'Cost per litre: $amount';
  }

  @override
  String get incomeVsExpenses => 'Income vs expenses';

  @override
  String milkAndOther(String milk, String other) {
    return 'Milk $milk  •  Other income $other';
  }

  @override
  String get whereMoneyWent => 'Where the money went';

  @override
  String get noExpensesMonth => 'No expenses recorded this month.';

  @override
  String get earningsPerBuyer => 'Earnings per buyer';

  @override
  String get noBuyersMonth =>
      'No buyers recorded this month. Add a buyer when logging milk to see who pays the most.';

  @override
  String get notRecorded => 'Not recorded';

  @override
  String shareOfMilkIncome(String percent) {
    return '$percent% of milk income';
  }

  @override
  String monthInProgress(String month, int day) {
    return '$month, 1 to $day (month in progress)';
  }

  @override
  String pdfAmountsGenerated(String date) {
    return 'Amounts in KES. Generated $date.';
  }

  @override
  String pdfPage(int page, int pages) {
    return 'Page $page of $pages';
  }

  @override
  String statementTitle(String start, String end) {
    return 'Financial Statement: $start to $end';
  }

  @override
  String monthlyReportTitle(String period) {
    return 'Monthly Report: $period';
  }

  @override
  String get none => 'None';

  @override
  String get colDate => 'Date';

  @override
  String get colSession => 'Session';

  @override
  String get colLitres => 'Litres';

  @override
  String get colCash => 'Cash';

  @override
  String get colType => 'Type';

  @override
  String get colNote => 'Note';

  @override
  String get colAmount => 'Amount';

  @override
  String get colCategory => 'Category';

  @override
  String get colDescription => 'Description';

  @override
  String get colShare => 'Share';

  @override
  String get colBuyer => 'Buyer';

  @override
  String get colShareMilk => 'Share of milk income';

  @override
  String get thisMonth => 'This month';

  @override
  String get lastMonth => 'Last month';

  @override
  String get milkIncome => 'Milk income';

  @override
  String get totalIncome => 'Total income';

  @override
  String get litresProducedLabel => 'Litres produced';

  @override
  String get costPerLitreLabel => 'Cost per litre';

  @override
  String get noMilkLogged => 'no milk logged';

  @override
  String get dailyAnalytics => 'Today\'s milk';

  @override
  String get totalToday => 'TOTAL PRODUCTION TODAY';

  @override
  String get aiFarmInsights => 'AI farm insights';

  @override
  String get sessionBreakdown => 'Session breakdown';

  @override
  String get todaysLogs => 'Today\'s logs';

  @override
  String get noMilkToday => 'No milk has been logged yet today.';

  @override
  String amountLine(String amount) {
    return 'Amount: $amount';
  }

  @override
  String sessionLine(String session) {
    return 'Session: $session';
  }

  @override
  String get calfDetails => 'Calf details';

  @override
  String get addCalf => 'Add calf';

  @override
  String get noCalvesYet =>
      'No calves yet. Calves appear here once a calving is recorded on a cow\'s breeding screen, or tap Add calf for one bought in or born before you used the app.';

  @override
  String calfSummary(int total, int kept, int sold) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total calves',
      one: '1 calf',
    );
    return '$_temp0 · $kept kept · $sold sold';
  }

  @override
  String calfSummaryAwaiting(int count) {
    return ' · $count awaiting outcome';
  }

  @override
  String calfSummaryByHand(int count) {
    return ' · $count added by hand';
  }

  @override
  String get unknownDam => 'Unknown dam';

  @override
  String get unnamedCalf => 'Unnamed calf';

  @override
  String calfOf(String dam) {
    return 'Calf of $dam';
  }

  @override
  String get kept => 'Kept';

  @override
  String get sold => 'Sold';

  @override
  String soldFor(String amount) {
    return 'Sold · $amount';
  }

  @override
  String get awaitingOutcome => 'Awaiting outcome';

  @override
  String get boughtIn => 'Bought in';

  @override
  String get onFarm => 'On farm';

  @override
  String get female => 'Female';

  @override
  String get male => 'Male';

  @override
  String get sexNotRecorded => 'Sex not recorded';

  @override
  String damLine(String dam) {
    return 'Dam: $dam';
  }

  @override
  String bornLine(String date, String age) {
    return 'Born $date ($age)';
  }

  @override
  String kgAtBirth(String kg) {
    return '$kg kg at birth';
  }

  @override
  String weanedOn(String date) {
    return 'Weaned on $date';
  }

  @override
  String get nameOptional => 'Name (optional)';

  @override
  String bornOn(String date) {
    return 'Born: $date';
  }

  @override
  String get damOptional => 'Dam (optional)';

  @override
  String get birthWeightOptional => 'Birth weight (optional)';

  @override
  String get birthWeight => 'Birth weight';

  @override
  String get notes => 'Notes';

  @override
  String get notWeaned => 'Not weaned';

  @override
  String get clearWeaning => 'Clear weaning date';

  @override
  String get breedingRecord => 'Breeding record';

  @override
  String get tapAgainToDelete => 'Tap again to delete';

  @override
  String get calfDetailsWhat => 'Calf details';

  @override
  String get ageNotBorn => 'not born yet';

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String ageWeeks(int count) {
    return '$count weeks';
  }

  @override
  String ageMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String ageYearsLong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years',
      one: '1 year',
    );
    return '$_temp0';
  }

  @override
  String get enterKgRange => 'Enter kg between 0 and 200';

  @override
  String get leftFarmButton => 'She left the farm';

  @override
  String get addedByMistakeButton => 'Added by mistake: delete';

  @override
  String leftReasonQuestion(String name) {
    return 'Why did $name leave?';
  }

  @override
  String get leftReasonSold => 'Sold';

  @override
  String get leftReasonDied => 'Died';

  @override
  String get leftReasonCulled => 'Culled';

  @override
  String get leftReasonGivenAway => 'Given away';

  @override
  String leftOnDate(String date) {
    return 'Date: $date';
  }

  @override
  String get leftKeepsRecords =>
      'Her milk, health and money records stay in your reports.';

  @override
  String get leftTheHerd => 'Left the herd';

  @override
  String get noCowsLeft => 'No cows have left the herd.';

  @override
  String get returnToHerd => 'Return to herd';

  @override
  String cowMovedToLeft(String name) {
    return '$name moved to Left the herd';
  }

  @override
  String cowReturned(String name) {
    return '$name is back in the herd';
  }

  @override
  String get category => 'Category';

  @override
  String get savedExpenses => 'Saved expenses';

  @override
  String get noExpensesYet => 'No expenses saved yet.';

  @override
  String get editingExpense => 'Editing expense';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get expenseUpdated => 'Expense updated';

  @override
  String get tapExpenseToEdit => 'Tap an expense to change it.';

  @override
  String notOnMilkingList(int count) {
    return 'Not on the milking list ($count)';
  }

  @override
  String get onMilkingList => 'On the milking list';

  @override
  String get onMilkingListHelp => 'Shows on the Log milk sheet';

  @override
  String removedFromMilkingList(String name) {
    return '$name taken off the milking list';
  }

  @override
  String get checkFigureHint => 'Much more than usual. Check it.';

  @override
  String get recentBuyers => 'Recent buyers';

  @override
  String ageYearsOnly(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years',
      one: '1 year',
    );
    return '$_temp0';
  }

  @override
  String ageYearsMonths(int years, int months) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years',
      one: '1 year',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String get editCow => 'Edit cow';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get pickDateOfBirth => 'Pick date of birth';

  @override
  String get dontKnowDate => 'Don\'t know the date? Enter age in years';

  @override
  String get useDateOfBirth => 'Pick the date of birth instead';

  @override
  String get ageEstimateNote => 'The app will count her age on from here.';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String cowUpdated(String name) {
    return '$name updated';
  }

  @override
  String get eraseAllData => 'Erase all data';

  @override
  String get eraseWhatGoes =>
      'This deletes every cow and all milk, health, breeding, calf, expense and price records, and the cow photos.';

  @override
  String get eraseWhatStays =>
      'Kept: screen colours and language. A backup copy of the records is saved on this device first.';

  @override
  String get eraseConfirmWord => 'ERASE';

  @override
  String eraseTypeToConfirm(String word) {
    return 'Type $word to confirm';
  }

  @override
  String get eraseButton => 'Erase everything';

  @override
  String get eraseDone => 'All data erased. A backup was saved.';

  @override
  String get settings => 'Settings';

  @override
  String get farmName => 'Farm name';

  @override
  String get farmNameHelp => 'Shown at the top of the app and on PDF reports.';

  @override
  String get useDefaultName => 'Use the default name';

  @override
  String get farmNameSaved => 'Farm name saved';

  @override
  String get farmNameLength => 'Use 2 to 60 letters';

  @override
  String get dangerZone => 'Danger zone';
}
