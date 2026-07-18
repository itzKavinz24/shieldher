import 'package:shared_preferences/shared_preferences.dart';

class DeviceStorage {
  static const String healthBandKey = 'health_band_id';
  static const String scrunchieKey = 'scrunchie_id';

  static Future<void> saveHealthBand(
    String deviceId,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      healthBandKey,
      deviceId,
    );
  }

  static Future<void> saveScrunchie(
    String deviceId,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      scrunchieKey,
      deviceId,
    );
  }

  static Future<String?> getHealthBandId()
      async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      healthBandKey,
    );
  }

  static Future<String?> getScrunchieId()
      async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      scrunchieKey,
    );
  }

  static Future<void> clearDevices()
      async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      healthBandKey,
    );

    await prefs.remove(
      scrunchieKey,
    );
  }
}