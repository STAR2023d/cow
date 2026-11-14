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

  /// No description provided for @myHerd.
  ///
  /// In en, this message translates to:
  /// **'My Herd'**
  String get myHerd;

  /// No description provided for @errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading data: {error}'**
  String errorLoading(String error);

  /// No description provided for @noCowsInHerd.
  ///
  /// In en, this message translates to:
  /// **'No cows in your herd yet!'**
  String get noCowsInHerd;

  /// Ear tag number
  ///
  /// In en, this message translates to:
  /// **'Tag: {tag}'**
  String tagLine(String tag);

  /// No description provided for @noTag.
  ///
  /// In en, this message translates to:
  /// **'No tag'**
  String get noTag;

  /// No description provided for @breedAgeLine.
  ///
  /// In en, this message translates to:
  /// **'Breed: {breed} • Age: {age}'**
  String breedAgeLine(String breed, String age);

  /// No description provided for @ageYears.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 yr} other{{count} yrs}}'**
  String ageYears(int count);

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @couldNotPickImage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t pick the image'**
  String get couldNotPickImage;

  /// No description provided for @cowSaved.
  ///
  /// In en, this message translates to:
  /// **'{name} saved'**
  String cowSaved(String name);

  /// No description provided for @failedToSave.
  ///
  /// In en, this message translates to:
  /// **'Could not save: {error}'**
  String failedToSave(String error);

  /// No description provided for @tapToUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to add a cow photo'**
  String get tapToUploadPhoto;

  /// No description provided for @tagNumber.
  ///
  /// In en, this message translates to:
  /// **'Tag number'**
  String get tagNumber;

  /// No description provided for @cowName.
  ///
  /// In en, this message translates to:
  /// **'Cow name'**
  String get cowName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get enterName;

  /// No description provided for @breed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get breed;

  /// No description provided for @selectBreed.
  ///
  /// In en, this message translates to:
  /// **'Select cow breed'**
  String get selectBreed;

  /// No description provided for @ageInYears.
  ///
  /// In en, this message translates to:
  /// **'Age (years)'**
  String get ageInYears;

  /// No description provided for @enterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get enterValidNumber;

  /// No description provided for @saveCow.
  ///
  /// In en, this message translates to:
  /// **'Save cow'**
  String get saveCow;

  /// No description provided for @choosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose cow photo'**
  String get choosePhoto;

  /// No description provided for @fromGallery.
  ///
  /// In en, this message translates to:
  /// **'Upload from gallery'**
  String get fromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a new photo'**
  String get takePhoto;

  /// No description provided for @removeCowTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove cow'**
  String get removeCowTitle;

  /// No description provided for @removeCowQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name} from the herd?'**
  String removeCowQuestion(String name);

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @cannotBeUndoneTitle.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone'**
  String get cannotBeUndoneTitle;

  /// No description provided for @deleteCowWarning.
  ///
  /// In en, this message translates to:
  /// **'All records for {name} (milk, health, feeding and breeding) will be deleted for good.'**
  String deleteCowWarning(String name);

  /// No description provided for @deletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete for good'**
  String get deletePermanently;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting…'**
  String get deleting;

  /// No description provided for @deletionComplete.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deletionComplete;

  /// No description provided for @milkEntryFor.
  ///
  /// In en, this message translates to:
  /// **'Milk entry: {name}'**
  String milkEntryFor(String name);

  /// No description provided for @milkingSession.
  ///
  /// In en, this message translates to:
  /// **'Milking session'**
  String get milkingSession;

  /// No description provided for @milkQuantity.
  ///
  /// In en, this message translates to:
  /// **'Milk quantity'**
  String get milkQuantity;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter the amount'**
  String get enterAmount;

  /// No description provided for @quantityAboveZero.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be greater than zero'**
  String get quantityAboveZero;

  /// No description provided for @buyerOptional.
  ///
  /// In en, this message translates to:
  /// **'Buyer (optional)'**
  String get buyerOptional;

  /// No description provided for @buyerHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. dairy co-op, hotel, neighbour'**
  String get buyerHint;

  /// No description provided for @savedAmount.
  ///
  /// In en, this message translates to:
  /// **'Saved {litres}'**
  String savedAmount(String litres);

  /// No description provided for @historyLog.
  ///
  /// In en, this message translates to:
  /// **'Milk history'**
  String get historyLog;

  /// No description provided for @noMilkEntriesForCow.
  ///
  /// In en, this message translates to:
  /// **'No milk entries logged yet for this cow.'**
  String get noMilkEntriesForCow;

  /// No description provided for @editEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit entry'**
  String get editEntry;

  /// No description provided for @deleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get deleteEntry;

  /// Used in '{what} deleted'
  ///
  /// In en, this message translates to:
  /// **'Milk entry'**
  String get milkEntryWhat;

  /// No description provided for @milkEntryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Milk entry updated'**
  String get milkEntryUpdated;

  /// No description provided for @editMilkEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit milk entry'**
  String get editMilkEntry;

  /// No description provided for @litresLabel.
  ///
  /// In en, this message translates to:
  /// **'Litres'**
  String get litresLabel;

  /// No description provided for @leaveEmptyRemoveBuyer.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to remove the buyer'**
  String get leaveEmptyRemoveBuyer;

  /// No description provided for @milkOnHoldBanner.
  ///
  /// In en, this message translates to:
  /// **'Milk on hold: do not sell until {date}'**
  String milkOnHoldBanner(String date);

  /// No description provided for @logFeeding.
  ///
  /// In en, this message translates to:
  /// **'Log feeding'**
  String get logFeeding;

  /// No description provided for @feedType.
  ///
  /// In en, this message translates to:
  /// **'Feed type'**
  String get feedType;

  /// No description provided for @cowOptional.
  ///
  /// In en, this message translates to:
  /// **'Cow (optional)'**
  String get cowOptional;

  /// No description provided for @wholeHerd.
  ///
  /// In en, this message translates to:
  /// **'Whole herd'**
  String get wholeHerd;

  /// No description provided for @quantityKg.
  ///
  /// In en, this message translates to:
  /// **'Quantity (kg)'**
  String get quantityKg;

  /// No description provided for @enterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter a quantity'**
  String get enterQuantity;

  /// No description provided for @enterValidNumberShort.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get enterValidNumberShort;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @noFeedingRecords.
  ///
  /// In en, this message translates to:
  /// **'No feeding records yet'**
  String get noFeedingRecords;

  /// No description provided for @unknownCow.
  ///
  /// In en, this message translates to:
  /// **'Unknown cow'**
  String get unknownCow;

  /// Used in '{what} deleted'
  ///
  /// In en, this message translates to:
  /// **'Feeding record'**
  String get feedingRecordWhat;

  /// No description provided for @feedHay.
  ///
  /// In en, this message translates to:
  /// **'Hay'**
  String get feedHay;

  /// No description provided for @feedSilage.
  ///
  /// In en, this message translates to:
  /// **'Silage'**
  String get feedSilage;

  /// No description provided for @feedConcentrate.
  ///
  /// In en, this message translates to:
  /// **'Concentrate'**
  String get feedConcentrate;

  /// No description provided for @feedPasture.
  ///
  /// In en, this message translates to:
  /// **'Pasture'**
  String get feedPasture;

  /// No description provided for @feedMineral.
  ///
  /// In en, this message translates to:
  /// **'Mineral Supplement'**
  String get feedMineral;

  /// No description provided for @feedDairyMeal.
  ///
  /// In en, this message translates to:
  /// **'Dairy Meal'**
  String get feedDairyMeal;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @addCowFirstHealth.
  ///
  /// In en, this message translates to:
  /// **'Add a cow before logging a health record.'**
  String get addCowFirstHealth;

  /// No description provided for @logHealthRecord.
  ///
  /// In en, this message translates to:
  /// **'Log health record'**
  String get logHealthRecord;

  /// No description provided for @presetsNote.
  ///
  /// In en, this message translates to:
  /// **'Presets only suggest a follow-up date. Change it as needed: your vet\'s advice comes first.'**
  String get presetsNote;

  /// No description provided for @cow.
  ///
  /// In en, this message translates to:
  /// **'Cow'**
  String get cow;

  /// No description provided for @recordType.
  ///
  /// In en, this message translates to:
  /// **'Record type'**
  String get recordType;

  /// No description provided for @dateLine.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String dateLine(String date);

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter a description'**
  String get enterDescription;

  /// No description provided for @medicineOptional.
  ///
  /// In en, this message translates to:
  /// **'Medicine (optional)'**
  String get medicineOptional;

  /// No description provided for @withdrawalDaysOptional.
  ///
  /// In en, this message translates to:
  /// **'Milk withdrawal days (optional)'**
  String get withdrawalDaysOptional;

  /// No description provided for @withdrawalHelper.
  ///
  /// In en, this message translates to:
  /// **'From the medicine label or your vet. The app only counts the days you enter.'**
  String get withdrawalHelper;

  /// No description provided for @enter1to60.
  ///
  /// In en, this message translates to:
  /// **'Enter 1 to 60 days'**
  String get enter1to60;

  /// No description provided for @noFollowUp.
  ///
  /// In en, this message translates to:
  /// **'No follow-up date'**
  String get noFollowUp;

  /// No description provided for @followUpOn.
  ///
  /// In en, this message translates to:
  /// **'Follow-up: {date}'**
  String followUpOn(String date);

  /// No description provided for @removeFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Remove follow-up'**
  String get removeFollowUp;

  /// No description provided for @noHealthRecords.
  ///
  /// In en, this message translates to:
  /// **'No health records yet'**
  String get noHealthRecords;

  /// No description provided for @medicineLine.
  ///
  /// In en, this message translates to:
  /// **'Medicine: {name}'**
  String medicineLine(String name);

  /// Used in '{what} deleted'
  ///
  /// In en, this message translates to:
  /// **'Health record'**
  String get healthRecordWhat;

  /// No description provided for @logRecord.
  ///
  /// In en, this message translates to:
  /// **'Log record'**
  String get logRecord;

  /// No description provided for @milkHoldEnded.
  ///
  /// In en, this message translates to:
  /// **'Milk hold ended {date}'**
  String milkHoldEnded(String date);

  /// No description provided for @milkOnHoldSafeFrom.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Milk on hold: safe from {date} (1 day left)} other{Milk on hold: safe from {date} ({count} days left)}}'**
  String milkOnHoldSafeFrom(int count, String date);

  /// No description provided for @recVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get recVaccination;

  /// No description provided for @recIllness.
  ///
  /// In en, this message translates to:
  /// **'Illness'**
  String get recIllness;

  /// No description provided for @recCheckup.
  ///
  /// In en, this message translates to:
  /// **'Checkup'**
  String get recCheckup;

  /// No description provided for @recTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get recTreatment;

  /// No description provided for @recDeworming.
  ///
  /// In en, this message translates to:
  /// **'Deworming'**
  String get recDeworming;

  /// No description provided for @recTickControl.
  ///
  /// In en, this message translates to:
  /// **'Tick control'**
  String get recTickControl;

  /// No description provided for @recHoofCare.
  ///
  /// In en, this message translates to:
  /// **'Hoof care'**
  String get recHoofCare;

  /// No description provided for @presetVetCheck.
  ///
  /// In en, this message translates to:
  /// **'Vet check'**
  String get presetVetCheck;

  /// No description provided for @presetDescVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination as advised by the vet'**
  String get presetDescVaccination;

  /// No description provided for @presetDescTick.
  ///
  /// In en, this message translates to:
  /// **'Tick control (spray or dip)'**
  String get presetDescTick;

  /// No description provided for @presetDescDeworming.
  ///
  /// In en, this message translates to:
  /// **'Deworming'**
  String get presetDescDeworming;

  /// No description provided for @presetDescHoof.
  ///
  /// In en, this message translates to:
  /// **'Hoof check and trimming'**
  String get presetDescHoof;

  /// No description provided for @presetDescVetCheck.
  ///
  /// In en, this message translates to:
  /// **'Routine vet check'**
  String get presetDescVetCheck;

  /// No description provided for @cowBreeding.
  ///
  /// In en, this message translates to:
  /// **'{name} • Breeding'**
  String cowBreeding(String name);

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @noPastCycles.
  ///
  /// In en, this message translates to:
  /// **'No past cycles yet'**
  String get noPastCycles;

  /// No description provided for @outcomeReturnedToHeat.
  ///
  /// In en, this message translates to:
  /// **'Returned to heat'**
  String get outcomeReturnedToHeat;

  /// No description provided for @outcomeHeiferKept.
  ///
  /// In en, this message translates to:
  /// **'Calved — heifer kept'**
  String get outcomeHeiferKept;

  /// No description provided for @outcomeCalfSold.
  ///
  /// In en, this message translates to:
  /// **'Calved — calf sold'**
  String get outcomeCalfSold;

  /// No description provided for @outcomeClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get outcomeClosed;

  /// No description provided for @heatOn.
  ///
  /// In en, this message translates to:
  /// **'Heat: {date}'**
  String heatOn(String date);

  /// No description provided for @servedOn.
  ///
  /// In en, this message translates to:
  /// **'Served: {date}'**
  String servedOn(String date);

  /// No description provided for @calvedOn.
  ///
  /// In en, this message translates to:
  /// **'Calved: {date}'**
  String calvedOn(String date);

  /// No description provided for @calfSoldFor.
  ///
  /// In en, this message translates to:
  /// **'Calf sold for {amount}'**
  String calfSoldFor(String amount);

  /// No description provided for @herdBreeding.
  ///
  /// In en, this message translates to:
  /// **'Herd breeding'**
  String get herdBreeding;

  /// No description provided for @noActiveCycle.
  ///
  /// In en, this message translates to:
  /// **'No active breeding cycle'**
  String get noActiveCycle;

  /// No description provided for @milestoneDue.
  ///
  /// In en, this message translates to:
  /// **'{milestone}: {date} • {due}'**
  String milestoneDue(String milestone, String date, String due);

  /// No description provided for @loadingBreeding.
  ///
  /// In en, this message translates to:
  /// **'Loading breeding status…'**
  String get loadingBreeding;

  /// No description provided for @logHeatToStart.
  ///
  /// In en, this message translates to:
  /// **'Log heat signs to start one'**
  String get logHeatToStart;

  /// No description provided for @logHeat.
  ///
  /// In en, this message translates to:
  /// **'Log heat'**
  String get logHeat;

  /// No description provided for @expectedCalving.
  ///
  /// In en, this message translates to:
  /// **'Expected calving: {date}'**
  String expectedCalving(String date);

  /// No description provided for @logServiceDate.
  ///
  /// In en, this message translates to:
  /// **'Log service date'**
  String get logServiceDate;

  /// No description provided for @logCalving.
  ///
  /// In en, this message translates to:
  /// **'Log calving'**
  String get logCalving;

  /// No description provided for @femaleKeep.
  ///
  /// In en, this message translates to:
  /// **'Female — keep'**
  String get femaleKeep;

  /// No description provided for @maleSell.
  ///
  /// In en, this message translates to:
  /// **'Male — sell'**
  String get maleSell;

  /// No description provided for @checkSuccess.
  ///
  /// In en, this message translates to:
  /// **'Check {n}: success'**
  String checkSuccess(int n);

  /// No description provided for @dateHeatSeen.
  ///
  /// In en, this message translates to:
  /// **'Date heat signs were seen'**
  String get dateHeatSeen;

  /// No description provided for @dateOfService.
  ///
  /// In en, this message translates to:
  /// **'Date of service'**
  String get dateOfService;

  /// No description provided for @dateOfCheck.
  ///
  /// In en, this message translates to:
  /// **'Date of check {n}'**
  String dateOfCheck(int n);

  /// No description provided for @calvingDate.
  ///
  /// In en, this message translates to:
  /// **'Calving date'**
  String get calvingDate;

  /// No description provided for @nameTheCalf.
  ///
  /// In en, this message translates to:
  /// **'Name the calf'**
  String get nameTheCalf;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @saleAmount.
  ///
  /// In en, this message translates to:
  /// **'Sale amount'**
  String get saleAmount;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @stageAwaitingService.
  ///
  /// In en, this message translates to:
  /// **'Heat detected — awaiting service'**
  String get stageAwaitingService;

  /// No description provided for @stageAwaitingCheck.
  ///
  /// In en, this message translates to:
  /// **'Awaiting {days}-day pregnancy check'**
  String stageAwaitingCheck(int days);

  /// No description provided for @stageConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy confirmed — counting down to calving'**
  String get stageConfirmed;

  /// No description provided for @stageDryOff.
  ///
  /// In en, this message translates to:
  /// **'Dry-off period (8 weeks to calving)'**
  String get stageDryOff;

  /// No description provided for @stagePrepWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 week to calving — final preparation} other{{count} weeks to calving — preparation}}'**
  String stagePrepWeeks(int count);

  /// No description provided for @stageCalved.
  ///
  /// In en, this message translates to:
  /// **'Calved — awaiting outcome'**
  String get stageCalved;

  /// No description provided for @stageKeptHeifer.
  ///
  /// In en, this message translates to:
  /// **'Calf kept as heifer'**
  String get stageKeptHeifer;

  /// No description provided for @stageSoldCalf.
  ///
  /// In en, this message translates to:
  /// **'Calf sold'**
  String get stageSoldCalf;

  /// No description provided for @stageFailed.
  ///
  /// In en, this message translates to:
  /// **'Returned to heat — re-service needed'**
  String get stageFailed;

  /// No description provided for @msWaitingService.
  ///
  /// In en, this message translates to:
  /// **'Waiting for service'**
  String get msWaitingService;

  /// No description provided for @msRecordOutcome.
  ///
  /// In en, this message translates to:
  /// **'Record the calf outcome'**
  String get msRecordOutcome;

  /// No description provided for @msCheckDue.
  ///
  /// In en, this message translates to:
  /// **'Check {n} due'**
  String msCheckDue(int n);

  /// No description provided for @msCalvingExpected.
  ///
  /// In en, this message translates to:
  /// **'Calving expected'**
  String get msCalvingExpected;

  /// No description provided for @dueOverdue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day overdue} other{{count} days overdue}}'**
  String dueOverdue(int count);

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get dueToday;

  /// No description provided for @dueTomorrow.
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get dueTomorrow;

  /// No description provided for @dueInDays.
  ///
  /// In en, this message translates to:
  /// **'in {count} days'**
  String dueInDays(int count);

  /// No description provided for @expenseSaved.
  ///
  /// In en, this message translates to:
  /// **'Expense saved'**
  String get expenseSaved;

  /// No description provided for @expenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expenseTitle;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @saveExpense.
  ///
  /// In en, this message translates to:
  /// **'Save expense'**
  String get saveExpense;

  /// No description provided for @catFeed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get catFeed;

  /// No description provided for @catVet.
  ///
  /// In en, this message translates to:
  /// **'Vet & medicine'**
  String get catVet;

  /// No description provided for @catLabour.
  ///
  /// In en, this message translates to:
  /// **'Labour'**
  String get catLabour;

  /// No description provided for @catTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get catTransport;

  /// No description provided for @incomeCalfSale.
  ///
  /// In en, this message translates to:
  /// **'Calf sale'**
  String get incomeCalfSale;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @periodRange.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}'**
  String periodRange(String start, String end);

  /// No description provided for @openingBalance.
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get openingBalance;

  /// No description provided for @milkCashRecords.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Milk cash (1 record)} other{Milk cash ({count} records)}}'**
  String milkCashRecords(int count);

  /// No description provided for @otherIncomeEntries.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Other income (1 entry)} other{Other income ({count} entries)}}'**
  String otherIncomeEntries(int count);

  /// No description provided for @expensesEntries.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Expenses (1 entry)} other{Expenses ({count} entries)}}'**
  String expensesEntries(int count);

  /// No description provided for @closingBalance.
  ///
  /// In en, this message translates to:
  /// **'Closing balance'**
  String get closingBalance;

  /// No description provided for @milkRecords.
  ///
  /// In en, this message translates to:
  /// **'Milk records'**
  String get milkRecords;

  /// No description provided for @otherIncome.
  ///
  /// In en, this message translates to:
  /// **'Other income'**
  String get otherIncome;

  /// No description provided for @savedFile.
  ///
  /// In en, this message translates to:
  /// **'Saved {path}'**
  String savedFile(String path);

  /// No description provided for @savedFileNotOpened.
  ///
  /// In en, this message translates to:
  /// **'Saved {path} (could not open it)'**
  String savedFileNotOpened(String path);

  /// No description provided for @couldNotSavePdf.
  ///
  /// In en, this message translates to:
  /// **'Could not save the PDF: {error}'**
  String couldNotSavePdf(String error);

  /// No description provided for @couldNotLoadMonth.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this month. Please try again.'**
  String get couldNotLoadMonth;

  /// No description provided for @nothingThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded this month.'**
  String get nothingThisMonth;

  /// No description provided for @profit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get profit;

  /// No description provided for @milk.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get milk;

  /// No description provided for @litresProduced.
  ///
  /// In en, this message translates to:
  /// **'{litres} produced'**
  String litresProduced(String litres);

  /// No description provided for @costPerLitreNone.
  ///
  /// In en, this message translates to:
  /// **'Cost per litre: no milk logged'**
  String get costPerLitreNone;

  /// No description provided for @costPerLitre.
  ///
  /// In en, this message translates to:
  /// **'Cost per litre: {amount}'**
  String costPerLitre(String amount);

  /// No description provided for @incomeVsExpenses.
  ///
  /// In en, this message translates to:
  /// **'Income vs expenses'**
  String get incomeVsExpenses;

  /// No description provided for @milkAndOther.
  ///
  /// In en, this message translates to:
  /// **'Milk {milk}  •  Other income {other}'**
  String milkAndOther(String milk, String other);

  /// No description provided for @whereMoneyWent.
  ///
  /// In en, this message translates to:
  /// **'Where the money went'**
  String get whereMoneyWent;

  /// No description provided for @noExpensesMonth.
  ///
  /// In en, this message translates to:
  /// **'No expenses recorded this month.'**
  String get noExpensesMonth;

  /// No description provided for @earningsPerBuyer.
  ///
  /// In en, this message translates to:
  /// **'Earnings per buyer'**
  String get earningsPerBuyer;

  /// No description provided for @noBuyersMonth.
  ///
  /// In en, this message translates to:
  /// **'No buyers recorded this month. Add a buyer when logging milk to see who pays the most.'**
  String get noBuyersMonth;

  /// No description provided for @notRecorded.
  ///
  /// In en, this message translates to:
  /// **'Not recorded'**
  String get notRecorded;

  /// No description provided for @shareOfMilkIncome.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of milk income'**
  String shareOfMilkIncome(String percent);

  /// No description provided for @monthInProgress.
  ///
  /// In en, this message translates to:
  /// **'{month}, 1 to {day} (month in progress)'**
  String monthInProgress(String month, int day);

  /// No description provided for @pdfAmountsGenerated.
  ///
  /// In en, this message translates to:
  /// **'Amounts in KES. Generated {date}.'**
  String pdfAmountsGenerated(String date);

  /// No description provided for @pdfPage.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {pages}'**
  String pdfPage(int page, int pages);

  /// No description provided for @statementTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Statement: {start} to {end}'**
  String statementTitle(String start, String end);

  /// No description provided for @monthlyReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Report: {period}'**
  String monthlyReportTitle(String period);

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @colDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get colDate;

  /// No description provided for @colSession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get colSession;

  /// No description provided for @colLitres.
  ///
  /// In en, this message translates to:
  /// **'Litres'**
  String get colLitres;

  /// No description provided for @colCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get colCash;

  /// No description provided for @colType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get colType;

  /// No description provided for @colNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get colNote;

  /// No description provided for @colAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get colAmount;

  /// No description provided for @colCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get colCategory;

  /// No description provided for @colDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get colDescription;

  /// No description provided for @colShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get colShare;

  /// No description provided for @colBuyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get colBuyer;

  /// No description provided for @colShareMilk.
  ///
  /// In en, this message translates to:
  /// **'Share of milk income'**
  String get colShareMilk;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get lastMonth;

  /// No description provided for @milkIncome.
  ///
  /// In en, this message translates to:
  /// **'Milk income'**
  String get milkIncome;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total income'**
  String get totalIncome;

  /// No description provided for @litresProducedLabel.
  ///
  /// In en, this message translates to:
  /// **'Litres produced'**
  String get litresProducedLabel;

  /// No description provided for @costPerLitreLabel.
  ///
  /// In en, this message translates to:
  /// **'Cost per litre'**
  String get costPerLitreLabel;

  /// No description provided for @noMilkLogged.
  ///
  /// In en, this message translates to:
  /// **'no milk logged'**
  String get noMilkLogged;

  /// No description provided for @dailyAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Today\'s milk'**
  String get dailyAnalytics;

  /// No description provided for @totalToday.
  ///
  /// In en, this message translates to:
  /// **'TOTAL PRODUCTION TODAY'**
  String get totalToday;

  /// No description provided for @aiFarmInsights.
  ///
  /// In en, this message translates to:
  /// **'AI farm insights'**
  String get aiFarmInsights;

  /// No description provided for @sessionBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Session breakdown'**
  String get sessionBreakdown;

  /// No description provided for @todaysLogs.
  ///
  /// In en, this message translates to:
  /// **'Today\'s logs'**
  String get todaysLogs;

  /// No description provided for @noMilkToday.
  ///
  /// In en, this message translates to:
  /// **'No milk has been logged yet today.'**
  String get noMilkToday;

  /// No description provided for @amountLine.
  ///
  /// In en, this message translates to:
  /// **'Amount: {amount}'**
  String amountLine(String amount);

  /// No description provided for @sessionLine.
  ///
  /// In en, this message translates to:
  /// **'Session: {session}'**
  String sessionLine(String session);

  /// No description provided for @calfDetails.
  ///
  /// In en, this message translates to:
  /// **'Calf details'**
  String get calfDetails;

  /// No description provided for @addCalf.
  ///
  /// In en, this message translates to:
  /// **'Add calf'**
  String get addCalf;

  /// No description provided for @noCalvesYet.
  ///
  /// In en, this message translates to:
  /// **'No calves yet. Calves appear here once a calving is recorded on a cow\'s breeding screen, or tap Add calf for one bought in or born before you used the app.'**
  String get noCalvesYet;

  /// No description provided for @calfSummary.
  ///
  /// In en, this message translates to:
  /// **'{total, plural, =1{1 calf} other{{total} calves}} · {kept} kept · {sold} sold'**
  String calfSummary(int total, int kept, int sold);

  /// No description provided for @calfSummaryAwaiting.
  ///
  /// In en, this message translates to:
  /// **' · {count} awaiting outcome'**
  String calfSummaryAwaiting(int count);

  /// No description provided for @calfSummaryByHand.
  ///
  /// In en, this message translates to:
  /// **' · {count} added by hand'**
  String calfSummaryByHand(int count);

  /// No description provided for @unknownDam.
  ///
  /// In en, this message translates to:
  /// **'Unknown dam'**
  String get unknownDam;

  /// No description provided for @unnamedCalf.
  ///
  /// In en, this message translates to:
  /// **'Unnamed calf'**
  String get unnamedCalf;

  /// No description provided for @calfOf.
  ///
  /// In en, this message translates to:
  /// **'Calf of {dam}'**
  String calfOf(String dam);

  /// No description provided for @kept.
  ///
  /// In en, this message translates to:
  /// **'Kept'**
  String get kept;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @soldFor.
  ///
  /// In en, this message translates to:
  /// **'Sold · {amount}'**
  String soldFor(String amount);

  /// No description provided for @awaitingOutcome.
  ///
  /// In en, this message translates to:
  /// **'Awaiting outcome'**
  String get awaitingOutcome;

  /// No description provided for @boughtIn.
  ///
  /// In en, this message translates to:
  /// **'Bought in'**
  String get boughtIn;

  /// No description provided for @onFarm.
  ///
  /// In en, this message translates to:
  /// **'On farm'**
  String get onFarm;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @sexNotRecorded.
  ///
  /// In en, this message translates to:
  /// **'Sex not recorded'**
  String get sexNotRecorded;

  /// No description provided for @damLine.
  ///
  /// In en, this message translates to:
  /// **'Dam: {dam}'**
  String damLine(String dam);

  /// No description provided for @bornLine.
  ///
  /// In en, this message translates to:
  /// **'Born {date} ({age})'**
  String bornLine(String date, String age);

  /// No description provided for @kgAtBirth.
  ///
  /// In en, this message translates to:
  /// **'{kg} kg at birth'**
  String kgAtBirth(String kg);

  /// No description provided for @weanedOn.
  ///
  /// In en, this message translates to:
  /// **'Weaned on {date}'**
  String weanedOn(String date);

  /// No description provided for @nameOptional.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get nameOptional;

  /// No description provided for @bornOn.
  ///
  /// In en, this message translates to:
  /// **'Born: {date}'**
  String bornOn(String date);

  /// No description provided for @damOptional.
  ///
  /// In en, this message translates to:
  /// **'Dam (optional)'**
  String get damOptional;

  /// No description provided for @birthWeightOptional.
  ///
  /// In en, this message translates to:
  /// **'Birth weight (optional)'**
  String get birthWeightOptional;

  /// No description provided for @birthWeight.
  ///
  /// In en, this message translates to:
  /// **'Birth weight'**
  String get birthWeight;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notWeaned.
  ///
  /// In en, this message translates to:
  /// **'Not weaned'**
  String get notWeaned;

  /// No description provided for @clearWeaning.
  ///
  /// In en, this message translates to:
  /// **'Clear weaning date'**
  String get clearWeaning;

  /// No description provided for @breedingRecord.
  ///
  /// In en, this message translates to:
  /// **'Breeding record'**
  String get breedingRecord;

  /// No description provided for @tapAgainToDelete.
  ///
  /// In en, this message translates to:
  /// **'Tap again to delete'**
  String get tapAgainToDelete;

  /// Used in '{what} deleted'
  ///
  /// In en, this message translates to:
  /// **'Calf details'**
  String get calfDetailsWhat;

  /// No description provided for @ageNotBorn.
  ///
  /// In en, this message translates to:
  /// **'not born yet'**
  String get ageNotBorn;

  /// No description provided for @ageDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String ageDays(int count);

  /// No description provided for @ageWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count} weeks'**
  String ageWeeks(int count);

  /// No description provided for @ageMonths.
  ///
  /// In en, this message translates to:
  /// **'{count} months'**
  String ageMonths(int count);

  /// No description provided for @ageYearsLong.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 year} other{{count} years}}'**
  String ageYearsLong(int count);

  /// No description provided for @enterKgRange.
  ///
  /// In en, this message translates to:
  /// **'Enter kg between 0 and 200'**
  String get enterKgRange;
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
