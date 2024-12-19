class SensorData {
  final String id;
  final double? temperature;
  final double? humidity;
  final bool? waterSensor;
  final bool? motionSensor;
  final bool? doorLocked;
  final bool? door;
  final bool? lamp;
  final String? createdAt;

  SensorData({
    required this.id,
    this.temperature,
    this.humidity,
    this.waterSensor,
    this.motionSensor,
    this.doorLocked,
    this.door,
    this.lamp,
    this.createdAt,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id'].toString(),
      temperature: json['temperature']?.toDouble(),
      humidity: json['humidity']?.toDouble(),
      waterSensor: json['water_sensor'],
      motionSensor: json['motion_sensor'],
      doorLocked: json['door_locked'],
      door: json['door'],
      lamp: json['lamp'],
      createdAt: json['created_at'],
    );
  }
}
