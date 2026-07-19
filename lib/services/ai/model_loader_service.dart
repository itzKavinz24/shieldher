import '../../models/feature_vector_model.dart';
import 'onnx_runtime_service.dart';
import 'preprocessing_service.dart';

/// Represents the prediction returned by the AI model.
class ModelPrediction {
  final String label;
  final double confidence;
  final List<double> probabilities;

  const ModelPrediction({
    required this.label,
    required this.confidence,
    required this.probabilities,
  });
}

class ModelLoaderService {
  final processed =
    PreprocessingService.preprocess(featureVector);
  final OnnxRuntimeService _onnxRuntime =
      OnnxRuntimeService();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    await _onnxRuntime.initialize();

    _initialized = true;
  }

  Future<ModelPrediction> predict(
    FeatureVectorModel featureVector,
  ) async {
    if (!_initialized) {
      throw Exception(
        "ModelLoaderService is not initialized.",
      );
    }

    // Normalize features
    final processed =
        preprocessing.preprocess(featureVector);

    // Convert to Float32 tensor
    final tensor =
        _preprocessing.toTensor(processed);

    // Run ONNX model
    final probabilities =
        await _onnxRuntime.runInference(tensor);

    // Find highest probability
    int bestIndex = 0;

    for (int i = 1; i < probabilities.length; i++) {
      if (probabilities[i] >
          probabilities[bestIndex]) {
        bestIndex = i;
      }
    }

    const labels = [
      "SAFE",
      "STRESS",
      "EMERGENCY",
    ];

    return ModelPrediction(
      label: labels[bestIndex],
      confidence: probabilities[bestIndex],
      probabilities: probabilities,
    );
  }

  Future<void> dispose() async {
    await _onnxRuntime.dispose();

    _initialized = false;
  }
}