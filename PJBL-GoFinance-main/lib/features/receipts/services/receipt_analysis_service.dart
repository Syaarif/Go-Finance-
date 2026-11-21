import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../models/receipt_analysis_model.dart';

class ReceiptAnalysisService {
  static const _apiUrl = String.fromEnvironment(
    'RECEIPT_API_URL',
  );

  Future<ReceiptAnalysisModel> analyze({
    required Uint8List bytes,
    required String fileName,
  }) async {
    if (_apiUrl.isEmpty) {
      throw const ReceiptAnalysisException(
        'RECEIPT_API_URL belum dikonfigurasi.',
      );
    }

    final uri = Uri.parse(_apiUrl);
    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes(
        'receipt',
        bytes,
        filename: fileName,
      ));

    final streamedResponse =
        await request.send().timeout(const Duration(seconds: 90));
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw ReceiptAnalysisException(
        body['message'] as String? ?? 'Gagal menganalisis struk.',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final result = body['result'] as Map<String, dynamic>? ??
        body;
    return ReceiptAnalysisModel.fromJson(result);
  }
}

class ReceiptAnalysisException implements Exception {
  final String message;

  const ReceiptAnalysisException(this.message);

  @override
  String toString() => message;
}
