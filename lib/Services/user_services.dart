import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housemasterapp/Models/user_model.dart';

class UserServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future getUserData() async {
    try {
      final doc = await _db.collection('users').doc(user?.uid).get();
      return UserModel.fromSnapshot(doc);
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  //   Future<String> getUid() async {
  //     try {
  //       String doc = await _db.collection('users').doc(user?.uid).get().then((
  //         value,
  //       ) {
  //         return value["uid"];
  //       });
  //       return doc;
  //     } catch (e) {
  //       throw Exception('Error fetching data: $e');
  //     }
  //   }

  //   Future<String> getUserImage() async {
  //     try {
  //       String doc = await _db.collection('users').doc(user?.uid).get().then((
  //         value,
  //       ) {
  //         return value["image"];
  //       });
  //       return doc;
  //     } catch (e) {
  //       throw Exception('Error fetching data: $e');
  //     }
  //   }

  //   Future<String> getUserName() async {
  //     try {
  //       String doc = await _db.collection('users').doc(user?.uid).get().then((
  //         value,
  //       ) {
  //         return value["name"];
  //       });
  //       return doc;
  //     } catch (e) {
  //       throw Exception('Error fetching data: $e');
  //     }
  //   }

  //   Future<String> getUserPhoneNumber() async {
  //     try {
  //       String doc = await _db.collection('users').doc(user?.uid).get().then((
  //         value,
  //       ) {
  //         return value["phonenumber"];
  //       });
  //       return doc;
  //     } catch (e) {
  //       throw Exception('Error fetching data: $e');
  //     }
  //   }
  // }
}
