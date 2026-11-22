import 'dart:convert';
import 'package:http/http.dart' as http;
import 'aws_auth_service.dart';

typedef StringHeaders = Map<String, String>;
typedef JsonMap = Map<String, dynamic>;

class AwsApiService {
  AwsApiService._();
  static final AwsApiService instance = AwsApiService._();

  Future<StringHeaders> _authHeaders() async {
    final token = await AwsAuthService.instance.getToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<JsonMap> getMyProfile() async {
    final res = await http.get(
      Uri.parse('${AwsConfig.apiBaseUrl}/me'),
      headers: await _authHeaders(),
    );
    if (res.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(res.body));
    }
    throw Exception('Gagal memuat profil (${res.statusCode}): ${res.body}');
  }

  Future<List<dynamic>> getCategories() async {
    final res = await http.get(
      Uri.parse('${AwsConfig.apiBaseUrl}/categories'),
    );
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      return List<dynamic>.from(decoded['data'] ?? []);
    }
    throw Exception('Gagal memuat kategori: ${res.body}');
  }

  Future<List<dynamic>> getWallets() async {
    final res = await http.get(
      Uri.parse('${AwsConfig.apiBaseUrl}/wallets'),
      headers: await _authHeaders(),
    );
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      return List<dynamic>.from(decoded['data'] ?? []);
    }
    throw Exception('Gagal memuat dompet (${res.statusCode}): ${res.body}');
  }

  Future<List<dynamic>> getTransactions() async {
    final res = await http.get(
      Uri.parse('${AwsConfig.apiBaseUrl}/transactions'),
      headers: await _authHeaders(),
    );
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      return List<dynamic>.from(decoded['data'] ?? []);
    }
    throw Exception('Gagal memuat transaksi (${res.statusCode}): ${res.body}');
  }

  Future<void> createTransaction({
    required int walletId,
    required int categoryId,
    required String type,
    required double amount,
    required String note,
    required String transactionDate,
  }) async {
    final res = await http.post(
      Uri.parse('${AwsConfig.apiBaseUrl}/transactions'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'wallet_id': walletId,
        'category_id': categoryId,
        'type': type,
        'amount': amount,
        'note': note,
        'transaction_date': transactionDate,
      }),
    );
    if (res.statusCode != 201) {
      throw Exception('Gagal mencatat transaksi (${res.statusCode}): ${res.body}');
    }
  }

  Future<List<dynamic>> getAdminUsers() async {
    final res = await http.get(
      Uri.parse('${AwsConfig.apiBaseUrl}/admin/users'),
      headers: await _authHeaders(),
    );
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      return List<dynamic>.from(decoded['data'] ?? []);
    }
    throw Exception('Gagal memuat daftar user (${res.statusCode}): ${res.body}');
  }

  Future<void> adminUserAction({
    required String targetUserId,
    required String targetEmail,
    required String action,
  }) async {
    final res = await http.post(
      Uri.parse('${AwsConfig.apiBaseUrl}/admin/users/action'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'target_user_id': targetUserId,
        'target_email': targetEmail,
        'action': action,
      }),
    );
    if (res.statusCode != 200) {
      throw Exception('Aksi gagal (${res.statusCode}): ${res.body}');
    }
  }
}