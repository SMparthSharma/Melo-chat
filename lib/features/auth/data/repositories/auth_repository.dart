import 'dart:developer';

import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/data/repositories/base_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository extends BaseReposisory {
  Stream<User?> get authStateChanges => auth.authStateChanges();
  Future<UserModel> signUp({
    required String userName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final formatedPhoneNumber = phoneNumber.replaceAll(
        RegExp(r'\s+'),
        "".trim(),
      );
      final phoneNumberExist = await isPhoneNumberExist(formatedPhoneNumber);
      if (phoneNumberExist) {
        throw 'The phone number is already in use by another account';
      }
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw 'Failed to create user';
      }
      final user = UserModel(
        uid: userCredential.user!.uid,
        userName: userName,
        email: email,
        phoneNumber: formatedPhoneNumber,
      );
      await saveUserData(user);
      return user;
    } catch (e) {
      log("from AuthRepository signup method ${e.toString()}");

      throw trimExceptionMessage(e.toString());
    }
  }

  Future<void> saveUserData(UserModel user) async {
    try {
      firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      throw 'Failed to save user data';
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw 'user not found';
      }
      final userData = await getUserData(userCredential.user!.uid);
      return userData;
    } catch (e) {
      log("from AuthRepository signin method ${e.toString()}");
      throw "Either email or password is incorrect";
    }
  }

  Future<UserModel> getUserData(String uid) async {
    try {
      final doc = await firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        throw 'user not found';
      }
      return UserModel.fromFireStore(doc);
    } catch (e) {
      throw 'user data not found';
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<bool> isPhoneNumberExist(String phoneNumber) async {
    try {
      final isPhoneNumbeer = await firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();
      return isPhoneNumbeer.docs.isNotEmpty;
    } catch (e) {
      log('error: on isPhoneNumberExist method ${e.toString()}');
      return false;
    }
  }

  String trimExceptionMessage(String message) {
    String errorMessage = message;
    int index = errorMessage.indexOf(']');

    if (index != -1 && index < errorMessage.length - 1) {
      errorMessage = errorMessage.substring(index + 1).trim();
    }
    return errorMessage;
  }
}
