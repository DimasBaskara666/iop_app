import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sensor_data.dart';

class SensorService {
  final String baseUrl = 'https://api-x-six.vercel.app/api';

  /// Mengambil data sensor dari API
  Future<List<SensorData>> fetchSensorData() async {
    final response = await http.get(Uri.parse('$baseUrl/sensors'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final sensors = data.map((item) => SensorData.fromJson(item)).toList();
      // Sort by created_at to ensure we get the latest data first
      sensors.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      return sensors;
    } else {
      throw Exception('Failed to fetch sensor data: ${response.body}');
    }
  }

  /// Mengubah status Door Lock
  Future<void> toggleDoorLock(String sensorId, bool currentStatus) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/sensors/$sensorId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'door_locked': !currentStatus}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle door lock: ${response.body}');
    }
  }

  /// Mengubah status Lamp
  Future<void> toggleLamp(String sensorId, bool currentStatus) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/sensors/$sensorId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'lamp': !currentStatus}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle lamp status: ${response.body}');
    }
  }

  /// Mengubah status Door
  Future<void> toggleDoor(String sensorId, bool currentStatus) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/sensors/$sensorId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'door': !currentStatus}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle door status: ${response.body}');
    }
  }
}
