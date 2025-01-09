import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../models/sensor_data.dart';

class SensorService {
  final String baseUrl = 'https://api-x-six.vercel.app/api';
  late final MqttServerClient mqttClient;
  bool _isConnected = false;

  // MQTT Topics
  static const String lampTopic = 'smart_casa/control/lamp';
  static const String doorLockTopic = 'smart_casa/control/door_lock';
  static const String doorTopic = 'smart_casa/control/door';

  SensorService() {
    // Initialize MQTT Client
    mqttClient = MqttServerClient('broker.hivemq.com',
        'flutter_client_${DateTime.now().millisecondsSinceEpoch}');
    _setupMqttClient();
  }

  void _setupMqttClient() {
    mqttClient.logging(on: false);
    mqttClient.keepAlivePeriod = 60;
    mqttClient.onConnected = _onConnected;
    mqttClient.onDisconnected = _onDisconnected;
    mqttClient.onSubscribed = _onSubscribed;
    mqttClient.pongCallback = _pong;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(
            'flutter_client_${DateTime.now().millisecondsSinceEpoch}')
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    mqttClient.connectionMessage = connMessage;
  }

  Future<void> connect() async {
    if (!_isConnected) {
      try {
        await mqttClient.connect();
      } catch (e) {
        print('Exception: $e');
        mqttClient.disconnect();
      }
    }
  }

  void _onConnected() {
    print('Connected to MQTT Broker');
    _isConnected = true;
  }

  void _onDisconnected() {
    print('Disconnected from MQTT Broker');
    _isConnected = false;
  }

  void _onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  void _pong() {
    print('Ping response received');
  }

  /// Mengambil data sensor dari API
  Future<List<SensorData>> fetchSensorData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/sensors'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final sensors = data.map((item) => SensorData.fromJson(item)).toList();
        sensors.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        return sensors;
      } else {
        throw Exception('Failed to fetch sensor data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching sensor data: $e');
      rethrow;
    }
  }

  /// Mengubah status Door Lock via MQTT
  Future<void> toggleDoorLock(String sensorId, bool currentStatus) async {
    await _publishMessage(doorLockTopic, !currentStatus);
  }

  /// Mengubah status Lamp via MQTT
  Future<void> toggleLamp(String sensorId, bool currentStatus) async {
    await _publishMessage(lampTopic, !currentStatus);
  }

  /// Mengubah status Door via MQTT
  Future<void> toggleDoor(String sensorId, bool currentStatus) async {
    await _publishMessage(doorTopic, !currentStatus);
  }

  /// Helper method untuk publish message
  Future<void> _publishMessage(String topic, bool value) async {
    if (!_isConnected) {
      await connect();
    }

    try {
      final builder = MqttClientPayloadBuilder();
      builder.addString(value.toString());

      mqttClient.publishMessage(
        topic,
        MqttQos.exactlyOnce,
        builder.payload!,
        retain: false,
      );

      print('Published message to $topic: $value');
    } catch (e) {
      print('Error publishing message: $e');
      rethrow;
    }
  }

  // Dispose method to clean up resources
  void dispose() {
    if (_isConnected) {
      mqttClient.disconnect();
    }
  }
}
