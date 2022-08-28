import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:good_tymes/components/drawer.dart';
import 'package:good_tymes/constants/language_constants.dart';
import 'package:good_tymes/screens/add_activity_screen.dart';
import 'package:good_tymes/screens/decide_activity_screen.dart';
import 'package:good_tymes/screens/discover_activity_screen.dart';
import 'package:good_tymes/screens/manage_activity_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Text(
                user.displayName ?? getText(context).noName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            CircleAvatar(
              radius: 28,
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
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 0, bottom: 0),
                        width: double.infinity,
                        child: Text(
                          getText(context).welcome,
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 30,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 30, bottom: 5),
                        width: double.infinity,
                        child: Text(
                          getText(context).notSureWhatToDo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(DecideActivityScreen.routeName);
                        },
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.only(
                              left: 0, right: 0, top: 5, bottom: 10),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image:
                                          AssetImage("assets/app/activity.png"),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: double.infinity,
                                  alignment: Alignment.centerRight,
                                  decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    getText(context).letUsHelp,
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 15,
                                      fontFamily: 'Montserrat',
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 20, bottom: 5),
                        width: double.infinity,
                        child: Text(
                          getText(context).createYourOwnActivity,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        margin: const EdgeInsets.only(
                            left: 0, right: 0, top: 5, bottom: 0),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  getText(context).createYourOwnActivityHint,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 15,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                height: double.infinity,
                                padding: const EdgeInsets.all(15),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        const CircleBorder()),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(15)),
                                    backgroundColor:
                                        MaterialStateProperty.all(primaryColor),
                                    overlayColor: MaterialStateProperty
                                        .resolveWith<Color?>((states) {
                                      if (states
                                          .contains(MaterialState.pressed)) {
                                        return const Color.fromRGBO(
                                            95, 173, 158, 1);
                                      }
                                      return null;
                                    }),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          AddActivityScreen.routeName);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 30, bottom: 5),
                        width: double.infinity,
                        child: Text(
                          getText(context).discoverActivities,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(DiscoverActivityScreen.routeName);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 0, right: 0, top: 5, bottom: 10),
                          height: 180,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset("assets/app/explore.png"),
                                Text(
                                  getText(context).participantActivity,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 30, bottom: 5),
                        width: double.infinity,
                        child: Text(
                          getText(context).yourActivities,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ManageActivityScreen.routeName);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 0, right: 0, top: 5, bottom: 80),
                          height: 180,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset("assets/app/checklist.png"),
                                Text(
                                  getText(context).manageActivities,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
