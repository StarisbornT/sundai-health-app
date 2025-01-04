import 'package:hive/hive.dart';

part 'journal_entry_model.g.dart';

@HiveType(typeId: 0) // Define a unique typeId for this model
class JournalEntry extends HiveObject {
  @HiveField(0)
  final String entryText;

  @HiveField(1)
  final String mood;

  @HiveField(2)
  final DateTime date;

  JournalEntry({
    required this.entryText,
    required this.mood,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'entryText': entryText,
      'mood': mood,
      'date': date.toIso8601String(),
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      entryText: map['entryText'] ?? '',
      mood: map['mood'] ?? '',
      date: DateTime.parse(map['date']),
    );
  }
}
