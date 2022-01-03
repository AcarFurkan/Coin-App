import '../../../../product/widget/component/rounded_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: SvgPicture.asset("assets/svg/login2.svg")),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: buildTextFormField("Name", autoFocus: true)),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: buildTextFormField("Email")),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: buildTextFormField("Password")),
        ],
      ),
    ));
  }
}
