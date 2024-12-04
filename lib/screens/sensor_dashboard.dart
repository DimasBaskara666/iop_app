import 'package:flutter/material.dart';
import '../services/supabase_http_service.dart';
import '../models/sensor_data.dart';
import '../widgets/sensor_tile.dart';

class SensorDashboard extends StatefulWidget {
  @override
  _SensorDashboardState createState() => _SensorDashboardState();
}

class _SensorDashboardState extends State<SensorDashboard> {
  final SupabaseHttpService _httpService = SupabaseHttpService();
  late Future<List<SensorData>> _sensorData;

  @override
  void initState() {
    super.initState();
    _sensorData = _httpService.fetchSensorData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _sensorData = _httpService.fetchSensorData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('IoT Monitoring Dashboard')),
      body: FutureBuilder<List<SensorData>>(
        future: _sensorData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final sensors = snapshot.data ?? [];
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
              itemCount: sensors.length,
              itemBuilder: (context, index) {
                final sensor = sensors[index];
                return SensorTile(sensor: sensor);
              },
            ),
          );
        },
      ),
    );
  }
}
