import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _userFromFirebase(User? user) {
    return user;
  }

  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  String? get userID {
    return _auth.currentUser?.uid;
  }

  Future<dynamic> signInWithEmailPass(String email, String password) async {
    try {
      UserCredential uc = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return uc.user;
    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found') {
        return e.message ?? 'User not found';
      } else if (e.code == 'wrong-password') {
        return e.message ?? 'Password is not correct';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> signUpWithEmailPass(String name, String surname, String schoolName, String email, String password) async {
    try {
      UserCredential uc = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return uc.user;
    } on FirebaseAuthException catch (e) {
      if(e.code == 'email-already-in-use') {
        return e.message ?? 'E-mail already in use';
      } else if (e.code == 'weak-password') {
        return e.message ?? 'Your password is weak';
      }
    }
  }

  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential uc = await FirebaseAuth.instance.signInWithCredential(credential);
    return _userFromFirebase(uc.user);
  }

  Future<void> signOut() async {
      await _auth.signOut();
  }


}