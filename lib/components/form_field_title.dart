import 'package:flutter/material.dart';

class FormFieldTitle extends StatelessWidget {
  const FormFieldTitle({
    Key? key,
    required this.title,
    required this.hint,
    required this.iconData,
  }) : super(key: key);

  final String title;
  final String hint;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(
                iconData,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            hint,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
