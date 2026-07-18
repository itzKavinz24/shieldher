import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BleService {
  static Future<void> requestPermissions() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();
  }

  static Future<List<ScanResult>> scanDevices() async {
    await requestPermissions();

    List<ScanResult> devices = [];

    print("========== BLE SCAN STARTED ==========");

    final subscription =
        FlutterBluePlus.scanResults.listen((results) {
      devices = results;

      print("Current devices found: ${results.length}");

      for (var device in results) {
        print(
  "Name: ${device.device.platformName} | "
  "AdvName: ${device.advertisementData.advName} | "
  "ID: ${device.device.remoteId} | "
  "RSSI: ${device.rssi}",
);
      }
    });

    await FlutterBluePlus.startScan(
  timeout: const Duration(seconds: 10),
  androidUsesFineLocation: true,
);

    await Future.delayed(
      const Duration(seconds: 5),
    );

    await FlutterBluePlus.stopScan();

    print("========== BLE SCAN FINISHED ==========");
    print("Devices found: ${devices.length}");

    await subscription.cancel();

    return devices;
  }

static Stream<String> connectAndListen(
  BluetoothDevice device,
  String characteristicUuid,
) async* {


    device.connectionState.listen((state) {

      print(
        "BLE STATE = $state",
      );

    });
  List<BluetoothService> services =
      await device.discoverServices();

  for (var service in services) {

    if (service.uuid.toString() ==
        "12345678-1234-1234-1234-123456789abc") {

      for (var characteristic
          in service.characteristics) {
          print(
            "CHAR UUID = ${characteristic.uuid}",
          );
        if (characteristic.uuid
                .toString()
                .toLowerCase() ==
            characteristicUuid
                .toLowerCase()) {

          await characteristic
              .setNotifyValue(true);

          yield* characteristic
              .lastValueStream
              .map(
                (value) =>
                    String.fromCharCodes(
                  value,
                ),
              );
        }
      }
    }
  }
}
}