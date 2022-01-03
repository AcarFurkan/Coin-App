import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../home/home_view.dart';
import '../../authentication_welcome/view/authentication_welcome_page.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (c) => HomeView()));
          },
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Geç"), Icon(Icons.arrow_forward_ios)],
          ),
        ),
        body: Column(
          children: [
            const Spacer(),
            Expanded(
              flex: 6,
              child: SvgPicture.asset(
                "assets/svg/stock.svg",
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AuthWelcomePage()));
              },
              child: Text(
                "LOGIN/REGISTER",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            ),
            Spacer(
              flex: 2,
            )
          ],
        ));
  }
}
