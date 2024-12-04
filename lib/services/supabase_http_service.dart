import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sensor_data.dart';

class SupabaseHttpService {
  final String supabaseUrl = 'https://ibysuirarplqcjlexbjs.supabase.co';
  final String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlieXN1aXJhcnBscWNqbGV4YmpzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA2MjgwMDIsImV4cCI6MjA0NjIwNDAwMn0.6f3Yv0t3e9HbjhBOOKmizpaRCYOFdXiAJfGektA0tsc';

  Future<List<SensorData>> fetchSensorData() async {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/sensors?order=created_at.desc&limit=10'),
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((json) => SensorData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sensor data: ${response.body}');
    }
  }

  Future<void> toggleDoorLock(String id, bool currentStatus) async {
    final response = await http.patch(
      Uri.parse('$supabaseUrl/rest/v1/sensors?id=eq.$id'),
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({'door_locked': !currentStatus}),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update door lock: ${response.body}');
    }
  }

  Future<void> toggleLamp(String id, bool currentStatus) async {
    final response = await http.patch(
      Uri.parse('$supabaseUrl/rest/v1/sensors?id=eq.$id'),
      headers: {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({'lamp_on': !currentStatus}),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update lamp status: ${response.body}');
    }
  }
}
