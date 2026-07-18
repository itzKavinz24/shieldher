import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class LastKnownLocationScreen extends StatelessWidget {
  const LastKnownLocationScreen({super.key});

  Future<void> openMap(double lat, double lng) async {
    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final parentId =
        FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Last Known Location"),
      ),
      body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('alerts')
          .where(
            'parentId',
            isEqualTo: parentId,
          )
          .orderBy(
            'timestamp',
            descending: true,
          )
          .limit(1)
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
              child: Text("No linked child found"),
            );
          }

          final alert =
              snapshot.data!.docs.first;

          final data =
              alert.data()
                  as Map<String, dynamic>;

          final childName =
              data['childName'] ?? "Unknown";

          final lat =
              (data['latitude'] ?? 0).toDouble();

          final lng =
              (data['longitude'] ?? 0).toDouble();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      childName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Latitude: $lat",
                    ),

                    Text(
                      "Longitude: $lng",
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child:
                          ElevatedButton.icon(
                        icon: const Icon(
                          Icons.map,
                        ),
                        label: const Text(
                          "Open Map",
                        ),
                        onPressed: () {
                          openMap(
                            lat,
                            lng,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}