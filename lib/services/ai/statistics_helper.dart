import 'dart:math';

class StatisticsHelper {
  StatisticsHelper._();

  static double mean(List<double> values) {
    if (values.isEmpty) return 0.0;

    double sum = 0.0;

    for (final v in values) {
      sum += v;
    }

    return sum / values.length;
  }

  /// Matches numpy.std() default behavior (population std, ddof=0)
  static double std(List<double> values) {
    if (values.isEmpty) return 0.0;

    final avg = mean(values);

    double variance = 0.0;

    for (final v in values) {
      variance += pow(v - avg, 2).toDouble();
    }

    variance /= values.length;

    return sqrt(variance);
  }

  static double minValue(List<double> values) {
    if (values.isEmpty) return 0.0;

    double minimum = values.first;

    for (final value in values) {
      if (value < minimum) {
        minimum = value;
      }
    }

    return minimum;
  }

  static double maxValue(List<double> values) {
    if (values.isEmpty) return 0.0;

    double maximum = values.first;

    for (final value in values) {
      if (value > maximum) {
        maximum = value;
      }
    }

    return maximum;
  }

  static List<double> magnitude(
    List<double> x,
    List<double> y,
    List<double> z,
  ) {
    final length = min(x.length, min(y.length, z.length));

    return List.generate(length, (index) {
      return sqrt(
        x[index] * x[index] +
            y[index] * y[index] +
            z[index] * z[index],
      );
    });
  }
}