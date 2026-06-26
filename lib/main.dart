import 'package:cow/database/app_database.dart';
import 'package:cow/models/milk.dart';
import 'package:cow/screens/analytics_dashboard.dart';
import 'package:cow/screens/cow_dashboard.dart';
import 'package:cow/screens/daily_record.dart';
import 'package:cow/screens/main_dashboard.dart';
import 'package:cow/screens/milk_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //OPEN DATABASE CONNECTIOON ONCE APPLICATION BOOTS UP

  runApp(
    Provider<AppDatabase>(
      create: (context) => AppDatabase(),
      dispose: (context, db) => db.close(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MWAURA'S FARM",
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.green,
        ),

        //colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: MainDashboard(),
    );
  }
}
