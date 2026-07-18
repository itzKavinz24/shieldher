import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

import 'contact_service.dart';
import '../models/contact_model.dart';
import 'location_service.dart';

class AlertService {
  static Future<void>
      sendEmergencyAlert() async {
    Position position =
        await LocationService
            .getCurrentLocation();

    List<ContactModel> contacts =
        await ContactService()
            .getContacts();

    if (contacts.isEmpty) return;

    String message = '''
EMERGENCY ALERT

I may be in danger.

Location:
https://maps.google.com/?q=${position.latitude},${position.longitude}
''';

    final firstContact =
        contacts.first.phone;

    final smsUri = Uri.parse(
      'sms:$firstContact?body=${Uri.encodeComponent(message)}',
    );

    await launchUrl(smsUri);

    final callUri = Uri.parse(
      'tel:$firstContact',
    );

    await launchUrl(callUri);
  }
}