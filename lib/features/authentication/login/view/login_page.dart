import 'package:coin_with_architecture/core/enums/back_up_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../product/model/user/my_user_model.dart';
import '../../../../product/repository/service/firebase/firestore/firestore_service.dart';
import '../../../../product/widget/component/rounded_text_form_field.dart';
import '../../viewmodel/cubit/user_cubit.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  MyUser? userInformationForUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirestoreService.instance
                .readUserInformations("gitprojectfurkan@gmail.com");
          },
          child: Icon(Icons.add),
        ),
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
          title: Text("Login"),
        ),
        body: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) async {
            if (state is UserUpdate) {
              //ScaffoldMessenger.of(context)
              //    .showSnackBar(SnackBar(content: Text("data")));
              showAlertDialog(context);
            }
          },
          builder: (context, state) {
            if (state is UserFull) {
              MyUser user = state.user;
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                    ),
                    Text(user.name ?? ""),
                    ListTile(
                      title: Text("Hey" + (user.name ?? "") + "😍"),
                    ),
                    InkWell(
                      child: ListTile(
                        title:
                            Text("Back Up " + (user.backUpType ?? "") + "😍"),
                      ),
                      onTap: () {
                        showAlertDialogForBackUp(context);
                      },
                    ),
                    Text((user.email ?? "")),
                    Text((user.isBackUpActive.toString())),
                    Text((user.backUpType ?? "")),
                    Text((user.isBackUpActive.toString())),
                    OutlinedButton(
                        onPressed: () {
                          context.read<UserCubit>().updateUser();
                        },
                        child: Text("Save changes")),
                    OutlinedButton(
                        onPressed: () {
                          context.read<UserCubit>().signOut();
                        },
                        child: Text("Sign Out")),
                    context.watch<UserCubit>().user?.backUpType ==
                            BackUpTypes.tapped.name
                        ? OutlinedButton(
                            onPressed: () async {
                              await context
                                  .read<UserCubit>()
                                  .backUpWhenTapped();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(" back up successful"),
                                duration: Duration(milliseconds: 600),
                              ));
                            },
                            child: Text("back up"))
                        : Container(),
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
                                .signInWithEmailandPassword(
                                    "furkan9@acar.com", "123123");
                          },
                          child: const Text("Login")),
                      OutlinedButton(
                          onPressed: () async {
                            await context.read<UserCubit>().signInWithGoogle();
                          },
                          child: const Text("Google"))
                    ]),
              );
            } else if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else {
              print(state.toString());

              return Center(child: Text(state.toString()));
            }
          },
        ));
  }

  showAlertDialogForBackUp(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('🗂️  Back Up To Cloud  🗂️'), //🗃️
        content: Container(
          height: 300,
          width: 300,
          color: Colors.transparent,
          child: BlocConsumer<UserCubit, UserState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Material(
                //BUNU CARD YAPIP TRANSPARENT YAPINCA FARKLI BİR RENK ALIYOR NEDEN BİR ARAŞTIR
                color: Colors.transparent,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: BackUpTypes.values.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RadioListTile<String>(
                      title: Text(BackUpTypes.values.toList()[index].name),
                      value: BackUpTypes.values.toList()[index].name,
                      groupValue: context.watch<UserCubit>().groupValue,
                      onChanged: (onChanged) async {
                        context.read<UserCubit>().changeGroupValue(onChanged!);
                        context.read<UserCubit>().updateUser();

                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
        // actions: <Widget>[
        //   TextButton(
        //     onPressed: () => Navigator.of(context).pop(false),
        //     child: const Text('No'),
        //   ),
        //   TextButton(
        //     onPressed: () {
        //       Navigator.of(context).pop(false);
        //       context.read<UserCubit>().updateUser();
        //     },
        //     child: const Text('Yes'),
        //   ),
        // ],
      ),
    );
  }

  showAlertDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('😎 OMG 😎'),
        content: const Text(
            "Lan lan cloud da sende olandan farklı veriler geldi bunları verilerinini üstüne yazmak istermisin yavrummm lüüllüüülüüü"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Navigator.of(context).pop(true);
              context.read<UserCubit>().overwriteDataToDb();

              //  Navigator.popUntil(context, (ModalRoute.withName("/home")));
              Navigator.pushNamedAndRemoveUntil(
                  context, "/home", (ModalRoute.withName("/home")));
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
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