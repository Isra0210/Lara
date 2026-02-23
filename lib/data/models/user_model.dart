import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lara/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    super.email,
    super.displayName,
    super.photoUrl,
    super.createdAt,
  });

  factory UserModel.fromFirebaseUser(firebase.User u) {
    return UserModel(
      id: u.uid,
      email: u.email,
      displayName: u.displayName,
      photoUrl: u.photoURL,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    email: json['email'],
    displayName: json['displayName'],
    photoUrl: json['photoUrl'],
    createdAt: json['createdAt'],
  );

  factory UserModel.fromCache(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    email: json['email'],
    displayName: json['displayName'],
    photoUrl: json['photoUrl'],
    createdAt: json['createdAt'] != null
        ? Timestamp.fromMillisecondsSinceEpoch(json['createdAt'])
        : null,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'createdAt': createdAt,
  };

  Map<String, dynamic> toMapCache() => {
    'id': id,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'createdAt': createdAt?.millisecondsSinceEpoch,
  };
}
