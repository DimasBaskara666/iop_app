import 'package:flutter/material.dart';
import '../models/sensor_data.dart';

class SensorTile extends StatelessWidget {
  final SensorData sensor;

  const SensorTile({Key? key, required this.sensor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
                'Temperature:', '${sensor.temperature} °C', Colors.red),
            _buildInfoRow('Humidity:', '${sensor.humidity} %', Colors.blue),
            _buildInfoRow('Motion Detected:', sensor.motion ? 'Yes' : 'No',
                Colors.orange),
            _buildInfoRow(
                'Fire Detected:', sensor.fire ? 'Yes' : 'No', Colors.red),
            _buildInfoRow(
                'Water Detected:', sensor.water ? 'Yes' : 'No', Colors.teal),
            _buildInfoRow('Door Locked:',
                sensor.doorLocked ? 'Locked' : 'Unlocked', Colors.green),
            _buildInfoRow(
                'Lamp Status:', sensor.lampOn ? 'On' : 'Off', Colors.amber),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
