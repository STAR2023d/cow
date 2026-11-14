import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sw'),
  ];

  /// App name
  ///
  /// In en, this message translates to:
  /// **'Mwaura\'s Farm'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Big dashboard button that opens the whole-herd milk sheet
  ///
  /// In en, this message translates to:
  /// **'Log milk'**
  String get logMilk;

  /// Drawer section heading
  ///
  /// In en, this message translates to:
  /// **'Herd'**
  String get sectionHerd;

  /// Drawer section heading
  ///
  /// In en, this message translates to:
  /// **'Daily care'**
  String get sectionDailyCare;

  /// Drawer section heading
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get sectionMoney;

  /// No description provided for @navLogMilk.
  ///
  /// In en, this message translates to:
  /// **'Log Milk'**
  String get navLogMilk;

  /// No description provided for @navHerdMilk.
  ///
  /// In en, this message translates to:
  /// **'Herd & Milk'**
  String get navHerdMilk;

  /// No description provided for @navBreeding.
  ///
  /// In en, this message translates to:
  /// **'Breeding'**
  String get navBreeding;

  /// No description provided for @navCalfRegister.
  ///
  /// In en, this message translates to:
  /// **'Calf Register'**
  String get navCalfRegister;

  /// No description provided for @navFeeding.
  ///
  /// In en, this message translates to:
  /// **'Feeding'**
  String get navFeeding;

  /// No description provided for @navHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get navHealth;

  /// AI helper for sick cows
  ///
  /// In en, this message translates to:
  /// **'Vet Assistant'**
  String get navVetAssistant;

  /// No description provided for @navMilkPrice.
  ///
  /// In en, this message translates to:
  /// **'Milk Price'**
  String get navMilkPrice;

  /// No description provided for @navExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get navExpenses;

  /// No description provided for @navStatement.
  ///
  /// In en, this message translates to:
  /// **'Financial Statement'**
  String get navStatement;

  /// No description provided for @navMonthlyReport.
  ///
  /// In en, this message translates to:
  /// **'Monthly Report'**
  String get navMonthlyReport;

  /// No description provided for @navMilkAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Milk Analytics'**
  String get navMilkAnalytics;

  /// No description provided for @screenColours.
  ///
  /// In en, this message translates to:
  /// **'Screen colours'**
  String get screenColours;

  /// Light theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Follow the phone's setting
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get themePhone;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @qaAddCow.
  ///
  /// In en, this message translates to:
  /// **'Add Cow'**
  String get qaAddCow;

  /// No description provided for @qaStatement.
  ///
  /// In en, this message translates to:
  /// **'Statement'**
  String get qaStatement;

  /// No description provided for @headerTagline.
  ///
  /// In en, this message translates to:
  /// **'PURE • FRESH • NATURAL'**
  String get headerTagline;

  /// No description provided for @milkYieldTitle.
  ///
  /// In en, this message translates to:
  /// **'MILK YIELD (LITRES)'**
  String get milkYieldTitle;

  /// No description provided for @noDataYesterday.
  ///
  /// In en, this message translates to:
  /// **'No data for yesterday'**
  String get noDataYesterday;

  /// change is like +12 or -5
  ///
  /// In en, this message translates to:
  /// **'{change}% from yesterday'**
  String changeFromYesterday(String change);

  /// No description provided for @herdSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'MY HERD SUMMARY'**
  String get herdSummaryTitle;

  /// No description provided for @totalAnimals.
  ///
  /// In en, this message translates to:
  /// **'Total Animals'**
  String get totalAnimals;

  /// No description provided for @noCowsYet.
  ///
  /// In en, this message translates to:
  /// **'No cows yet'**
  String get noCowsYet;

  /// Breed not recorded
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownBreed;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// Dashboard card: cows whose milk must not be sold after treatment
  ///
  /// In en, this message translates to:
  /// **'Milk on hold ({count})'**
  String milkOnHoldCount(int count);

  /// No description provided for @cowNumber.
  ///
  /// In en, this message translates to:
  /// **'Cow #{id}'**
  String cowNumber(int id);

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day left} other{{count} days left}}'**
  String daysLeft(int count);

  /// No description provided for @healthRemindersCount.
  ///
  /// In en, this message translates to:
  /// **'Health reminders ({count})'**
  String healthRemindersCount(int count);

  /// No description provided for @overdueBy.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Overdue by 1 day} other{Overdue by {count} days}}'**
  String overdueBy(int count);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @inDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{In 1 day} other{In {count} days}}'**
  String inDays(int count);

  /// No description provided for @breedingAlertsCount.
  ///
  /// In en, this message translates to:
  /// **'Breeding Alerts ({count})'**
  String breedingAlertsCount(int count);

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// Shown after a delete, with an Undo button
  ///
  /// In en, this message translates to:
  /// **'{what} deleted'**
  String deleted(String what);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// Milking session
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get sessionMorning;

  /// Milking session
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get sessionAfternoon;

  /// Milking session
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get sessionEvening;

  /// No description provided for @otherDay.
  ///
  /// In en, this message translates to:
  /// **'Other day'**
  String get otherDay;

  /// No description provided for @buyerForAll.
  ///
  /// In en, this message translates to:
  /// **'Buyer for all (optional)'**
  String get buyerForAll;

  /// No description provided for @couldNotLoadHerd.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the herd.'**
  String get couldNotLoadHerd;

  /// No description provided for @noCowsAddFirst.
  ///
  /// In en, this message translates to:
  /// **'No cows yet. Add a cow from the dashboard first.'**
  String get noCowsAddFirst;

  /// No description provided for @saveCowsLitres.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Save 1 cow: {litres} ≈ {money}} other{Save {count} cows: {litres} ≈ {money}}}'**
  String saveCowsLitres(int count, String litres, String money);

  /// No description provided for @usuallyAbout.
  ///
  /// In en, this message translates to:
  /// **'Usually about {litres}'**
  String usuallyAbout(String litres);

  /// No description provided for @noSessionMilkLast7.
  ///
  /// In en, this message translates to:
  /// **'No {session} milk in the last 7 days'**
  String noSessionMilkLast7(String session);

  /// No description provided for @savedLitres.
  ///
  /// In en, this message translates to:
  /// **'Saved: {litres}'**
  String savedLitres(String litres);

  /// No description provided for @milkOnHoldUntil.
  ///
  /// In en, this message translates to:
  /// **'Milk on hold until {date}: do not sell'**
  String milkOnHoldUntil(String date);

  /// No description provided for @enterNumberAboveZero.
  ///
  /// In en, this message translates to:
  /// **'Enter a number above 0'**
  String get enterNumberAboveZero;

  /// No description provided for @typeLitresAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Type the litres for at least one cow.'**
  String get typeLitresAtLeastOne;

  /// No description provided for @checkFiguresTitle.
  ///
  /// In en, this message translates to:
  /// **'Check these figures'**
  String get checkFiguresTitle;

  /// No description provided for @checkFiguresBody.
  ///
  /// In en, this message translates to:
  /// **'These look much higher than usual:\n\n{lines}\n\nSave them anyway?'**
  String checkFiguresBody(String lines);

  /// No description provided for @goBackFix.
  ///
  /// In en, this message translates to:
  /// **'Go back and fix'**
  String get goBackFix;

  /// No description provided for @saveAnyway.
  ///
  /// In en, this message translates to:
  /// **'Save anyway'**
  String get saveAnyway;

  /// No description provided for @unusualUsual.
  ///
  /// In en, this message translates to:
  /// **'{cow}: {litres} (usually about {usual})'**
  String unusualUsual(String cow, String litres, String usual);

  /// No description provided for @savedSessionMilk.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Saved {session} milk for 1 cow: {litres}} other{Saved {session} milk for {count} cows: {litres}}}'**
  String savedSessionMilk(int count, String session, String litres);

  /// No description provided for @milkPrice.
  ///
  /// In en, this message translates to:
  /// **'Milk price'**
  String get milkPrice;

  /// No description provided for @noPriceYet.
  ///
  /// In en, this message translates to:
  /// **'No price yet'**
  String get noPriceYet;

  /// No description provided for @perLitre.
  ///
  /// In en, this message translates to:
  /// **'{price} per litre'**
  String perLitre(String price);

  /// No description provided for @since.
  ///
  /// In en, this message translates to:
  /// **'since {date}'**
  String since(String date);

  /// No description provided for @changePrice.
  ///
  /// In en, this message translates to:
  /// **'Change price'**
  String get changePrice;

  /// No description provided for @priceExplain.
  ///
  /// In en, this message translates to:
  /// **'You set the price here when your buyer changes it. You never type it when logging milk.'**
  String get priceExplain;

  /// No description provided for @priceHistory.
  ///
  /// In en, this message translates to:
  /// **'Price history'**
  String get priceHistory;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'from {date}'**
  String fromDate(String date);

  /// No description provided for @fromDateUpcoming.
  ///
  /// In en, this message translates to:
  /// **'from {date} (upcoming)'**
  String fromDateUpcoming(String date);

  /// No description provided for @priceSaved.
  ///
  /// In en, this message translates to:
  /// **'Milk price saved'**
  String get priceSaved;

  /// Used in '{what} deleted'
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceWhat;

  /// No description provided for @changeMilkPrice.
  ///
  /// In en, this message translates to:
  /// **'Change milk price'**
  String get changeMilkPrice;

  /// No description provided for @nowPerLitre.
  ///
  /// In en, this message translates to:
  /// **'Now: {price} per litre'**
  String nowPerLitre(String price);

  /// No description provided for @newPricePerLitre.
  ///
  /// In en, this message translates to:
  /// **'New price per litre'**
  String get newPricePerLitre;

  /// No description provided for @enterPriceAboveZero.
  ///
  /// In en, this message translates to:
  /// **'Enter a price above 0'**
  String get enterPriceAboveZero;

  /// No description provided for @priceTooHigh.
  ///
  /// In en, this message translates to:
  /// **'That looks too high for one litre'**
  String get priceTooHigh;

  /// No description provided for @appliesFrom.
  ///
  /// In en, this message translates to:
  /// **'Applies from'**
  String get appliesFrom;

  /// No description provided for @priceChangeNote.
  ///
  /// In en, this message translates to:
  /// **'Earnings for milk from {date} onward will use the new price. Earlier milk keeps its old price.'**
  String priceChangeNote(String date);

  /// No description provided for @setYourMilkPrice.
  ///
  /// In en, this message translates to:
  /// **'Set your milk price'**
  String get setYourMilkPrice;

  /// No description provided for @setPriceExplain.
  ///
  /// In en, this message translates to:
  /// **'Earnings use KSh 50 per litre until you set what your buyer pays.'**
  String get setPriceExplain;

  /// No description provided for @milkPricePerLitre.
  ///
  /// In en, this message translates to:
  /// **'Milk price: {price} per litre'**
  String milkPricePerLitre(String price);

  /// No description provided for @moreCount.
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String moreCount(int count);

  /// No description provided for @holdCardLine.
  ///
  /// In en, this message translates to:
  /// **'{cow}: do not sell until {date} ({left})'**
  String holdCardLine(String cow, String date, String left);
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return L10nEn();
    case 'sw':
      return L10nSw();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
