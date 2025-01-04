import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import '../main.dart';
import '../models/journal_entry_model.dart';
import '../services/api_service.dart';
import '../widgets/graph_widget.dart';
import 'journal.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<JournalEntry> journalEntries = [];
  int totalSteps = 0;

  @override
  void initState() {
    super.initState();
    journalEntriesNotifier.addListener(() {
      setState(() {
        journalEntries = journalEntriesNotifier.value;
      });
    });

    fetchJournalEntries();
    fetchHealthMetrics();
  }

  void fetchJournalEntries() async {
    final box = await Hive.openBox<JournalEntry>('journalBox');
    setState(() {
      journalEntries = box.values.toList();
    });
  }

  void fetchHealthMetrics() async {
    try {
      final steps = await ApiService().fetchHealthMetrics();
      setState(() {
        totalSteps = steps;
      });
    } catch (error) {
      setState(() {
        totalSteps = 0;
      });
    }
  }

  List<FlSpot> _generateMoodData() {
    final List<FlSpot> spots = [];
    for (int i = 0; i < journalEntries.length && i < 7; i++) {
      final moodValue = _mapMoodToValue(journalEntries[i].mood);
      spots.add(FlSpot(i.toDouble(), moodValue.toDouble()));
    }
    return spots;
  }

  double _mapMoodToValue(String mood) {
    switch (mood) {
      case "😊":
        return 5.0;
      case "😐":
        return 3.0;
      case "😔":
        return 1.0;
      default:
        return 0.0;
    }
  }

  Widget _buildHighlightCard() {
    if (journalEntries.isEmpty) {
      return Text("No journal entries available.");
    }

    final positiveEntry = journalEntries.reduce((current, next) {
      return _mapMoodToValue(current.mood) > _mapMoodToValue(next.mood)
          ? current
          : next;
    });

    return Card(
      child: ListTile(
        title: Text("Most Positive Entry"),
        subtitle: Text(positiveEntry.entryText),
        trailing: Text(positiveEntry.mood),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Steps: $totalSteps",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Mood Trends (Last 7 Entries)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: GraphWidget(moodData: _generateMoodData()),
            ),
            SizedBox(height: 20),
            _buildHighlightCard(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JournalScreen()),
                );
              },
              child: Text("Go to Journal Screen"),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    journalEntriesNotifier.removeListener(() {});
    super.dispose();
  }
}








