import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:good_tymes/components/profile_card.dart';
import 'package:good_tymes/constants/language_constants.dart';
import 'package:good_tymes/models/activity.dart';
import 'package:readmore/readmore.dart';

class ActivityDetailScreen extends StatefulWidget {
  const ActivityDetailScreen({Key? key, required this.activity})
      : super(key: key);

  final Activity activity;

  @override
  State<ActivityDetailScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ActivityDetailScreen> {
  User currentUser = FirebaseAuth.instance.currentUser!;

  final double mainTitleFont = 26;
  final double subTitleFont = 18;
  final double contentFont = 14;

  bool _isLoading = false;
  bool _isMe = false;
  bool _cannotParticipate = false;

  // Increment Seen By & Check if activity can be participated
  void initialise() async {
    setState(() {
      _isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("activities")
        .doc(widget.activity.uid)
        .update({'seenBy': FieldValue.increment(1)});
    setState(() {
      _cannotParticipate =
          widget.activity.participants.contains(currentUser.uid) ||
              widget.activity.participants.length > widget.activity.limit;
      _isLoading = false;
    });
  }

  // Participate
  void _participate() async {
    setState(() {
      _isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("activities")
        .doc(widget.activity.uid)
        .update({
      'participants': FieldValue.arrayUnion([currentUser.uid])
    });
    if (!mounted) return;
    Navigator.of(context).pop();
    setState(() {
      _isLoading = false;
    });
  }

  // Withdraw
  void _withdraw() async {
    setState(() {
      _isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("activities")
        .doc(widget.activity.uid)
        .update({
      'participants': FieldValue.arrayRemove([currentUser.uid])
    });
    if (!mounted) return;
    Navigator.of(context).pop();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    User currentUser = FirebaseAuth.instance.currentUser!;
    if (widget.activity.createdBy == currentUser.uid) {
      setState(() {
        _isMe = true;
      });
    }
    initialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 20);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity.name),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
          if (!_isMe)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.report),
            ),
          if (_isMe)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
            ),
        ],
      ),
      bottomNavigationBar: !_isMe && !_cannotParticipate
          ? Material(
              color: Theme.of(context).primaryColor,
              child: InkWell(
                onTap: _participate,
                child: SizedBox(
                  height: kToolbarHeight,
                  child: Center(
                    child: Text(
                      getText(context).participate,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : !_isMe && widget.activity.participants.contains(currentUser.uid)
              ? Material(
                  color: const Color.fromARGB(255, 191, 43, 43),
                  child: InkWell(
                    onTap: _withdraw,
                    child: SizedBox(
                      height: kToolbarHeight,
                      child: Center(
                        child: Text(
                          getText(context).withdraw,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : null,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        Text(
                          widget.activity.name,
                          style: TextStyle(
                            fontSize: mainTitleFont,
                            height: 1.15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        sizedBox,

                        // Created
                        InfoTile(
                          info: 'Created ${widget.activity.created.toDate()}',
                          iconData: Icons.access_time_outlined,
                        ),

                        // Seen By
                        InfoTile(
                          info: 'Seen by ${widget.activity.seenBy}',
                          iconData: Icons.remove_red_eye_outlined,
                        ),

                        // Description
                        ReadMoreText(
                          widget.activity.description,
                          textAlign: TextAlign.justify,
                          trimLines: 3,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: getText(context).showMore,
                          trimExpandedText: '\t\t${getText(context).showLess}',
                          style: TextStyle(
                            fontSize: contentFont,
                            color: Colors.black87,
                            height: 2.0,
                          ),
                          moreStyle: TextStyle(
                            color: Colors.purple,
                            fontSize: contentFont,
                            fontWeight: FontWeight.bold,
                          ),
                          lessStyle: TextStyle(
                            color: Colors.purple,
                            fontSize: contentFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        sizedBox,

                        // More Details Subtitle
                        Text(
                          getText(context).moreDetails,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: subTitleFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        sizedBox,

                        // Date
                        InfoTile(
                          info:
                              '${getText(context).date}: ${widget.activity.date}',
                          iconData: Icons.calendar_month,
                        ),

                        // Time
                        InfoTile(
                          info:
                              '${getText(context).time}: ${widget.activity.time}',
                          iconData: Icons.timer_outlined,
                        ),

                        // Address
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InfoTile(
                              info: getText(context).locatedAt,
                              iconData: Icons.location_pin,
                            ),
                            Text(
                              widget.activity.location['displayName'],
                              style: const TextStyle(height: 1.5),
                            ),
                          ],
                        ),
                        sizedBox,

                        // Organiser Card
                        Text(
                          getText(context).aboutOrganiser,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        sizedBox,
                        ProfileCard(uid: widget.activity.createdBy),

                        // Participants
                        Text(
                          getText(context).participants,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        sizedBox,
                        for (String participant in widget.activity.participants)
                          ProfileCard(uid: participant),
                        sizedBox,
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({
    Key? key,
    required this.info,
    required this.iconData,
  }) : super(key: key);

  final String info;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            iconData,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 20),
          Text(
            info,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
