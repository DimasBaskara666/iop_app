import 'package:flutter/material.dart';
import 'control_dashboard.dart';
import 'sensor_dashboard.dart';
import '../services/sensor_service.dart';
import '../models/sensor_data.dart';
import '../utils/page_transition.dart';

class HomePage extends StatelessWidget {
  final SensorService _sensorService = SensorService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Use SingleChildScrollView to prevent overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SMART CASA',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'WELCOME, PUTRI!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.account_circle,
                          size: 32,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Navigation Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    NavigationButton(
                      label: 'Monitoring',
                      onTap: () {
                        Navigator.push(
                          context,
                          SlidePageRoute(page: SensorDashboard()),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    NavigationButton(
                      label: 'Controlling',
                      onTap: () {
                        Navigator.push(
                          context,
                          SlidePageRoute(page: ControlDashboard()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Control Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: StreamBuilder<List<SensorData>>(
                        stream: Stream.periodic(Duration(seconds: 5))
                            .asyncMap((_) => _sensorService.fetchSensorData()),
                        builder: (context, snapshot) {
                          final isLampOn =
                              snapshot.hasData && snapshot.data!.isNotEmpty
                                  ? snapshot.data!.first.lamp ?? false
                                  : false;

                          return ControlCard(
                            title: 'Lamp',
                            subtitle: isLampOn ? 'ON' : 'OFF',
                            icon: isLampOn
                                ? Icons.lightbulb
                                : Icons.lightbulb_outline,
                            color: Colors.amber.shade100,
                            onTap: () {}, // Action for Lamp
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: StreamBuilder<List<SensorData>>(
                        stream: Stream.periodic(Duration(seconds: 5))
                            .asyncMap((_) => _sensorService.fetchSensorData()),
                        builder: (context, snapshot) {
                          final isDoorLocked =
                              snapshot.hasData && snapshot.data!.isNotEmpty
                                  ? snapshot.data!.first.doorLocked ?? false
                                  : false;

                          return ControlCard(
                            title: 'Lock Door',
                            subtitle: isDoorLocked ? 'LOCKED' : 'UNLOCKED',
                            icon: isDoorLocked ? Icons.lock : Icons.lock_open,
                            color: Colors.red.shade100,
                            onTap: () {}, // Action for Door Lock
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Frequently Used Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Frequently Used',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    QuickAction(icon: Icons.lightbulb, label: 'Lamp'),
                    QuickAction(icon: Icons.thermostat, label: 'Temperature'),
                    QuickAction(icon: Icons.lock, label: 'Lock Door'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const NavigationButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orangeAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(
            vertical: 16, horizontal: 24), // Added padding for a better look
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        ],
      ),
    );
  }
}

class ControlCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool switchControl;
  final VoidCallback? onTap;

  const ControlCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.switchControl = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14),
            ),
            if (switchControl)
              Switch(
                value: true,
                onChanged: (value) {},
              ),
          ],
        ),
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const QuickAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.orangeAccent.withOpacity(0.2),
          child: Icon(icon, color: Colors.orangeAccent),
        ),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
