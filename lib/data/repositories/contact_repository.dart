import 'dart:developer';

import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/data/service/base_repository.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactRepository extends BaseReposisory {
  String get currentUserId => auth.currentUser!.uid;

  Future<bool> requestContactPermission() async {
    return await FlutterContacts.requestPermission();
  }

  // get phoneNumber from divice
  Future<List<Map<String, dynamic>>> getRegisterContact() async {
    try {
      final contacts = await FlutterContacts.getContacts(
        withPhoto: true,
        withProperties: true,
      );
      //extract phone number and normalize them (eg.+9123434266--23434266)
      final phoneNumber = contacts
          .where((contact) => contact.phones.isNotEmpty)
          .map(
            (contact) => {
              'name': contact.displayName,
              'phoneNumber': contact.phones.first.number.replaceAll(
                RegExp(r'[^\d+]'),
                '',
              ),
              'photo': contact.photo,
            },
          );
      //get user form firestore
      final userSnapshot = await firestore.collection("users").get();
      final registerUser = await userSnapshot.docs
          .map((doc) => UserModel.fromFireStore(doc))
          .toList();

      //match phone number

      final matchContact = phoneNumber
          .where((contact) {
            final phoneNumber = contact['phoneNumber'];
            return registerUser.any(
              (user) =>
                  user.phoneNumber == phoneNumber && user.uid != currentUserId,
            );
          })
          .map((contact) {
            final registeruser = registerUser.firstWhere(
              (user) => user.phoneNumber == contact['phoneNumber'],
            );
            return {
              'id': registeruser.uid,
              'name': contact['name'],
              'phoneNumber': contact['phoneNumber'],
            };
          })
          .toList();
      return matchContact;
    } catch (e) {
      log('error: geting register user and in contact repository');
      return [];
    }
  }
}
