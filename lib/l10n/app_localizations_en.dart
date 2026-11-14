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
}
