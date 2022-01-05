import 'package:coin_with_architecture/features/authentication/viewmodel/cubit/user_cubit.dart';
import 'package:coin_with_architecture/product/model/user/my_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../product/widget/component/rounded_text_form_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.popUntil(
                  context, (ModalRoute.withName("/settingsGeneral")));
            },
          ),
          title: Text("Register"),
        ),
        body: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is UserFull) {
              MyUser user = state.user;
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                    ),
                    Text(user.name ?? "" + (user.email ?? "")),
                    OutlinedButton(
                        onPressed: () {
                          context.read<UserCubit>().signOut();
                        },
                        child: Text("Sign Out"))
                  ]);
            } else if (state is UserNull) {
              return Padding(
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
                          child: buildTextFormField(
                            "furkan@acar.com",
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: buildTextFormField("123123")),
                      OutlinedButton(
                          onPressed: () async {
                            await context
                                .read<UserCubit>()
                                .createUserWithEmailandPassword(
                                    "furkan@acar.com", "123123");
                          },
                          child: const Text("Register")),
                    ]),
              );
            } else if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else {
              return const Center(child: Text("error"));
            }
          },
        ));
  }
}
