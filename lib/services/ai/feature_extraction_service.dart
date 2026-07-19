import '../../models/feature_vector_model.dart';
import '../../models/sensor_data_model.dart';
import 'statistics_helper.dart';

class FeatureExtractionService {
  FeatureExtractionService._();

  static FeatureVectorModel extractFeatures(
    List<SensorDataModel> window,
  ) {
    final accX = <double>[];
    final accY = <double>[];
    final accZ = <double>[];

    final gyroX = <double>[];
    final gyroY = <double>[];
    final gyroZ = <double>[];

    final gsr = <double>[];
    final hr = <double>[];
    final spo2 = <double>[];

    for (final sample in window) {
      accX.add(sample.accelX);
      accY.add(sample.accelY);
      accZ.add(sample.accelZ);

      gyroX.add(sample.gyroX);
      gyroY.add(sample.gyroY);
      gyroZ.add(sample.gyroZ);

      gsr.add(sample.gsr);
      hr.add(sample.heartRate);
      spo2.add(sample.spo2);
    }

    final accMag = StatisticsHelper.magnitude(
      accX,
      accY,
      accZ,
    );

    final gyroMag = StatisticsHelper.magnitude(
      gyroX,
      gyroY,
      gyroZ,
    );

    return FeatureVectorModel(
      features: [

        // =========================
        // ACC X
        // =========================

        StatisticsHelper.mean(accX),
        StatisticsHelper.std(accX),
        StatisticsHelper.minValue(accX),
        StatisticsHelper.maxValue(accX),

        // =========================
        // ACC Y
        // =========================

        StatisticsHelper.mean(accY),
        StatisticsHelper.std(accY),
        StatisticsHelper.minValue(accY),
        StatisticsHelper.maxValue(accY),

        // =========================
        // ACC Z
        // =========================

        StatisticsHelper.mean(accZ),
        StatisticsHelper.std(accZ),
        StatisticsHelper.minValue(accZ),
        StatisticsHelper.maxValue(accZ),

        // =========================
        // ACC MAG
        // =========================

        StatisticsHelper.mean(accMag),
        StatisticsHelper.std(accMag),
        StatisticsHelper.maxValue(accMag),

        // =========================
        // GYRO X
        // =========================

        StatisticsHelper.mean(gyroX),
        StatisticsHelper.std(gyroX),
        StatisticsHelper.minValue(gyroX),
        StatisticsHelper.maxValue(gyroX),

        // =========================
        // GYRO Y
        // =========================

        StatisticsHelper.mean(gyroY),
        StatisticsHelper.std(gyroY),
        StatisticsHelper.minValue(gyroY),
        StatisticsHelper.maxValue(gyroY),

        // =========================
        // GYRO Z
        // =========================

        StatisticsHelper.mean(gyroZ),
        StatisticsHelper.std(gyroZ),
        StatisticsHelper.minValue(gyroZ),
        StatisticsHelper.maxValue(gyroZ),

        // =========================
        // GYRO MAG
        // =========================

        StatisticsHelper.mean(gyroMag),
        StatisticsHelper.std(gyroMag),
        StatisticsHelper.maxValue(gyroMag),

        // =========================
        // GSR
        // =========================

        StatisticsHelper.mean(gsr),
        StatisticsHelper.std(gsr),
        StatisticsHelper.minValue(gsr),
        StatisticsHelper.maxValue(gsr),

        // =========================
        // HEART RATE
        // =========================

        StatisticsHelper.mean(hr),
        StatisticsHelper.std(hr),
        StatisticsHelper.minValue(hr),
        StatisticsHelper.maxValue(hr),

        // =========================
        // SPO2
        // =========================

        StatisticsHelper.mean(spo2),
        StatisticsHelper.std(spo2),
        StatisticsHelper.minValue(spo2),
        StatisticsHelper.maxValue(spo2),
      ],
    );
  }
}