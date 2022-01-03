import '../../login/view/login_page.dart';
import '../../register/view/register_page.dart';
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          },
          child: Text(
            "LOGIN",
            style: TextStyle(color: Theme.of(context).colorScheme.background),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RegisterPage()));
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
