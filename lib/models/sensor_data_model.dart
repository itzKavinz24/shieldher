class SensorDataModel {
  final int heartRate;
  final int gsr;

  final double accelX;
  final double accelY;
  final double accelZ;

  final double gyroX;
  final double gyroY;
  final double gyroZ;

  final double spo2;

  final DateTime timestamp;

  const SensorDataModel({
    required this.heartRate,
    required this.gsr,
    required this.accelX,
    required this.accelY,
    required this.accelZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
    required this.spo2,
    required this.timestamp,
  }); 

  Map<String, dynamic> toJson() {
    return {
      'heartRate': heartRate,
      'gsr': gsr,
      'accelX': accelX,
      'accelY': accelY,
      'accelZ': accelZ,
      'gyroX': gyroX,
      'gyroY': gyroY,
      'gyroZ': gyroZ,
      'spo2': spo2,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SensorDataModel.fromJson(Map<String, dynamic> json) {
    return SensorDataModel(
      heartRate: json['heartRate'],
      gsr: json['gsr'],
      accelX: json['accelX'].toDouble(),
      accelY: json['accelY'].toDouble(),
      accelZ: json['accelZ'].toDouble(),
      gyroX: json['gyroX'].toDouble(),
      gyroY: json['gyroY'].toDouble(),
      gyroZ: json['gyroZ'].toDouble(),
      spo2: json['spo2'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}