// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/models/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, LocalUser>((ref) {
  return UserNotifier();
});

class LocalUser {
  const LocalUser({required this.id, required this.user});
  final String id;
  final FireBaseUser user;

  LocalUser copyWith({
    String? id,
    FireBaseUser? user,
  }) {
    return LocalUser(
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }
}

class UserNotifier extends StateNotifier<LocalUser> {
  UserNotifier()
      : super(const LocalUser(
            id: "error",
            user: FireBaseUser(
                email: "error", name: "error", profilepic: "error")));

  //signip

  Future<void> logIn(String email) async {
    QuerySnapshot response = await _firestore
        .collection("users")
        .where('email', isEqualTo: email)
        .get();
    state = LocalUser(
        id: response.docs[0].id,
        user: FireBaseUser.fromMap(
            response.docs[0].data() as Map<String, dynamic>));

    if (response.docs.isEmpty) {
      print("No fireStore user authenticated to this email $email");
      return;
    }
    if (response.docs.length > 1) {
      print("More than one fireStore user authenticated to this email $email");
      return;
    }
  }

  //signup
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> signup(String email) async {
    DocumentReference response = await _firestore.collection("users").add(
          FireBaseUser(
            email: email,
            name: "no Name",
            profilepic: "https://www.gravatar.com/avatar/?d=mp",
          ).toMap(),
        );
    DocumentSnapshot snapshot = await response.get();
    state = LocalUser(
        id: response.id,
        user: FireBaseUser.fromMap(snapshot.data() as Map<String, dynamic>));
  }

  Future<void> updateName(String name) async {
    await _firestore.collection("users").doc(state.id).update({'name': name});
    state = state.copyWith(user: state.user.copyWith(name: name));
  }

  Future<void> updateImage(File image) async {
    Reference ref = _storage.ref().child('users').child(state.id);
    TaskSnapshot snapshot = await ref.putFile(image);
    String PropicUrl = await snapshot.ref.getDownloadURL();
    await _firestore
        .collection("users")
        .doc(state.id)
        .update({'profilepic': PropicUrl});
    state = state.copyWith(user: state.user.copyWith(profilepic: PropicUrl));
  }

  void logOut() {
    state = const LocalUser(
        id: "error",
        user: FireBaseUser(email: "error", name: "error", profilepic: "error"));
  }
}
