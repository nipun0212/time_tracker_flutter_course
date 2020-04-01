import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  User(
      {@required this.uid,
      this.photoUrl,
      this.displayName,
      this.isOwner,
      this.isSuperAdmin,
      this.organizationDocId});

  final String uid;
  final String photoUrl;
  final String displayName;
  final isOwner;
  final isSuperAdmin;
  final organizationDocId;
}

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;

  Future<User> currentUser();

  Future<User> signInAnonymously();

  Future<User> signInWithEmailAndPassword(String email, String password);

  Future<User> createUserWithEmailAndPassword(String email, String password);

  Future<User> signInWithGoogle();

  Future<User> signInWithFacebook();

  void signInWithPhoneNumber(String phoneNumber,
      Function(String verificationId, [int forceResendingToken]) ab);

  Future<User> sendOTP(String otp, String verificationId);

  Future<void> signOut();
}

class Auth implements AuthBase {
  Auth({this.cs});
  final _firebaseAuth = FirebaseAuth.instance;
  final Function(PhoneCodeSent) cs;
  String verificationId;

  Future<User> _userFromFirebase(FirebaseUser user) async {
    if (user == null) {
      return null;
    }
    bool isOwner = false;
    bool isSuperAdmin = false;
    String organizationDocId;
    (await user.getIdToken()).claims.forEach((k, v) {
      print('k= $k and v= $v');
      if (k == 'isOwner') isOwner = v;
      if (k == 'isSuperAdmin') isSuperAdmin = v;
      if (k == 'organizationDocId') organizationDocId = v;
    });
    return User(
        uid: user.uid,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
        isOwner: isOwner,
        isSuperAdmin: isSuperAdmin,
        organizationDocId: organizationDocId);
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.asyncMap(_userFromFirebase);
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    bool isOwner;
    bool isSuperAdmin;
    (await user.getIdToken()).claims.forEach((k, v) {
      print('k= $k and v= $v');
      if (k == 'isOwner') isOwner = v;
      if (k == 'isSuperAdmin') isSuperAdmin = v;
    });
    print('isOwenr = $isOwner');
    print('isSuperAdmin = $isSuperAdmin');
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  void signInWithPhoneNumber(String phoneNumber,
      Function(String verificationId, [int forceResendingToken]) ab) async {
    print('called');
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+91' + phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: null,
      verificationFailed: verificationFailed,
      codeSent: ab,
      codeAutoRetrievalTimeout: null,
    );
  }

  void codeSent<PhoneCodeSent>(String verificationId,
      [int forceResendingToken]) {
    this.verificationId = verificationId;
    print('verificationId= $verificationId');
  }

  void verificationFailed(AuthException error) {
    print("Error Occured");
    print(error.message);
  }

  @override
  Future<User> sendOTP(String otp, verificationId) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: otp,
    );
    print("otp");
    print(otp);
    print('x');

    final AuthResult authResult =
        (await _firebaseAuth.signInWithCredential(credential));
    print("authResult");
    print(authResult.user);
    print(authResult.user.uid);
    bool isOwner;
    bool isSuperAdmin;
    (await authResult.user.getIdToken()).claims.forEach((k, v) {
      print('k= $k and v= $v');
      if (k == 'isOwner') isOwner = v;
      if (k == 'isSuperAdmin') isSuperAdmin = v;
    });
    print('isOwenr = $isOwner');
    print('isSuperAdmin = $isSuperAdmin');
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logInWithReadPermissions(
      ['public_profile'],
    );
    if (result.accessToken != null) {
      final authResult = await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        ),
      );
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }
}
