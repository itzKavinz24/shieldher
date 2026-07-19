import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';

class OnnxRuntimeService {
  OrtSession? _session;
  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize ONNX Runtime
    OrtEnv.instance.init();

    // Load model from Flutter assets
    final modelBytes =
        await rootBundle.load('assets/models/shieldher_model.onnx');

    final sessionOptions = OrtSessionOptions();

    _session = OrtSession.fromBuffer(
      modelBytes.buffer.asUint8List(),
      sessionOptions,
    );

    _initialized = true;
  }

  Future<List<double>> runInference(Float32List input) async {
    if (!_initialized || _session == null) {
      throw Exception(
        "ONNX Runtime is not initialized.",
      );
    }

    // Create input tensor
    final inputTensor = OrtValueTensor.createTensorWithDataList(
      input,
      [1, input.length],
    );

    // Input name from the ONNX model
    final inputNames = _session!.inputNames;

    // Run inference
    final outputs = _session!.run(
      OrtRunOptions(),
      {
        inputNames.first: inputTensor,
      },
    );

    // First output tensor
    final outputTensor = outputs.first!.value as List;

    return outputTensor.cast<double>();
  }

  Future<void> dispose() async {
    _session?.release();
    OrtEnv.instance.release();

    _initialized = false;
  }
}