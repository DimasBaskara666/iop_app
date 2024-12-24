import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../services/sensor_service.dart';
import '../widgets/sensor_tile.dart';

class SensorDashboard extends StatefulWidget {
  @override
  _SensorDashboardState createState() => _SensorDashboardState();
}

class _SensorDashboardState extends State<SensorDashboard> {
  final SensorService _sensorService = SensorService();
  List<SensorData> _sensors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSensors();
  }

  Future<void> _fetchSensors() async {
    try {
      final sensors = await _sensorService.fetchSensorData();
      setState(() {
        _sensors = sensors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load sensors: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _buildTemperatureText(double? temperature) {
    if (temperature == null) return 'N/A';

    final temp = temperature.toStringAsFixed(1);
    if (temperature > 28) {
      return '$temp °C|red'; // Hot temperature
    } else if (temperature < 20) {
      return '$temp °C|blue'; // Cold temperature
    } else {
      return '$temp °C|green'; // Normal temperature
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sensor Dashboard'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _sensors.length,
              itemBuilder: (context, index) {
                final sensor = _sensors[index];
                return SensorTile(
                  title: 'Sensor ${sensor.id}',
                  subtitle: 'Time: ${sensor.createdAt}',
                  icon: Icons.thermostat,
                  additionalInfo: {
                    'Temperature': _buildTemperatureText(sensor.temperature),
                    'Humidity':
                        '${sensor.humidity?.toStringAsFixed(1) ?? 'N/A'}%',
                    'Motion': sensor.motionSensor == true
                        ? 'Detected'
                        : 'Not Detected',
                    'Water': sensor.waterSensor == true
                        ? 'Detected'
                        : 'Not Detected',
                    'Door': sensor.door == true ? 'Open' : 'Closed',
                  },
                );
              },
            ),
    );
  }
}
