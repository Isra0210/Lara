import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  const UserEntity({
    required this.id,
    this.displayName,
    this.email,
    this.photoUrl,
    this.createdAt,
  });

  final String id;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final Timestamp? createdAt;
}
