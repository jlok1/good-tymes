import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:good_tymes/components/language_dropdown_menu.dart';
import 'package:good_tymes/constants/language_constants.dart';
import 'package:good_tymes/screens/home_screen.dart';
import 'package:good_tymes/services/auth_services.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = '/landing';

  const LandingScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        color: Theme.of(context).primaryColor,
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 40, top: 60),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Good Tymes",
                        style: TextStyle(
                          color: Color.fromRGBO(83, 42, 120, 1),
                          fontSize: 35,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 400,
                    height: 400,
                    padding: const EdgeInsets.all(0),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: CachedNetworkImage(
                      imageUrl: 'https://i.ibb.co/G3pMHNR/welcoe.png',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/app/google.jpg",
                    width: 36,
                    height: 36,
                  ),
                ),
                label: Text(
                  getText(context).continueWithGoogle,
                  style: const TextStyle(color: Colors.black54),
                ),
                onPressed: () async {
                  await AuthServices().continueWithGoogle(context);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      HomeScreen.routeName, (route) => false);
                },
              ),
              const DropdownLanguageMenu(),
            ],
          ),
        ),
      ),
    );
  }
}
