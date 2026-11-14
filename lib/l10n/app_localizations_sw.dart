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

  @override
  String get myHerd => 'Mifugo Yangu';

  @override
  String errorLoading(String error) {
    return 'Hitilafu kupakia data: $error';
  }

  @override
  String get noCowsInHerd => 'Bado hakuna ng\'ombe kwenye mifugo yako!';

  @override
  String tagLine(String tag) {
    return 'Namba ya hereni: $tag';
  }

  @override
  String get noTag => 'Hakuna hereni';

  @override
  String breedAgeLine(String breed, String age) {
    return 'Aina: $breed • Umri: $age';
  }

  @override
  String ageYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'miaka $count',
      one: 'mwaka 1',
    );
    return '$_temp0';
  }

  @override
  String get notAvailable => 'Haijulikani';

  @override
  String get couldNotPickImage => 'Imeshindikana kuchagua picha';

  @override
  String cowSaved(String name) {
    return '$name amehifadhiwa';
  }

  @override
  String failedToSave(String error) {
    return 'Imeshindikana kuhifadhi: $error';
  }

  @override
  String get tapToUploadPhoto => 'Gusa kuongeza picha ya ng\'ombe';

  @override
  String get tagNumber => 'Namba ya hereni';

  @override
  String get cowName => 'Jina la ng\'ombe';

  @override
  String get enterName => 'Tafadhali weka jina';

  @override
  String get breed => 'Aina';

  @override
  String get selectBreed => 'Chagua aina ya ng\'ombe';

  @override
  String get ageInYears => 'Umri (miaka)';

  @override
  String get enterValidNumber => 'Tafadhali weka namba sahihi';

  @override
  String get saveCow => 'Hifadhi ng\'ombe';

  @override
  String get choosePhoto => 'Chagua picha ya ng\'ombe';

  @override
  String get fromGallery => 'Pakia kutoka kwenye picha';

  @override
  String get takePhoto => 'Piga picha mpya';

  @override
  String get removeCowTitle => 'Ondoa ng\'ombe';

  @override
  String removeCowQuestion(String name) {
    return 'Una uhakika unataka kumwondoa $name kwenye mifugo?';
  }

  @override
  String get continueLabel => 'Endelea';

  @override
  String get cannotBeUndoneTitle => 'Hili haliwezi kutenduliwa';

  @override
  String deleteCowWarning(String name) {
    return 'Kumbukumbu zote za $name (maziwa, afya, ulishaji na uzazi) zitafutwa kabisa.';
  }

  @override
  String get deletePermanently => 'Futa kabisa';

  @override
  String get deleting => 'Inafuta…';

  @override
  String get deletionComplete => 'Imefutwa';

  @override
  String milkEntryFor(String name) {
    return 'Maziwa: $name';
  }

  @override
  String get milkingSession => 'Kipindi cha kukamua';

  @override
  String get milkQuantity => 'Kiasi cha maziwa';

  @override
  String get enterAmount => 'Tafadhali weka kiasi';

  @override
  String get quantityAboveZero => 'Kiasi lazima kiwe zaidi ya sifuri';

  @override
  String get buyerOptional => 'Mnunuzi (si lazima)';

  @override
  String get buyerHint => 'mf. chama cha ushirika, hoteli, jirani';

  @override
  String savedAmount(String litres) {
    return 'Imehifadhiwa $litres';
  }

  @override
  String get historyLog => 'Historia ya maziwa';

  @override
  String get noMilkEntriesForCow =>
      'Bado hakuna maziwa yaliyoandikwa kwa ng\'ombe huyu.';

  @override
  String get editEntry => 'Hariri';

  @override
  String get deleteEntry => 'Futa';

  @override
  String get milkEntryWhat => 'Kumbukumbu ya maziwa';

  @override
  String get milkEntryUpdated => 'Maziwa yamesasishwa';

  @override
  String get editMilkEntry => 'Hariri kumbukumbu ya maziwa';

  @override
  String get litresLabel => 'Lita';

  @override
  String get leaveEmptyRemoveBuyer => 'Acha wazi kumwondoa mnunuzi';

  @override
  String milkOnHoldBanner(String date) {
    return 'Maziwa yamezuiliwa: usiuze hadi $date';
  }

  @override
  String get logFeeding => 'Andika ulishaji';

  @override
  String get feedType => 'Aina ya chakula';

  @override
  String get cowOptional => 'Ng\'ombe (si lazima)';

  @override
  String get wholeHerd => 'Mifugo yote';

  @override
  String get quantityKg => 'Kiasi (kg)';

  @override
  String get enterQuantity => 'Weka kiasi';

  @override
  String get enterValidNumberShort => 'Weka namba sahihi';

  @override
  String get notesOptional => 'Maelezo (si lazima)';

  @override
  String get noFeedingRecords => 'Bado hakuna kumbukumbu za ulishaji';

  @override
  String get unknownCow => 'Ng\'ombe asiyejulikana';

  @override
  String get feedingRecordWhat => 'Kumbukumbu ya ulishaji';

  @override
  String get feedHay => 'Hei (nyasi kavu)';

  @override
  String get feedSilage => 'Sileji';

  @override
  String get feedConcentrate => 'Chakula cha nyongeza';

  @override
  String get feedPasture => 'Malisho';

  @override
  String get feedMineral => 'Madini ya nyongeza';

  @override
  String get feedDairyMeal => 'Dairy meal';

  @override
  String get other => 'Nyingine';

  @override
  String get addCowFirstHealth =>
      'Ongeza ng\'ombe kabla ya kuandika kumbukumbu ya afya.';

  @override
  String get logHealthRecord => 'Andika kumbukumbu ya afya';

  @override
  String get presetsNote =>
      'Chaguo hizi zinapendekeza tu tarehe ya ufuatiliaji. Ibadilishe inapohitajika: ushauri wa daktari wako wa mifugo ndio wa kwanza.';

  @override
  String get cow => 'Ng\'ombe';

  @override
  String get recordType => 'Aina ya kumbukumbu';

  @override
  String dateLine(String date) {
    return 'Tarehe: $date';
  }

  @override
  String get description => 'Maelezo';

  @override
  String get enterDescription => 'Weka maelezo';

  @override
  String get medicineOptional => 'Dawa (si lazima)';

  @override
  String get withdrawalDaysOptional => 'Siku za kuzuia maziwa (si lazima)';

  @override
  String get withdrawalHelper =>
      'Kutoka kwenye lebo ya dawa au kwa daktari wako. Programu inahesabu tu siku unazoweka.';

  @override
  String get enter1to60 => 'Weka siku 1 hadi 60';

  @override
  String get noFollowUp => 'Hakuna tarehe ya ufuatiliaji';

  @override
  String followUpOn(String date) {
    return 'Ufuatiliaji: $date';
  }

  @override
  String get removeFollowUp => 'Ondoa ufuatiliaji';

  @override
  String get noHealthRecords => 'Bado hakuna kumbukumbu za afya';

  @override
  String medicineLine(String name) {
    return 'Dawa: $name';
  }

  @override
  String get healthRecordWhat => 'Kumbukumbu ya afya';

  @override
  String get logRecord => 'Andika kumbukumbu';

  @override
  String milkHoldEnded(String date) {
    return 'Kuzuia maziwa kuliisha $date';
  }

  @override
  String milkOnHoldSafeFrom(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maziwa yamezuiliwa: salama kuanzia $date (zimebaki siku $count)',
      one: 'Maziwa yamezuiliwa: salama kuanzia $date (imebaki siku 1)',
    );
    return '$_temp0';
  }

  @override
  String get recVaccination => 'Chanjo';

  @override
  String get recIllness => 'Ugonjwa';

  @override
  String get recCheckup => 'Uchunguzi';

  @override
  String get recTreatment => 'Matibabu';

  @override
  String get recDeworming => 'Dawa ya minyoo';

  @override
  String get recTickControl => 'Kudhibiti kupe';

  @override
  String get recHoofCare => 'Utunzaji wa kwato';

  @override
  String get presetVetCheck => 'Ukaguzi wa daktari';

  @override
  String get presetDescVaccination =>
      'Chanjo kama alivyoshauri daktari wa mifugo';

  @override
  String get presetDescTick => 'Kudhibiti kupe (kunyunyizia au kuogesha)';

  @override
  String get presetDescDeworming => 'Dawa ya minyoo';

  @override
  String get presetDescHoof => 'Ukaguzi na ukataji wa kwato';

  @override
  String get presetDescVetCheck => 'Ukaguzi wa kawaida wa daktari';

  @override
  String cowBreeding(String name) {
    return '$name • Uzazi';
  }

  @override
  String get history => 'Historia';

  @override
  String get noPastCycles => 'Bado hakuna mizunguko iliyopita';

  @override
  String get outcomeReturnedToHeat => 'Amerudi kwenye joto';

  @override
  String get outcomeHeiferKept => 'Amezaa — mtamba amebakizwa';

  @override
  String get outcomeCalfSold => 'Amezaa — ndama ameuzwa';

  @override
  String get outcomeClosed => 'Imefungwa';

  @override
  String heatOn(String date) {
    return 'Joto: $date';
  }

  @override
  String servedOn(String date) {
    return 'Amepandishwa: $date';
  }

  @override
  String calvedOn(String date) {
    return 'Amezaa: $date';
  }

  @override
  String calfSoldFor(String amount) {
    return 'Ndama ameuzwa kwa $amount';
  }

  @override
  String get herdBreeding => 'Uzazi wa mifugo';

  @override
  String get noActiveCycle => 'Hakuna mzunguko wa uzazi unaoendelea';

  @override
  String milestoneDue(String milestone, String date, String due) {
    return '$milestone: $date • $due';
  }

  @override
  String get loadingBreeding => 'Inapakia hali ya uzazi…';

  @override
  String get logHeatToStart => 'Andika dalili za joto kuanza mzunguko';

  @override
  String get logHeat => 'Andika joto';

  @override
  String expectedCalving(String date) {
    return 'Anatarajiwa kuzaa: $date';
  }

  @override
  String get logServiceDate => 'Andika tarehe ya kupandishwa';

  @override
  String get logCalving => 'Andika kuzaa';

  @override
  String get femaleKeep => 'Jike — bakiza';

  @override
  String get maleSell => 'Dume — uza';

  @override
  String checkSuccess(int n) {
    return 'Kipimo $n: mimba ipo';
  }

  @override
  String get dateHeatSeen => 'Tarehe dalili za joto zilionekana';

  @override
  String get dateOfService => 'Tarehe ya kupandishwa';

  @override
  String dateOfCheck(int n) {
    return 'Tarehe ya kipimo $n';
  }

  @override
  String get calvingDate => 'Tarehe ya kuzaa';

  @override
  String get nameTheCalf => 'Mpe ndama jina';

  @override
  String get add => 'Ongeza';

  @override
  String get saleAmount => 'Bei ya kuuza';

  @override
  String get sell => 'Uza';

  @override
  String get stageAwaitingService => 'Joto limeonekana — anasubiri kupandishwa';

  @override
  String stageAwaitingCheck(int days) {
    return 'Anasubiri kipimo cha mimba cha siku $days';
  }

  @override
  String get stageConfirmed =>
      'Mimba imethibitishwa — kuhesabu siku hadi kuzaa';

  @override
  String get stageDryOff => 'Kipindi cha kukausha (wiki 8 kabla ya kuzaa)';

  @override
  String stagePrepWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wiki $count kabla ya kuzaa — maandalizi',
      one: 'Wiki 1 kabla ya kuzaa — maandalizi ya mwisho',
    );
    return '$_temp0';
  }

  @override
  String get stageCalved => 'Amezaa — tunasubiri uamuzi wa ndama';

  @override
  String get stageKeptHeifer => 'Ndama amebakizwa kama mtamba';

  @override
  String get stageSoldCalf => 'Ndama ameuzwa';

  @override
  String get stageFailed => 'Amerudi kwenye joto — apandishwe tena';

  @override
  String get msWaitingService => 'Anasubiri kupandishwa';

  @override
  String get msRecordOutcome => 'Andika uamuzi kuhusu ndama';

  @override
  String msCheckDue(int n) {
    return 'Kipimo $n kinatakiwa';
  }

  @override
  String get msCalvingExpected => 'Anatarajiwa kuzaa';

  @override
  String dueOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'amechelewa siku $count',
      one: 'amechelewa siku 1',
    );
    return '$_temp0';
  }

  @override
  String get dueToday => 'leo';

  @override
  String get dueTomorrow => 'kesho';

  @override
  String dueInDays(int count) {
    return 'baada ya siku $count';
  }
}
