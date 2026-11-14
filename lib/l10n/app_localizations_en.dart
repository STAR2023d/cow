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
    return 'Are you sure you want to remove $name from the herd?';
  }

  @override
  String get continueLabel => 'Continue';

  @override
  String get cannotBeUndoneTitle => 'This cannot be undone';

  @override
  String deleteCowWarning(String name) {
    return 'All records for $name (milk, health, feeding and breeding) will be deleted for good.';
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
}
