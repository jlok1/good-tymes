import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:good_tymes/components/drawer.dart';
import 'package:good_tymes/constants/language_constants.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text(getText(context).profile),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
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
      drawer: const AppDrawer(),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 64,
                backgroundColor: Colors.grey,
                child: CachedNetworkImage(
                  imageUrl: user.photoURL!,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
          Column(
            children: [
              ProfileDetailTile(
                title: 'Name',
                subtitle: user.displayName ?? 'No Email',
                iconData: Icons.email,
              ),
              ProfileDetailTile(
                title: getText(context).email,
                subtitle: user.email ?? 'No Email',
                iconData: Icons.email,
              ),
              ProfileDetailTile(
                title: getText(context).contact,
                subtitle: user.phoneNumber ?? 'No Contact No.',
                iconData: Icons.phone,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileDetailTile extends StatelessWidget {
  const ProfileDetailTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconData,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).backgroundColor,
            radius: 25.0,
            child: Icon(
              iconData,
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}
