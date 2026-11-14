// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class L10nSw extends L10n {
  L10nSw([String locale = 'sw']) : super(locale);

  @override
  String get appTitle => 'Shamba la Mwaura';

  @override
  String get dashboard => 'Dashibodi';

  @override
  String get logMilk => 'Andika maziwa';

  @override
  String get sectionHerd => 'Mifugo';

  @override
  String get sectionDailyCare => 'Huduma ya kila siku';

  @override
  String get sectionMoney => 'Pesa';

  @override
  String get navLogMilk => 'Andika Maziwa';

  @override
  String get navHerdMilk => 'Ng\'ombe na Maziwa';

  @override
  String get navBreeding => 'Uzazi';

  @override
  String get navCalfRegister => 'Rejista ya Ndama';

  @override
  String get navFeeding => 'Ulishaji';

  @override
  String get navHealth => 'Afya';

  @override
  String get navVetAssistant => 'Msaidizi wa Mifugo';

  @override
  String get navMilkPrice => 'Bei ya Maziwa';

  @override
  String get navExpenses => 'Matumizi';

  @override
  String get navStatement => 'Taarifa ya Fedha';

  @override
  String get navMonthlyReport => 'Ripoti ya Mwezi';

  @override
  String get navMilkAnalytics => 'Takwimu za Maziwa';

  @override
  String get screenColours => 'Rangi za skrini';

  @override
  String get themeLight => 'Mwanga';

  @override
  String get themeDark => 'Giza';

  @override
  String get themePhone => 'Simu';

  @override
  String get language => 'Lugha';

  @override
  String get qaAddCow => 'Ongeza Ng\'ombe';

  @override
  String get qaStatement => 'Taarifa';

  @override
  String get headerTagline => 'SAFI • MAPYA • ASILI';

  @override
  String get milkYieldTitle => 'MAZIWA (LITA)';

  @override
  String get noDataYesterday => 'Hakuna takwimu za jana';

  @override
  String changeFromYesterday(String change) {
    return '$change% ukilinganisha na jana';
  }

  @override
  String get herdSummaryTitle => 'MUHTASARI WA MIFUGO';

  @override
  String get totalAnimals => 'Jumla ya Wanyama';

  @override
  String get noCowsYet => 'Bado hakuna ng\'ombe';

  @override
  String get unknownBreed => 'Haijulikani';

  @override
  String get recentActivity => 'Shughuli za Karibuni';

  @override
  String get noRecentActivity => 'Hakuna shughuli za karibuni';

  @override
  String milkOnHoldCount(int count) {
    return 'Maziwa yamezuiliwa ($count)';
  }

  @override
  String cowNumber(int id) {
    return 'Ng\'ombe #$id';
  }

  @override
  String daysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zimebaki siku $count',
      one: 'Imebaki siku 1',
    );
    return '$_temp0';
  }

  @override
  String healthRemindersCount(int count) {
    return 'Vikumbusho vya afya ($count)';
  }

  @override
  String overdueBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imechelewa siku $count',
      one: 'Imechelewa siku 1',
    );
    return '$_temp0';
  }

  @override
  String get today => 'Leo';

  @override
  String get tomorrow => 'Kesho';

  @override
  String get yesterday => 'Jana';

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Baada ya siku $count',
      one: 'Baada ya siku 1',
    );
    return '$_temp0';
  }

  @override
  String breedingAlertsCount(int count) {
    return 'Tahadhari za Uzazi ($count)';
  }

  @override
  String get viewAll => 'Ona zote';

  @override
  String deleted(String what) {
    return '$what imefutwa';
  }

  @override
  String get undo => 'Tendua';

  @override
  String get delete => 'Futa';

  @override
  String get cancel => 'Ghairi';

  @override
  String get save => 'Hifadhi';

  @override
  String get set => 'Weka';

  @override
  String get change => 'Badilisha';

  @override
  String get sessionMorning => 'Asubuhi';

  @override
  String get sessionAfternoon => 'Mchana';

  @override
  String get sessionEvening => 'Jioni';

  @override
  String get otherDay => 'Siku nyingine';

  @override
  String get buyerForAll => 'Mnunuzi wa maziwa yote (si lazima)';

  @override
  String get couldNotLoadHerd => 'Imeshindikana kupakia mifugo.';

  @override
  String get noCowsAddFirst =>
      'Bado hakuna ng\'ombe. Ongeza ng\'ombe kwanza kutoka dashibodi.';

  @override
  String saveCowsLitres(int count, String litres, String money) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hifadhi ng\'ombe $count: $litres ≈ $money',
      one: 'Hifadhi ng\'ombe 1: $litres ≈ $money',
    );
    return '$_temp0';
  }

  @override
  String usuallyAbout(String litres) {
    return 'Kwa kawaida karibu $litres';
  }

  @override
  String noSessionMilkLast7(String session) {
    return 'Hakuna maziwa ya $session katika siku 7 zilizopita';
  }

  @override
  String savedLitres(String litres) {
    return 'Imehifadhiwa: $litres';
  }

  @override
  String milkOnHoldUntil(String date) {
    return 'Maziwa yamezuiliwa hadi $date: usiuze';
  }

  @override
  String get enterNumberAboveZero => 'Weka namba iliyo juu ya 0';

  @override
  String get typeLitresAtLeastOne => 'Andika lita za angalau ng\'ombe mmoja.';

  @override
  String get checkFiguresTitle => 'Kagua namba hizi';

  @override
  String checkFiguresBody(String lines) {
    return 'Hizi zinaonekana juu sana kuliko kawaida:\n\n$lines\n\nZihifadhi hata hivyo?';
  }

  @override
  String get goBackFix => 'Rudi urekebishe';

  @override
  String get saveAnyway => 'Hifadhi hata hivyo';

  @override
  String unusualUsual(String cow, String litres, String usual) {
    return '$cow: $litres (kwa kawaida karibu $usual)';
  }

  @override
  String savedSessionMilk(int count, String session, String litres) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maziwa ya $session yamehifadhiwa, ng\'ombe $count: $litres',
      one: 'Maziwa ya $session yamehifadhiwa, ng\'ombe 1: $litres',
    );
    return '$_temp0';
  }

  @override
  String get milkPrice => 'Bei ya maziwa';

  @override
  String get noPriceYet => 'Bado hakuna bei';

  @override
  String perLitre(String price) {
    return '$price kwa lita';
  }

  @override
  String since(String date) {
    return 'tangu $date';
  }

  @override
  String get changePrice => 'Badilisha bei';

  @override
  String get priceExplain =>
      'Weka bei hapa mnunuzi wako anapoibadilisha. Huhitaji kuiandika unapoandika maziwa.';

  @override
  String get priceHistory => 'Historia ya bei';

  @override
  String fromDate(String date) {
    return 'kuanzia $date';
  }

  @override
  String fromDateUpcoming(String date) {
    return 'kuanzia $date (inakuja)';
  }

  @override
  String get priceSaved => 'Bei ya maziwa imehifadhiwa';

  @override
  String get priceWhat => 'Bei';

  @override
  String get changeMilkPrice => 'Badilisha bei ya maziwa';

  @override
  String nowPerLitre(String price) {
    return 'Sasa: $price kwa lita';
  }

  @override
  String get newPricePerLitre => 'Bei mpya kwa lita';

  @override
  String get enterPriceAboveZero => 'Weka bei iliyo juu ya 0';

  @override
  String get priceTooHigh => 'Hiyo inaonekana juu sana kwa lita moja';

  @override
  String get appliesFrom => 'Inaanza kutumika';

  @override
  String priceChangeNote(String date) {
    return 'Mapato ya maziwa kuanzia $date yatatumia bei mpya. Maziwa ya awali yanabaki na bei yake ya zamani.';
  }

  @override
  String get setYourMilkPrice => 'Weka bei yako ya maziwa';

  @override
  String get setPriceExplain =>
      'Mapato yanatumia KSh 50 kwa lita hadi uweke bei anayolipa mnunuzi wako.';

  @override
  String milkPricePerLitre(String price) {
    return 'Bei ya maziwa: $price kwa lita';
  }

  @override
  String moreCount(int count) {
    return '+$count zaidi';
  }

  @override
  String holdCardLine(String cow, String date, String left) {
    return '$cow: usiuze hadi $date ($left)';
  }
}
