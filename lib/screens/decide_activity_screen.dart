import 'package:flutter/material.dart';
import 'package:good_tymes/constants/language_constants.dart';
import 'package:good_tymes/models/category.dart';
import 'package:good_tymes/screens/category_detail_screen.dart';

class DecideActivityScreen extends StatefulWidget {
  static const routeName = '/decide-an-activity';

  const DecideActivityScreen({Key? key}) : super(key: key);

  @override
  State<DecideActivityScreen> createState() => _DecideActivityScreenState();
}

class _DecideActivityScreenState extends State<DecideActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getText(context).activityDecide),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              if (categories[index].name != 'sep') {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryDetailScreen(
                              category: categories[index])),
                    );
                  },
                  child: Container(
                    width: 200,
                    height: 200,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GridTile(
                        footer: GridTileBar(
                          backgroundColor: Theme.of(context).primaryColor,
                          title: Text(categories[index].name),
                          trailing: null,
                        ),
                        child: FadeInImage(
                          placeholder: const AssetImage(
                              'assets/app/loading-buffering.gif'),
                          image: AssetImage(
                              'assets/activities/${categories[index].image}'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Text(categories[index].type),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
