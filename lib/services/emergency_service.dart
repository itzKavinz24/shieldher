import 'dart:async';
import 'package:flutter/material.dart';
import 'ble_manager.dart';
import 'location_service.dart';
import 'contact_service.dart';
import 'native_sms_service.dart';
import 'package:geolocator/geolocator.dart';
import '../models/contact_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class EmergencyService {
  static final EmergencyService instance =
      EmergencyService._internal();

  EmergencyService._internal();

  bool emergencyTriggered = false;

  int countdown = 45;

  int lowScoreSeconds = 0;

  Timer? _monitorTimer;
  Timer? _countdownTimer;

  void startMonitoring(
    BuildContext context,
  ) {
    _monitorTimer?.cancel();

    _monitorTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        final score =
            BleManager.instance.safetyScore;

        print(
          "EMERGENCY CHECK = $score",
        );

        if (score > 0 &&
    score <= 50) {
          lowScoreSeconds++;

          print(
            "LOW SCORE TIMER = $lowScoreSeconds",
          );

          // CHANGE TO 10 FOR FINAL DEMO
          if (lowScoreSeconds >= 2 &&
              !emergencyTriggered ) {
            emergencyTriggered = true;

            showEmergencyDialog(
              context,
            );
          }
        } else {
          lowScoreSeconds = 0;
        }
      },
    );
  }
    Future<void> sendEmergencyAlert() async {

    try {

        print("STEP 1 - ENTERED sendEmergencyAlert");
        Position position =
            await LocationService
                .getCurrentLocation();
        print(
  "STEP 2 - LOCATION = ${position.latitude}, ${position.longitude}",
);
        List<ContactModel> contacts =
            await ContactService()
                .getContacts();
        print(
  "STEP 3 - CONTACTS FOUND = ${contacts.length}",
);

        if (contacts.isEmpty) {

        print(
            "NO CONTACTS FOUND",
        );

        return;
        }

        String message = '''
    🚨 SHIELDHER EMERGENCY ALERT

    I may be in danger.

    Location:
    https://maps.google.com/?q=${position.latitude},${position.longitude}
    ''';

        for (final contact in contacts) {
              print(
    "STEP 4 - SENDING TO ${contact.phone}",
  );
        try {

            await NativeSmsService.sendSms(
            phone: contact.phone,
            message: message,
            );
            print(
  "SMS FINISHED AT = ${DateTime.now()}",
);
              print(
    "STEP 5 - SENT TO ${contact.phone}",
  );
            print(
            "SMS SENT TO ${contact.phone}",
            );

        }catch (e) {
  print(
    "SMS FAILED ${contact.phone}",
  );

  print(
    "SMS ERROR = $e",
  );
}
        }

final user =
    FirebaseAuth.instance.currentUser;

if (user != null) {

  final userDoc =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

  await FirebaseFirestore.instance
      .collection('alerts')
      .add({

    'childUid': user.uid,

    'parentId':
        userDoc['parentId'] ?? '',

    'childName':
        userDoc['name'] ?? 'Unknown',

    'latitude':
        position.latitude,

    'longitude':
        position.longitude,

    'risk':
        BleManager.instance.risk,

    'active': true,

    'timestamp':
        FieldValue.serverTimestamp(),
  });

  

  print(
    "ALERT SAVED TO FIRESTORE",
  );

final parentId =
    userDoc['parentId'];

if (parentId != null &&
    parentId.toString().isNotEmpty) {

  final parentDoc =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(parentId)
          .get();

  final token =
      parentDoc.data()?['fcmToken'];

  if (token != null) {

    final response =
        await http.post(
      Uri.parse(
        "http://10.61.153.50:5000/send-alert",
      ),
      headers: {
        "Content-Type":
            "application/json",
      },
      body: jsonEncode({
        "token": token,
        "childName":
            userDoc['name'] ?? "Unknown",
        "risk":
            BleManager.instance.risk,
      }),
    );

    print(
      "FCM RESPONSE = ${response.body}",
    );
  }
}

}

    } catch (e) {

        print(
        "EMERGENCY ALERT ERROR = $e",
        );
    }
    }
void showEmergencyDialog(
  BuildContext context,
) {
  countdown = 10;

  _countdownTimer?.cancel();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {

      _countdownTimer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) async {

          countdown--;

          if (countdown <= 0) {

            timer.cancel();

            emergencyTriggered = false;
            lowScoreSeconds = 0;

            if (Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext);
            }

            await sendEmergencyAlert();
          }
        },
      );

      return StatefulBuilder(
        builder: (
          context,
          setState,
        ) {

          Timer(
            const Duration(seconds: 1),
            () {
              if (context.mounted) {
                setState(() {});
              }
            },
          );

          return AlertDialog(
            title: const Text(
              "Emergency Detected",
            ),

            content: Text(
              "Sending alert in $countdown seconds",
            ),

            actions: [
              ElevatedButton(
                onPressed: () {

                  _countdownTimer?.cancel();

                  emergencyTriggered = false;
                  lowScoreSeconds = 0;

                  Navigator.pop(
                    dialogContext,
                  );

                  print(
                    "USER MARKED SAFE",
                  );
                },

                child: const Text(
                  "I'm Safe",
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
}