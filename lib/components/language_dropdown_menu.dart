import 'package:flutter/material.dart';
import 'package:good_tymes/constants/language_constants.dart';
import 'package:good_tymes/main.dart';
import 'package:good_tymes/models/language.dart';

class DropdownLanguageMenu extends StatelessWidget {
  const DropdownLanguageMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<Language>(
        underline: const SizedBox(),
        hint: Text(
          getText(context).language,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: const Icon(
          Icons.language,
          color: Colors.white,
        ),
        onChanged: (Language? language) async {
          if (language != null) {
            Locale locale = await setLocale(language.languageCode);
            MyApp.setLocale(context, locale);
          }
        },
        items: Language.languageList()
            .map<DropdownMenuItem<Language>>(
              (e) => DropdownMenuItem<Language>(
                value: e,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      e.flag,
                      style: const TextStyle(fontSize: 30),
                    ),
                    Text(e.name)
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
