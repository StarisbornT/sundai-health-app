import 'package:flutter/material.dart';

class MoodSelector extends StatefulWidget {
  final Function(String) onMoodSelected;

  const MoodSelector({Key? key, required this.onMoodSelected}) : super(key: key);

  @override
  _MoodSelectorState createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  String? _selectedMood;

  final List<Map<String, String>> moods = [
    {"emoji": "😄", "label": "Happy"},
    {"emoji": "😐", "label": "Neutral"},
    {"emoji": "😢", "label": "Sad"},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: moods.map((mood) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedMood = mood['label'];
            });
            widget.onMoodSelected(mood['label']!);
          },
          child: Column(
            children: [
              Text(
                mood['emoji']!,
                style: TextStyle(
                  fontSize: 30,
                  color: _selectedMood == mood['label'] ? Colors.blue : Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                mood['label']!,
                style: TextStyle(
                  fontWeight: _selectedMood == mood['label']
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
