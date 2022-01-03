import '../../../../product/widget/component/rounded_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: SvgPicture.asset("assets/svg/login2.svg")),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: buildTextFormField("Email", autoFocus: true)),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: buildTextFormField("Password"))
          ]),
    ));
  }
}
/**
 * TextFormField(
              cursorHeight:
                  context.watch<ListPageGeneralCubit>().isSearhOpen ? 18 : 0,
              controller: _searchTextEditingController,
              onChanged: (a) {
                context.read<ListPageGeneralCubit>().textFormFieldChanged();
              },
              focusNode: context.watch<ListPageGeneralCubit>().myFocusNode,
              autofocus: context.watch<ListPageGeneralCubit>().isSearhOpen
                  ? true
                  : false,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
 */