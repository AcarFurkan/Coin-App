import 'package:flutter/material.dart';

import '../../../../../core/constant/app/app_constant.dart';

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
