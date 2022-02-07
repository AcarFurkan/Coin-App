import '../../../core/constant/app/app_constant.dart';
import '../../../core/extension/context_extension.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.splashColor,
      body: Center(child: Image.asset(AppConstant.instance.SPLASH_GIF_PATH)),
    );
  }
}
