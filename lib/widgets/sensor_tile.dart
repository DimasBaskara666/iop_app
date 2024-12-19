import 'package:flutter/material.dart';

class SensorTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Map<String, String> additionalInfo;

  const SensorTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.additionalInfo = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: Colors.orangeAccent),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(subtitle),
                  ],
                ),
              ],
            ),
            if (additionalInfo.isNotEmpty) ...[
              SizedBox(height: 12),
              ...additionalInfo.entries.map((entry) => Text(
                    '${entry.key}: ${entry.value}',
                    style: TextStyle(fontSize: 14),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
