import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AwsConfig {
  static const String apiBaseUrl =
      'https://f60yfb7vcj.execute-api.us-east-1.amazonaws.com';
  static const String cognitoUserPoolId = 'us-east-1_rjWKiBG0I';
  static const String cognitoClientId = 'nl8s0pt9hl834ad6v20ttpn4c';
}

class AwsAuthService {
  AwsAuthService._();
  static final AwsAuthService instance = AwsAuthService._();

  final CognitoUserPool _userPool = CognitoUserPool(
    AwsConfig.cognitoUserPoolId,
    AwsConfig.cognitoClientId,
  );

  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final nameToUse = (fullName != null && fullName.trim().isNotEmpty)
        ? fullName.trim()
        : email.split('@').first;

    final userAttributes = [
      AttributeArg(name: 'email', value: email.trim()),
      AttributeArg(name: 'name', value: nameToUse),
    ];

    await _userPool.signUp(
      email.trim(),
      password,
      userAttributes: userAttributes,
    );
  }

  Future<bool> confirmUser(String email, String otpCode) async {
    final cognitoUser = CognitoUser(email.trim(), _userPool);
    return await cognitoUser.confirmRegistration(otpCode.trim());
  }

  Future<void> resendConfirmationCode(String email) async {
    final cognitoUser = CognitoUser(email.trim(), _userPool);
    await cognitoUser.resendConfirmationCode();
  }

  Future<String> signIn(String email, String password) async {
    final cognitoUser = CognitoUser(email.trim(), _userPool);
    final authDetails = AuthenticationDetails(
      username: email.trim(),
      password: password,
    );

    final session = await cognitoUser.authenticateUser(authDetails);
    final idToken = session?.getIdToken().getJwtToken();

    if (idToken == null || idToken.isEmpty) {
      throw Exception('Token sesi Cognito gagal diperoleh.');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('aws_jwt_token', idToken);
    await prefs.setString('aws_user_email', email.trim());
    return idToken;
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
  }
}