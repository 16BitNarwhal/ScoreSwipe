import 'package:flutter/material.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({Key? key, this.title = ""}) : super(key: key);

  final String title;

  titleText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Welcome to',
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground),
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary),
        ),
        Text(
          'Ready to make some music?',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onBackground),
        ),
      ],
    );
  }

  // TODO: make auth
  authButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12.0, left: 16.0, right: 16.0),
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/mainscreen');
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: Text(
              'Sign In',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 12.0, left: 16.0, right: 16.0),
          height: 48,
          child: ElevatedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              side: BorderSide(
                  width: 1.0,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/mainscreen');
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/mainscreen');
          },
          child: Text(
            'continue as guest',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).colorScheme.onBackground,
                color: Theme.of(context).colorScheme.onBackground),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin:
              const EdgeInsets.only(top: 64, left: 32, right: 32, bottom: 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              titleText(context),
              authButtons(context),
            ],
          ),
        ),
      ),
    );
  }
}
