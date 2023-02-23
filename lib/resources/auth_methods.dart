import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign up user

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
              password.isNotEmpty ||
              username.isNotEmpty ||
              bio.isNotEmpty
          // ignore: unnecessary_null_comparison
          //file != null
          ) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods().uploadImagetoStorage(
          'profilePics',
          file,
          false,
        );

        // adding user to firestore

        _firestore.collection('users').doc(cred.user!.uid).set({
          'email': email,
          'username': username,
          'bio': bio,
          'uid': cred.user!.uid,
          'followers': [],
          'following': [],
          'imageUrl': photoUrl,
        });

        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
