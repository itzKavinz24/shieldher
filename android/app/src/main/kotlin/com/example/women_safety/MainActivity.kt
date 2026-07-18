package com.example.women_safety

import android.telephony.SmsManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "shieldher_sms"

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            if (call.method == "sendSms") {

                val phone =
                    call.argument<String>("phone")

                val message =
                    call.argument<String>("message")

                try {

                    val smsManager =
                        SmsManager.getDefault()

                    val parts =
                        smsManager.divideMessage(message)

                    smsManager.sendMultipartTextMessage(
                        phone,
                        null,
                        parts,
                        null,
                        null
                    )

                    result.success(true)

                } catch (e: Exception) {

                    result.error(
                        "SMS_ERROR",
                        e.message,
                        null
                    )
                }
            }
        }
    }
}