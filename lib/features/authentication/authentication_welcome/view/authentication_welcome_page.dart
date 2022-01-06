import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthWelcomePage extends StatelessWidget {
  const AuthWelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: SvgPicture.asset("assets/svg/login2.svg")),
        OutlinedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/login");
          },
          child: Text(
            "LOGIN",
            style: TextStyle(color: Theme.of(context).colorScheme.background),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/register");
          },
          child: Text(
            "REGISTER",
            style: TextStyle(color: Theme.of(context).colorScheme.background),
          ),
        ),
      ]),
    );
  }
}
