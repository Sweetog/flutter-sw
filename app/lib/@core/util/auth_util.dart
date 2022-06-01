import 'dart:async';
import 'package:app/@core/constants/roles.dart';
import 'package:app/@core/services/user_service.dart';
import 'package:app/@core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

enum AuthResult {
  Unknown,
  Exists,
  DoesNotExist,
  Created,
  CreationError,
  SignInSuccess,
  NoProviderPassword,
  UserDbRecordCreationError,
  InvalidUsernameOrPassword,
  TooManyAttempts,
}

class AuthUtil {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final _lg = new Logger();

  static Future<UserModel?> getCurrentUserDetails() async {
    var currentUser = _auth.currentUser;
    if (currentUser == null) {
      _lg.d('currentUser is null');
      return null;
    }

    return UserService.getUser(currentUser.uid);
  }

  static bool isElevated(UserModel user) {
    if (user.role != Roles.Admin && user.role != Roles.Employee) return false;

    return true;
  }

  // static Future<bool> isElevated() async {
  //   var user = await getCurrentUserDetails();
  //   if (user == null) return false;

  //   if (user.role != Roles.Admin && user.role != Roles.Employee) return false;

  //   return true;
  // }

  static Future<bool> isAdmin(UserModel user) async {
    return user.role == Roles.Admin;
  }

  static Future<bool> isSignedIn() async {
    return _auth.currentUser != null;
  }

  static Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }

  static Future<String?> getDisplayName() async {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      return null;
    }

    return (currentUser.displayName != null &&
            currentUser.displayName!.isNotEmpty)
        ? currentUser.displayName
        : currentUser.email;
  }

  static Future<DateTime?> getCreatedDate() async {
    var currentUser = _auth.currentUser;

    if (currentUser == null) {
      return null;
    }

    return currentUser.metadata.creationTime;
  }

  static Future<String?> getBearerToken() async {
    var currentUser = _auth.currentUser;

    if (currentUser == null) {
      return null;
    }

    return currentUser.getIdToken();
  }

  static Future<AuthResult> signIn(String email, String password) async {
    var providers = await _auth.fetchSignInMethodsForEmail(email);

    if (providers.length <= 0) {
      return AuthResult.DoesNotExist;
    }

    var hasPasswordProvider = false;

    for (int i = 0; i < providers.length; i++) {
      if (providers[i] == AuthProviders.Password) {
        hasPasswordProvider = true;
      }
    }

    if (!hasPasswordProvider) {
      return AuthResult.NoProviderPassword;
    }

    if (kIsWeb) {
      _auth.setPersistence(Persistence.SESSION);
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return AuthResult.SignInSuccess;
    } on FirebaseAuthException catch (e) {
      _lg.e(e);
      _lg.e('====== type of e: ${e.runtimeType}');
      _lg.e('====== type of e.code: ${e.code.runtimeType}');
      if (e.code == 'ERROR_WRONG_PASSWORD') {
        return AuthResult.InvalidUsernameOrPassword;
      }
      if (e.code == 'ERROR_TOO_MANY_REQUESTS') {
        return AuthResult.TooManyAttempts;
      }
      return AuthResult.Unknown;
    }
  }

//add an auth message return type or enum
  static Future<AuthResult> createAccount(
      String name, String email, String password, String role) async {
    _lg.d('create account start');
    _lg.d('email $email');

    var providers = await _auth.fetchSignInMethodsForEmail(email);

    if (providers.length > 0) {
      _lg.w(
          '==========AuthUtil.createAccount - $email account exits==========');
      return AuthResult.Exists;
    }

    try {
      var result = await UserService.createUser(name, email, password, role);

      if (result == UserStatus.UserCreationError) {
        _lg.w(
            '==========AuthUtil.createAccount - user db record creation failed for $email==========');
        return AuthResult.UserDbRecordCreationError;
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return AuthResult.Created;
    } catch (e) {
      _lg.e(e);
      return AuthResult.CreationError;
    }
  }

  static signOut() {
    _auth.signOut();
  }
}

class AuthProviders {
  static const Password = "password";
}
