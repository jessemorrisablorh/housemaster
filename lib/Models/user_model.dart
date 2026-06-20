import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String image;

  const UserModel({required this.id, required this.name, required this.image});

  /// From Firestore document
  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return UserModel(id: data['uid'], image: data['image'], name: data['name']);
  }

  /// From Map (useful for APIs, testing, local cache)
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(id: data['uid'], image: data['image'], name: data['name']);
  }

  /// To Firestore
  Map<String, dynamic> toMap() {
    return {'uid': id, 'image': image, 'name': name};
  }
}
