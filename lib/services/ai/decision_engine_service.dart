import 'risk_engine_service.dart';

/// Final decision returned by the AI system.
class DecisionResult {
  final String status;

  final bool triggerSOS;
  final bool notifyEmergencyContacts;
  final bool playAlarm;
  final bool saveIncident;
  final bool showWarning;

  const DecisionResult({
    required this.status,
    required this.triggerSOS,
    required this.notifyEmergencyContacts,
    required this.playAlarm,
    required this.saveIncident,
    required this.showWarning,
  });

  bool get isSafe => status == "SAFE";
  bool get isWarning => status == "WARNING";
  bool get isEmergency => status == "EMERGENCY";
}

class DecisionEngineService {
  DecisionResult makeDecision({
    required RiskResult riskResult,
  }) {
    switch (riskResult.riskLevel) {
      case "HIGH":
        return const DecisionResult(
          status: "EMERGENCY",

          triggerSOS: true,
          notifyEmergencyContacts: true,
          playAlarm: true,
          saveIncident: true,
          showWarning: true,
        );

      case "MEDIUM":
        return const DecisionResult(
          status: "WARNING",

          triggerSOS: false,
          notifyEmergencyContacts: true,
          playAlarm: false,
          saveIncident: true,
          showWarning: true,
        );

      default:
        return const DecisionResult(
          status: "SAFE",

          triggerSOS: false,
          notifyEmergencyContacts: false,
          playAlarm: false,
          saveIncident: false,
          showWarning: false,
        );
    }
  }
}