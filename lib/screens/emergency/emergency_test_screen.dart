import 'package:flutter/material.dart';
import '../../services/native_sms_service.dart';

class EmergencyTestScreen extends StatelessWidget {
  const EmergencyTestScreen({super.key});

  void showAlert(
    BuildContext context,
    String level,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Alert Triggered",
        ),
        content: Text(
          "$level Alert Sent Successfully",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Emergency Test",
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () =>
                  showAlert(
                    context,
                    "Low Risk",
                  ),
              child: const Text(
                "Low Risk Alert",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () =>
                  showAlert(
                    context,
                    "Medium Risk",
                  ),
              child: const Text(
                "Medium Risk Alert",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () =>
                  showAlert(
                    context,
                    "High Risk",
                  ),
              child: const Text(
                "High Risk Alert",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await NativeSmsService
                    .sendSms(
                  phone:
                      "9600036044",
                  message:
                      "ShieldHer SMS Test",
                );
              },
              child: const Text(
                "SEND TEST SMS",
              ),
            ),
          ],
        ),
      ),
    );
  }
}