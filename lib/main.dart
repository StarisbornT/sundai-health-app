import 'package:flutter/material.dart';
import 'package:health/screens/dashboard.dart';
import 'package:health/screens/journal.dart';
import 'package:health/screens/onboarding.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'models/journal_entry_model.dart';
ValueNotifier<List<JournalEntry>> journalEntriesNotifier = ValueNotifier([]);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);

  runApp(HealthApp());
}

class HealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/journal': (context) => JournalScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}

