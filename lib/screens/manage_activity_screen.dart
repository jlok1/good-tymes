import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:good_tymes/constants/language_constants.dart';
import 'package:good_tymes/models/activity.dart';
import 'package:good_tymes/models/category.dart';
import 'package:good_tymes/screens/activity_detail_screen.dart';

class ManageActivityScreen extends StatefulWidget {
  static const routeName = '/manage-your-activity';

  const ManageActivityScreen({Key? key}) : super(key: key);

  @override
  State<ManageActivityScreen> createState() => _ManageActivityScreenState();
}

class _ManageActivityScreenState extends State<ManageActivityScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getText(context).manageActivities),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('activities')
              .where('createdBy', isEqualTo: currentUser!.uid)
              .snapshots(),
          builder:
              (BuildContext ctx, AsyncSnapshot<QuerySnapshot> scanSnapshot) {
            if (scanSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final scanDocs = scanSnapshot.data!.docs;
            if (scanDocs.isEmpty) {
              return Center(
                child: Text(getText(context).noActivitesYet),
              );
            }
            return ListView.builder(
                itemCount: scanDocs.length,
                itemBuilder: (ctx, index) {
                  return ActivityTile(
                    activity: Activity(
                      uid: scanDocs[index]['uid'],
                      name: scanDocs[index]['name'],
                      description: scanDocs[index]['description'],
                      category: scanDocs[index]['category'],
                      date: scanDocs[index]['date'],
                      time: scanDocs[index]['time'],
                      location: scanDocs[index]['location'],
                      limit: scanDocs[index]['limit'],
                      seenBy: scanDocs[index]['seenBy'],
                      participants: scanDocs[index]['participants'],
                      createdBy: scanDocs[index]['createdBy'],
                      created: scanDocs[index]['created'],
                      lastUpdated: scanDocs[index]['lastUpdated'],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  const ActivityTile({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage:
              AssetImage("assets/activities/${getPicture(activity.category)}"),
        ),
        title: Text(
          activity.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        textColor: Colors.black87,
        iconColor: Theme.of(context).primaryColor,
        subtitle: Text(activity.description.length > 20
            ? '${activity.description.substring(0, 20)}...'
            : activity.description),
        trailing: IconButton(
          icon:
              Icon(Icons.arrow_forward, color: Theme.of(context).primaryColor),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityDetailScreen(activity: activity),
              ),
            );
          },
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
