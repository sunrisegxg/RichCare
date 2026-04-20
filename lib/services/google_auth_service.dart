import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<String?> getIdToken() async {
    await _googleSignIn.initialize(
      serverClientId:
          '966627803704-5efl3j3b1ap48gl1qmifi6rbhfq099ra.apps.googleusercontent.com',
    );

    final account = await _googleSignIn.authenticate(
      scopeHint: ['email', 'profile'],
    );

    final auth = account.authentication;
    print("ID TOKEN: $auth.idToken");
    return auth.idToken;
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }
}
