import 'package:flutter/foundation.dart';

import '../../models/feature_vector_model.dart';
import '../../models/sensor_data_model.dart';
import 'decision_engine_service.dart';
import 'model_loader_service.dart';
import 'risk_engine_service.dart';

class PredictionLoggerService {
  Future<void> logPrediction({
    required SensorDataModel sensorData,
    required FeatureVectorModel featureVector,
    required ModelPrediction prediction,
    required RiskResult riskResult,
    required DecisionResult decisionResult,
  }) async {
    debugPrint("");
    debugPrint("===========================================");
    debugPrint("        SHIELDHER AI PREDICTION");
    debugPrint("===========================================");

    debugPrint("Timestamp");
    debugPrint("-------------------------------------------");
    debugPrint(sensorData.timestamp.toIso8601String());

    debugPrint("");

    debugPrint("Sensor Data");
    debugPrint("-------------------------------------------");
    debugPrint("Heart Rate : ${sensorData.heartRate}");
    debugPrint("GSR        : ${sensorData.gsr}");

    debugPrint(
        "Accel      : (${sensorData.accelX}, ${sensorData.accelY}, ${sensorData.accelZ})");

    debugPrint(
        "Gyro       : (${sensorData.gyroX}, ${sensorData.gyroY}, ${sensorData.gyroZ})");

    debugPrint("");

    debugPrint("Extracted Features");
    debugPrint("-------------------------------------------");
    debugPrint(featureVector.features.toString());

    debugPrint("");

    debugPrint("Model Prediction");
    debugPrint("-------------------------------------------");
    debugPrint("Label        : ${prediction.label}");
    debugPrint("Confidence   : ${prediction.confidence}");
    debugPrint("Probabilities: ${prediction.probabilities}");

    debugPrint("");

    debugPrint("Risk");
    debugPrint("-------------------------------------------");
    debugPrint("Risk Score : ${riskResult.riskScore}");
    debugPrint("Risk Level : ${riskResult.riskLevel}");

    debugPrint("");

    debugPrint("Decision");
    debugPrint("-------------------------------------------");
    debugPrint("Status              : ${decisionResult.status}");
    debugPrint("Trigger SOS         : ${decisionResult.triggerSOS}");
    debugPrint(
        "Notify Contacts     : ${decisionResult.notifyEmergencyContacts}");
    debugPrint("Play Alarm          : ${decisionResult.playAlarm}");
    debugPrint("Save Incident       : ${decisionResult.saveIncident}");
    debugPrint("Show Warning        : ${decisionResult.showWarning}");

    debugPrint("===========================================");
    debugPrint("");
  }
}