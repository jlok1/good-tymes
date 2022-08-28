import 'package:flutter/material.dart';
import 'package:good_tymes/constants/language_constants.dart';
import 'package:good_tymes/models/user.dart';
import 'package:good_tymes/services/auth_services.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    Key? key,
    required this.uid,
  }) : super(key: key);

  final String uid;

  @override
  State<ProfileCard> createState() => _RequesterCardState();
}

class _RequesterCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MyUser>(
      future: AuthServices().getOtherUserDetails(widget.uid),
      builder: (BuildContext context, AsyncSnapshot<MyUser> snapshot) {
        if (snapshot.hasData) {
          return AboutUser(otherUser: snapshot.data!);
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              getText(context).somethingWentWrong,
              style: TextStyle(
                color: Theme.of(context).errorColor,
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }
}

class AboutUser extends StatelessWidget {
  const AboutUser({
    Key? key,
    required this.otherUser,
  }) : super(key: key);

  final MyUser otherUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage(otherUser.profilePictureUrl),
            ),
            const SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  otherUser.name,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  otherUser.gmail,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
