import '../../models/sensor_data_model.dart';
import 'sliding_window_service.dart';
import 'decision_engine_service.dart';
import 'feature_extraction_service.dart';
import 'model_loader_service.dart';
import 'prediction_logger_service.dart';
import 'risk_engine_service.dart';

class AiPipelineResult {
  final ModelPrediction prediction;
  final RiskResult riskResult;
  final DecisionResult decisionResult;

  const AiPipelineResult({
    required this.prediction,
    required this.riskResult,
    required this.decisionResult,
  });
}

class AiPipelineService {
  final SlidingWindowService _slidingWindow =
    SlidingWindowService.instance;

  final FeatureExtractionService _featureExtractionService =
      FeatureExtractionService();

  final ModelLoaderService _modelLoaderService =
      ModelLoaderService();

  final RiskEngineService _riskEngineService =
      RiskEngineService();

  final DecisionEngineService _decisionEngineService =
      DecisionEngineService();

  final PredictionLoggerService _loggerService =
      PredictionLoggerService();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    await _modelLoaderService.initialize();

    _initialized = true;
  }

  Future<AiPipelineResult?> processSensorData(
    SensorDataModel sensorData,
  ) async {
    if (!_initialized) {
      throw Exception(
        "AI Pipeline is not initialized.",
      );
    }

    //------------------------------------------------
    // Sliding Window
    //------------------------------------------------

    // Add latest BLE sample
    _slidingWindow.addSample(sensorData);

    // Wait until we have a full window
    if (!_slidingWindow.isWindowReady) {
      return null;
    }

    // Get the complete 700-sample window
    final window = _slidingWindow.getWindow();

    // Extract 42 features
    final featureVector =
        FeatureExtractionService.extractFeatures(window);

    //------------------------------------------------
    // AI Prediction
    //------------------------------------------------

    final prediction =
        await _modelLoaderService.predict(
      featureVector,
    );

    //------------------------------------------------
    // Risk Calculation
    //------------------------------------------------

    final riskResult =
        _riskEngineService.calculateRisk(
      prediction: prediction,
      sensorData: sensorData,
    );

    //------------------------------------------------
    // Decision
    //------------------------------------------------

    final decisionResult =
        _decisionEngineService.makeDecision(
      riskResult: riskResult,
    );

    //------------------------------------------------
    // Logging
    //------------------------------------------------

    await _loggerService.logPrediction(
      sensorData: sensorData,
      featureVector: featureVector,
      prediction: prediction,
      riskResult: riskResult,
      decisionResult: decisionResult,
    );
    _slidingWindow.slideWindow();
    return AiPipelineResult(
      prediction: prediction,
      riskResult: riskResult,
      decisionResult: decisionResult,
    );
  }

  Future<void> dispose() async {
    await _modelLoaderService.dispose();

    _initialized = false;
  }
}