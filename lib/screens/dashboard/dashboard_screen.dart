import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/user_service.dart';
import '../../services/alert_service.dart'; 
import '../../services/ble_manager.dart';
import '../../services/emergency_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  String userName = "User";
  String phone = "";
  final ble = BleManager.instance;

  @override
  @override
void initState() {
  super.initState();

  // Start BLE auto connection
  BleManager.instance.start();

  WidgetsBinding.instance
      .addPostFrameCallback((_) {
    EmergencyService.instance
        .startMonitoring(context);
  });

  loadUser();
}
  Future<void> loadUser() async {
    final uid =
        FirebaseAuth.instance.currentUser!.uid;

    final user =
        await UserService().getUser(uid);

    if (user != null) {
      setState(() {
        userName = user['name'] ?? "User";
        phone = user['phone'] ?? "";
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xffF7F3FA),

      body: AnimatedBuilder(
    animation: ble,
    builder: (context, child) {
    return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                                  SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Text(
                  "Welcome, $userName 👋",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 5),

                      const Text(
                        "You're safe and protected",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      
                    ],
                  ),

                  Stack(
                    children: [
                                const CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.notifications_none,
                          size: 30,
                        ),
                      ),

                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// SAFETY SCORE CARD
              Container(
                padding: const EdgeInsets.all(25),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),

                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffA259FF),
                      Color(0xffF78BC8),
                    ],
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "SAFETY SCORE",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            Text(
                               "${ble.safetyScore}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const Text(
                              "/100",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          width: 90,
                          height: 90,

                          child: CircularProgressIndicator(
                            value:
                                ble.safetyScore / 100,
                            strokeWidth: 8,
                            color: Colors.white,
                            backgroundColor:
                                Colors.white24,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_user,
                            color: Colors.white,
                            size: 18,
                          ),

                          SizedBox(width: 5),

                          Text(
                            ble.risk == "HIGH"
                              ? "Emergency Attention Needed"
                              : ble.risk == "MEDIUM"
                                  ? "Monitoring Activity"
                                  : "All Systems Normal",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              /// STATS GRID
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.25,

              children: [

                statCard(
                  Icons.bluetooth,
                  "Devices",
                  "${ble.connectedCount}/2",
                  ble.connectedCount == 2
                      ? "All Devices Ready"
                      : "Searching",
                  ble.connectedCount == 2
                      ? Colors.green
                      : Colors.orange,
                ),

                statCard(
                  Icons.favorite,
                  "Heart Rate",
                  "${ble.bpm}",
                  ble.bpm > 110
                      ? "Elevated"
                      : "Normal",
                  Colors.red,
                ),

                statCard(
                  Icons.favorite_border,
                  "SpO₂",
                  "${ble.spo2}%",
                  "Oxygen Level",
                  Colors.blue,
                ),

                statCard(
                  Icons.psychology,
                  "Stress Level",
                  ble.risk,
                  ble.risk == "HIGH"
                      ? "Attention"
                      : ble.risk == "MEDIUM"
                          ? "Monitor Status"
                          : "All Clear",
                  ble.risk == "HIGH"
                      ? Colors.red
                      : ble.risk == "MEDIUM"
                          ? Colors.orange
                          : Colors.green,
                ),
              statCard(
                Icons.directions_run,
                "Activity",
                ble.activityStatus,
                ble.activityStatus == "Still"
                    ? "No Movement"
                    : ble.activityStatus == "Moving"
                        ? "Motion Detected"
                        : "Intense Movement",
                ble.activityStatus == "Still"
                    ? Colors.green
                    : ble.activityStatus == "Moving"
                        ? Colors.orange
                        : Colors.red,
              ),

              statCard(
                Icons.directions_walk,
                "Steps",
                "${ble.steps}",
                "Today's Steps",
                Colors.blue,
              ),

              ],
              ),

              const SizedBox(height: 25),
              /// WEARABLES
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(25),
                ),

                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: const [
                        Text(
                          "Wearables",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const SizedBox(height: 15),
                    wearableTile(
                      "Health Band",
                      "",
                      Icons.favorite,
                      ble.healthConnected,
                    ),

                    const SizedBox(height: 15),

                    wearableTile(
                      "Safety Scrunchie",
                      "",
                      Icons.shield,
                      ble.scrunchieConnected,
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 25),

            ],
          ),
        ),
      );
    },
  ),
  );
  }

  Widget statCard(
    IconData icon,
    String title,
    String value,
    String subtitle,
    Color color,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Icon(icon, color: color),

            const Spacer(),

            Text(title),

            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
static Widget wearableTile(
  String name,
  String battery,
  IconData icon,
  bool connected,
) {
  return Container(
    padding: const EdgeInsets.all(18),

    decoration: BoxDecoration(
      color: const Color(0xffF8F2FA),
      borderRadius: BorderRadius.circular(20),
    ),

    child: Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.purple.shade300,
          child: Icon(icon, color: Colors.white),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),

              Text(
                connected
                    ? "● Connected"
                    : "● Disconnected",
                style: TextStyle(
                  color: connected
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),
        ),

        Text(
          battery,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    ),
  );
}

  static Widget quickButton(
    IconData icon,
    String label,
    Color color,
  ) {
    return Container(
      width: 80,
      height: 110,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),

      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          CircleAvatar(
            backgroundColor:
                color.withValues(alpha: 0.15),
            child: Icon(icon, color: color),
          ),

          const SizedBox(height: 10),

          Text(
            label,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}