import 'package:flutter/material.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: buildFloatingActionButton(context),
        body: Column(
          children: [
            const Spacer(),
            Expanded(flex: 6, child: buildWelcomeImage()),
            buildLoginRegisterButton(context),
            const Spacer(flex: 2) // as
          ],
        ));
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.popAndPushNamed(context, "/home"),
      label: buildFloatingActionButtonContent(),
    );
  }

  Row buildFloatingActionButtonContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [Text("Geç"), Icon(Icons.arrow_forward_ios)],
    );
  }

  Image buildWelcomeImage() => Image.asset("assets/images/welcome_two.png");

  OutlinedButton buildLoginRegisterButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.popAndPushNamed(context, "/home");
        Navigator.pushNamed(context, "/settingsGeneral");
        Navigator.pushNamed(
            context, "/userSettings"); //bundan sonra geri kısmını bir düşün
      },
      child: buildButtonText(context),
    );
  }

  Text buildButtonText(BuildContext context) {
    return Text(
      "LOGIN/REGISTER",
      style: TextStyle(color: Theme.of(context).colorScheme.background),
    );
  }
}
