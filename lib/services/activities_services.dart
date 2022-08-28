import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:good_tymes/constants/language_constants.dart';
import 'package:good_tymes/models/activity.dart';
import 'package:good_tymes/models/address.dart';

class ActivitiesServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Post an activity
  Future<String> addNewActivity({
    required BuildContext context,
    required String name,
    required String description,
    required String category,
    required String date,
    required String time,
    required Address address,
    required int limit,
  }) async {
    String res = getText(context).somethingWentWrong;
    try {
      res = getText(context).successCreateActivity;
      User currentUser = _auth.currentUser!;

      Activity newActivity = Activity(
        name: name,
        description: description,
        category: category,
        date: date,
        time: time,
        location: address.toMap(),
        limit: limit,
        participants: [currentUser.uid],
        createdBy: currentUser.uid,
        created: Timestamp.now(),
        lastUpdated: Timestamp.now(),
      );

      await _firestore
          .collection("activities")
          .add(newActivity.toJson())
          .then((value) {
        _firestore
            .collection('activities')
            .doc(value.id)
            .update({'uid': value.id});
      });
    } catch (err) {
      return getText(context).failedCreateActivity;
    }
    return res;
  }
}
