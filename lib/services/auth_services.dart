import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:good_tymes/models/user.dart';
import 'package:good_tymes/utils/show_snack_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get logged-in user's information
  Future<MyUser> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return MyUser.fromSnap(documentSnapshot);
  }

  // Get other user's information
  Future<MyUser> getOtherUserDetails(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(uid).get();
    return MyUser.fromSnap(documentSnapshot);
  }

  // Continue with Google
  Future<void> continueWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            final user = userCredential.user;

            // Creates a new instance of MyUser
            MyUser myUser = MyUser(
              uid: user!.uid,
              name: user.displayName as String,
              gmail: user.email as String,
              contact: user.phoneNumber ?? '',
              profilePictureUrl: user.photoURL as String,
            );

            // Adds new user to Firebase
            await _firestore
                .collection("users")
                .doc(user.uid)
                .set(myUser.toJson());
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // Sign out user
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}
