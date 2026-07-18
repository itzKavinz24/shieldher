import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../services/ble_service.dart';
import '../../services/ble_manager.dart';
import '../../services/device_storage.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final ble = BleManager.instance;
  
  List<ScanResult> nearbyDevices = [];
  List<BluetoothDevice> connectedDevices = [];

  bool isScanning = false;
  

  Future<void> scanDevices() async {
    setState(() {
      isScanning = true;
      nearbyDevices.clear();
    });

    try {
      final devices = await BleService.scanDevices();

      setState(() {
        nearbyDevices = devices;
      });

      debugPrint(
        "Devices Found: ${nearbyDevices.length}",
      );
    } catch (e) {
      debugPrint("Scan Error: $e");
    }

    setState(() {
      isScanning = false;
    });
  }

  Future<void> connectToDevice(
    BluetoothDevice device,
  ) async {
    try {
      await device.connect(
        timeout: const Duration(seconds: 10),
      );

      device.connectionState.listen(
        (state) {

          print(
            "${device.platformName} STATE = $state",
          );

          if (state ==
              BluetoothConnectionState.disconnected) {

            if (device.platformName ==
                "Scrunchie") {

              BleManager.instance
                  .scrunchieDisconnected();

            } else {

              BleManager.instance
                  .healthDisconnected();
            }
          }
        },
      );

      if (device.platformName == "Scrunchie") {

        BleManager.instance
            .setScrunchieDevice(device);

      } else {

        BleManager.instance
            .setHealthDevice(device);
      }

      if (device.platformName == "Scrunchie") {

        await DeviceStorage.saveScrunchie(
          device.remoteId.toString(),
        );

        print(
          "SCRUNCHIE SAVED = ${device.remoteId}",
        );
        print(
          "SCRUNCHIE STORED = ${await DeviceStorage.getScrunchieId()}",
        );

      } else {

        await DeviceStorage.saveHealthBand(
          device.remoteId.toString(),
        );

        print(
          "HEALTH BAND SAVED = ${device.remoteId}",
        );
        print(
          "HEALTH STORED = ${await DeviceStorage.getHealthBandId()}",
        );
      }

        if (!connectedDevices.any(
          (d) => d.remoteId == device.remoteId,
        )) {
          setState(() {
            connectedDevices.add(device);

            nearbyDevices.removeWhere(
              (d) =>
                  d.device.remoteId ==
                  device.remoteId,
            );
          });
        }

        String characteristicUuid;

        if (device.platformName == "Scrunchie") {
          characteristicUuid =
              "abcdefab-1234-5678-1234-abcdefabcdef";
        } else {
          characteristicUuid =
              "abcdef12-3456-7890-abcd-123456789abc";
        }

        BleService.connectAndListen(
          device,
          characteristicUuid,
        ).listen((data) {

          print("BLE DATA = $data");

          BleManager.instance.processIncomingData(data);

        }, onError: (e) {

          print(
            "BLE ERROR = $e",
          );

        });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Device Connected Successfully",
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Connection Error: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Connection Failed: $e",
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
     return AnimatedBuilder(
    animation: ble,
    builder: (context, child) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FB),
      appBar: AppBar(
        title: const Text("My Devices"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isScanning
                    ? null
                    : scanDevices,
                icon: const Icon(
                  Icons.bluetooth_searching,
                ),
                label: Text(
                  isScanning
                      ? "Scanning..."
                      : "Scan Devices",
                ),
              ),
            ),

            const SizedBox(height: 20),

            Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                "Connected Devices (${ble.connectedCount})",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

ble.connectedCount == 0
    ? Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "No devices connected",
        ),
      )
    : Column(
        children: [

          if (ble.healthDevice != null)
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.bluetooth_connected,
                  color: Colors.green,
                ),
                title: const Text(
                  "ESP32_Health",
                ),
              ),
            ),

          if (ble.scrunchieDevice != null)
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.bluetooth_connected,
                  color: Colors.green,
                ),
                title: const Text(
                  "Scrunchie",
                ),
              ),
            ),
        ],
      ),

            const SizedBox(height: 20),

            Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                "Nearby Devices (${nearbyDevices.length})",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: nearbyDevices.isEmpty
                  ? const Center(
                      child: Text(
                        "No nearby devices",
                      ),
                    )
                  : ListView.builder(
                      itemCount:
                          nearbyDevices
                              .length,
                      itemBuilder:
                          (context, index) {
                        final result =
                            nearbyDevices[
                                index];

                        return Container(
                          margin:
                              const EdgeInsets
                                  .only(
                            bottom: 10,
                          ),
                          padding:
                              const EdgeInsets
                                  .all(12),
                          decoration:
                              BoxDecoration(
                            color:
                                Colors.white,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              12,
                            ),
                            border:
                                Border.all(
                              color: Colors
                                  .grey
                                  .shade300,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                               result.advertisementData.advName.isNotEmpty
                                ? result.advertisementData.advName
                                : "Unknown Device",
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                  fontSize:
                                      16,
                                ),
                              ),

                              const SizedBox(
                                  height: 5),

                              Text(
                                result.device
                                    .remoteId
                                    .toString(),
                              ),

                              const SizedBox(
                                  height: 10),

                              SizedBox(
                                width: double
                                    .infinity,
                                child:
                                    ElevatedButton(
                                  onPressed:
                                      () async {
                                    await connectToDevice(
                                      result
                                          .device,
                                    );
                                  },
                                  child:
                                      const Text(
                                    "Connect",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
           ),
    );
    },
  );
}
}