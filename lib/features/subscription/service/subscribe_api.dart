import 'package:bond/config/constant.dart';
import 'package:bond/shared/helpers/auth_helper.dart';
import 'package:http/http.dart' as http;

class SubscribeApi {
  Future<String> subribePlan(String plan, String period) async {
    final token = await AuthHelper.getAccessToken() ?? "";
    Map<String, String> params = {
      'plan': plan,
      'period': period,
    };
    final url = Uri.parse(subscribeUrl).replace(queryParameters: params);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to subscribe plan');
      }
    } catch (e) {
      throw Exception('Failed to subscribe plan: $e');
    }
  }
}
