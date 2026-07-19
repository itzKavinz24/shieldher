class RiskPredictionModel {
  final int predictedClass;

  final String label;

  final double confidence;

  final List<double> probabilities;

  final DateTime timestamp;

  const RiskPredictionModel({
    required this.predictedClass,
    required this.label,
    required this.confidence,
    required this.probabilities,
    required this.timestamp,
  });

  bool get isSafe => predictedClass == 0;

  bool get isStress => predictedClass == 1;

  bool get isEmergency => predictedClass == 2;
}