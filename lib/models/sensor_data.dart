class SensorData {
  final String id;
  final double temperature;
  final double humidity;
  final bool motion;
  final bool fire;
  final bool water;
  final bool doorLocked;
  final bool lampOn;

  SensorData({
    required this.id,
    required this.temperature,
    required this.humidity,
    required this.motion,
    required this.fire,
    required this.water,
    required this.doorLocked,
    required this.lampOn,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id'],
      temperature: json['temperature'].toDouble(),
      humidity: json['humidity'].toDouble(),
      motion: json['motion'],
      fire: json['fire'],
      water: json['water'],
      doorLocked: json['door_locked'],
      lampOn: json['lamp_on'],
    );
  }
}
