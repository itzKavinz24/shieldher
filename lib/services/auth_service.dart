import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
  final GoogleSignIn signIn = GoogleSignIn.instance;

  await signIn.initialize(
    serverClientId:
        '933286018701-6vvn9jfqr56ckq3q0b5o16agh62tk96v.apps.googleusercontent.com',
  );

  final GoogleSignInAccount googleUser =
      await signIn.authenticate();

  final googleAuth =
      googleUser.authentication;

  final credential =
      GoogleAuthProvider.credential(
    idToken: googleAuth.idToken,
  );

  return await _auth.signInWithCredential(
    credential,
  );
}

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  User? get currentUser => _auth.currentUser;
}