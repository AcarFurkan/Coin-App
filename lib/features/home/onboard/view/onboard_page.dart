import 'package:coin_with_architecture/core/constant/app/app_constant.dart';
import 'package:coin_with_architecture/core/extension/string_extension.dart';
import 'package:coin_with_architecture/product/language/locale_keys.g.dart';
import 'package:flutter/material.dart';

import '../../../../core/extension/context_extension.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: buildFloatingActionButton(context),
        body: Column(
          children: [
            const Spacer(),
            Expanded(
                flex: (context.width * 0.015).toInt(),
                child: buildWelcomeImage()),
            buildLoginRegisterButton(context),
            Spacer(
              flex: (context.width * 0.006).toInt(),
            ) // as
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
      children: [
        Text(LocaleKeys.landingPage_passButton.locale),
        const Icon(Icons.arrow_forward_ios)
      ],
    );
  }

  Image buildWelcomeImage() => Image.asset(AppConstant.instance.WELCOME_PAGE);

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

  Text buildButtonText(BuildContext context) =>
      Text(LocaleKeys.landingPage_loginRegisterButton.locale);
}
