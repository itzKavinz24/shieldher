import 'package:flutter/services.dart';

class NativeSmsService {
  static const MethodChannel _channel =
      MethodChannel('shieldher_sms');

static Future<void> sendSms({
  required String phone,
  required String message,
}) async {

  print("NATIVE SMS CALL = $phone");

  final result = await _channel.invokeMethod(
    'sendSms',
    {
      'phone': phone,
      'message': message,
    },
  );

  print("NATIVE SMS RESULT = $result");
}
}