import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000/api";

  // ======================
  // 🔐 TOKEN HELPERS
  // ======================

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<Map<String, String>> authHeader() async {
    final token = await getToken();

    print("========== TOKEN DEBUG ==========");
    print("TOKEN VALUE: $token");
    print("=================================");

    return {
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  // ======================
  // 🔑 AUTH
  // ======================

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );

    print("LOGIN STATUS: ${response.statusCode}");
    print("LOGIN BODY: ${response.body}");

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> changePassword(
      String currentPassword, String newPassword) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/change-password"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "current_password": currentPassword,
        "new_password": newPassword,
        "new_password_confirmation": newPassword,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>?> register(
    String name,
    String email,
    String password,
    String role,
    String? department,
    String? faculty,
    String? degree,
    String? campusId,
    String? batchNumber,
  ) async {
    try {
      // ✅ Base fields (always sent)
      Map<String, dynamic> body = {
        "name": name,
        "email": email,
        "password": password,
        "role": role,
      };

      // ✅ Only add student fields IF they exist
      if (department != null) body["department"] = department;
      if (faculty != null) body["faculty"] = faculty;
      if (degree != null) body["degree"] = degree;
      if (campusId != null) body["campus_id"] = campusId;
      if (batchNumber != null) body["batch_number"] = batchNumber;

      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {
          "Accept": "application/json",
        },
        body: body,
      );

      print("REGISTER STATUS: ${response.statusCode}");
      print("REGISTER BODY: ${response.body}");

      // ✅ Handle response safely
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return decoded; // success
      } else {
        print("REGISTER ERROR: ${decoded['message']}");
        return null; // fail
      }
    } catch (e) {
      print("REGISTER EXCEPTION: $e");
      return null;
    }
  }
  // ======================
  // 💬 FEEDBACK
  // ======================

  static Future<bool> submitFeedback(String message) async {
    final headers = await authHeader();

    final response = await http.post(
      Uri.parse("$baseUrl/feedback"),
      headers: {
        ...headers,
        "Accept": "application/json",
      },
      body: {
        "user_id": "1", // ✅ ADD THIS (TEMP FIX)
        "message": message,
      },
    );

    print("FEEDBACK STATUS: ${response.statusCode}");
    print("FEEDBACK BODY: ${response.body}");

    final data = jsonDecode(response.body);

    return data['status'] == true;
  }

  // ======================
  // ⏰ REMINDERS
  // ======================

  static Future<bool> saveReminder(
      String title, String date, String time) async {
    final headers = await authHeader();

    final response = await http.post(
      Uri.parse("$baseUrl/reminders"),
      headers: headers,
      body: {
        "title": title,
        "date": date,
        "time": time,
      },
    );

    print("SAVE REMINDER STATUS: ${response.statusCode}");
    print("SAVE REMINDER BODY: ${response.body}");

    return response.statusCode == 201 || response.statusCode == 200;
  }

  static Future<List<dynamic>> getReminders() async {
    final headers = await authHeader();

    final response = await http.get(
      Uri.parse("$baseUrl/reminders"),
      headers: headers,
    );

    print("GET REMINDER STATUS: ${response.statusCode}");
    print("GET REMINDER BODY: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map && decoded.containsKey("data")) {
        return decoded["data"];
      }

      if (decoded is List) {
        return decoded;
      }
    }

    return [];
  }

  // ======================
  // 👨‍🏫 LECTURERS
  // ======================

  static Future<List<dynamic>> getLecturers({String? search}) async {
    final headers = await authHeader();
    String url = "$baseUrl/lecturers";
    if (search != null && search.isNotEmpty) {
      url += "?search=${Uri.encodeComponent(search)}";
    }

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<bool> deleteReminder(int id) async {
    final headers = await authHeader();

    final response = await http.delete(
      Uri.parse("$baseUrl/reminders/$id"),
      headers: headers,
    );

    print("DELETE REMINDER STATUS: ${response.statusCode}");
    print("DELETE REMINDER BODY: ${response.body}");

    return response.statusCode == 200;
  }
  // ======================
  // 🔔 NOTIFICATIONS
  // ======================

  static Future<List<dynamic>> getNotifications() async {
    final headers = await authHeader();

    final response = await http.get(
      Uri.parse("$baseUrl/notifications"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic> && decoded.containsKey("data")) {
        return decoded["data"];
      }

      if (decoded is List) {
        return decoded;
      }
    }

    return [];
  }

  static Future<bool> markNotificationRead(int id) async {
    final headers = await authHeader();

    final response = await http.put(
      Uri.parse("$baseUrl/notifications/$id/read"),
      headers: headers,
    );

    return response.statusCode == 200;
  }
// ================= LOST & FOUND =================

  static Future<List<dynamic>> getLostFound(
      {String? search, String? type}) async {
    final headers = await authHeader();
    String url = "$baseUrl/lost-found";
    List<String> params = [];
    if (search != null && search.isNotEmpty) {
      params.add("search=${Uri.encodeComponent(search)}");
    }
    if (type != null) params.add("type=$type");

    if (params.isNotEmpty) {
      url += "?${params.join("&")}";
    }

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }

  static Future<bool> addLostFound(
    String itemName,
    String description,
    String type,
    String phone,
    String? imagePath,
  ) async {
    final token = await getToken();
    final uri = Uri.parse("$baseUrl/lost-found");
    final request = http.MultipartRequest("POST", uri);

    request.headers.addAll({
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    });

    request.fields.addAll({
      "item_name": itemName,
      "description": description,
      "type": type,
      "phone": phone,
    });

    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath("image", imagePath));
    }

    final response = await request.send();
    return response.statusCode == 201 || response.statusCode == 200;
  }

  static Future<bool> updateLostFound(
    int id,
    String title,
    String description,
    String phone,
    String type,
  ) async {
    final headers = await authHeader();

    final response = await http.put(
      Uri.parse("$baseUrl/lost-found/$id"),
      headers: headers,
      body: {
        "title": title,
        "description": description,
        "phone": phone,
        "type": type,
      },
    );

    return response.statusCode == 200;
  }

  static Future<bool> deleteLostFound(int id) async {
    final headers = await authHeader();

    final response = await http.delete(
      Uri.parse("$baseUrl/lost-found/$id"),
      headers: headers,
    );

    return response.statusCode == 200;
  }

  // ======================
  // 💬 CHAT
  // ======================

  static Future<Map<String, dynamic>> startConversation(
      int lostFoundId, int receiverId) async {
    final headers = await authHeader();

    final response = await http.post(
      Uri.parse("$baseUrl/conversations"),
      headers: headers,
      body: {
        "lost_found_id": lostFoundId.toString(),
        "receiver_id": receiverId.toString(),
      },
    );

    print("START CONVERSATION STATUS: ${response.statusCode}");
    print("START CONVERSATION BODY: ${response.body}");

    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getMessages(int conversationId) async {
    final headers = await authHeader();

    final response = await http.get(
      Uri.parse("$baseUrl/messages/$conversationId"),
      headers: headers,
    );

    print("GET MESSAGES STATUS: ${response.statusCode}");
    print("GET MESSAGES BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }

  static Future<bool> sendMessage(int conversationId, String message) async {
    final headers = await authHeader();

    final response = await http.post(
      Uri.parse("$baseUrl/messages"),
      headers: headers,
      body: {
        "conversation_id": conversationId.toString(),
        "message": message,
      },
    );

    print("SEND MESSAGE STATUS: ${response.statusCode}");
    print("SEND MESSAGE BODY: ${response.body}");

    return response.statusCode == 201 || response.statusCode == 200;
  }

  // ======================
  // 👤 USER PROFILE
  // ======================

  static Future<Map<String, dynamic>?> getUserProfile() async {
    final headers = await authHeader();

    final response = await http.get(
      Uri.parse("$baseUrl/profile"),
      headers: headers,
    );

    print("PROFILE STATUS: ${response.statusCode}");
    print("PROFILE BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  static Future<bool> submitItems(int userId, List<String> items) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/need-items"),
        headers: {"Accept": "application/json"},
        body: {
          "user_id": userId.toString(),
          "items": jsonEncode(items),
        },
      );

      print("ITEM STATUS: ${response.statusCode}");
      print("ITEM BODY: ${response.body}");

      return response.statusCode == 201;
    } catch (e) {
      print("ITEM ERROR: $e");
      return false;
    }
  }
}
