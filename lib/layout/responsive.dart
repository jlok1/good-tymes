import 'package:flutter/material.dart';
import 'package:good_tymes/provider/user_provider.dart';
import 'package:good_tymes/screens/home_screen.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({
    Key? key,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    setState(() {
      isLoading = true;
    });
    MyUserProvider userProvider =
        Provider.of<MyUserProvider>(context, listen: false);
    await userProvider.refreshUser();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              backgroundColor: Colors.white,
            ),
          )
        : const HomeScreen();
  }
}
