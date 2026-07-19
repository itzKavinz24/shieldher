import 'dart:typed_data';

import '../../models/feature_vector_model.dart';

class PreprocessingService {
  PreprocessingService._();

  static Float32List preprocess(
    FeatureVectorModel featureVector,
  ) {
    return Float32List.fromList(
      featureVector.features
          .map((e) => e.toDouble())
          .toList(),
    );
  }
}