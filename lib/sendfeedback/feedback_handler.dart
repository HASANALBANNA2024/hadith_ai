import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedbackHandler {
  // logic done
  static const String _n8nWebhookUrl = 'YOUR_GLOBAL_N8N_WEBHOOK_URL';

  static Future<bool> sendGlobalFeedback({
    required String appId,
    required String name,
    required String email,
    required String category,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_n8nWebhookUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "app_id": appId,
          "service_type": "feedback_submission",
          "payload": {
            "user_name": name.isEmpty ? "Anonymous" : name,
            "user_email": email.isEmpty ? "Not Provided" : email,
            "category": category,
            "message": message,
            "submitted_at": DateTime.now().toIso8601String(),
          },
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error sending feedback: $e");
      return false;
    }
  }
}
