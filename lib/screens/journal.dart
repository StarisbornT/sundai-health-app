import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import '../models/journal_entry_model.dart';
import '../widgets/mood_selector.dart';

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  String journalEntry = "";
  String mood = "😊";
  int steps = 0;
  String motivationalMessage = "Stay positive!";
  Box<JournalEntry>? journalBox;

  @override
  void initState() {
    super.initState();
    initializeHive();
    fetchHealthData();
    fetchMotivationalMessage();
  }

  Future<void> initializeHive() async {
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);
    Hive.registerAdapter(JournalEntryAdapter());
    journalBox = await Hive.openBox<JournalEntry>('journalBox');
  }

  void fetchHealthData() async {
    try {
      final String response =
      await rootBundle.loadString('assets/wearable_data.json');
      final data = json.decode(response);
      setState(() {
        steps = data['steps'];
      });
    } catch (error) {
      setState(() {
        steps = 0; // Default value in case of an error
      });
    }
  }

  void fetchMotivationalMessage() async {
    try {
      final String response =
      await rootBundle.loadString('assets/motivational_messages.json');
      final data = json.decode(response);
      setState(() {
        motivationalMessage = data['message'];
      });
    } catch (error) {
      setState(() {
        motivationalMessage = "Keep going! You're amazing!"; // Fallback message
      });
    }
  }

  void saveJournal() async {
    if (journalBox != null && journalEntry.isNotEmpty) {
      final newEntry = JournalEntry(
        entryText: journalEntry,
        mood: mood,
        date: DateTime.now(),
      );

      await journalBox!.add(newEntry);
      final updatedEntries = journalBox!.values.toList();
      journalEntriesNotifier.value = updatedEntries; // Update the notifier
      setState(() {
        journalEntry = "";
        mood = "😊";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Journal entry saved successfully!")),
      );
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Journal")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Steps Today: $steps",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "Motivational Message: $motivationalMessage",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) => setState(() => journalEntry = value),
                  decoration: InputDecoration(
                    labelText: "Write your journal",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 20),
                Text(
                  "Select Mood:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                MoodSelector(
                  onMoodSelected: (selectedMood) {
                    setState(() {
                      mood = selectedMood;
                    });
                  },
                ),
                SizedBox(height: 20), // Add some spacing at the bottom
                Center(
                  child: ElevatedButton(
                    onPressed: saveJournal,
                    child: Text("Save Journal"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
