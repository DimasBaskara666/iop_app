import 'package:flutter/material.dart';
import '../services/supabase_http_service.dart';

class ControlDashboard extends StatefulWidget {
  const ControlDashboard({Key? key}) : super(key: key);

  @override
  State<ControlDashboard> createState() => _ControlDashboardState();
}

class _ControlDashboardState extends State<ControlDashboard> {
  final SupabaseHttpService _httpService = SupabaseHttpService();

  // State variables for Door Lock and Lamp
  bool _doorLocked = true; // Default state
  bool _lampOn = false;    // Default state

  String sensorId = 'YOUR_SENSOR_ID'; // Replace with actual sensor ID from database

  @override
  void initState() {
    super.initState();
    _fetchInitialStatus();
  }

  Future<void> _fetchInitialStatus() async {
    try {
      final sensors = await _httpService.fetchSensorData();
      if (sensors.isNotEmpty) {
        setState(() {
          sensorId = sensors.first.id; // Ambil ID dari data sensor pertama
          _doorLocked = sensors.first.doorLocked;
          _lampOn = sensors.first.lampOn;
        });
      }
    } catch (e) {
      print('Error fetching initial data: $e');
    }
  }

  Future<void> _toggleDoorLock() async {
    try {
      await _httpService.toggleDoorLock(sensorId, _doorLocked);
      setState(() {
        _doorLocked = !_doorLocked;
      });
    } catch (e) {
      _showError('Failed to update door lock: $e');
    }
  }

  Future<void> _toggleLamp() async {
    try {
      await _httpService.toggleLamp(sensorId, _lampOn);
      setState(() {
        _lampOn = !_lampOn;
      });
    } catch (e) {
      _showError('Failed to update lamp status: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: Icon(
                _doorLocked ? Icons.lock : Icons.lock_open,
                color: _doorLocked ? Colors.green : Colors.red,
              ),
              title: const Text('Door Lock'),
              trailing: Switch(
                value: _doorLocked,
                onChanged: (value) => _toggleDoorLock(),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(
                _lampOn ? Icons.lightbulb : Icons.lightbulb_outline,
                color: _lampOn ? Colors.yellow : Colors.grey,
              ),
              title: const Text('Lamp'),
              trailing: Switch(
                value: _lampOn,
                onChanged: (value) => _toggleLamp(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
