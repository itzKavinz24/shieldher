import '../../models/sensor_data_model.dart';
import 'model_loader_service.dart';

class RiskResult {
  final int riskScore;
  final String riskLevel;
  final double confidence;

  const RiskResult({
    required this.riskScore,
    required this.riskLevel,
    required this.confidence,
  });

  bool get isLow => riskLevel == "LOW";
  bool get isMedium => riskLevel == "MEDIUM";
  bool get isHigh => riskLevel == "HIGH";
}

class RiskEngineService {
  RiskResult calculateRisk({
    required ModelPrediction prediction,
    required SensorDataModel sensorData,
  }) {
    double score = 0;

    //------------------------------------
    // 1. AI Prediction (60%)
    //------------------------------------
    switch (prediction.label) {
      case "HIGH":
        score += 60;
        break;
      case "MEDIUM":
        score += 35;
        break;
      case "LOW":
        score += 10;
        break;
    }

    //------------------------------------
    // 2. Heart Rate
    //------------------------------------
    if (sensorData.heartRate >= 140) {
      score += 15;
    } else if (sensorData.heartRate >= 120) {
      score += 10;
    } else if (sensorData.heartRate >= 100) {
      score += 5;
    }

    //------------------------------------
    // 3. GSR
    //------------------------------------
    if (sensorData.gsr >= 900) {
      score += 15;
    } else if (sensorData.gsr >= 700) {
      score += 10;
    } else if (sensorData.gsr >= 500) {
      score += 5;
    }

    //------------------------------------
    // 4. Motion Intensity
    //------------------------------------
    final motion =
        sensorData.accelX.abs() +
        sensorData.accelY.abs() +
        sensorData.accelZ.abs() +
        sensorData.gyroX.abs() +
        sensorData.gyroY.abs() +
        sensorData.gyroZ.abs();

    if (motion >= 40) {
      score += 10;
    } else if (motion >= 20) {
      score += 5;
    }

    //------------------------------------
    // Clamp to 100
    //------------------------------------
    if (score > 100) {
      score = 100;
    }

    //------------------------------------
    // Final Level
    //------------------------------------
    String level;

    if (score >= 75) {
      level = "HIGH";
    } else if (score >= 45) {
      level = "MEDIUM";
    } else {
      level = "LOW";
    }

    return RiskResult(
      riskScore: score.round(),
      riskLevel: level,
      confidence: prediction.confidence,
    );
  }
}