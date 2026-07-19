import '../../models/sensor_data_model.dart';

class SensorFusionService {
  int _heartRate = 0;
  int _gsr = 0;

  double _accelX = 0;
  double _accelY = 0;
  double _accelZ = 0;

  double _gyroX = 0;
  double _gyroY = 0;
  double _gyroZ = 0;

  void updateHealthData({
    required int heartRate,
    required int gsr,
  }) {
    _heartRate = heartRate;
    _gsr = gsr;
  }

  void updateMotionData({
    required double accelX,
    required double accelY,
    required double accelZ,
    required double gyroX,
    required double gyroY,
    required double gyroZ,
  }) {
    _accelX = accelX;
    _accelY = accelY;
    _accelZ = accelZ;

    _gyroX = gyroX;
    _gyroY = gyroY;
    _gyroZ = gyroZ;
  }

  SensorDataModel getSensorData() {
    return SensorDataModel(
      heartRate: _heartRate,
      gsr: _gsr,
      accelX: _accelX,
      accelY: _accelY,
      accelZ: _accelZ,
      gyroX: _gyroX,
      gyroY: _gyroY,
      gyroZ: _gyroZ,
      timestamp: DateTime.now(),
    );
  }
}