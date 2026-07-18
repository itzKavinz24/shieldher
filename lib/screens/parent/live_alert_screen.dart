import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LiveAlertScreen extends StatelessWidget {
  const LiveAlertScreen({super.key});

  Future<void> openMap(double lat, double lng) async {
    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> resolveAlert(String alertId) async {
    await FirebaseFirestore.instance
        .collection('alerts')
        .doc(alertId)
        .update({
      'active': false,
      'resolvedAt':
          FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Alerts"),
      ),
      body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('alerts')
          .where(
            'parentId',
            isEqualTo:
                FirebaseAuth.instance.currentUser!.uid,
          )
          .where(
            'active',
            isEqualTo: true,
          )
          .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No active alerts"),
            );
          }

          final alerts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final doc = alerts[index];
              final data =
                  doc.data() as Map<String, dynamic>;

              final userName =
                  data['childName'] ?? "Unknown";

              final riskLevel =
                  data['risk'] ?? "LOW";

              final lat =
                  (data['latitude'] ?? 0).toDouble();
              final lng =
                  (data['longitude'] ?? 0).toDouble();

              return Card(
                margin: const EdgeInsets.all(12),
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "EMERGENCY ALERT",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text("Child Name: $userName"),
                      Text("Risk Level: $riskLevel"),
                      Text("Latitude: $lat"),
                      Text("Longitude: $lng"),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.map),
                              label: const Text("Map"),
                              onPressed: () {
                                openMap(lat, lng);
                              },
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.check),
                              label: const Text("Resolve"),
                              onPressed: () {
                                resolveAlert(doc.id);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}