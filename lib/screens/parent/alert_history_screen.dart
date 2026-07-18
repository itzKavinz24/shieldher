import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AlertHistoryScreen extends StatelessWidget {
  const AlertHistoryScreen({super.key});

  Future<void> openMap(double lat, double lng) async {
    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  String formatTime(dynamic timestamp) {
    if (timestamp == null) {
      return "No time";
    }

    final date = (timestamp as Timestamp).toDate();

    return "${date.day}/${date.month}/${date.year}  ${date.hour}:${date.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alert History"),
      ),
      body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('alerts')
          .where(
            'parentId',
            isEqualTo:
                FirebaseAuth.instance.currentUser!.uid,
          )
          .orderBy(
            'timestamp',
            descending: true,
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
              child: Text("No alert history"),
            );
          }
print(
  "PARENT UID = ${FirebaseAuth.instance.currentUser?.uid}",
);

print(
  "DOC COUNT = ${snapshot.data!.docs.length}",
);
          final alerts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final data =
                  alerts[index].data() as Map<String, dynamic>;

              final userName =
                  data['childName'] ?? "Unknown";

              final riskLevel =
                  data['risk'] ?? "LOW";

              final status =
                  data['active'] == true
                      ? "ACTIVE"
                      : "RESOLVED";

              final lat =
                  (data['latitude'] ?? 0).toDouble();
              final lng =
                  (data['longitude'] ?? 0).toDouble();

              final time =
                  formatTime(data['timestamp']);

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: Icon(
                    status == "ACTIVE"
                        ? Icons.warning
                        : Icons.check_circle,
                    color: status == "ACTIVE"
                        ? Colors.red
                        : Colors.green,
                  ),
                  title: Text(userName),
                  subtitle: Text(
                    "Risk: $riskLevel\nStatus: $status\nTime: $time\nLocation: $lat, $lng",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: () {
                      openMap(lat, lng);
                    },
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