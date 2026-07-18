import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'device_storage.dart';
import 'ble_service.dart';
class BleManager extends ChangeNotifier {
  static final BleManager instance =
      BleManager._internal();

  BleManager._internal();

  BluetoothDevice? healthDevice;
  BluetoothDevice? scrunchieDevice;

  bool healthConnected = false;
  bool scrunchieConnected = false;

  bool get allConnected =>
      healthConnected &&
      scrunchieConnected;
  
  bool get connected =>
    healthConnected ||
    scrunchieConnected;
  
  BluetoothDevice? get device =>
      healthDevice ?? scrunchieDevice;

  int bpm = 0;
  int spo2 = 0;
  int gsr = 0;

  double ax = 0;
  double ay = 0;
  double az = 0;

  double gx = 0;
  double gy = 0;
  double gz = 0;

  int steps = 0;

  bool _stepDetected = false;

  String rawData = "";
  String risk = "LOW";

  Timer? _uiTimer;
  bool _isReconnecting = false;
  void start() {

    _autoConnectSavedDevices();

    _uiTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        notifyListeners();
      },
    );
  }

  Future<void> _autoConnectSavedDevices() async {

    final healthId =
        await DeviceStorage.getHealthBandId();

    final scrunchieId =
        await DeviceStorage.getScrunchieId();

    print(
      "AUTO HEALTH ID = $healthId",
    );

    print(
      "AUTO SCRUNCHIE ID = $scrunchieId",
    );

    final devices =
      await BleService.scanDevices();

    for (var d in devices) {

      if (d.device.remoteId.toString() ==
          healthId) {

        print(
          "FOUND SAVED HEALTH BAND",
        );

          await d.device.connect();

          d.device.connectionState.listen(
            (state) {

              print(
                "${d.device.platformName} STATE = $state",
              );

              if (state ==
                  BluetoothConnectionState.disconnected) {

                healthDisconnected();

                if (!_isReconnecting) {

                  _isReconnecting = true;

                  Future.delayed(
                    const Duration(seconds: 3),
                    () async {

                      await _autoConnectSavedDevices();

                      _isReconnecting = false;
                    },
                  );
                }
              }
            },
          );

          setHealthDevice(
            d.device,
          );

        BleService.connectAndListen(
          d.device,
          "abcdef12-3456-7890-abcd-123456789abc",
        ).listen(
          processIncomingData,
        );

        print(
          "AUTO CONNECTED HEALTH BAND",
        );
      }

      if (d.device.remoteId.toString() ==
          scrunchieId) {

        print(
          "FOUND SAVED SCRUNCHIE",
        );

        await d.device.connect();
          d.device.connectionState.listen(
            (state) {

              print(
                "${d.device.platformName} STATE = $state",
              );

              if (state ==
                  BluetoothConnectionState.disconnected) {

                scrunchieDisconnected();

                if (!_isReconnecting) {

                  _isReconnecting = true;

                  Future.delayed(
                    const Duration(seconds: 3),
                    () async {

                      await _autoConnectSavedDevices();

                      _isReconnecting = false;
                    },
                  );
                }
              }
            },
        );
        setScrunchieDevice(
          d.device,
        );

        BleService.connectAndListen(
          d.device,
          "abcdefab-1234-5678-1234-abcdefabcdef",
        ).listen(
          processIncomingData,
        );

        print(
          "AUTO CONNECTED SCRUNCHIE",
        );
      }
    }

    print(
      "AUTO SCAN FOUND = ${devices.length}",
    );

  }

  void setHealthDevice(
    BluetoothDevice device,
  ) {
    healthDevice = device;
    healthConnected = true;
    notifyListeners();
  }

  void setScrunchieDevice(
    BluetoothDevice device,
  ) {
    scrunchieDevice = device;
    scrunchieConnected = true;
    notifyListeners();
  }

  int get connectedCount {
    int count = 0;

    if (healthConnected) count++;
    if (scrunchieConnected) count++;

    return count;
  }

  String get activityStatus {

    final movement =
        gx.abs() +
        gy.abs() +
        gz.abs();

    if (movement < 15) {
      return "Still";
    }

    if (movement < 250) {
      return "Moving";
    }

    return "High Activity";
  }

  void healthDisconnected() {
    healthConnected = false;

    healthDevice = null;

    bpm = 0;
    spo2 = 0;
    gsr = 0;

    if (!scrunchieConnected) {
      rawData = "";
      risk = "LOW";
    }

    notifyListeners();
  }

    void scrunchieDisconnected() {
      scrunchieConnected = false;

      scrunchieDevice = null;

      ax = 0;
      ay = 0;
      az = 0;

      gx = 0;
      gy = 0;
      gz = 0;

      if (!healthConnected) {
        rawData = "";
        risk = "LOW";
      }

      notifyListeners();
    }

  void processIncomingData(
    String data,
  ) {
    rawData = data;

    print(
      "BLE MANAGER RECEIVED = $data",
    );

    if (!data.contains("BPM:")) {
      final values = data.split(',');

      if (values.length >= 6) {
        ax =
            double.tryParse(values[0]) ??
                0;

        ay =
            double.tryParse(values[1]) ??
                0;

        az =
            double.tryParse(values[2]) ??
                0;

        gx =
            double.tryParse(values[3]) ??
                0;

        gy =
            double.tryParse(values[4]) ??
                0;

        gz =
            double.tryParse(values[5]) ??
                0;
        
        final movement =
            gx.abs() +
            gy.abs() +
            gz.abs();

        if (movement > 150 &&
            !_stepDetected) {

          steps++;

          _stepDetected = true;
        }

        if (movement < 50) {
          _stepDetected = false;
        }

        notifyListeners();
        return;
      }
    }

    try {
      final parts = data.split(',');

      for (var item in parts) {
        if (item.startsWith("BPM:")) {
          bpm = int.parse(
            item.replaceAll(
              "BPM:",
              "",
            ),
          );
        }

        if (item.startsWith("SpO2:")) {
          spo2 = int.parse(
            item.replaceAll(
              "SpO2:",
              "",
            ),
          );
        }

        if (item.startsWith("GSR:")) {
          gsr = int.parse(
            item.replaceAll(
              "GSR:",
              "",
            ),
          );
        }
      }

      if (bpm > 120 || gsr > 850) {
        risk = "HIGH";
      } else if (bpm > 100 ||
          gsr > 700) {
        risk = "MEDIUM";
      } else {
        risk = "LOW";
      }
    } catch (e) {
      debugPrint(
        "BLE Parse Error: $e",
      );
    }

    notifyListeners();
  }

    int get safetyScore {

      if (!healthConnected &&
          !scrunchieConnected) {
        return 0;
      }

      int score = 100;

      // Stress impact
      if (risk == "MEDIUM") {
        score -= 20;
      }

      if (risk == "HIGH") {
        score -= 40;
      }

      // Oxygen impact
      if (spo2 > 0) {

        if (spo2 < 95) {
          score -= 10;
        }

        if (spo2 < 90) {
          score -= 20;
        }
      }

      // Activity impact
      final movement =
          gx.abs() +
          gy.abs() +
          gz.abs();

      if (movement > 250) {
        score -= 10;
      }

      if (movement > 500) {
        score -= 20;
      }

      return score.clamp(0, 100);
    }

}