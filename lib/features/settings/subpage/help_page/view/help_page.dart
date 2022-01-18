import 'package:coin_with_architecture/core/constant/app/app_constant.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(child: Image.asset(AppConstant.instance.HELP_IMAGE_PATH)),
      ),
    );
  }
}
