import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_finance/core/services/aws_api_service.dart';

class AwsConfig {
  static const String apiBaseUrl =
      'https://f60yfb7vcj.execute-api.us-east-1.amazonaws.com';
  static const String cognitoUserPoolId = 'us-east-1_rjWKiBG0I';
  static const String cognitoClientId = 'nl8s0pt9hl834ad6v20ttpn4c';
  static const String primaryAdminEmail = 'admin@gofinance.id';
}

class AwsAuthService {
  AwsAuthService._();
  static final AwsAuthService instance = AwsAuthService._();

  final CognitoUserPool _userPool = CognitoUserPool(
    AwsConfig.cognitoUserPoolId,
    AwsConfig.cognitoClientId,
  );

  Future<void> Function()? onLoginSuccess;
  Future<void> Function()? onLogout;

  Map<String, dynamic> _decodeJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return {};
      final normalized = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      return Map<String, dynamic>.from(jsonDecode(decoded));
    } catch (_) {
      return {};
    }
  }

  bool isTokenExpired(String? token) {
    if (token == null || token.isEmpty) return true;
    final payload = _decodeJwtPayload(token);
    final exp = payload['exp'];
    if (exp is! int) return false;
    final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return nowSeconds >= (exp - 30);
  }

  Future<bool> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final nameToUse = (fullName != null && fullName.trim().isNotEmpty)
        ? fullName.trim()
        : cleanEmail.split('@').first;

    final userAttributes = [
      AttributeArg(name: 'email', value: cleanEmail),
      AttributeArg(name: 'name', value: nameToUse),
    ];

    final result = await _userPool.signUp(
      cleanEmail,
      password,
      userAttributes: userAttributes,
    );

    return result.userConfirmed ?? false;
  }

  Future<bool> confirmUser(String email, String otpCode) async {
    final cognitoUser = CognitoUser(email.trim().toLowerCase(), _userPool);
    return await cognitoUser.confirmRegistration(otpCode.trim());
  }

  Future<void> resendConfirmationCode(String email) async {
    final cognitoUser = CognitoUser(email.trim().toLowerCase(), _userPool);
    await cognitoUser.resendConfirmationCode();
  }

  Future<String> signIn(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();
    final cognitoUser = CognitoUser(cleanEmail, _userPool);
    final authDetails = AuthenticationDetails(
      username: cleanEmail,
      password: password,
    );

    final session = await cognitoUser.authenticateUser(authDetails);
    final idToken = session?.getIdToken().getJwtToken();

    if (idToken == null || idToken.isEmpty) {
      throw Exception('Token sesi Cognito gagal diperoleh.');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('aws_jwt_token', idToken);
    await prefs.setString('aws_user_email', cleanEmail);

    final payload = _decodeJwtPayload(idToken);
    final groups = (payload['cognito:groups'] as List<dynamic>?)
            ?.map((e) => e.toString().toLowerCase())
            .toList() ??
        [];

    String role = (groups.contains('admin') ||
            cleanEmail == AwsConfig.primaryAdminEmail.toLowerCase())
        ? 'admin'
        : 'user';
    String status = role == 'admin' ? 'active' : 'pending';

    final profile = await AwsApiService.instance.getMyProfile();
    final data = profile['data'] is Map
        ? Map<String, dynamic>.from(profile['data'])
        : profile;

    final apiRole = data['role']?.toString().toLowerCase();
    final apiStatus = data['status']?.toString().toLowerCase();

    if (apiRole != null && apiRole.isNotEmpty) {
      role = (cleanEmail == AwsConfig.primaryAdminEmail.toLowerCase())
          ? 'admin'
          : apiRole;
    }
    if (apiStatus != null && apiStatus.isNotEmpty) {
      status = role == 'admin' ? 'active' : apiStatus;
    }

    await prefs.setString('aws_user_role', role);
    await prefs.setString('aws_user_status', status);

    if (onLoginSuccess != null && role != 'admin' && status == 'active') {
      await onLoginSuccess!();
    }

    return idToken;
  }

  Future<bool> hasValidSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('aws_jwt_token');
    return token != null && token.isNotEmpty && !isTokenExpired(token);
  }

  Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final role = (prefs.getString('aws_user_role') ?? 'user').toLowerCase();
    final email = (prefs.getString('aws_user_email') ?? '').toLowerCase();
    return role == 'admin' || email == AwsConfig.primaryAdminEmail.toLowerCase();
  }

  Future<String> getUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('aws_user_status') ?? 'pending';
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('aws_jwt_token');
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('aws_user_email');
    if (email != null) {
      try {
        final cognitoUser = CognitoUser(email, _userPool);
        await cognitoUser.signOut();
      } catch (_) {}
    }
    await prefs.remove('aws_jwt_token');
    await prefs.remove('aws_user_email');
    await prefs.remove('aws_user_role');
    await prefs.remove('aws_user_status');

    if (onLogout != null) {
      await onLogout!();
    }
  }
}