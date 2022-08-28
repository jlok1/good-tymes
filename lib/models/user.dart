import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  const MyUser({
    required this.uid,
    required this.name,
    required this.gmail,
    required this.contact,
    required this.profilePictureUrl,
  });

  final String uid;
  final String name;
  final String gmail;
  final String contact;
  final String profilePictureUrl;

  static MyUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return MyUser(
      uid: snapshot["uid"],
      name: snapshot["name"],
      gmail: snapshot["gmail"],
      contact: snapshot["contact"],
      profilePictureUrl: snapshot["profilePictureUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "gmail": gmail,
        "contact": contact,
        "profilePictureUrl": profilePictureUrl,
      };
}
