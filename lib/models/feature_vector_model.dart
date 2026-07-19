class FeatureVectorModel {
  final List<double> features;

  const FeatureVectorModel({
    required this.features,
  });

  int get length => features.length;

  double operator [](int index) => features[index];

  List<double> toList() => List<double>.from(features);
}