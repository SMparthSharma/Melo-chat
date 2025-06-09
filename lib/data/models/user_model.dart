// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String userName;
  final String email;
  final String phoneNumber;
  final bool isOnline;
  final String? fcmToken;
  final Timestamp? lastSeen;
  final Timestamp? createdAt;
  final List<String> blockedUsers;

  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    this.fcmToken,
    this.isOnline = false,
    Timestamp? lastSeen,
    Timestamp? createdAt,
    this.blockedUsers = const [],
  }) : lastSeen = lastSeen ?? Timestamp.now(),
       createdAt = createdAt ?? Timestamp.now();

  UserModel copyWith({
    String? uid,
    String? userName,
    String? email,
    String? phoneNumber,
    bool? isOnline,
    String? fcmToken,
    Timestamp? lastSeen,
    Timestamp? createdAt,
    List<String>? blockedUsers,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isOnline: isOnline ?? this.isOnline,
      fcmToken: fcmToken ?? this.fcmToken,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      blockedUsers: blockedUsers ?? this.blockedUsers,
    );
  }

  factory UserModel.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      userName: data['userName'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      fcmToken: data['fcmToken'],
      isOnline: data['isOnline'],
      lastSeen: data['lastSeen'],
      createdAt: data['createdAt'],
      blockedUsers: data['blockedUsers'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userName": userName,
      "email": email,
      "phoneNumber": phoneNumber,
      "fcmToken": fcmToken,
      "isOnline": isOnline,
      "lastSeen": lastSeen,
      "createdAt": createdAt,
      "blockedUsers": blockedUsers,
    };
  }
}
