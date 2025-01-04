import 'dart:convert';
import 'package:flutter/services.dart';

Future<Map<String, dynamic>> fetchJsonData(String path) async {
  final String response = await rootBundle.loadString(path);
  return json.decode(response);
}
