import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  Activity({
    this.uid,
    required this.name,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.limit,
    this.seenBy = 0,
    required this.participants,
    required this.createdBy,
    required this.created,
    required this.lastUpdated,
  });

  final String? uid;
  final String name;
  final String description;
  final String category;
  final String date;
  final String time;
  final Map location;
  final int limit;
  final int seenBy;
  final List participants;
  final String createdBy;
  final Timestamp created;
  final Timestamp lastUpdated;

  static Activity fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Activity(
      uid: snapshot["uid"],
      name: snapshot["name"],
      description: snapshot["description"],
      category: snapshot["category"],
      date: snapshot["date"],
      time: snapshot["time"],
      location: snapshot["location"],
      limit: snapshot["limit"],
      seenBy: snapshot["seenBy"],
      participants: snapshot['participants'],
      createdBy: snapshot["createdBy"],
      created: snapshot["created"],
      lastUpdated: snapshot["lastUpdated"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "description": description,
        "category": category,
        "date": date,
        "time": time,
        "location": location,
        "limit": limit,
        "seenBy": seenBy,
        "participants": participants,
        "createdBy": createdBy,
        "created": created,
        "lastUpdated": lastUpdated,
      };
}
