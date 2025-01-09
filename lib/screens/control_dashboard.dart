import 'package:flutter/material.dart';
import '../services/sensor_service.dart';
import '../widgets/control_card.dart';

class ControlDashboard extends StatefulWidget {
  const ControlDashboard({Key? key}) : super(key: key);

  @override
  State<ControlDashboard> createState() => _ControlDashboardState();
}

class _ControlDashboardState extends State<ControlDashboard> {
  final SensorService _sensorService = SensorService();

  // State variables untuk kontrol
  bool _doorLocked = false; // Status solenoid door lock
  bool _lampOn = false; // Status LED
  bool _doorOpen = false; // Status servo door

  // Sensor ID yang akan digunakan untuk update ke API
  String? sensorId;

  // Flag untuk menandai apakah sedang loading data
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _sensorService.connect(); // Connect to MQTT broker
    _fetchInitialStatus();
  }

  @override
  void dispose() {
    _sensorService.dispose(); // Clean up MQTT connection
    super.dispose();
  }

  /// Mengambil status awal dari sensor terbaru
  Future<void> _fetchInitialStatus() async {
    try {
      final sensors = await _sensorService.fetchSensorData();
      if (sensors.isNotEmpty) {
        setState(() {
          sensorId = sensors.first.id.toString(); // Convert int to String
          _doorLocked = sensors.first.doorLocked ?? false;
          _lampOn = sensors.first.lamp ?? false;
          _doorOpen = sensors.first.door ?? false;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showError('No sensor data available.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Failed to fetch initial data: $e');
    }
  }

  /// Mengubah status Door Lock
  Future<void> _toggleDoorLock() async {
    if (sensorId == null) {
      _showError('Sensor ID not available. Please refresh.');
      return;
    }

    try {
      await _sensorService.toggleDoorLock(sensorId!, _doorLocked);
      setState(() {
        _doorLocked = !_doorLocked;
      });
      // Tambahkan feedback ke user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Door ${_doorLocked ? 'Locked' : 'Unlocked'}')),
      );
    } catch (e) {
      _showError('Failed to toggle door lock: $e');
    }
  }

  /// Mengubah status Lamp
  Future<void> _toggleLamp() async {
    if (sensorId == null) {
      _showError('Sensor ID not available. Please refresh.');
      return;
    }

    try {
      await _sensorService.toggleLamp(sensorId!, _lampOn);
      setState(() {
        _lampOn = !_lampOn;
      });
      // Tambahkan feedback ke user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lamp turned ${_lampOn ? 'On' : 'Off'}')),
      );
    } catch (e) {
      _showError('Failed to toggle lamp: $e');
    }
  }

  /// Mengubah status Door
  Future<void> _toggleDoor() async {
    if (sensorId == null) {
      _showError('Sensor ID not available. Please refresh.');
      return;
    }

    try {
      await _sensorService.toggleDoor(sensorId!, _doorOpen);
      setState(() {
        _doorOpen = !_doorOpen;
      });
      // Tambahkan feedback ke user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Door ${_doorOpen ? 'Opened' : 'Closed'}')),
      );
    } catch (e) {
      _showError('Failed to toggle door: $e');
    }
  }

  /// Menampilkan pesan error dengan SnackBar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _fetchInitialStatus,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Control Dashboard'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Controlling Devices',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Lamp Control
                  ControlCard(
                    title: 'Lamp',
                    subtitle: _lampOn ? 'On' : 'Off',
                    icon: _lampOn ? Icons.lightbulb : Icons.lightbulb_outline,
                    color: Colors.amber.shade100,
                    switchControl: true,
                    switchValue:
                        _lampOn, // Gunakan state _lampOn sebagai nilai Switch
                    onSwitchChanged: (value) async {
                      try {
                        await _toggleLamp(); // Panggil fungsi untuk mengubah status Lamp
                      } catch (e) {
                        // Tangani error jika diperlukan
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  // Lock Door Control
                  ControlCard(
                    title: 'Lock Door',
                    subtitle: _doorLocked ? 'Locked' : 'Unlocked',
                    icon: _doorLocked ? Icons.lock : Icons.lock_open,
                    color: Colors.red.shade100,
                    switchControl: true,
                    switchValue:
                        _doorLocked, // Gunakan state _doorLocked sebagai nilai Switch
                    onSwitchChanged: (value) async {
                      try {
                        await _toggleDoorLock(); // Panggil fungsi untuk mengubah status Lock Door
                      } catch (e) {
                        // Tangani error jika diperlukan
                      }
                    },
                  ),

                  SizedBox(height: 10),
                  // Door Control
                  ControlCard(
                    title: 'Door',
                    subtitle: _doorOpen ? 'Open' : 'Closed',
                    icon: _doorOpen
                        ? Icons.door_front_door_outlined
                        : Icons.door_front_door,
                    color: Colors.blue.shade100,
                    switchControl: true,
                    switchValue: _doorOpen, // Atur nilai switch dari state
                    onSwitchChanged: (value) async {
                      try {
                        await _toggleDoor(); // Pastikan status diperbarui melalui API
                      } catch (e) {
                        // Handle error jika perlu
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
