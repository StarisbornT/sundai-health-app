import 'package:flutter/services.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class ApiService {
  Future<String> fetchMotivationalMessage() async {
    final data = await fetchJsonData(motivationalMessageApi);
    return data['message'] ?? 'Stay positive!';
  }

  Future<Map<String, dynamic>> fetchWearableData() async {
    return await fetchJsonData(wearableDataApi);
  }
  Future<int> fetchHealthMetrics() async {
    final data = await fetchWearableData();
    return data['steps'] ?? 0;
  }
}
