import 'dart:collection';

import '../../models/sensor_data_model.dart';

class SlidingWindowService {
  SlidingWindowService._();

  static final SlidingWindowService instance = SlidingWindowService._();

  /// Training window size
  static const int windowSize = 700;

  /// 50% overlap
  static const int stepSize = 350;

  final Queue<SensorDataModel> _buffer = Queue<SensorDataModel>();

  bool addSample(SensorDataModel sample) {
    _buffer.addLast(sample);

    if (_buffer.length > windowSize) {
      _buffer.removeFirst();
    }

    return isWindowReady;
  }

  bool get isWindowReady => _buffer.length >= windowSize;

  List<SensorDataModel> getWindow() {
    return List<SensorDataModel>.from(_buffer);
  }

  void slideWindow() {
    for (int i = 0; i < stepSize; i++) {
      if (_buffer.isNotEmpty) {
        _buffer.removeFirst();
      }
    }
  }

  void clear() {
    _buffer.clear();
  }

  int get currentSize => _buffer.length;
}