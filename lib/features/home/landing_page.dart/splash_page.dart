import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor:
          lightMode ? const Color(0xff1D1D1D) : const Color(0xff1D1D1D),
      body: Center(
          child: lightMode
              ? Image.asset('assets/gif/splash35.gif')
              : Image.asset('assets/gif/splash35.gif')),
    );
  }
}
